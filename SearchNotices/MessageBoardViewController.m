//
//  MessageBoardViewController.m
//  SearchNotices
//
//  Created by Jackey on 2016/12/18.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "MessageBoardViewController.h"
#import "AFHTTPSessionManager.h"
#import "MBDataSource.h"
#import "messageBoardModel.h"
#import "MBTableViewCell.h"
#import "YYModel.h"
#import "MJRefresh.h"
#import "SNManager.h"
#import "SVProgressHUD.h"

#define BackViewColor [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]
#define NavHeight self.navigationController.navigationBar.frame.size.height
static NSString * const CELLIDENTIFIER = @"CELLIDENTIFIER";

@interface MessageBoardViewController () <UITableViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) UITableView          *myTableView;
@property (nonatomic, strong) NSMutableArray       *models;
@property (nonatomic, strong) MBDataSource         *dataSource;
@property (nonatomic, strong) NSRecursiveLock      *lock;
@property (nonatomic, strong) UIView               *backView;
@property (nonatomic, strong) UITextView           *inputTextView;
@property (nonatomic, strong) UIButton             *sendBtn;

@end

@implementation MessageBoardViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //1.初始化model数组和AFN Manager等等
    [self initData];
    
    //2.创建TableView及其他控件
    [self initView];
    
    //3.调用TableView下拉刷新, 开始下载数据
    [self.myTableView.mj_header beginRefreshing];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
    self.tabBarController.tabBar.userInteractionEnabled = YES;
}

//初始化model数组和AFN Manager等等
- (void)initData {
    
    self.models     = [@[] mutableCopy];
    self.lock       = [[NSRecursiveLock alloc] init];
    self.manager    = ({
        
        AFHTTPSessionManager *manager           = [AFHTTPSessionManager manager];
        AFSecurityPolicy *securityPolicy        = \
        [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
        
        securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy                  = securityPolicy;
        
        manager;
    });

}

//初始化TableView以及其他UI控件
- (void)initView {
    
    [self.view setBackgroundColor:BackColor];
    
    self.tabBarController.tabBar.userInteractionEnabled = NO;
    
    //挡住TabBar黑框
    UIView *view = ({
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 49)];
        view.backgroundColor = BackColor;
        
        view;
    });
    
    [self.view addSubview:view];
    [self createTableView];
    
    //添加输入框背景
    self.backView      = ({
    
        UIView *view = [[UIView alloc] initWithFrame:\
                        CGRectMake(0, SCREEN_HEIGHT - NavHeight - 20 -40, SCREEN_WIDTH, 40)];
        [view setBackgroundColor:BackViewColor];
        
        view;
    });
    [self.view addSubview:self.backView];
    
    //添加输入框
    self.inputTextView = ({
    
        UITextView *textView        = [[UITextView alloc] initWithFrame:\
                CGRectMake(10, SCREEN_HEIGHT - NavHeight - 20 - 35, SCREEN_WIDTH - 20 - 65, 30)];
        
        textView.font               = [UIFont systemFontOfSize:12];
        textView.backgroundColor    = [UIColor whiteColor];
        textView.layer.cornerRadius = 5.0f;
        textView.delegate           = self;
        
        textView;
    });
    [self.view addSubview:self.inputTextView];
    
    //添加留言按钮
    self.sendBtn      = ({
        
        UIButton *btn          = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.titleLabel.font    = [UIFont systemFontOfSize:12];
        btn.layer.cornerRadius = 5.0f;
        
        btn.frame              = CGRectMake(SCREEN_WIDTH - 70, self.inputTextView.frame.origin.y, 60, 30);
        
        [btn setTitle:@"发送" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTintColor:[UIColor blackColor]];
        
        [btn addTarget:self
                action:@selector(startToAddMessage)
      forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    [self.view addSubview: self.sendBtn];
}

//创建TableView
- (void)createTableView {
    
    //创建DataSource
    self.dataSource  = ({
    
        MBDataSource *datasource = [[MBDataSource alloc] initWithModels:self.models
                                                             Identifier:CELLIDENTIFIER];
        
        datasource;
    });
    
    //创建TableView
    self.myTableView = ({
        
        UITableView *tableView        = [[UITableView alloc] initWithFrame:\
                                CGRectMake(10, 0, SCREEN_WIDTH-20, SCREEN_HEIGHT - 40 - NavHeight)
                                                                 style:UITableViewStyleGrouped];
        tableView.delegate            = self;
        tableView.dataSource          = self.dataSource;
        tableView.separatorStyle      = NO;
        tableView.sectionHeaderHeight = 0.0f;
        tableView.sectionFooterHeight = 10.0f;
        tableView.mj_header           = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [self downloadMessageData];
        }];
        
        [tableView registerClass:[MBTableViewCell class] forCellReuseIdentifier:CELLIDENTIFIER];
        [tableView setBackgroundColor:BackColor];
        
        
        tableView;
    });
    
    //添加TableView到主界面
    [self.view addSubview:self.myTableView];
}

