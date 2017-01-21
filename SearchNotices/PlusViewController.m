//
//  PlusViewController.m
//  SearchNotices
//
//  Created by Jackey on 2017/1/8.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import "PlusViewController.h"

@interface PlusViewController ()

@property (nonatomic, strong) UIButton *plusButton;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic, strong) UIButton *clareButton;

@end

@implementation PlusViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setupView];
    [self createPlusButton];
}

- (void)setupView {
    
    [self.view setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.5]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismisSelf)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismisSelf {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createPlusButton {
    
    self.plusButton = ({
    
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"plus_normal"]
                          forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"plus_normal"]
                          forState:UIControlStateHighlighted];
        button.frame  = CGRectMake(SCREEN_WIDTH / 2 - button.currentBackgroundImage.size.width / 2,
                                   SCREEN_HEIGHT - 49 - button.currentBackgroundImage.size.height / 3,
                                   button.currentBackgroundImage.size.width,
                                   button.currentBackgroundImage.size.height);
        
        
        button;
    });
    
    [self.view addSubview:self.plusButton];
}

@end
