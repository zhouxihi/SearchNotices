//
//  RegisterViewController.m
//  SearchNotices
//
//  Created by Jackey on 2017/1/6.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import "RegisterViewController.h"
#import "SVProgressHUD.h"
#import "SNManager.h"

#define countTime 25

@interface RegisterViewController ()

@property (nonatomic, strong) UILabel       *titleLable;
@property (nonatomic, strong) UIImageView   *bgImageView;
@property (nonatomic, strong) UITextField   *accountTextField;
@property (nonatomic, strong) UITextField   *pwdTextField;
@property (nonatomic, strong) UITextField   *confirmTextField;
@property (nonatomic, strong) UITextField   *codeTextField;
@property (nonatomic, strong) UIButton      *getCodeButton;
@property (nonatomic, strong) UIButton      *registerButton;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSInteger      countdown;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupData];
    [self setupView];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.displayLink invalidate];
}

- (void)setupData {
    
    self.countdown = countTime * 60;
}
//初始化UI
- (void)setupView {
    
    //设置背景imageView
    self.bgImageView = ({
    
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imgView.image        = [UIImage imageNamed:@"LGSC"];
        
        imgView;
    });
    
    [self.view addSubview:self.bgImageView];
    
    self.titleLable = ({
    
        UILabel *lable      = [[UILabel alloc] initWithFrame:\
                               CGRectMake(SCREEN_WIDTH / 2 - 80, SCREEN_WIDTH / 2 - 80, 160, 50)];
        
        lable.text          = @"注册";
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
    
    self.pwdTextField = ({
    
        UITextField *mimatextField       = [[UITextField alloc] initWithFrame:\
                                            CGRectMake(40, SCREEN_WIDTH / 2 - 80 + 50 + 40 + 40 + 10, SCREEN_WIDTH - 80, 40)];
        
        mimatextField.layer.cornerRadius = 10;
        mimatextField.placeholder        = @"输入密码";
        mimatextField.layer.borderColor  = [UIColor whiteColor].CGColor;
        mimatextField.layer.borderWidth  = 0.7;
        mimatextField.textAlignment      = NSTextAlignmentCenter;
        mimatextField.textColor          = [UIColor whiteColor];
        mimatextField.backgroundColor    = [UIColor clearColor];
        mimatextField.secureTextEntry    = YES;
        
        mimatextField;
    });
    
    [self.view addSubview:self.pwdTextField];
    
    self.confirmTextField = ({
    
        UITextField *mimatextField       = [[UITextField alloc] initWithFrame:\
                                            CGRectMake(40,
                                                       SCREEN_WIDTH / 2 - 80 + 50 + 40 + 40 + 10 + 50,
                                                       SCREEN_WIDTH - 80, 40)];
        
        mimatextField.layer.cornerRadius = 10;
        mimatextField.placeholder        = @"重复密码";
        mimatextField.layer.borderColor  = [UIColor whiteColor].CGColor;
        mimatextField.layer.borderWidth  = 0.7;
        mimatextField.textAlignment      = NSTextAlignmentCenter;
        mimatextField.textColor          = [UIColor whiteColor];
        mimatextField.backgroundColor    = [UIColor clearColor];
        mimatextField.secureTextEntry    = YES;
        
        mimatextField;
    });
    
    [self.view addSubview:self.confirmTextField];
    
    self.codeTextField = ({
    
        UITextField *mimatextField       = [[UITextField alloc] initWithFrame:\
                                            CGRectMake(40,
                                                       SCREEN_WIDTH / 2 - 80 + 50 + 40 + 40 + 10 + 100,
                                                       SCREEN_WIDTH - 80 - 80, 40)];
        
        mimatextField.layer.cornerRadius = 10;
        mimatextField.placeholder        = @"输入验证码";
        mimatextField.layer.borderColor  = [UIColor whiteColor].CGColor;
        mimatextField.layer.borderWidth  = 0.7;
        mimatextField.textAlignment      = NSTextAlignmentCenter;
        mimatextField.textColor          = [UIColor whiteColor];
        mimatextField.backgroundColor    = [UIColor clearColor];
        //mimatextField.secureTextEntry    = YES;
        
        mimatextField;
    });
    
    [self.view addSubview:self.codeTextField];
    
    self.getCodeButton = ({
    
        UIButton *btn          = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame              = \
        CGRectMake(40 + SCREEN_WIDTH - 80 - 80 + 10, SCREEN_WIDTH / 2 - 80 + 50 + 40 + 40 + 10 + 100,
                   70, 40);
        btn.layer.cornerRadius = 10;
        btn.titleLabel.font    = [UIFont systemFontOfSize:10];
        [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [btn setBackgroundColor:BlueBtnColor];
        [btn setTintColor:[UIColor whiteColor]];
        
        [btn addTarget:self
                action:@selector(startTimer)
      forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    
    [self.view addSubview:self.getCodeButton];
    
    self.registerButton = ({
    
        UIButton *btn          = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame              = \
        CGRectMake(40, SCREEN_WIDTH / 2 - 80 + 50 + 40 + 40 + 10 + 150,
                   SCREEN_WIDTH - 80, 40);
        btn.layer.cornerRadius = 10;
        
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn setBackgroundColor:BlueBtnColor];
        [btn setTintColor:[UIColor whiteColor]];
        
        [btn addTarget:self
                action:@selector(startToRegister)
      forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    
    [self.view addSubview:self.registerButton];
    
}

//获取验证码
- (void)startTimer {
    
    LRLog(@"获取验证码");
    
    //检查输入的手机号码
    if ([self.accountTextField.text isEqualToString:@""]) {
        
        LRLog(@"手机号码不能为空");
        [SVProgressHUD showErrorWithStatus:@"手机号码不能为空"];
        [SVProgressHUD dismissWithDelay:1];
    }
    else if (![zx_SN checkAccount:self.accountTextField.text]) {
        
        LRLog(@"手机号码格式不正确");
        [SVProgressHUD showErrorWithStatus:@"手机号码格式不正确"];
        [SVProgressHUD dismissWithDelay:1];
    } else {
        
        //获取验证码
        [zx_SN getPhoneCodeWithPhoneNumer:self.accountTextField.text Success:^(id responseObject) {
            
            LRLog(@"已经获取到验证码");
            [SVProgressHUD showWithStatus:@"请注意查看短信"];
            [SVProgressHUD dismissWithDelay:1.5];
        } Fail:^(NSString *errorCode) {
            
            LRLog(@"获取验证码失败");
            [SVProgressHUD showErrorWithStatus:@"获取验证码失败"];
            [SVProgressHUD dismissWithDelay:1];
            
            if ([errorCode isEqualToString:@"outOfTimes"]) {
                
                [SVProgressHUD showErrorWithStatus:@"获取验证码次数超限"];
                [SVProgressHUD dismissWithDelay:1];
            } else {
                
                [SVProgressHUD showErrorWithStatus:@"获取验证码失败"];
                [SVProgressHUD dismissWithDelay:1];
            }
        }];
        
        //倒计时
        self.displayLink    = ({
            
            CADisplayLink *link = \
            [CADisplayLink displayLinkWithTarget:self selector:@selector(buttonCountdown)];
            
            
            link;
        });
        
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}

//计时器事件
- (void)buttonCountdown {
    
    //Normal时button的颜色
    UIColor *mainColor  = BlueBtnColor;
    
    //计数时button的颜色
    UIColor *countColor = [UIColor grayColor];
    
    self.countdown--;
    if (self.countdown > 60) {
        
        NSString *title = [NSString stringWithFormat:@"%ld", self.countdown / 60];
        
        [self.getCodeButton setTitle:title forState:UIControlStateNormal];
        [self.getCodeButton setBackgroundColor:countColor];
        [self.getCodeButton setEnabled:NO];
    } else {
        
        self.countdown = countTime * 60;
        NSString *title = @"获取验证码";
        
        [self.getCodeButton setTitle:title forState:UIControlStateNormal];
        [self.getCodeButton setBackgroundColor:mainColor];
        [self.getCodeButton setEnabled:YES];
        
        [self.displayLink invalidate];
        
    }
}

- (void)startToRegister {
    
    //检查密码格式
    if ([self.pwdTextField.text isEqualToString:@""]) {
        
        LRLog(@"密码不能为空");
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        [SVProgressHUD dismissWithDelay:1];
    }
    else if ([self.confirmTextField.text isEqualToString:@""]) {
        
        LRLog(@"密码不能为空");
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        [SVProgressHUD dismissWithDelay:1];
    }
    else if (![self.pwdTextField.text isEqualToString:self.confirmTextField.text]) {
        
        LRLog(@"两次密码不同");
        [SVProgressHUD showErrorWithStatus:@"两次密码不同"];
        [SVProgressHUD dismissWithDelay:1];
    }
    else if (![zx_SN checkPassword:self.pwdTextField.text]) {
        
        LRLog(@"密码格式不正确");
        [SVProgressHUD showErrorWithStatus:@"密码需为6到8位数字或字母"];
        [SVProgressHUD dismissWithDelay:1];
    }
    else {
        
//        LRWeakSelf(self)
//        [zx_SN registerWithAccount:self.accountTextField.text
//                          Password:self.pwdTextField.text
//                           Success:^(id responseObject) {
//            
//                               [SVProgressHUD showSuccessWithStatus:@"注册成功"];
//                               [SVProgressHUD dismissWithDelay:1 completion:^{
//                                   
//                                   LRStrongSelf(self);
//                                   [self dismissViewControllerAnimated:YES completion:nil];
//                                   
//                               }];
//                           }
//                              Fail:^(NSString *errorCode) {
//            
//                                  LRLog(@"注册失败");
//                                   [SVProgressHUD dismiss];
//                              }];
        
        [SVProgressHUD showWithStatus:@"验证码校验"];
        LRWeakSelf(self)
        [zx_SN verifyPhoneCode:self.codeTextField.text
                   PhoneNumber:self.accountTextField.text
                       Success:^(id responseObject) {
            
                           LRLog(@"验证码正确");
                           //开始注册
                           [SVProgressHUD showWithStatus:@"开始注册"];
                           LRStrongSelf(self)
                           [zx_SN registerWithAccount:self.accountTextField.text
                                             Password:self.pwdTextField.text
                                              Success:^(id responseObject) {

                                                    LRLog(@"注册成功");
                                                    [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                                                    [SVProgressHUD dismissWithDelay:1 completion:^{
                                                          
                                                        [self dismissViewControllerAnimated:YES
                                                                                   completion:nil];
                                                    }];
                                              }
                                                 Fail:^(NSString *errorCode) {
                
                                                     LRLog(@"注册失败");
                                                     
                                                     if ([errorCode isEqualToString:@"Repeat"]) {
                                                         
                                                         [SVProgressHUD showErrorWithStatus:@"账号重复"];
                                                         [SVProgressHUD dismissWithDelay:1];
                                                     } else {
                                                         
                                                         [SVProgressHUD showErrorWithStatus:@"注册失败, 稍后再试"];
                                                         [SVProgressHUD dismissWithDelay:1];
                                                     }
                                                 }];
            
                       }
                          Fail:^(NSString *errorCode) {
            
                              LRLog(@"验证码不正确");
                              [SVProgressHUD showErrorWithStatus:@"验证码不正确"];
                              [SVProgressHUD dismissWithDelay:1];
                          }];
    }
}

@end