//下载网络数据
- (void)downloadMessageData {
    
    [self.lock lock];
    LRWeakSelf(self)
    [zx_SN getMessageWithNumber:self.number
                        Success:^(id responseObject) {
                            
                            //取得返回开始处理数据
                            LRStrongSelf(self);
                            [self.models removeAllObjects];
                            for (NSDictionary *dict in [responseObject objectForKey:@"Message"]) {
                                
                                messageBoardModel *model = [messageBoardModel yy_modelWithDictionary:dict];
                                [model calculateHeight];
                                [self.models addObject:model];
                            }
                            
                            if (!self.models.count) {
                                
                                [SVProgressHUD showInfoWithStatus:@"还没有人留言哦"];
                                [SVProgressHUD dismissWithDelay:1];
                            }
                            
                            //刷新Table
                            [self.myTableView reloadData];
                            [self.myTableView.mj_header endRefreshing];
                            
                            [self.lock unlock];
                        }
                           Fail:^(NSString *errorCode) {
                               
                               //ERROR
                               LRLog(@"%@", errorCode);
                               [self.myTableView.mj_header endRefreshing];
                               
                               [self.lock unlock];
                               
                               [SVProgressHUD showErrorWithStatus:@"网络异常"];
                               [SVProgressHUD dismissWithDelay:1];
                           }];
    
}

- (void)startToAddMessage {
    
    if (![self.inputTextView.text isEqualToString:@""]) {
        
        if ([zx_SN getLonginStatus]) {
            
            [SVProgressHUD showWithStatus:@"留言中"];
            LRWeakSelf(self)
            [zx_SN addMessageWithString:self.inputTextView.text
                           toItemNumber:self.number
                                Success:^(id responseObject) {
                                    
                                    LRStrongSelf(self)
                                    LRLog(@"留言成功");
                                    LRWeakSelf(self)
                                    [SVProgressHUD showSuccessWithStatus:@"留言成功"];
                                    [SVProgressHUD dismissWithDelay:1 completion:^{
                                        
                                        LRStrongSelf(self)
                                        [self.myTableView.mj_header beginRefreshing];
                                    }];
                                }
                                   Fail:^(NSString *errorCode) {
                                       
                                       LRLog(@"留言失败");
                                       [SVProgressHUD showErrorWithStatus:@"网络异常"];
                                       [SVProgressHUD dismissWithDelay:1];
                                   }];
        } else {
            
            [SVProgressHUD showInfoWithStatus:@"请先登录"];
            [SVProgressHUD dismissWithDelay:1];
        }
    }
}

//计算TextView高度
- (CGFloat)textViewHeight {
    
    UITextView *textView                    = [[UITextView alloc] initWithFrame:\
                                        CGRectMake(10, SCREEN_HEIGHT - 102, SCREEN_WIDTH - 20, 30)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing              = 3;// 字体的行间距
    paragraphStyle.paragraphSpacingBefore   = 0;
    paragraphStyle.firstLineHeadIndent      = 0;
    
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:12],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    textView.attributedText = [[NSAttributedString alloc] initWithString:self.inputTextView.text
                                                              attributes:attributes];
    
    return textView.contentSize.height;
}


#pragma mark - UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    messageBoardModel *model = [self.models objectAtIndex:indexPath.row];
    return model.Height + 10;
}

#pragma mark - textview delegate

- (void)textViewDidChange:(UITextView *)textView {
    NSInteger number = [self.inputTextView.text length];
    if (number > 100) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"字符个数不能大于100" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        self.inputTextView.text = [self.inputTextView.text substringToIndex:100];
    }
}


@end
