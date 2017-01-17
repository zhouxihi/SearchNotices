//
//  MoreCategoryViewController.m
//  SearchNotices
//
//  Created by Jackey on 2016/12/25.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "MoreCategoryViewController.h"
#import "MoreCategoryDataSource.h"
#import "MoreCategoryTableCell.h"
#import "MainModel.h"
#import "AFNetworking.h"
#import "YYModel.h"
#import "MJRefresh.h"
#import "DetailViewController.h"

static NSString * const MoreCategoryIdentifer = @"MoreCategoryTableCellIdentifer";

@interface MoreCategoryViewController ()<UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray         *models;           //存储全部的数据
@property (nonatomic, strong) NSMutableArray         *showModels;       //存储当前要显示的数据
@property (nonatomic, strong) UITableView            *myTableView;
@property (nonatomic, strong) MoreCategoryDataSource *dataSource;       //自定义Datasource
@property (nonatomic, strong) AFHTTPSessionManager   *manager;          //AFN
@property (nonatomic, strong) NSString               *address;          //分类下载地址

@end

@implementation MoreCategoryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //1.初始化数组, AFN, 数据源等
    [self initData];
    
    //2.初始化TableView;
    [self initView];
    
    //3.调用TableView下拉刷新开始加载数据
    [self.myTableView.mj_header beginRefreshing];
}

//初始化数组, AFN
- (void)initData {
    
    //初始化数组
    self.models     = [@[] mutableCopy];
    self.showModels = [@[] mutableCopy];
    
    //初始化AFN manager
    self.manager      = ({
        
        AFHTTPSessionManager *manager           = [AFHTTPSessionManager manager];
        AFSecurityPolicy *securityPolicy        = \
            [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
        
        securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy                  = securityPolicy;
        
        manager;
    });
    
    //设置数据源地址
    [self setDownloadURL];
}

//初始化TableView
- (void)initView {
    
    //设置背景色
    [self.view setBackgroundColor:BackColor];
    
    //挡住TabBar黑框
    UIView *view = ({
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 49)];
        view.backgroundColor = BackColor;
        
        view;
    });
    
    [self.view addSubview:view];
    
    //先初始化DataSource
    self.dataSource = ({
        
        MoreCategoryDataSource *dataSource = \
            [[MoreCategoryDataSource alloc] initWithModels:self.showModels
                                            withIdentifier:MoreCategoryIdentifer];
        
        dataSource;
    });
    
    //初始化TableView
    self.myTableView = ({
        
        UITableView *tableView         = \
            [[UITableView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, SCREEN_HEIGHT)
                                         style:UITableViewStyleGrouped];
        
        tableView.dataSource           = self.dataSource;
        tableView.delegate             = self;
        tableView.sectionHeaderHeight  = 0.0f;
        tableView.sectionFooterHeight  = 10.0f;
        tableView.tableFooterView      = [UIView new];
        //tableView.contentInset         = UIEdgeInsetsMake(0, 0, 140, 0);
        
        //设置透明分割线
        [tableView setSeparatorColor:[UIColor clearColor]];
        //注册Cell class
        [tableView registerClass:[MoreCategoryTableCell class]
          forCellReuseIdentifier:MoreCategoryIdentifer];
        
        tableView.showsVerticalScrollIndicator = NO;
        
        LRWeakSelf(self)
        //设置下拉刷新
        tableView.mj_header    = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            LRStrongSelf(self)
            [self.myTableView.mj_footer resetNoMoreData];
            [self.myTableView.mj_footer setHidden:NO];
            [self downloadFromAddress:self.address];
        }];
        
        //设置上拉刷新
        tableView.mj_footer    = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            LRStrongSelf(self)
            if (self.models.count > self.showModels.count) {
                
                [self addShowModels];
                [self.myTableView.mj_footer endRefreshing];
            } else {
                
                [self.myTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
        
        tableView;
    });
    
    //添加TableView到UI
    [self.view addSubview:self.myTableView];
    
    //解决TabBar遮挡
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myTableView.autoresizingMask = \
    UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

//根据models设置初始showmodels
- (void)setUpShowModels {
    
    if (self.models.count > 7) {
        
        for (MainModel *model in self.models) {
            
            [self.showModels addObject:model];
            if (self.showModels.count == 7) return;
        }
    } else {
        
        for (MainModel *model in self.models) {
            
            [self.showModels addObject:model];
        }
    }
}

//上拉后增加要显示的数据
- (void)addShowModels {
    
    if (self.models.count > self.showModels.count) {
        
        if (self.models.count - self.showModels.count >= 7) {
            
            //添加7个数据
            [self.showModels addObject:self.models[self.showModels.count]];
            [self.showModels addObject:self.models[self.showModels.count]];
            [self.showModels addObject:self.models[self.showModels.count]];
            [self.showModels addObject:self.models[self.showModels.count]];
            [self.showModels addObject:self.models[self.showModels.count]];
            [self.showModels addObject:self.models[self.showModels.count]];
            [self.showModels addObject:self.models[self.showModels.count]];
        } else {
            
            [self.showModels removeAllObjects];
            for (MainModel *model in self.models) {
                
                [self.showModels addObject:model];
            }
        }
    }
}

//设置数据源地址
- (void)setDownloadURL {
    
    if (self.type == kLiJiaChuZou) {
        
        self.address = liJiaChuZouAddress;
        self.title   = @"离家出走";
    }
    
    if (self.type == kBeiGuaiBeiPian) {
        
        self.address = beiGuaiBeiPianAddress;
        self.title   = @"被拐被骗";
    }
    
    if (self.type == kMiLuZouShi) {
        
        self.address = miLuZouShiAddress;
        self.title   = @"迷路走失";
    }
    
    if (self.type == kBuMingYuanYin) {
        
        self.address = buMingYuanYinAddress;
        self.title   = @"不明原因";
    }
    
    if (self.type == kErNvXunJia) {
        
        self.address = erNvXunJiaAddress;
        self.title   = @"儿女寻家";
    }
}

- (void)downloadFromAddress:(NSString *)address {
    
    LRWeakSelf(self)
    [self.manager GET:address parameters:nil progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            LRStrongSelf(self)
            
            //清除旧数据
            [self.models     removeAllObjects];
            [self.showModels removeAllObjects];
            
            for (NSDictionary *dict in (NSArray *)responseObject) {
                
                MainModel *model = [MainModel yy_modelWithDictionary:dict];
                [self.models addObject:model];
            }
            
            [self setUpShowModels];
            [self.myTableView reloadData];
            [self.myTableView.mj_header endRefreshing];
            [self.myTableView.mj_footer setHidden:NO];
            
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        LRLog(@"Error: %@", error);
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer setHidden:YES];
    }];
}

#pragma mark - UITableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return SCREEN_WIDTH / 6 + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    
    detailVC.imgArray = \
        [[self.showModels objectAtIndex:indexPath.section] valueForKey:@"DetailImagePathArray"];
    detailVC.info     = \
        [[self.showModels objectAtIndex:indexPath.section] valueForKey:@"DetailInfo"];
    detailVC.title    = \
        [[self.showModels objectAtIndex:indexPath.section] valueForKey:@"Name"];
    detailVC.number    = \
    [[self.showModels objectAtIndex:indexPath.section] valueForKey:@"Number"];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
