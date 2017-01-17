//
//  HomeViewController.m
//  ZXTabBarController
//
//  Created by Jackey on 2016/12/14.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "HomeViewController.h"
#import "AFNetworking.h"
#import "HomeDataSource.h"
#import "YYModel.h"
#import "MainModel.h"
#import "JSONKit.h"
#import "CategoryCell.h"
#import "HomeCell.h"
#import "HomeHeaderView.h"
#import "MJRefresh.h"
#import "MessageViewController.h"
#import "WebViewController.h"
#import "MoreCategoryViewController.h"
#import "DetailViewController.h"
#import "SNManager.h"
#import "SDCHeader.h"

static NSString * const CategoryCellIdentifier = @"CategoryCellIdentifier";
static NSString * const HomeCellIdentifer      = @"HomeCellIdentifer";
static NSString * const HeaderViewIdentifer    = @"HeaderViewIdentifer";
static NSString * const SDCHeaderIdentifer     = @"SDCHeaderIdentifer";

@interface HomeViewController ()
<UICollectionViewDelegateFlowLayout, HomeHeaderProtocol, SDCycleScrollViewDelegate>

@property (nonatomic, strong) AFHTTPSessionManager *manager;                //AFN Manager
@property (nonatomic, strong) UICollectionView     *myCollectionView;       //CollectionView
@property (nonatomic, strong) HomeDataSource       *dataSource;             //dataSource
@property (nonatomic, strong) NSArray              *models;                 //存储所有模型
@property (nonatomic, strong) NSMutableArray       *showModels;             //存储要显示的模型
@property (nonatomic, strong) NSMutableArray       *teBieArray;             //存储特别寻人模型
@property (nonatomic, strong) NSMutableArray       *liJiaArray;             //存储离家出走模型
@property (nonatomic, strong) NSMutableArray       *beiGuaiArray;           //存储被拐被骗模型
@property (nonatomic, strong) NSMutableArray       *miLuArray;              //存储迷路走失模型
@property (nonatomic, strong) NSMutableArray       *buMingArray;            //存储不明原因模型
@property (nonatomic, strong) NSMutableArray       *erNvArray;              //存储儿女寻家模型

@end

@implementation HomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    //1.初始化数组及AFN
    [self initData];
    
    //2.创建CollectionCellView
    [self initView];
    
    //3.调用CollectionView的下拉刷新, 开始加载数据
    //[self.myCollectionView.mj_header beginRefreshing];
    [self downloadMainData];
    
    //test
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

