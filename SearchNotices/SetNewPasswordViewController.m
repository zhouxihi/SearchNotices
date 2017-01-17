//
//  SetNewPasswordViewController.m
//  SearchNotices
//
//  Created by Jackey on 2017/1/7.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import "SetNewPasswordViewController.h"
#import "SVProgressHUD.h"
#import "SNManager.h"

@interface SetNewPasswordViewController ()

@property (nonatomic, strong) UIImageView       *bgImageView;
@property (nonatomic, strong) UILabel           *titleLable;
@property (nonatomic, strong) UITextField       *newpwdTextField;
@property (nonatomic, strong) UITextField       *confirmTextField;
@property (nonatomic, strong) UIButton          *okButton;

@end

@implementation SetNewPasswordViewController

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
        
        lable.text          = @"设置新密码";
        lable.textColor     = [UIColor whiteColor];
        lable.font          = [UIFont systemFontOfSize:26 weight:0];
        lable.textAlignment = NSTextAlignmentCenter;
        
        lable;
    });
    
    [self.view addSubview:self.titleLable];
    
    self.newpwdTextField = ({
    
        UITextField *textField       = [[UITextField alloc] initWithFrame:\
                                        CGRectMake(40, SCREEN_WIDTH / 2 - 80 + 50 + 40,
                                                   SCREEN_WIDTH - 80, 40)];
        
        textField.layer.cornerRadius = 10;
        textField.placeholder        = @"输入密码";
        textField.layer.borderColor  = [UIColor whiteColor].CGColor;
        textField.layer.borderWidth  = 0.7;
        textField.textAlignment      = NSTextAlignmentCenter;
        textField.textColor          = [UIColor whiteColor];
        textField.backgroundColor    = [UIColor clearColor];
        
        textField;
    });
    
    [self.view addSubview:self.newpwdTextField];
    
    self.confirmTextField = ({
    
        UITextField *textField       = [[UITextField alloc] initWithFrame:\
                                        CGRectMake(40, SCREEN_WIDTH / 2 - 80 + 50 + 40 + 50,
                                                   SCREEN_WIDTH - 80, 40)];
        
        textField.layer.cornerRadius = 10;
        textField.placeholder        = @"重复输入";
        textField.layer.borderColor  = [UIColor whiteColor].CGColor;
        textField.layer.borderWidth  = 0.7;
        textField.textAlignment      = NSTextAlignmentCenter;
        textField.textColor          = [UIColor whiteColor];
        textField.backgroundColor    = [UIColor clearColor];
        
        textField;
    });
    
    [self.view addSubview:self.confirmTextField];
    
    self.okButton = ({
    
        UIButton *btn          = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame              = \
        CGRectMake(40, SCREEN_WIDTH / 2 - 80 + 50 + 40 + 40 + 10 + 50,
                   SCREEN_WIDTH - 80, 40);
        btn.layer.cornerRadius = 10;
        
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn setBackgroundColor:BlueBtnColor];
        [btn setTintColor:[UIColor whiteColor]];
        
        [btn addTarget:self
                action:@selector(changeAction)
      forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    
    [self.view addSubview:self.okButton];
}

- (void)changeAction {
    
    //先检查密码
    if ([self.newpwdTextField.text isEqualToString:@""]) {
        
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        [SVProgressHUD dismissWithDelay:1];
    }
    else if ([self.confirmTextField.text isEqualToString:@""]) {
        
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        [SVProgressHUD dismissWithDelay:1];
    }
    else if (![zx_SN checkPassword:self.newpwdTextField.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"密码需为6到8位数字或字母"];
        [SVProgressHUD dismissWithDelay:1];
    } else {
        
        //先设置SNManager账号
        [zx_SN setAccount:self.account];
        
        [SVProgressHUD showWithStatus:@"修改中"];
        //调用修改密码
        LRWeakSelf(self)
        [zx_SN setPasswordWithString:self.newpwdTextField.text
                             Success:^(id responseObject) {
                                 
                                 LRStrongSelf(self)
                                 //密码修改成功后, 直接设置为已经登录
                                 [zx_SN setLoginStatus:YES];
                                 [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                                 
                                 LRWeakSelf(self)
                                 [SVProgressHUD dismissWithDelay:1 completion:^{
                                     
                                     LRStrongSelf(self)
                                     [self dismissViewControllerAnimated:YES completion:nil];
                                 }];
                                 
                             }
                                Fail:^(NSString *errorCode) {
                                    
                                    //清空账户信息
                                    [zx_SN setAccount:@""];
                                    [zx_SN setLoginStatus:NO];
                                    [SVProgressHUD showErrorWithStatus:@"网络异常, 稍后重试"];
                                    [SVProgressHUD dismissWithDelay:1];
                                }];
    }
}
@end
