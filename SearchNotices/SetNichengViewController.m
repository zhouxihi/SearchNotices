//
//  SetNichengViewController.m
//  SearchNotices
//
//  Created by Jackey on 2017/1/4.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import "SetNichengViewController.h"
#import "SNManager.h"
#import "SVProgressHUD.h"

@interface SetNichengViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;    //显示昵称
@property (nonatomic, strong) UIButton    *btn;          //确认修改按钮
@property (nonatomic, strong) UILabel     *mentionLable; //提示lable

@end

@implementation SetNichengViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //1.创建UI
    [self setupView];
    
    //2.获取当前昵称
    [self setupData];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)setupData {
    
    [self getNicheng];
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
    
    //创建显示昵称textField
    self.textField = ({
    
        UITextField *text       = [[UITextField alloc] initWithFrame:\
                                   CGRectMake(10, 40, SCREEN_WIDTH - 100, 40)];
        text.placeholder        = @"设置昵称";
        text.font               = [UIFont systemFontOfSize:14];
        text.delegate           = self;
        text.backgroundColor    = [UIColor whiteColor];
        //text.layer.cornerRadius = 5;
        
        text;
    });
    
    [self.view addSubview:self.textField];
    
    //创建修改昵称按钮
    self.btn = ({
    
        UIButton *button          = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame              = CGRectMake(10 + SCREEN_WIDTH - 100 + 10, 40, 70, 40);
        button.enabled            = NO;
        button.layer.cornerRadius = 5;
        
        [button setTitle:@"修改" forState:UIControlStateNormal];
        [button setTintColor:[UIColor blackColor]];
        [button setBackgroundColor: [UIColor whiteColor]];
        
        [button addTarget:self
                   action:@selector(changeNiCheng)
         forControlEvents:UIControlEventTouchUpInside];
        
        button;
    });
    
    [self.view addSubview:self.btn];
    
    //创建昵称提醒lable
    self.mentionLable = ({
    
        UILabel *lable      = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 25)];
        lable.text          = @"昵称只能是8位以内的汉字";
        lable.textColor     = [UIColor lightGrayColor];
        lable.font          = [UIFont systemFontOfSize:10];
        lable.textAlignment = NSTextAlignmentLeft;
        lable.hidden        = YES;
        
        lable;
    });
    
    [self.view addSubview:self.mentionLable];
}

//获取昵称方法
- (void)getNicheng {
    
    LRLog(@"获取昵称");
    
    [SVProgressHUD show];
    LRWeakSelf(self)
    [zx_SN getNichengSuccess:^(id responseObject) {
        
        LRStrongSelf(self)
        if ([(NSString *)responseObject isEqualToString:@"Default"]) {
            
            self.textField.placeholder = @"尚未设置昵称";
        } else {
            
            self.textField.placeholder = (NSString *)responseObject;
        }
        
        [SVProgressHUD dismiss];
        
    } Fail:^(NSString *errorCode) {
        
        LRLog(@"网络异常");
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        [SVProgressHUD dismissWithDelay:1];
    }];
}

//设置昵称方法
- (void)changeNiCheng {
    
    LRLog(@"修改昵称");
    
    //检查昵称格式
    if ([self.textField.text isEqualToString:@""]) {
        
        LRLog(@"昵称不能为空");
        [SVProgressHUD showErrorWithStatus:@"昵称不能为空"];
        [SVProgressHUD dismissWithDelay:1];
    }
    else if (![zx_SN checkNicheng:self.textField.text]) {
        
        LRLog(@"昵称不符合8位以内的汉字");
        [SVProgressHUD showErrorWithStatus:@"昵称需要为8位以内的汉字"];
        [SVProgressHUD dismissWithDelay:1];
    } else {
        
        //开始修改
        [SVProgressHUD showWithStatus:@"修改中"];
        [zx_SN setNichengWithString:self.textField.text Success:^(id responseObject) {
            
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [SVProgressHUD dismissWithDelay:1];
        } Fail:^(NSString *errorCode) {
            
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
            [SVProgressHUD dismissWithDelay:1];
        }];
    }
}

#pragma mark - TextField Delegate Method

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.btn.enabled         = YES;
    self.mentionLable.hidden = NO;
}

@end
