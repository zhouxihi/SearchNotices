//
//  SubmitViewController.m
//  SearchNotices
//
//  Created by Jackey on 2017/1/13.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreLocation/CoreLocation.h>

#import "SubmitViewController.h"
#import "SVProgressHUD.h"
#import "SubmitDataSource.h"
#import "selectedImageCell.h"
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"
#import "SNManager.h"
#import <MapKit/MapKit.h>

static NSString * const submitCellIdentifer = @"submitCellIdentifer";

@interface SubmitViewController ()<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UICollectionViewDelegate,
SKPSMTPMessageDelegate,
MKMapViewDelegate,
CLLocationManagerDelegate
>

@property (nonatomic, strong) UISegmentedControl        *segmentController;
@property (nonatomic, strong) UITextView                *infoTextView;
@property (nonatomic, strong) UIBarButtonItem           *submitBarButton;
@property (nonatomic, strong) UIImagePickerController   *picker;
@property (nonatomic, strong) UICollectionView          *myCollection;
@property (nonatomic, strong) SubmitDataSource          *dataSource;

@property (nonatomic, assign) CGFloat                   latitude;
@property (nonatomic, assign) CGFloat                   longitude;
@property (nonatomic, copy)   NSString                  *city;
@property (nonatomic, copy)   NSString                  *jiedao;

@property (nonatomic, strong) CLGeocoder                *geocoder;
@property (nonatomic, strong) MKMapView                 *mapView;
@property (nonatomic, strong) CLLocationManager         *locationManager;

@property (nonatomic, assign) BOOL                      maplock;

@end

@implementation SubmitViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //初始化数据
    [self setupData];
    
    //初始化界面
    [self setupView];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}


//初始化数据
- (void)setupData {
    
    if (!self.imageMutableArray) {
        
        self.imageMutableArray = [@[] mutableCopy];
    }
    
    self.city            = @"";
    self.jiedao          = @"";
    self.locationManager = [[CLLocationManager alloc] init];
    self.geocoder        = [[CLGeocoder alloc] init];
    
    //获取定位权限
    [self.locationManager requestWhenInUseAuthorization];
}

//初始化界面
- (void)setupView {
    
    //设置背景颜色
    [self.view setBackgroundColor:BackColor];
    
    //添加类型选择说明
    UILabel *choseLable = ({
    
        UILabel *lable      = \
        [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 100, 25)];
        lable.font          = [UIFont systemFontOfSize:12];
        lable.textColor     = [UIColor darkGrayColor];
        lable.textAlignment = NSTextAlignmentLeft;
        lable.text          = @"选择发布类型: ";
        
        lable;
    });
    
    [self.view addSubview:choseLable];
    
    //添加选择Segment
    self.segmentController = ({
    
        UISegmentedControl *segement = \
            [[UISegmentedControl alloc] initWithFrame: CGRectMake(10, 45, SCREEN_WIDTH - 20, 35)];
        
        [segement insertSegmentWithTitle:@"发布寻人" atIndex:0 animated:YES];
        [segement insertSegmentWithTitle:@"发布随拍" atIndex:1 animated:YES];
        
        [segement setTintColor:[UIColor orangeColor]];
        [segement setBackgroundColor:[UIColor whiteColor]];
        
        segement.layer.cornerRadius = 5.0;
        
        segement;
    });
    
    [self.view addSubview:self.segmentController];
    
    //添加输入描述信息Lable
    UILabel *mentionLable = ({
        
        UILabel *lable      = \
        [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 180, 25)];
        lable.font          = [UIFont systemFontOfSize:12];
        lable.textColor     = [UIColor darkGrayColor];
        lable.textAlignment = NSTextAlignmentLeft;
        lable.text          = @"输入描述信息: ";
        
        lable;
    });
    
    [self.view addSubview:mentionLable];
    
    //添加输入框
    self.infoTextView = ({
        
        UITextView *text = [[UITextView alloc] initWithFrame:\
                            CGRectMake(10, 125, SCREEN_WIDTH-20, 120)];
        
        text;
    });
    
    [self.view addSubview:self.infoTextView];
    
    //创建Image展示
    //[self createImageGroup];
    
    //照片提示
    UILabel *imgMentionLable = ({
    
        UILabel *lable      = \
        [[UILabel alloc] initWithFrame:CGRectMake(10, 265, 280, 25)];
        lable.font          = [UIFont systemFontOfSize:12];
        lable.textColor     = [UIColor darkGrayColor];
        lable.textAlignment = NSTextAlignmentLeft;
        lable.text          = @"照片: (最多5张, 点击加号添加, 点击图片删除)";
        
        lable;
    });
    
    [self.view addSubview:imgMentionLable];
    //创建ImageCollection
    [self createCollection];
    
    //初始化发布按钮
    self.submitBarButton = [[UIBarButtonItem alloc] initWithTitle:@"发布"
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(submitAction)];
    
    self.navigationItem.rightBarButtonItem = self.submitBarButton;
    
    //初始化UIImagePicker
    self.picker          = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;

}

