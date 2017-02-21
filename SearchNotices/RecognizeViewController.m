//
//  RecognizeViewController.m
//  ZXTabBarController
//
//  Created by Jackey on 2016/12/14.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "RecognizeViewController.h"
#import "AFNetworking.h"
#import "RecognizeDataSource.h"
#import "RecognizeButtonCell.h"
#import "RecognizeCollectionCell.h"
#import "RecognizeModel.h"
#import "JSONKit.h"
#import "YYModel.h"
#import "UIImage+Image.h"
#import "MJRefresh.h"
#import "GYZChooseCityController.h"
#import "MapViewController.h"
#import "UIImageView+WebCache.h"
#import "MessageBoardViewController.h"
#import "ShowPhotoViewController.h"
#import "ShowPhotoCollectionViewCell.h"
#import "SVProgressHUD.h"
#import "SubmitViewController.h"
#import "PresentPhotoViewController.h"

static NSString * const CollectionMainCellIdentifer = @"MainCell";
static NSString * const CollectionBtnCellIdentifer  = @"BtnCell";

@interface RecognizeViewController () <UICollectionViewDelegateFlowLayout, GYZChooseCityDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) AFHTTPSessionManager      *manager;
@property (nonatomic, strong) NSMutableArray            *models;                 //存储的所有模型数组
@property (nonatomic, strong) NSMutableArray            *showModels;             //当前要显示的模型数组
@property (nonatomic, strong) UICollectionView          *MyRecCollectionView;
@property (nonatomic, strong) RecognizeDataSource       *dataSource;
@property (nonatomic, strong) NSRecursiveLock           *lock;
@property (nonatomic, strong) UIBarButtonItem           *choseBtn;
@property (nonatomic, assign) BOOL                       sifted;                  //是否开启筛选
@property (nonatomic, strong) UIBarButtonItem           *submitBarButton;
@property (nonatomic, strong) UIImagePickerController   *picker;

@end

@implementation RecognizeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    //1.初始化model数组和AFN Manager等等
    [self initData];
    
    //2.初始化CollectionView, ChoseBtn
    [self initView];
    
    //3.调用CollectionView下拉刷新, 开始下载数据
    [self.MyRecCollectionView.mj_header beginRefreshing];

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

#pragma mark - 初始化数据和界面

//初始化model数组和AFN Manager等等
- (void)initData {
    
    //初始化筛选状态
    self.sifted     = NO;
    
    //初始化models
    self.models     = [@[] mutableCopy];
    self.showModels = [@[] mutableCopy];
    
    //初始化AFN manager
    self.manager    = ({
        
        AFHTTPSessionManager *manager           = [AFHTTPSessionManager manager];
        AFSecurityPolicy *securityPolicy        = \
                                [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
        
        securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy                  = securityPolicy;
        
        manager;
    });
    
    //初始化lock
    self.lock       = ({
        
        NSRecursiveLock *mylock = [[NSRecursiveLock alloc] init];
        mylock;
    });
}

//初始化CollectionView
- (void)initView {
    
    [self.view setBackgroundColor:BackColor];
    
    //创建Collection
    [self setUpCollectionView];
    
    //创建筛选按钮
    self.choseBtn           = ({
    
        UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                    target:self
                                    action:@selector(choseCity)];
        
        [btnItem setTintColor:[UIColor whiteColor]];
        
        btnItem;
    });
    
    self.navigationItem.leftBarButtonItem = self.choseBtn;
    
    //创建发布按钮
    self.submitBarButton    = ({
    
        UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                    target:self
                                    action:@selector(cameraAction)];
        
        [btnItem setTintColor:[UIColor whiteColor]];
        
        btnItem;
    });
    
    self.navigationItem.rightBarButtonItem = self.submitBarButton;
}

#pragma mark - 私有方法

