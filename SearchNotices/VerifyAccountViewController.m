//
//  VerifyAccountViewController.m
//  SearchNotices
//
//  Created by Jackey on 2017/1/7.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import "VerifyAccountViewController.h"
#import "SVProgressHUD.h"
#import "SNManager.h"
#import "CheckCodeViewController.h"

@interface VerifyAccountViewController ()

@property (nonatomic, strong) UIImageView   *bgImageView;
@property (nonatomic, strong) UILabel       *titleLable;
@property (nonatomic, strong) UITextField   *accountTextField;
@property (nonatomic, strong) UIButton      *nextButton;

@end

@implementation VerifyAccountViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupView];
}

- (void)setupView {
    
    //设置背景
    self.bgImageView = ({
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imgView.image        = [UIImage imageNamed:@"LGSC"];
        
        imgView;
    });
    
    [self.view addSubview:self.bgImageView];
    
    self.titleLable = ({
        
        UILabel *lable      = [[UILabel alloc] initWithFrame:\
                               CGRectMake(SCREEN_WIDTH / 2 - 80, SCREEN_WIDTH / 2 - 80, 160, 50)];
        
        lable.text          = @"检查账号";
        lable.textColor     = [UIColor whiteColor];
        lable.font          = [UIFont systemFontOfSize:26 weight:0];
        lable.textAlignment = NSTextAlignmentCenter;
        
        lable;
    });
    
    [self.view addSubview:self.titleLable];
    
    self.accountTextField = ({
        
        UITextField *textField       = [[UITextField alloc] initWithFrame:\
                                        CGRectMake(40, SCREEN_WIDTH / 2 - 80 + 50 + 40,
                                                   SCREEN_WIDTH - 80, 40)];
        
        textField.layer.cornerRadius = 10;
        textField.placeholder        = @"手机号码";
        textField.layer.borderColor  = [UIColor whiteColor].CGColor;
        textField.layer.borderWidth  = 0.7;
        textField.textAlignment      = NSTextAlignmentCenter;
        textField.textColor          = [UIColor whiteColor];
        textField.backgroundColor    = [UIColor clearColor];
        
        textField;
    });
    
    [self.view addSubview:self.accountTextField];
    
    self.nextButton = ({
    
        UIButton *btn          = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame              = \
        CGRectMake(40, SCREEN_WIDTH / 2 - 80 + 50 + 40 + 40 + 10,
                   SCREEN_WIDTH - 80, 40);
        btn.layer.cornerRadius = 10;
        
        [btn setTitle:@"下一步" forState:UIControlStateNormal];
        [btn setBackgroundColor:BlueBtnColor];
        [btn setTintColor:[UIColor whiteColor]];
        
        [btn addTarget:self
                action:@selector(nextAction)
      forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    
    [self.view addSubview:self.nextButton];
    
}

- (void)nextAction {
    
    //检查账号
    if ([self.accountTextField.text isEqualToString:@""]) {
        
        [SVProgressHUD showErrorWithStatus:@"账号不能为空"];
        [SVProgressHUD dismissWithDelay:1];
    }
    else if (![zx_SN checkAccount:self.accountTextField.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"手机号码不正确"];
        [SVProgressHUD dismissWithDelay:1];
    }
    else {
        
        LRWeakSelf(self)
        [SVProgressHUD showWithStatus:@"检查账号中"];
        [zx_SN checkAccount:self.accountTextField.text
                    Success:^(id responseObject) {
                        
                        LRStrongSelf(self)
                        LRLog(@"账号存在");
                        LRWeakSelf(self)
                        [SVProgressHUD showWithStatus:@"账号检查成功"];
                        [SVProgressHUD dismissWithDelay:1 completion:^{
                            
                            LRStrongSelf(self)
                            CheckCodeViewController *checkCodeVC = [[CheckCodeViewController alloc] init];
                            checkCodeVC.account                  = self.accountTextField.text;
                            [self.navigationController pushViewController:checkCodeVC animated:YES];
                        }];
                        
                    }
                       Fail:^(NSString *errorCode) {
                           
                           if ([errorCode isEqualToString:@"NO"]) {
                               
                               LRLog(@"账号不存在");
                               [SVProgressHUD showErrorWithStatus:@"账号不存在"];
                               [SVProgressHUD dismissWithDelay:1];
                           } else {
                               
                               LRLog(@"网络错误");
                               [SVProgressHUD showErrorWithStatus:@"网络错误"];
                               [SVProgressHUD dismissWithDelay:1];
                           }
                       }];
    }
}

@end
