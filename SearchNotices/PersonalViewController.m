//
//  PersonalViewController.m
//  ZXTabBarController
//
//  Created by Jackey on 2016/12/14.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "PersonalViewController.h"
#import "PersonDataSource.h"
#import "WebViewController.h"
#import "LoginViewController.h"
#import "UIImage+Image.h"
#import "SNManager.h"
#import "DetailAccountViewController.h"

typedef enum : NSUInteger {
    kAccount = 0,
    kRuHeFaBu,
    kContactUs,
    kShengMing,
    kAbout
} EPersonCategory;

static NSString * const PersonCellIdentifer = @"PersonCellIdentifer";

@interface PersonalViewController ()<UITableViewDelegate>

@property (nonatomic, strong) NSArray          *array;
@property (nonatomic, strong) PersonDataSource *dataSource;
@property (nonatomic, strong) UITableView      *myTableView;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //1.初始化标题数组
    [self initData];
    
    //2.创建TableView
    [self initView];
}

//初始化标题数组
- (void)initData {
    
    self.array = @[@"我的账号", @"如何发布", @"联系我们", @"免责声明", @"关于"];
}

//创建TableView
- (void)initView {
    
    [self.view setBackgroundColor:BackColor];
    
    self.dataSource = ({
    
        PersonDataSource *dataSource = [[PersonDataSource alloc] initWithArray:self.array
                                                                    Identifier:PersonCellIdentifer];
        
        dataSource;
    });
    
    self.myTableView = ({
    
        UITableView *tableView = [[UITableView alloc] initWithFrame:\
                                                    CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                              style:UITableViewStyleGrouped];
        
        tableView.delegate     = self;
        tableView.dataSource   = self.dataSource;
        //tableView.contentInset = UIEdgeInsetsMake(0, 0, 140, 0);
        
        //设置透明分割线
        [tableView setSeparatorColor:[UIColor clearColor]];
        
        [tableView setShowsVerticalScrollIndicator:NO];
        
        tableView;
    });
    
    [self.view addSubview:self.myTableView];
    
    //解决TabBar遮挡
    self.edgesForExtendedLayout               = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myTableView.autoresizingMask         = \
    UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

#pragma TableView delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //取消选择
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    
    if (indexPath.section == kAccount) {
        
        //判断是否已经登录
        if (![zx_SN getLonginStatus]) {
            
            //如果没有登录则跳转至登录界面
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
            [nav.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
            [nav.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
            
            [self presentViewController:nav animated:YES completion:nil];
            
        } else {
            //否则跳转至详细账户界面
            DetailAccountViewController *detailAccountVC = [[DetailAccountViewController alloc] init];
            
            [self.navigationController pushViewController:detailAccountVC animated:YES];
        }
        
    }
    else if (indexPath.section == kRuHeFaBu) {
        
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.strOfURL           = urlOfRuHeFaBu;
        webVC.info               = @"如何发布";
        
        [self.navigationController pushViewController:webVC animated:YES];
    }
    else if (indexPath.section == kContactUs) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"如果您有好的建议或者疑问, 欢迎您致信给我们. 我们会仔细阅读您的每一封来信, 您的关注是对我们最大的鼓舞!\n\n    电子邮箱: zhouxihi@aliyun.com" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }
    else if (indexPath.section == kShengMing) {
        
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.strOfURL           = urlOfMianZe;
        webVC.info               = @"免责申明";
        
        [self.navigationController pushViewController:webVC animated:YES];
    }
    else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"互助寻人\nVersion: 2.0" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }
}

@end