- (void)createCollection {
    
    self.dataSource = [[SubmitDataSource alloc] initWithImageArray:self.imageMutableArray
                                                         Identifer:submitCellIdentifer];
    
    self.myCollection = ({
    
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        flowLayout.scrollDirection             = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize                    = \
                                CGSizeMake((SCREEN_WIDTH - 40) / 5, (SCREEN_WIDTH - 40) / 5);
        flowLayout.minimumLineSpacing          = 5;
        flowLayout.minimumInteritemSpacing     = 0;
        
        UICollectionView *collection = [[UICollectionView alloc] initWithFrame:\
                                        CGRectMake(10, 290, SCREEN_WIDTH - 20, (SCREEN_WIDTH - 30) / 5)
                                                          collectionViewLayout:flowLayout];
        collection.dataSource        = self.dataSource;
        collection.delegate          = self;
        collection.scrollEnabled     = NO;
        collection.backgroundColor   = BackColor;
        collection.showsHorizontalScrollIndicator = NO;

        
        //注册selectImageCell
        [collection registerClass:[selectedImageCell class]
       forCellWithReuseIdentifier:submitCellIdentifer];
        
        collection;
    });
    
    [self.view addSubview:self.myCollection];
}

- (void)createImageGroup {
    
    CGSize imgSize = CGSizeMake((SCREEN_WIDTH - 30) / 5, (SCREEN_WIDTH - 30) / 5);
    
    for (int i = 0; i < self.imageMutableArray.count; i ++) {
        
        CGRect frame            = \
        CGRectMake((i + 1) * 5 + i * imgSize.width, 35 + 230, imgSize.width, imgSize.height);
        
        UIImageView *imgView    = [[UIImageView alloc] initWithFrame:frame];
        imgView.backgroundColor = [UIColor whiteColor];
        imgView.image           = [self.imageMutableArray objectAtIndex:i];
        
        [self.view addSubview:imgView];
    }
    
    if (self.imageMutableArray.count < 5) {
        
        int i = (int)self.imageMutableArray.count;
        
        CGRect frame                   = \
            CGRectMake((i + 1) * 5 + i * imgSize.width, 35 + 230, imgSize.width, imgSize.height);
        
        UIImageView *imgView           = [[UIImageView alloc] initWithFrame:frame];
        imgView.image                  = [UIImage imageNamed:@"添加.png"];
        UITapGestureRecognizer *tap    = \
                [[UITapGestureRecognizer alloc] initWithTarget:self
                                                        action:@selector(addImage)];

        [imgView addGestureRecognizer:tap];
        [imgView setUserInteractionEnabled:YES];
        [self.view addSubview:imgView];
    }
    
}

