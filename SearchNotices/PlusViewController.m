//
//  PlusViewController.m
//  SearchNotices
//
//  Created by Jackey on 2017/1/8.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import "PlusViewController.h"

@interface PlusViewController ()

@end

@implementation PlusViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setupView];
}

- (void)setupView {
    
    [self.view setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.5]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismisSelf)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismisSelf {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