//创建CollectionView
- (void)setUpCollectionView {
    
    //初始化dataSource
    self.dataSource          = ({
        
        RecognizeDataSource *dataSource = \
        [[RecognizeDataSource alloc] initWithModel:self.showModels
                                    cellIdentifier:CollectionMainCellIdentifer
                                     btnIdentifier:CollectionBtnCellIdentifer];
        
        dataSource;
    });
    
    //初始化CollectionView
    self.MyRecCollectionView = ({
        
        UICollectionViewFlowLayout *layout          = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        CGRect rect                                 = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        UICollectionView *collectionView            = [[UICollectionView alloc] initWithFrame:rect
                                                                 collectionViewLayout:layout];
        collectionView.showsVerticalScrollIndicator = NO;
        
        [collectionView registerClass:[RecognizeCollectionCell class] \
           forCellWithReuseIdentifier:CollectionMainCellIdentifer];
        [collectionView registerClass:[RecognizeButtonCell class] \
           forCellWithReuseIdentifier:CollectionBtnCellIdentifer];
        
        collectionView.dataSource   = self.dataSource;
        collectionView.delegate     = self;
        //collectionView.contentInset = UIEdgeInsetsMake(0, 0, 140, 0);
        
        
        [collectionView setBackgroundColor:BackColor];
        
        
        //设置下拉刷新
        LRWeakSelf(self);
        collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            LRStrongSelf(self);
            if (!self.sifted) {

                [self.MyRecCollectionView.mj_footer resetNoMoreData];
                [self downloadSuiPaiData];
            } else {
                
                self.sifted = NO;
                [self.showModels removeAllObjects];
                [self setUpShowModels];
                [self.MyRecCollectionView reloadData];
                [self.MyRecCollectionView.mj_header endRefreshing];
            }
            
            
        }];
        
        //设置上拉刷新
        collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            LRStrongSelf(self);
            
            if (!self.sifted) {
                if (self.models.count > self.showModels.count) {
                    
                    [self addShowModels];
                    [self.MyRecCollectionView reloadData];
                    [self.MyRecCollectionView.mj_footer endRefreshing];
                } else {
                    
                    [self.MyRecCollectionView.mj_footer endRefreshingWithNoMoreData];
                }
                
            }
        }];
        [collectionView.mj_footer setAutomaticallyHidden:YES];
        
        collectionView;
    });
    
    //添加到View上
    [self.view addSubview:self.MyRecCollectionView];
    
    //初始化ImagePicker
    self.picker          = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;

    //解决TabBar遮挡
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.MyRecCollectionView.autoresizingMask = \
    UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

//下载网络数据
- (void)downloadSuiPaiData {
    
    [self.lock lock];
    LRWeakSelf(self);
    [self.manager GET:suipaiAddress parameters:nil progress:nil \
            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                LRStrongSelf(self);
                [self.models removeAllObjects];
                [self.showModels removeAllObjects];
                for (NSDictionary *dict in (NSArray *)responseObject) {
                    
                    RecognizeModel *model = [RecognizeModel yy_modelWithDictionary:dict];
                    [model calculateHeight];
                    [self.models addObject:model];
                }
                [self setUpShowModels];
                [self.MyRecCollectionView reloadData];
                [self.MyRecCollectionView.mj_header endRefreshing];
                
                [self.lock unlock];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                LRLog(@"%@", error);
                [self.MyRecCollectionView.mj_header endRefreshing];
                
                [self.lock unlock];
            }];
}

//根据models设置初始showmodels
- (void)setUpShowModels {
    
    if (self.models.count > 2) {
        for (RecognizeModel *model in self.models) {
            
            [self.showModels addObject:model];
            if (self.showModels.count == 2) return;
        }
    }
    
}

//上拉后增加要显示的数据
- (void)addShowModels {
    
    if (self.models.count > self.showModels.count) {
        
        if (self.models.count - self.showModels.count >= 2) {
            
            [self.showModels addObject:self.models[self.showModels.count]];
            [self.showModels addObject:self.models[self.showModels.count]];
        } else {
            [self.showModels addObject:self.models[self.showModels.count]];
        }
    }
}

