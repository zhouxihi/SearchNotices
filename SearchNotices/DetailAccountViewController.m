//
//  DetailAccountViewController.m
//  SearchNotices
//
//  Created by Jackey on 2017/1/4.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import "DetailAccountViewController.h"
#import "SNManager.h"
#import "SetNichengViewController.h"
#import "ChangePWDViewController.h"

typedef enum : NSUInteger {
    kAccount = 0,
    kChangePWD,
    kExit
} EDetail;

static NSString * const DetailCellIdentifier = @"DetailCellIdentifier";

@interface DetailAccountViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray     *array;
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation DetailAccountViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //初始化Data
    [self setupData];
    
    //创建TableView
    [self setupView];
}

- (void)setupData {
    
    self.array = @[@"我的昵称", @"修改密码", @"退出"];
}

- (void)setupView {
    
    self.myTableView = ({
    
        UITableView *tableView   = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        
        tableView.delegate       = self;
        tableView.dataSource     = self;
        tableView.separatorColor = [UIColor clearColor];
        
        tableView;
    });
    
    [self.view addSubview:self.myTableView];
    
    //解决TabBar遮挡
    self.edgesForExtendedLayout               = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myTableView.autoresizingMask         = \
    UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

#pragma mark - UITableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailCellIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:DetailCellIdentifier];
    }
    
    cell.textLabel.text = self.array[indexPath.section];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    if (indexPath.section == kExit) {
        
        cell.textLabel.textColor = [UIColor redColor];
        cell.accessoryType       = UITableViewCellAccessoryNone;
    } else {
        
        cell.textLabel.textColor = [UIColor blackColor];
        cell.accessoryType       = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    if (indexPath.section == kAccount) {
        
        SetNichengViewController *setVC = [[SetNichengViewController alloc] init];
        [self.navigationController pushViewController:setVC animated:YES];
    }
    else if (indexPath.section == kChangePWD) {
        
        ChangePWDViewController *changeVC = [[ChangePWDViewController alloc] init];
        [self.navigationController pushViewController:changeVC animated:YES];
    }
    else if (indexPath.section == kExit) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"确定退出吗?" preferredStyle:UIAlertControllerStyleActionSheet];
        
        LRWeakSelf(self)
        UIAlertAction *exit = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            LRStrongSelf(self)
            //退出账号
            [zx_SN exit];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:exit];
        [alertController addAction:cancel];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end