//Camera按钮响应事件
- (void)addImage {
    
    if (self.imageMutableArray.count > 4) {
        
        [SVProgressHUD showInfoWithStatus:@"最多5张照片哦"];
        [SVProgressHUD dismissWithDelay:1];
    } else {
        
        LRLog(@"添加图片");
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
    
}

- (void)removeImageAtIndexPath:(NSIndexPath *)indexPath{
    
    UIAlertController *alertController = \
    [UIAlertController alertControllerWithTitle:@""
                                        message:@"删除这张照片吗?"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    LRWeakSelf(self)
    UIAlertAction *delete = \
    [UIAlertAction actionWithTitle:@"删除"
                             style:UIAlertActionStyleDestructive
                           handler:^(UIAlertAction * _Nonnull action) {
        
                               LRStrongSelf(self)
                               [self.imageMutableArray removeObjectAtIndex:indexPath.row];
                               [self.myCollection reloadData];
                           }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    
    [alertController addAction:delete];
    [alertController addAction:cancel];
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

//定位
- (void)startToGetLocation {
    
    if ([CLLocationManager locationServicesEnabled]) {
        //NSLog(@"开始执行定位服务");
        [SVProgressHUD showWithStatus:@"准备中"];
        self.mapView                   = [[MKMapView alloc] initWithFrame:\
                                          CGRectMake(self.view.bounds.size.width,
                                                     0,
                                                     self.view.bounds.size.width,
                                                     self.view.bounds.size.height)];
        self.mapView.mapType           = MKMapTypeStandard;
        self.mapView.zoomEnabled       = YES;
        self.mapView.scrollEnabled     = YES;
        self.mapView.showsUserLocation = YES;
        self.mapView.delegate          = self;
        
        
        CLLocationCoordinate2D center;
        center.latitude  = 29.776171;
        center.longitude = 106.669782;
        
        MKCoordinateSpan span;
        span.latitudeDelta  = 0.01;
        span.longitudeDelta = 0.01;
        
        MKCoordinateRegion region = {center, span};
        
        [self.mapView setRegion:region animated:YES];
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.title              = @"发布地点:";
        annotation.subtitle           = @"青岛台东一路";
        annotation.coordinate         = center;
        [self.mapView addAnnotation:annotation];
        [self.view addSubview:self.mapView];
    } else {
        
        [SVProgressHUD showInfoWithStatus:@"无法定位, 请检查是否有打开定位功能"];
        [SVProgressHUD dismissWithDelay:1];
        self.navigationController.navigationBar.userInteractionEnabled = YES;
    }

}

//发送邮件
- (void)sendMail {
    
    [SVProgressHUD showWithStatus:@"发送中"];
    
    SKPSMTPMessage * mm=[[SKPSMTPMessage alloc] init];
    
    //设置邮件标题
    NSString *subTitle;
    if (self.segmentController.selectedSegmentIndex) {
        
        subTitle = @"发布随拍";
    } else {
        
        subTitle = @"发布寻人";
    }
    
    [mm setSubject:subTitle];
    [mm setToEmail:@"zhouxihi@aliyun.com"];
    [mm setFromEmail:@"zhouxihi@yeah.net"];
    [mm setRelayHost:@"smtp.yeah.net"];
    [mm setRequiresAuth:YES];
    [mm setLogin:@"zhouxihi@yeah.net"];
    [mm setPass:@"594588zx"];
    [mm setWantsSecure:YES];
    [mm setDelegate:self];
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];

    //配置邮件信息
    
    //描述信息
    NSString *locat = [NSString stringWithFormat:@"描述信息:\n%@", self.infoTextView.text];
    
    //发送账号
    locat = [locat stringByAppendingString:\
             [NSString stringWithFormat:@"\n\n发送账号: \n%@", [zx_SN account]]];
    
    //发送城市
    locat = [locat stringByAppendingString:\
             [NSString stringWithFormat:@"\n\n城市: \n%@", self.city]];
    
    //发送街道
    locat = [locat stringByAppendingString:\
             [NSString stringWithFormat:@"\n\n街道: \n%@", self.jiedao]];
    
    //纬度
    locat = [locat stringByAppendingString:\
             [NSString stringWithFormat:@"\n\n纬度: \n%f", self.latitude]];
    
    //经度
    locat = [locat stringByAppendingString:\
             [NSString stringWithFormat:@"\n\n经度: \n%f", self.longitude]];
    //正文
    NSDictionary *zhengwen = @{kSKPSMTPPartContentTypeKey: @"text/plain", kSKPSMTPPartMessageKey: locat, kSKPSMTPPartContentTransferEncodingKey: @"8bit"};
    [mutableArray addObject:zhengwen];
    
    //附件
    for (int i = 0; i < self.imageMutableArray.count; i ++) {
        NSData *data = UIImagePNGRepresentation([self.imageMutableArray objectAtIndex:i]);
        NSString *typeKey = [NSString stringWithFormat:@"image/png;\r\n\tx-unix-mode=0644;\r\n\tname=\"%d.png\"", i];
        NSString *dispositionKey = [NSString stringWithFormat:@"attachment;\r\n\tfilename=\"%d.png\"", i];
        NSDictionary *part = @{kSKPSMTPPartContentTypeKey: typeKey, kSKPSMTPPartContentDispositionKey: dispositionKey, kSKPSMTPPartMessageKey: [data encodeBase64ForData], kSKPSMTPPartContentTransferEncodingKey: @"base64"};
        [mutableArray addObject:part];
    }
    
    NSArray *array = [mutableArray copy];
    
    [mm setParts:array];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [mm send];
    });
    
}

- (void)submitAction {
    
    if (self.segmentController.selectedSegmentIndex < 0) {
        
        [SVProgressHUD showInfoWithStatus:@"请选择发布类型"];
        [SVProgressHUD dismissWithDelay:1];
    }
    else if ([self.infoTextView.text isEqualToString:@""]) {
        
        [SVProgressHUD showInfoWithStatus:@"请输入描述信息"];
        [SVProgressHUD dismissWithDelay:1];
    }
    else if (![zx_SN loginStatus]) {
        
        [SVProgressHUD showInfoWithStatus:@"请先登录"];
        [SVProgressHUD dismissWithDelay:1];
    }
    else {
        
        self.maplock = FALSE;
        self.navigationController.navigationBar.userInteractionEnabled = NO;
        LRLog(@"发布");
        [self startToGetLocation];
    }
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    LRLog(@"成功: %@", info);
    
    //获取用户拍摄的是照片还是视频
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    LRLog(@"类型: %@", mediaType);
    
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
        UIImageWriteToSavedPhotosAlbum(theImage, self, nil, nil);
        
        [self.imageMutableArray addObject:theImage];
        [self.myCollection reloadData];
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
        
        [self.imageMutableArray addObject:theImage];
        [self.myCollection reloadData];
    }
    //如果是视频则提示不支持
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        
        [SVProgressHUD showInfoWithStatus:@"暂不支持视频格式"];
        [SVProgressHUD dismissWithDelay:1];
    }
    
    [self.picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self.picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - CollectionDelegate methods

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.imageMutableArray.count && self.imageMutableArray.count < 5) {
        
        [self addImage];
    }
    else if (self.imageMutableArray.count == 0) {
        
        [self addImage];
    }
    else {
        
        [self removeImageAtIndexPath:indexPath];
    }
}

