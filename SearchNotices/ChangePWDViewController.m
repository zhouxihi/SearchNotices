//
//  ChangePWDViewController.m
//  SearchNotices
//
//  Created by Jackey on 2017/1/5.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import "ChangePWDViewController.h"
#import "SNManager.h"
#import "SVProgressHUD.h"

@interface ChangePWDViewController ()

@property (nonatomic, strong) UILabel           *oldLable;
@property (nonatomic, strong) UILabel           *newpwdLable;
@property (nonatomic, strong) UILabel           *confirmLable;
@property (nonatomic, strong) UITextField       *oldText;
@property (nonatomic, strong) UITextField       *newpwdText;
@property (nonatomic, strong) UITextField       *confirmText;
@property (nonatomic, strong) UIBarButtonItem   *okBarButton;

@end

@implementation ChangePWDViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
 
    [self setupView];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)setupData {
    
}

- (void)setupView {
    
    //设置背景颜色
    [self.view setBackgroundColor:BackColor];
    
    //挡住TabBar黑框
    UIView *view = ({
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 49)];
        view.backgroundColor = BackColor;
        
        view;
    });
    
    [self.view addSubview:view];
    
    //创建提示Lable
    self.oldLable = ({
    
        UILabel *lable      = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 80, 35)];
        lable.text          = @"当前密码";
        lable.font          = [UIFont systemFontOfSize:14];
        lable.textColor     = [UIColor grayColor];
        lable.textAlignment = NSTextAlignmentRight;
        
        lable;
    });
    
    [self.view addSubview:self.oldLable];
    
    self.newpwdLable = ({
    
        UILabel *lable      = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 80, 35)];
        lable.text          = @"新的密码";
        lable.font          = [UIFont systemFontOfSize:14];
        lable.textColor     = [UIColor grayColor];
        lable.textAlignment = NSTextAlignmentRight;
        
        lable;
    });
    
    [self.view addSubview:self.newpwdLable];
    
    self.confirmLable = ({
    
        UILabel *lable      = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, 80, 35)];
        lable.text          = @"重复密码";
        lable.font          = [UIFont systemFontOfSize:14];
        lable.textColor     = [UIColor grayColor];
        lable.textAlignment = NSTextAlignmentRight;
        
        lable;
    });
    
    [self.view addSubview:self.confirmLable];
    
    //创建密码框
    self.oldText = ({
    
        UITextField *text    = [[UITextField alloc] initWithFrame:\
                                CGRectMake(120, 40, SCREEN_WIDTH - 120 - 40, 35)];
        text.backgroundColor = [UIColor whiteColor];
        text.textAlignment   = NSTextAlignmentCenter;
        text.font            = [UIFont systemFontOfSize:14];
        text.secureTextEntry = YES;
        
        text;
    });
    
    [self.view addSubview:self.oldText];
    
    self.newpwdText = ({
    
        UITextField *text    = [[UITextField alloc] initWithFrame:\
                                CGRectMake(120, 100, SCREEN_WIDTH - 120 - 40, 35)];
        text.backgroundColor = [UIColor whiteColor];
        text.textAlignment   = NSTextAlignmentCenter;
        text.font            = [UIFont systemFontOfSize:14];
        text.secureTextEntry = YES;
        
        text;
    });
    
    [self.view addSubview:self.newpwdText];
    
    self.confirmText = ({
    
        UITextField *text    = [[UITextField alloc] initWithFrame:\
                                CGRectMake(120, 160, SCREEN_WIDTH - 120 - 40, 35)];
        text.backgroundColor = [UIColor whiteColor];
        text.textAlignment   = NSTextAlignmentCenter;
        text.font            = [UIFont systemFontOfSize:14];
        text.secureTextEntry = YES;
        
        text;
    });
    
    [self.view addSubview:self.confirmText];
    
    //创建barButton
    self.okBarButton = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(verifyNewPWD)];
    
    self.navigationItem.rightBarButtonItem = self.okBarButton;
    
    
    //创建手势关闭键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] \
                                   initWithTarget:self action:@selector(hideKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    


}

- (void)verifyNewPWD {
    
    if ([self.oldText.text isEqualToString:@""]) {
        
        LRLog(@"密码不能为空");
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        [SVProgressHUD dismissWithDelay:1];
    }
    
    else if ([self.newpwdText.text isEqualToString:@""]) {
        
        LRLog(@"密码不能为空");
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        [SVProgressHUD dismissWithDelay:1];
    }
    
    else if ([self.confirmText.text isEqualToString:@""]) {
        
        LRLog(@"密码不能为空");
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        [SVProgressHUD dismissWithDelay:1];
    }
    //验证两次密码是否相同
    else if (![self.newpwdText.text isEqualToString:self.confirmText.text]) {
    
        LRLog(@"密码不相同");
        [SVProgressHUD showErrorWithStatus:@"两次输入密码不相同"];
        [SVProgressHUD dismissWithDelay:1];
    }
    else if (![zx_SN checkPassword:self.newpwdText.text]) {
        
        LRLog(@"新密码格式不对");
        [SVProgressHUD showErrorWithStatus:@"新密码必须是6-8位数字或字母"];
        [SVProgressHUD dismissWithDelay:1];
    } else {
        
        [self startToVerifyOldPWD];
    }
}

- (void)startToVerifyOldPWD {
    
    [SVProgressHUD showWithStatus:@"验证中..."];
    [zx_SN loginWithAccount:[zx_SN account] Password:self.oldText.text Success:^(id responseObject) {
        
        LRLog(@"密码正确");
        [SVProgressHUD showWithStatus:@"验证通过, 修改中"];
        [self startToChange];
    } Fail:^(NSString *errorCode) {
        
        LRLog(@"密码错误");
        [SVProgressHUD showErrorWithStatus:@"旧密码不正确"];
        [SVProgressHUD dismissWithDelay:1];
    }];
}

- (void)startToChange {
    
    LRWeakSelf(self)
    [zx_SN setPasswordWithString:self.newpwdText.text Success:^(id responseObject) {
        
        LRLog(@"密码修改成功");
        LRStrongSelf(self)
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        [SVProgressHUD dismissWithDelay:1 completion:^{
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    } Fail:^(NSString *errorCode) {
        
        LRLog(@"密码修改失败");
        [SVProgressHUD showErrorWithStatus:@"修改失败, 请检查网络哦"];
        [SVProgressHUD dismissWithDelay:1];
    }];
}

- (void)hideKeyboard {
    
    [self.oldText       becomeFirstResponder];
    [self.oldText       resignFirstResponder];
    [self.newpwdText    becomeFirstResponder];
    [self.newpwdText    resignFirstResponder];
    [self.confirmText   becomeFirstResponder];
    [self.confirmText   resignFirstResponder];
}

@end
