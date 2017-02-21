//
//  MessageViewController.m
//  ZXTabBarController
//
//  Created by Jackey on 2016/12/14.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "MessageViewController.h"
#import "AFNetworking.h"
#import "MessageModel.h"
#import "MessageDataSource.h"
#import "YYModel.h"
#import "MJRefresh.h"
#import "WebViewController.h"

static NSString * const MESSAGECELL = @"MessageCell";

@interface MessageViewController () <UITableViewDelegate>

@property (nonatomic, strong) UITableView          *myTableView;
@property (nonatomic, strong) MessageDataSource    *dataSource;
@property (nonatomic, strong) NSMutableArray       *models;        //保存所有数据
@property (nonatomic, strong) NSMutableArray       *showModels;    //保存当前显示的数据
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSString             *address;
@property (nonatomic, strong) NSRecursiveLock      *lock;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //1.初始化模型数组, 锁, AFN, Message类型
    [self initData];
    
    //2.设置背景色, 创建TableView后添加到界面
    [self initView];
    
    //3.调用TableView下拉刷新, 开始下载网络数据
    [self.myTableView.mj_header beginRefreshing];
}

//初始化模型数组, 锁, AFN, Message类型
- (void)initData {
    
    self.models     = [@[] mutableCopy];
    self.showModels = [@[] mutableCopy];
    self.lock       = [[NSRecursiveLock alloc] init];
    
    self.manager = ({
    
        AFHTTPSessionManager *manager           = [AFHTTPSessionManager manager];
        AFSecurityPolicy *securityPolicy        = \
        [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
        
        securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy                  = securityPolicy;
        
        manager;
    });
    
    //设定Type类型
    switch (self.type) {
        case kMainMesage:
            self.address = urlOfMainMessage;
            break;
            
        case kXingWen:
            self.address = urlOfXinWenZhongXin;
            break;
        
        case kFangGuai:
            self.address = urlOfFangGuaiFangPian;
            break;
            
        case kXieFa:
            self.address = urlOfXieFaTongGao;
            break;
            
        case kBenZhan:
            self.address = urlOfBenZhanGongGao;
            break;
            
        default:
            self.address = urlOfMainMessage;
            break;
    }
}

//设置背景色, 创建TableView后添加到界面
- (void)initView {
    
    [self.view setBackgroundColor:BackColor];
    
    //挡住TabBar黑框
    UIView *view = ({
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 49)];
        view.backgroundColor = BackColor;
        
        view;
    });
    
    [self.view addSubview:view];
    [self createTableView];
}

//创建TableView
- (void)createTableView {
    
    //初始化DataSource
    self.dataSource = ({
        
        MessageDataSource *dataSource = [[MessageDataSource alloc] initWithModels:self.showModels
                                                                   withIdentifier:MESSAGECELL];
        dataSource.models             = self.showModels;
        dataSource;
    });
    
    //创建TableView
    self.myTableView = ({
        
        UITableView *tableView         = [[UITableView alloc] initWithFrame:\
                                            CGRectMake(10, 0, SCREEN_WIDTH - 20, SCREEN_HEIGHT)
                                                              style:UITableViewStyleGrouped];
        tableView.dataSource           = self.dataSource;
        tableView.delegate             = self;
        tableView.separatorStyle       = NO;
        tableView.sectionHeaderHeight  = 0.0f;
        tableView.sectionFooterHeight  = 10.0f;
        //tableView.contentInset         = UIEdgeInsetsMake(0, 0, 140, 0);
        
        LRWeakSelf(self);
        
        //设置下拉刷新
        //bleView下拉刷新, 开始下载网络数据
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            LRStrongSelf(self);
            [self.myTableView.mj_footer resetNoMoreData];
            [self.myTableView.mj_footer setHidden:NO];
            [self downloadMessageData];
        }];
        
        //设置上拉刷新
        //增加要显示的内容
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            LRStrongSelf(self);
            if (self.models.count > self.showModels.count) {
                
                [self addShowModels];   //调用给showModels添加数据的方法
                
                [self.myTableView.mj_footer endRefreshing];
                [self.myTableView reloadData];
        
            } else {
                
                [self.myTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
        
        [tableView.mj_footer setAutomaticallyHidden:YES];
        
        //tableView.contentInset                 = UIEdgeInsetsMake(0, 0, 180, 0);
        tableView.showsVerticalScrollIndicator = NO;
        
        tableView;
        
    });
    
    //添加TableView到主界面
    [self.view addSubview:self.myTableView];
    
    //解决TabBar遮挡
    self.edgesForExtendedLayout               = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myTableView.autoresizingMask         = \
                        UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

//根据models设置初始showmodels
- (void)setUpShowModels {
    
    if (self.models.count > 11) {
        for (MessageModel *model in self.models) {
            
            [self.showModels addObject:model];
            if (self.showModels.count == 11) return;
        }
    } else {
        for (MessageModel *model in self.models) {
            
            [self.showModels addObject:model];
        }
    }
}

//上拉后增加要显示的数据
- (void)addShowModels {
    
    if (self.models.count > self.showModels.count) {
        
        if (self.models.count - self.showModels.count >= 11) {
            
            //添加11个数据
            [self.showModels addObject:self.models[self.showModels.count]];
            [self.showModels addObject:self.models[self.showModels.count]];
            [self.showModels addObject:self.models[self.showModels.count]];
            [self.showModels addObject:self.models[self.showModels.count]];
            [self.showModels addObject:self.models[self.showModels.count]];
            [self.showModels addObject:self.models[self.showModels.count]];
            [self.showModels addObject:self.models[self.showModels.count]];
            [self.showModels addObject:self.models[self.showModels.count]];
            [self.showModels addObject:self.models[self.showModels.count]];
            [self.showModels addObject:self.models[self.showModels.count]];
            [self.showModels addObject:self.models[self.showModels.count]];
        } else {
            
            [self.showModels removeAllObjects];
            for (MessageModel *model in self.models) {
                
                [self.showModels addObject:model];
            }
        }
    }
}

//下载消息数据
- (void)downloadMessageData {
    
    [self.lock lock];
    [self.manager GET:self.address parameters:nil progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //清空旧数据
        [self.models removeAllObjects];
        [self.showModels removeAllObjects];
        
        //处理和添加新数据
        for (NSDictionary *dict in (NSArray *)responseObject) {
            
            MessageModel *model = [MessageModel yy_modelWithDictionary:dict];
            
            [self.models addObject:model];
        }
        
//                  LRLog(@"%d", self.models.count);
        //设定要显示的数据
        [self setUpShowModels];
        
        //刷新Tableview
        [self.myTableView reloadData];
        [self.myTableView.mj_header endRefreshing];
        [self.lock unlock];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@", error);
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer setHidden:YES];
        [self.lock unlock];
    }];
}

#pragma mark - TableView Delegate Method
//点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    MessageModel *model = [self.showModels objectAtIndex:indexPath.section];
    
    //反选
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    
    //创建WebViewController
    WebViewController *webVC = [[WebViewController alloc] init];
    
    //设置Title & URL
    webVC.info    = model.Detail;
    webVC.strOfURL = model.URL;
    
    //跳转
    [self.navigationController pushViewController:webVC animated:YES];
}

@end
