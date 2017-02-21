//
//  PresentPhotoViewController.m
//  SearchNotices
//
//  Created by Jackey on 2017/2/5.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import "PresentPhotoViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Image.h"
#import "SVProgressHUD.h"

@interface PresentPhotoViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILabel     *numberLable;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, assign) NSInteger   num;

@end

@implementation PresentPhotoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupView];
    [self setupData];
}

- (void)setupView {
    
    //设置背景颜色为黑色
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    //初始化numberLable
    self.numberLable = ({
    
        UILabel *lable = \
            [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100) / 2, SCREEN_HEIGHT / 6 - 25 - 20, 100, 25)];
        
        [lable setBackgroundColor:[UIColor blackColor]];
        [lable setTextColor:[UIColor whiteColor]];
        [lable setFont:[UIFont systemFontOfSize:12]];
        [lable setTextAlignment:NSTextAlignmentCenter];
        
        lable;
    });
    
    [self.view addSubview:self.numberLable];
    
    //初始化imgView
    self.imgView    = ({
    
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 80, SCREEN_WIDTH - 80)];
        imageView.center       = self.view.center;
        
        //[imageView setUserInteractionEnabled:YES];
        
        //创建动画
        //创建专场动画
//        CATransition *animation = [CATransition animation];
//        animation.duration      = 1;
//        animation.fillMode      = kCAFillModeForwards;
//        animation.type          = @"reveal";
//        animation.subtype       = kCATransitionFromTop;
//        
//        [imageView.layer addAnimation:animation forKey:nil];
        
        imageView;
    });
    
    [self.view addSubview:self.imgView];
    
    //添加提醒
    
    UILabel *mentionLable = ({
    
        UILabel *lable = \
        [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100) / 2, SCREEN_HEIGHT / 6 * 5 + 10, 100, 25)];
        
        [lable setBackgroundColor:[UIColor blackColor]];
        [lable setTextColor:[UIColor whiteColor]];
        [lable setFont:[UIFont systemFontOfSize:10]];
        [lable setTextAlignment:NSTextAlignmentCenter];
        [lable setText:@"左右滑动切换图片"];
        
        lable;
    });
    
    [self.view addSubview:mentionLable];
    
    //创建手势
    
    //左滑手势
    UISwipeGestureRecognizer *leftSwipe = \
                [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(leftSlideAction)];
    
    leftSwipe.direction                 = UISwipeGestureRecognizerDirectionLeft;
    
    [self.view addGestureRecognizer:leftSwipe];
    
    //右滑手势
    UISwipeGestureRecognizer *rightSwipe = \
                [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(rightSlideAction)];
    
    rightSwipe.direction                 = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:rightSwipe];
    
    //点击手势
    UITapGestureRecognizer *tap    = \
                [[UITapGestureRecognizer alloc] initWithTarget:self
                                                        action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)setupData {
    
    //设置imgView初始图片
    [self.imgView sd_setImageWithURL:self.imglinkArray[0]
                    placeholderImage:[UIImage imageWithColor:[UIColor blackColor]]];
    
    //初始图片位置编号
    self.num = 0;
    
    //初始numberLable值
    [self.numberLable setText:[NSString stringWithFormat:@"%d/%lu", self.num + 1, (unsigned long)self.imglinkArray.count]];
    
}

- (void)swipeAction:(UISwipeGestureRecognizer *)gesture {
    
    //获取手势方向
    NSUInteger direction = gesture.direction;
    NSLog(@"%lu", (unsigned long)direction);
    
    if (direction == UISwipeGestureRecognizerDirectionLeft) {
        
        [self leftSlideAction];
    }
    else if (direction == UISwipeGestureRecognizerDirectionRight) {
        
        [self rightSlideAction];
    }
}

- (void)leftSlideAction {
    
    //先判断是否为最后一张图
    if (self.num < self.imglinkArray.count - 1) {
        
        LRLog(@"下一张");
        ++ self.num;
        [self.numberLable setText:\
        [NSString stringWithFormat:@"%d/%lu", self.num + 1, (unsigned long)self.imglinkArray.count]];
        
        CATransition *animation = [CATransition animation];
        animation.duration      = 1;
        animation.fillMode      = kCAFillModeForwards;
        animation.type          = @"rippleEffect";
        animation.subtype       = kCATransitionFromTop;
        
        [self.imgView.layer addAnimation:animation forKey:nil];
        
        [self.imgView sd_setImageWithURL:self.imglinkArray[self.num]
                        placeholderImage:[UIImage imageWithColor:[UIColor blackColor]]];
    } else {
        
        [SVProgressHUD showInfoWithStatus:@"最后一张啦"];
        [SVProgressHUD dismissWithDelay:1];
    }
}

- (void)rightSlideAction {
    
    //先判断是否为第一张
    if (self.num != 0) {
        
        LRLog(@"上一张");
        -- self.num;
        [self.numberLable setText:\
         [NSString stringWithFormat:@"%ld/%lu", self.num + 1, (unsigned long)self.imglinkArray.count]];
        
        CATransition *animation = [CATransition animation];
        animation.duration      = 1;
        animation.fillMode      = kCAFillModeForwards;
        animation.type          = @"rippleEffect";
        animation.subtype       = kCATransitionFromTop;
        
        [self.imgView.layer addAnimation:animation forKey:nil];
        
        [self.imgView sd_setImageWithURL:self.imglinkArray[self.num]
                        placeholderImage:[UIImage imageWithColor:[UIColor blackColor]]];
    } else {
        
        [SVProgressHUD showInfoWithStatus:@"前面没有啦"];
        [SVProgressHUD dismissWithDelay:1];
    }
}

- (void)tapAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
