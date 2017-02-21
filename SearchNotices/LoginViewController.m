//
//  LoginViewController.m
//  SearchNotices
//
//  Created by Jackey on 2017/1/2.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import "LoginViewController.h"
#import "SNManager.h"
#import "SVProgressHUD.h"
#import "RegisterViewController.h"
#import "VerifyAccountViewController.h"

@interface LoginViewController ()

@property (nonatomic, strong) UIBarButtonItem *barButton;
@property (nonatomic, strong) UILabel         *DescLable;
@property (nonatomic, strong) UITextField     *accountTextField;
@property (nonatomic, strong) UITextField     *pwdTextField;
@property (nonatomic, strong) UIButton        *confirmButton;
@property (nonatomic, strong) UIButton        *registerButton;
@property (nonatomic, strong) UIButton        *forgetPWDbutton;
@property (nonatomic, strong) UILabel         *seperateLable;
@property (nonatomic, strong) UIImageView     *bgImageView;
@property (nonatomic, strong) UIButton        *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initData];
    [self initView];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)initData {
    
}

- (void)initView {
    
    //设置NavigationBar button
    self.barButton = ({
    
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(close)];
        
        [barButton setTintColor:BlueBtnColor];
        barButton;
    });
    
    self.navigationItem.leftBarButtonItem = self.barButton;
    
    //设置背景图片
    self.bgImageView = ({
    
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imgView.image        = [UIImage imageNamed:@"LGSC"];
        
        imgView;
    });
    
    [self.view addSubview:self.bgImageView];
    
    //    //添加毛玻璃效果
    //    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    //
    //    UIVisualEffectView *view = [[UIVisualEffectView alloc]initWithEffect:beffect];
    //
    //    view.frame = self.view.bounds;
    //
    //    view.alpha = 1.0;
    //
    //    [self.view addSubview:view];
    
    
    //设置说明标题
    self.DescLable = ({
    
        UILabel *lable      = [[UILabel alloc] initWithFrame:\
                               CGRectMake(SCREEN_WIDTH / 2 - 80, SCREEN_WIDTH / 2 - 80, 160, 50)];
        
        lable.text          = @"用户登录";
        lable.textColor     = [UIColor whiteColor];
        lable.font          = [UIFont systemFontOfSize:26 weight:0];
        lable.textAlignment = NSTextAlignmentCenter;
        
        lable;
    });
    
    [self.view addSubview:self.DescLable];
    
    //设置账号栏
    self.accountTextField = ({
    
        UITextField *textField       = [[UITextField alloc] initWithFrame:\
                            CGRectMake(40, SCREEN_WIDTH / 2 - 80 + 50 + 40, SCREEN_WIDTH - 80, 40)];
        
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
    
    //设置密码栏
    self.pwdTextField = ({
    
        UITextField *mimatextField       = [[UITextField alloc] initWithFrame:\
                CGRectMake(40, SCREEN_WIDTH / 2 - 80 + 50 + 40 + 40 + 10, SCREEN_WIDTH - 80, 40)];
        
        mimatextField.layer.cornerRadius = 10;
        mimatextField.placeholder        = @"密码";
        mimatextField.layer.borderColor  = [UIColor whiteColor].CGColor;
        mimatextField.layer.borderWidth  = 0.7;
        mimatextField.textAlignment      = NSTextAlignmentCenter;
        mimatextField.textColor          = [UIColor whiteColor];
        mimatextField.backgroundColor    = [UIColor clearColor];
        mimatextField.secureTextEntry    = YES;
        
        mimatextField;

    });
    
    [self.view addSubview:self.pwdTextField];
    
    //设置登录Button
    self.loginButton = ({
    
        UIButton *btn          = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame              = \
                    CGRectMake(40, SCREEN_WIDTH / 2 - 80 + 50 + 40 + 40 + 10 + 40 + 10,
                               SCREEN_WIDTH - 80, 40);
        btn.layer.cornerRadius = 10;
        
        [btn setTitle:@"登录" forState:UIControlStateNormal];
        [btn setBackgroundColor:BlueBtnColor];
        [btn setTintColor:[UIColor whiteColor]];
        
        [btn addTarget:self
                action:@selector(loginAction)
      forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    
    [self.view addSubview:self.loginButton];
    
    //设置注册Button
    self.registerButton = ({
    
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame     = CGRectMake(SCREEN_WIDTH / 2 - 64, SCREEN_WIDTH / 2 - 80 + 50 + 40 + 40 + 10 + 40 + 40 + 80, 60, 30);
        [btn            setTitle        :@"注册账号" forState:UIControlStateNormal];
        
        [btn            setTintColor    :[UIColor whiteColor]];
        [btn.titleLabel setFont         :[UIFont systemFontOfSize:14]];
        [btn.titleLabel setTextAlignment:NSTextAlignmentRight];
        
        [btn addTarget:self
                action:@selector(registerAction)
      forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    
    [self.view addSubview:self.registerButton];
    
    //设置忘记密码button
    self.forgetPWDbutton = ({
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame     = CGRectMake(SCREEN_WIDTH / 2 + 4, SCREEN_WIDTH / 2 - 80 + 50 + 40 + 40 + 10 + 40 + 40 + 80, 60, 30);
        [btn            setTitle        :@"忘记密码" forState:UIControlStateNormal];
        
        [btn            setTintColor    :[UIColor whiteColor]];
        [btn.titleLabel setFont         :[UIFont systemFontOfSize:14]];
        [btn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        
        [btn addTarget:self
                action:@selector(forgetAction)
      forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    
    [self.view addSubview:self.forgetPWDbutton];
    
    //设置分割Lable
    self.seperateLable = ({
        
        UILabel *lable        = [[UILabel alloc] initWithFrame:\
                                CGRectMake(SCREEN_WIDTH / 2 - 0.5,
                                        SCREEN_WIDTH / 2 - 80 + 50 + 40 + 40 + 10 + 40 + 40 + 5 + 80,
                                           1, 20)];
        
        lable.backgroundColor = [UIColor whiteColor];
        
        lable;
    });
    
    [self.view addSubview:self.seperateLable];
    
    //添加手势关闭键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.bgImageView addGestureRecognizer:tap];
}

- (void)close {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)hideKeyboard {
    
    [self.accountTextField becomeFirstResponder];
    [self.accountTextField resignFirstResponder];
    [self.pwdTextField becomeFirstResponder];
    [self.pwdTextField resignFirstResponder];
}

- (void)loginAction {
    
    //[SVProgressHUD showWithStatus:@"登录"];
    if ([self.accountTextField.text isEqualToString:@""]) {
        
        LRLog(@"账号不能为空");
        [SVProgressHUD showErrorWithStatus:@"账号不能为空"];
        [SVProgressHUD dismissWithDelay:1];
        
    } else if ([self.pwdTextField.text isEqualToString:@""]) {
        
        LRLog(@"密码不能为空");
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        [SVProgressHUD dismissWithDelay:1];

    } else {
        
        [SVProgressHUD showWithStatus:@"正在登录"];
        
        LRLog(@"登录");
        LRWeakSelf(self)
        //开始登录
        [zx_SN loginWithAccount:self.accountTextField.text Password:self.pwdTextField.text Success:^(id responseObject) {
            
                LRLog(@"登录成功");
                LRStrongSelf(self)
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                [SVProgressHUD dismissWithDelay:1 completion:^{
                    //登录成功后返回我的界面
                    [self dismissViewControllerAnimated:YES completion:nil];
            }];
        } Fail:^(NSString *errorCode) {
            
            LRLog(@"登录失败");
            if ([errorCode isEqualToString:@"NotMatch"]) {
                
                LRLog(@"密码错误");
                [SVProgressHUD showErrorWithStatus:@"密码错误"];
                [SVProgressHUD dismissWithDelay:1];
            }
            else if ([errorCode isEqualToString:@"NoAccount"]) {
                
                LRLog(@"账号不存在");
                [SVProgressHUD showErrorWithStatus:@"账号不存在"];
                [SVProgressHUD dismissWithDelay:1];
            }
            else if ([errorCode isEqualToString:@"Network Error"]) {
                
                LRLog(@"网络异常");
                [SVProgressHUD showErrorWithStatus:@"网络异常"];
                [SVProgressHUD dismissWithDelay:1];
            } else {
                
                [SVProgressHUD showErrorWithStatus:@"登录失败 "];
                [SVProgressHUD dismissWithDelay:1];
            }
            
        }];
    }
    
}

- (void)registerAction {
    
    LRLog(@"注册");
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)forgetAction {
    
    LRLog(@"忘记密码");
    VerifyAccountViewController *verifyVC = [[VerifyAccountViewController alloc] init];
    [self.navigationController pushViewController:verifyVC animated:YES];
}


@end