#pragma mark - SKPSMTPMessageDelegate delegate methods

- (void)messageSent:(SKPSMTPMessage *)message {
    
    LRWeakSelf(self)
    [SVProgressHUD showSuccessWithStatus:@"发布成功, 愿所有宝贝早日回家"];
    [SVProgressHUD dismissWithDelay:1 completion:^{
        
        LRStrongSelf(self)
        self.navigationController.navigationBar.userInteractionEnabled = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error {
    LRLog(@"发送失败");
    LRLog(@"---------------------Fail code-------------------");
    LRLog(@"message - %@\nerror - %@", message, error);
    LRLog(@"---------------------Fail code-------------------");
    
    LRWeakSelf(self)
    [SVProgressHUD showInfoWithStatus:@"发布失败, 请使用 WiFi/4G 网络, 或稍后再尝试发布"];
    [SVProgressHUD dismissWithDelay:1 completion:^{
        
        LRStrongSelf(self)
        self.navigationController.navigationBar.userInteractionEnabled = YES;
    }];
}

#pragma mark - MapView delegate methods

- (void)mapView:(MKMapView *)mapView
didUpdateUserLocation:(MKUserLocation *)userLocation NS_AVAILABLE(10_9, 4_0) {
    
    if (!self.maplock) {
        
        self.maplock = TRUE;
        
        CLLocationCoordinate2D coord = [userLocation coordinate];

        self.latitude  = coord.latitude;
        self.longitude = coord.longitude;
        
        //[SVProgressHUD showWithStatus:@"定位成功, 开始解析"];

        [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            if (placemarks.count > 0) {
                CLPlacemark *placemark = placemarks[0];
                
                self.city = placemark.locality;
                
                NSArray *addrArray = [placemark.addressDictionary objectForKey:@"FormattedAddressLines"];
                NSMutableString *addr = [[NSMutableString alloc] init];
                for (int i = 0; i < addrArray.count; i++) {
                    [addr appendString:addrArray[i]];
                }
                //[SVProgressHUD showWithStatus:@"解析成功"];
                self.jiedao = [addr copy];
                
                self.mapView = nil;
                [self sendMail];
                
            } else {

                LRWeakSelf(self)
                [SVProgressHUD showInfoWithStatus:@"网络异常"];
                [SVProgressHUD dismissWithDelay:1 completion:^{
                    
                    LRStrongSelf(self)
                    self.mapView = nil;
                    self.navigationController.navigationBar.userInteractionEnabled = YES;
                }];
            }
        }];
    }
    
}

@end