//Camera按钮响应事件
- (void)cameraAction {
    
    LRWeakSelf(self)
    UIAlertController *alertController = \
                [UIAlertController alertControllerWithTitle:@""
                                                    message:@"发布随拍"
                                             preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
        
                                                             LRLog(@"拍照");
                                                             LRStrongSelf(self)
                                                             [self openCamera];
                                                         }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
        
                                                            LRLog(@"相册");
                                                            LRStrongSelf(self)
                                                            [self openPhoto];
                                                        }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
        
                                                             LRLog(@"取消");
                                    
                                                         }];
    
    [alertController addAction:cameraAction];
    [alertController addAction:photoAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//跳转到照相界面
- (void)openCamera {

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        //将sourcetype设置为Camera type
        self.picker.sourceType        = UIImagePickerControllerSourceTypeCamera;
        //设置拍摄照片
        self.picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        //设置使用手机的后置摄像头
        self.picker.cameraDevice      = UIImagePickerControllerCameraDeviceRear;
        //设置使用手机的前置摄像头
        //self.picker.cameraDevice      = UIImagePickerControllerCameraDeviceFront;
        //设置摆设的照片允许编辑
        self.picker.allowsEditing     = YES;
        
        [self presentViewController:self.picker animated:YES completion:nil];
        
    } else {
        
        [SVProgressHUD showInfoWithStatus:@"摄像头不可用"];
        [SVProgressHUD dismissWithDelay:1];
    }
}

//跳转到相册
- (void)openPhoto {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        //将sourcetype设置为photolibrary
        self.picker.sourceType    = UIImagePickerControllerSourceTypePhotoLibrary;
        self.picker.allowsEditing = YES;
        
        [self presentViewController:self.picker animated:YES completion:nil];
    } else {
        
        [SVProgressHUD showInfoWithStatus:@"相册不可用"];
        [SVProgressHUD dismissWithDelay:1];
    }
}

//筛选按钮响应事件: pop到选择城市页面
- (void)choseCity {
    
    GYZChooseCityController *cityController = [[GYZChooseCityController alloc] init];
    cityController.delegate                 = self;
    cityController.hotCitys                 = \
                            @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    [self presentViewController:[[UINavigationController alloc] \
                                 initWithRootViewController:cityController]
                       animated:YES
                     completion:nil];
}

#pragma mark - UICollectionViewDelegateFlowLayout Methods

//设置Cell大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == kMainUI) {
        
        RecognizeModel *model = [self.showModels objectAtIndex:indexPath.section];
        return CGSizeMake(SCREEN_WIDTH - 20, model.Height);
    } else {
        
        return CGSizeMake((SCREEN_WIDTH - 22.4)/ 3, 30);
    }
}

//设置位移
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    
    if (section == kMainUI) {
        return UIEdgeInsetsMake(20, 10, 10, 10);
    } else {
        
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
}

//设置行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 1;
}

//设置列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 1;
}