//初始化数组及AFN
- (void)initData {
    
    //初始化数组
    self.models       = @[];
    self.showModels   = [@[] mutableCopy];
    self.teBieArray   = [@[] mutableCopy];
    self.liJiaArray   = [@[] mutableCopy];
    self.beiGuaiArray = [@[] mutableCopy];
    self.miLuArray    = [@[] mutableCopy];
    self.buMingArray  = [@[] mutableCopy];
    self.erNvArray    = [@[] mutableCopy];
    
    self.models       = @[self.teBieArray,
                          self.liJiaArray,
                          self.beiGuaiArray,
                          self.miLuArray,
                          self.buMingArray,
                          self.erNvArray];
    
    //初始化AFN manager
    self.manager      = ({
        
        AFHTTPSessionManager *manager           = [AFHTTPSessionManager manager];
        AFSecurityPolicy *securityPolicy        = \
        [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
        
        securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy                  = securityPolicy;
        
        manager;
    });
    
}

//创建CollectionCellView
- (void)initView {
    
    //[self.navigationController.navigationBar setHidden:YES];
    //self.hidesBottomBarWhenPushed=YES;
    
    //设置背景色
    [self.view setBackgroundColor:BackColor];
    
    //初始化datasource
    self.dataSource = ({
    
        HomeDataSource *dataSource = [[HomeDataSource alloc] \
                                      initWithModels:self.showModels
                               CategoryCellIdentifer:CategoryCellIdentifier
                                   HomeCellIdentifer:HomeCellIdentifer
                                 HomeHeaderIdentifer:HeaderViewIdentifer];
        
        dataSource.delegate        = self;
        dataSource;
    });
    
    //创建CollectionView
    self.myCollectionView = ({
    
        //创建CollectionFlowLayout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.scrollDirection             = UICollectionViewScrollDirectionVertical;
        
        //创建CollectionView
        UICollectionView *collection            = [[UICollectionView alloc] \
                                         initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                  collectionViewLayout:layout];
        
        collection.dataSource                   = self.dataSource;
        collection.delegate                     = self;
        //collection.contentInset                 = UIEdgeInsetsMake(0, 0, 140, 0);
        collection.showsVerticalScrollIndicator = NO;
        
        //注册Cell Class & HeaderView Class
        [collection registerClass:[CategoryCell class]
       forCellWithReuseIdentifier:CategoryCellIdentifier];
        
        [collection registerClass:[HomeCell class]
       forCellWithReuseIdentifier:HomeCellIdentifer];
        
        [collection registerClass:[HomeHeaderView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:HeaderViewIdentifer];
        
        [collection registerClass:[SDCHeader class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:SDCHeaderIdentifer];
        
        //设置背景色
        [collection setBackgroundColor:BackColor];
        
        LRWeakSelf(self)
        
        //设置下拉刷新
        collection.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            LRStrongSelf(self)
            [self.myCollectionView.mj_footer resetNoMoreData];
            [self downloadMainData];
        }];
        
        //设置上拉刷新
        collection.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            LRStrongSelf(self)
            if (self.models.count > self.showModels.count) {
                
                [self addinShowModels];
                [self.myCollectionView reloadData];
                [self.myCollectionView.mj_footer endRefreshing];
            } else {
                
                [self.myCollectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
        
        collection;
    });
    
    [self.view addSubview:self.myCollectionView];
    
    
    //解决TabBar遮挡
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myCollectionView.autoresizingMask = \
    UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

//调用下载数据方法
- (void)downloadMainData {
    
    [self downloadFrom:MainJSONAddress];

}

//删除旧数据
- (void)deleteOldData {
    
    [self.showModels    removeAllObjects];
    [self.teBieArray    removeAllObjects];
    [self.liJiaArray    removeAllObjects];
    [self.beiGuaiArray  removeAllObjects];
    [self.miLuArray     removeAllObjects];
    [self.buMingArray   removeAllObjects];
    [self.erNvArray     removeAllObjects];

}

//重新配置要显示的数据
- (void)configureShowModels {
    
    [self.showModels removeAllObjects];
    
    [self.showModels addObject:self.models[0]];
}

//上拉后增加要显示的数据
- (void)addinShowModels {
    
    if (self.models.count > self.showModels.count) {
        
        [self.showModels addObject:self.models[self.showModels.count]];
    }
}

//下载数据
- (void)downloadFrom:(NSString *)address {
    
    LRWeakSelf(self)
    [self.manager GET:address parameters:nil progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
                  LRStrongSelf(self)
        
                  //删除旧数据
                  [self deleteOldData];
        
                  NSArray *tempArray = (NSArray *)responseObject;
        
                  for (int i = 0; i < 6; i ++) {
            
                      for (NSDictionary *dict in tempArray[i]) {
                
                          MainModel *model = [MainModel yy_modelWithDictionary:dict];
                
                          [self.models[i] addObject:model];
                      }
                  }
                  
                  //设置要显示的数据
                  [self configureShowModels];
                  
                  [self.myCollectionView reloadData];
                  [self.myCollectionView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        LRLog(@"Error: %@", error);
        [self.myCollectionView.mj_header endRefreshing];
    }];
}

#pragma mark - CollectionFlowLayout Delegate 

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
    sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == kMainCategory) {
        
        return CGSizeMake(SCREEN_WIDTH / 5, 10 + SCREEN_WIDTH / 5 - SCREEN_WIDTH / 15 + 25);
    } else {
        
        return CGSizeMake((SCREEN_WIDTH - 2.5 ) / 2 , (SCREEN_WIDTH / 4 - 5) * 1.5 + 20);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    
    if (section) {
        
        return UIEdgeInsetsMake(1, 0.5, 4, 0.5);
    } else {
        
        return UIEdgeInsetsMake(0, 0, 4, 0);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
    minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    if (section == kMainCategory) {
        
        return 0;
    } else return 1.2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
    minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    if (section == kMainCategory) {
        
        return 0;
    } else return 1.2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
    referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section) {
        return CGSizeMake(SCREEN_WIDTH, 25);
    }
    
    return CGSizeMake(SCREEN_WIDTH, 120);
}

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //点击消息分类时
    if (indexPath.section == kMainCategory) {
        
        if (indexPath.row > 4 && indexPath.row < 9) {
            
            MessageViewController *messageVC = [[MessageViewController alloc] init];
            messageVC.type                   = indexPath.row - 4;
            
            [self.navigationController pushViewController:messageVC animated:YES];
        }
        else if (indexPath.row == 9) {
            
            WebViewController *webVC = [[WebViewController alloc] init];
            webVC.strOfURL           = urlOfRuHeFaBu;
            webVC.info               = @"如何发布";
            
            [self.navigationController pushViewController:webVC animated:YES];
        } else {
            
            MoreCategoryViewController *moreVC = [[MoreCategoryViewController alloc] init];
            moreVC.type                        = indexPath.row + 2;
            
            [self.navigationController pushViewController:moreVC animated:YES];
        }
    } else {
        
        MainModel *model = \
        [[self.showModels objectAtIndex:indexPath.section -1] objectAtIndex:indexPath.row];
        
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.info     = model.DetailInfo;
        detailVC.number   = model.Number;
        detailVC.imgArray = model.DetailImagePathArray;
        detailVC.title    = model.Name;
        
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
}

#pragma mark - HomeHeader Delegate Methods

- (void)headerDidClickedWithCategoryType:(CategoryType)type {
    
    MoreCategoryViewController *moreVC = [[MoreCategoryViewController alloc] init];
    moreVC.type                        = type;
    
    [self.navigationController pushViewController:moreVC animated:YES];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    LRLog(@"接收到点击SDC");
    if (index == 0) {
        
        UIAlertController *alertController = \
        [UIAlertController alertControllerWithTitle:@"提示"
                                            message:@"跳转至全国打拐解救儿童寻亲公告平台"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"好的"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {

                            WebViewController *webVC      = [[WebViewController alloc] init];
                            webVC.strOfURL                = quanGuoDaGuaiAddress;
                            webVC.fit = YES;
                                                       
                            [self.navigationController pushViewController:webVC animated:YES];

                                                   }];
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"不要"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {

        
                                                   }];
        [alertController addAction:ok];
        [alertController addAction:no];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    else if (index == 1) {
        
        WebViewController *webVC      = [[WebViewController alloc] init];
        webVC.strOfURL                = fangGuaiShouCe;
        webVC.info                    = @"防拐防骗";
        
        [self.navigationController pushViewController:webVC animated:YES];
    }
    
    else if (index == 2) {
        
        WebViewController *webVC      = [[WebViewController alloc] init];
        webVC.strOfURL                = urlOfMianZe;
        webVC.info                    = @"免责申明";
        
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

@end
