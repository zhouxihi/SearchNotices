//
//  CheckCodeViewController.m
//  SearchNotices
//
//  Created by Jackey on 2017/1/7.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import "CheckCodeViewController.h"
#import "SNManager.h"
#import "SVProgressHUD.h"
#import "SetNewPasswordViewController.h"

#define countTime 25

@interface CheckCodeViewController ()

@property (nonatomic, strong) UIImageView       *bgImageView;
@property (nonatomic, strong) UILabel           *titleLable;
@property (nonatomic, strong) UITextField       *accountTextField;
@property (nonatomic, strong) UITextField       *codeTextField;
@property (nonatomic, strong) UIButton          *getCodeButton;
@property (nonatomic, strong) UIButton          *nextButton;
@property (nonatomic, assign) NSInteger          countdown;
@property (nonatomic, strong) CADisplayLink     *displayLink;

@end

@implementation CheckCodeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setupData];
    [self setupView];
}

- (void)setupData {
    
    self.countdown = countTime * 60;
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
        
        lable.text          = @"身份验证";
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
        textField.placeholder        = self.account;
        textField.layer.borderColor  = [UIColor whiteColor].CGColor;
        textField.layer.borderWidth  = 0.7;
        textField.textAlignment      = NSTextAlignmentCenter;
        textField.textColor          = [UIColor whiteColor];
        textField.backgroundColor    = [UIColor clearColor];
        textField.enabled            = NO;
        
        textField;
    });
    
    [self.view addSubview:self.accountTextField];
    
    self.codeTextField = ({
    
        UITextField *textField       = [[UITextField alloc] initWithFrame:\
                                        CGRectMake(40, SCREEN_WIDTH / 2 - 80 + 50 + 40 + 50,
                                                   SCREEN_WIDTH - 80 - 80, 40)];
        
        textField.layer.cornerRadius = 10;
        textField.placeholder        = @"输入验证码";
        textField.layer.borderColor  = [UIColor whiteColor].CGColor;
        textField.layer.borderWidth  = 0.7;
        textField.textAlignment      = NSTextAlignmentCenter;
        textField.textColor          = [UIColor whiteColor];
        textField.backgroundColor    = [UIColor clearColor];
        
        textField;

    });
    
    [self.view addSubview:self.codeTextField];
    
    self.getCodeButton = ({
    
        UIButton *btn          = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame              = \
        CGRectMake(40 + SCREEN_WIDTH - 80 - 80 + 10, SCREEN_WIDTH / 2 - 80 + 50 + 40 + 50,
                   70, 40);
        btn.layer.cornerRadius = 10;
        
        [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [btn setBackgroundColor:BlueBtnColor];
        [btn setTintColor:[UIColor whiteColor]];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:10]];
        
        [btn addTarget:self
                action:@selector(startTimer)
      forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    
    [self.view addSubview:self.getCodeButton];
    
    self.nextButton = ({
    
        UIButton *btn          = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame              = \
        CGRectMake(40, SCREEN_WIDTH / 2 - 80 + 50 + 40 + 40 + 10 + 50,
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

- (void)startTimer {
    
    //获取验证码
    [zx_SN getPhoneCodeWithPhoneNumer:self.account Success:^(id responseObject) {
        
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
    
    LRLog(@"加计时器");
    //倒计时
    self.displayLink    = ({
        
        CADisplayLink *link = \
        [CADisplayLink displayLinkWithTarget:self selector:@selector(buttonCountdown)];
        
        
        link;
    });
    
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];

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

//下一步动作
- (void)nextAction {
    
    if ([self.codeTextField.text isEqualToString:@""]) {
        
        [SVProgressHUD showErrorWithStatus:@"验证码不能为空"];
        [SVProgressHUD dismissWithDelay:1];
    } else {
        
//        SetNewPasswordViewController *setVC = \
//        [[SetNewPasswordViewController alloc] init];
//        [self.navigationController pushViewController:setVC animated:YES];
        
        //验证码校验
        [SVProgressHUD showWithStatus:@"验证中"];
        LRWeakSelf(self)
        [zx_SN verifyPhoneCode:self.codeTextField.text
                   PhoneNumber:self.account
                       Success:^(id responseObject) {
                           
                           LRStrongSelf(self)
                           [SVProgressHUD showSuccessWithStatus:@"验证通过"];
                           LRWeakSelf(self)
                           [SVProgressHUD dismissWithDelay:1 completion:^{
                               
                               LRStrongSelf(self)
                               SetNewPasswordViewController *setVC = \
                                            [[SetNewPasswordViewController alloc] init];
                               [self.navigationController pushViewController:setVC animated:YES];
                           }];
                       }
                          Fail:^(NSString *errorCode) {
                              
                              [SVProgressHUD showErrorWithStatus:@"验证码错误"];
                              [SVProgressHUD dismissWithDelay:1];
                          }];
    }
}

@end