//配置选中事件
- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RecognizeModel *model = [self.showModels objectAtIndex:indexPath.section];
    if (indexPath.row == kMainUI) {
        //跳转至照片
//        ShowPhotoViewController *photoVC = [[ShowPhotoViewController alloc] init];
        PresentPhotoViewController *photoVC = [[PresentPhotoViewController alloc] init];
        photoVC.imglinkArray         = model.ImageArray;
        [self presentViewController:photoVC animated:YES completion:nil];
    }
    
    if (indexPath.row == kMap) {
        //跳转至MapVC
        RecognizeModel *model = [self.showModels objectAtIndex:indexPath.section];
        MapViewController *mapVC = [[MapViewController alloc] \
                                    initWithLatitude:model.Latitude.doubleValue
                                           Longitude:model.Longitude.doubleValue
                                        LocationInfo:model.InfoText];
        [self.navigationController pushViewController:mapVC animated:YES];
    }
    
    if (indexPath.row == kMessage) {
        
        MessageBoardViewController *messageBVC = [[MessageBoardViewController alloc] init];
        messageBVC.number                      = model.Number;
        [self.navigationController pushViewController:messageBVC animated:YES];
    }
    
    if (indexPath.row == kShare) {
        //开始分享
        UIImageView *imageView = ({
            
            
            UIImageView *imgView = [[UIImageView alloc] init];
            [imgView sd_setImageWithURL:[NSURL URLWithString:model.ImageArray[0]]
                       placeholderImage:[UIImage imageWithColor:[UIColor whiteColor]]];
            
            imgView;
        });
        
        UIActivityViewController *activityViewController = ({
            
            UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                                    initWithActivityItems: \
                                                    @[model.InfoText, \
                                                      [NSURL URLWithString:APPLINK], \
                                                      imageView.image]
                                                    applicationActivities:nil];
            
            activityVC.excludedActivityTypes = \
                @[UIActivityTypeAirDrop, UIActivityTypePrint, \
                  UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList];
            
            activityVC;
        });
        
        [self presentViewController:activityViewController animated:YES completion:nil];

    }
}

#pragma mark - GYZChooseCityDelegate Methods

//选择城市后开始筛选数据
- (void) cityPickerController:(GYZChooseCityController *)chooseCityController
                didSelectCity:(GYZCity *)city {
    
    self.sifted = YES;
    [chooseCityController dismissViewControllerAnimated:YES completion:nil];
    
    [[[UIAlertView alloc] initWithTitle:@""
                                message:\
      [NSString stringWithFormat:@"您选择: %@\n下拉刷新可取消选择...", city.cityName]
                              delegate:self
                     cancelButtonTitle:@"知道了"
                     otherButtonTitles: nil] show];
    
    [self.showModels removeAllObjects];
    for (RecognizeModel *model in self.models) {
     
        if ([model.City isEqualToString:city.cityName]) {
            
            [self.showModels addObject:model];
        }
    }
    
    [self.MyRecCollectionView reloadData];
    [self.MyRecCollectionView.mj_footer setHidden:YES];
    [self.MyRecCollectionView.mj_footer resetNoMoreData];
    
}

//单击关闭按钮时退出城市选择器
- (void) cityPickerControllerDidCancel:(GYZChooseCityController *)chooseCityController {
    
    [chooseCityController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    LRLog(@"%@", info);
    
    //获取用户拍摄的是照片还是视频
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    LRLog(@"Type: %@", mediaType);
    LRLog(@"%@", (NSString *)kUTTypeImage);
    
    UIImage *theImage = nil;
    
    //判断是否为拍照所得照片
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage] && self.picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        LRLog(@"是拍摄的照片");
        
        //判断, 照片是否允许修改
        if ([self.picker allowsEditing]) {
            
            //获取用户编辑之后的照片
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            
            //获取原始的照片
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        //保存照片到相册中
        //UIImageWriteToSavedPhotosAlbum(theImage, self, nil, nil);
    }
    //判断是否从相册选择的图片
    else if ([mediaType isEqualToString:(NSString *)kUTTypeImage] && self.picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        
        LRLog(@"是相册");
        //判断, 照片是否允许修改
        if ([self.picker allowsEditing]) {
            
            //获取用户编辑之后的照片
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            
            //获取原始的照片
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }

    }
    //如果是视频则提示不支持
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        
        [SVProgressHUD showInfoWithStatus:@"暂不支持视频格式"];
        [SVProgressHUD dismissWithDelay:1];
    }
    
    __block SubmitViewController *subVC = [[SubmitViewController alloc] init];
    subVC.imageMutableArray     = [@[theImage] mutableCopy];
    
    LRWeakSelf(self)
    [self.picker dismissViewControllerAnimated:YES completion:^{
        
        LRStrongSelf(self)
        [self.navigationController pushViewController:subVC animated:YES];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self.picker dismissViewControllerAnimated:YES completion:nil];
}
@end
