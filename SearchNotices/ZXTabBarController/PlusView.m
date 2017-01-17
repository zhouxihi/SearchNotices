//
//  PlusView.m
//  SearchNotices
//
//  Created by Jackey on 2017/1/8.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import "PlusView.h"
#import "YXEasing.h"

@interface PlusView ()

@property CGPoint plusPoint;
@property CGPoint cameraPoint;
@property CGPoint photoPoint;
@property CGPoint describePoint;

@end

@implementation PlusView

static PlusView *_instance = nil;

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance       = [[super allocWithZone:NULL] init];
        _instance.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        [_instance setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.8]];
        
        _instance.radius = SCREEN_WIDTH / 3;
        [_instance setupActionView];
        [_instance setupCameraView];
        [_instance setupPhotoView];
        [_instance setupDescView];
        [_instance addSubview:_instance.actionView];
        
        
        
    });

    return _instance;
}

- (void)setupActionView {
    
    //创建一个ImageView来装图片
    UIImageView *imageView = ({
    
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image        = [UIImage imageNamed:@"plus_normal"];
        CGSize size          = [[UIImage imageNamed:@"plus_normal"] size];
        CGRect frame         = CGRectMake(0, 0, size.width, size.height);
        imgView.frame        = frame;
        
        imgView;
    });
    
    self.actionView = ({
    
        CGSize size          = [[UIImage imageNamed:@"plus_normal"] size];
        CGRect frame         = \
        CGRectMake(SCREEN_WIDTH / 2 - size.width / 2,
                   SCREEN_HEIGHT - 49 - size.height / 3,
                   size.width,
                   size.height);
        
        UIView *view   = [[UIView alloc] initWithFrame:frame];
        self.plusPoint = view.center;
        
        [view addSubview:imageView];
        
        view;
    });
    
    //[self addSubview:self.actionView];
}

- (void)setupCameraView {
    
    //创建一个ImageView来装图片
    UIImageView *imageView = ({
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image        = [UIImage imageNamed:@"take_picture"];
        CGSize size          = [[UIImage imageNamed:@"plus_normal"] size];
        CGRect frame         = CGRectMake(0, 0, size.width, size.height);
        imgView.frame        = frame;
        
        imgView;
    });
    
    self.cameraView = ({
        
        //设置View大小
        CGSize size          = [[UIImage imageNamed:@"plus_normal"] size];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        
        //计算中心离中线的距离
        CGFloat distance = sqrt(pow(self.radius, 2) * 3 / 4);
        NSLog(@"distance = %f", distance);
        
        //计算中心位置
        CGFloat x = SCREEN_WIDTH / 2 - distance;
        CGFloat y = SCREEN_HEIGHT - self.radius / 2 - 49 + size.height / 6;
        NSLog(@"x= %f, y = %f", x, y);
        view.center = CGPointMake(x, y);
        
        self.cameraPoint = view.center;
        view.center = self.plusPoint;
        
        [view addSubview:imageView];
        
        view;
    });
    
    [self addSubview:self.cameraView];
}

- (void)setupPhotoView {
    
    //创建一个ImageView来装图片
    UIImageView *imageView = ({
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image        = [UIImage imageNamed:@"photo"];
        CGSize size          = [[UIImage imageNamed:@"plus_normal"] size];
        CGRect frame         = CGRectMake(0, 0, size.width, size.height);
        imgView.frame        = frame;
        
        imgView;
    });
    
    self.photoView = ({
        
        //设置View大小
        CGSize size          = [[UIImage imageNamed:@"plus_normal"] size];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        
        //计算中心位置
        CGFloat x = SCREEN_WIDTH / 2;
        CGFloat y = SCREEN_HEIGHT - self.radius - 49 + size.height / 6;
        view.center = CGPointMake(x, y);
        
        self.photoPoint = view.center;
        view.center = self.plusPoint;
        
        [view addSubview:imageView];
        
        view;
    });
    
    [self addSubview:self.photoView];
}

- (void)setupDescView {
    
    //创建一个ImageView来装图片
    UIImageView *imageView = ({
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image        = [UIImage imageNamed:@"shouye"];
        CGSize size          = [[UIImage imageNamed:@"plus_normal"] size];
        CGRect frame         = CGRectMake(0, 0, size.width, size.height);
        imgView.frame        = frame;
        
        imgView;
    });
    
    self.describeView = ({
        
        //设置View大小
        CGSize size          = [[UIImage imageNamed:@"plus_normal"] size];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        
        //计算中心离中线的距离
        CGFloat distance = sqrt(pow(self.radius, 2) * 3 / 4);
        
        //计算中心位置
        CGFloat x = SCREEN_WIDTH / 2 + distance;
        CGFloat y = SCREEN_HEIGHT - self.radius / 2 - 49 + size.height / 6;
        view.center = CGPointMake(x, y);
        
        self.describePoint = view.center;
        
        view.center = self.plusPoint;
        
        [view addSubview:imageView];
        
        view;

    });
    
    [self addSubview:self.describeView];

}


- (void)drawRect:(CGRect)rect {
    
    //创建Camera关键帧动画
    CAKeyframeAnimation *cameraPointAnimation = ({
    
        CAKeyframeAnimation *animation = \
            [CAKeyframeAnimation animationWithKeyPath:@"position"];
        
        animation.removedOnCompletion  = NO;
        animation.fillMode             = kCAFillModeForwards;
        animation.duration             = 0.3 + 0.05;
        animation.calculationMode      = kCAAnimationCubicPaced;
        animation.values               = [YXEasing calculateFrameFromPoint:self.plusPoint
                                                                   toPoint:self.cameraPoint
                                                                      func:BounceEaseOut
                                                                frameCount:0.3f * 30];
        animation;
    });

    [self.cameraView.layer addAnimation:cameraPointAnimation forKey:@"nil"];
    
    //创建Photo关键帧动画
    CAKeyframeAnimation *photoPointAnimation = ({
        
        CAKeyframeAnimation *animation = \
        [CAKeyframeAnimation animationWithKeyPath:@"position"];
        
        animation.removedOnCompletion  = NO;
        animation.fillMode             = kCAFillModeForwards;
        animation.duration             = 0.3 + 0.05;
        animation.calculationMode      = kCAAnimationCubicPaced;
        animation.values               = [YXEasing calculateFrameFromPoint:self.plusPoint
                                                                   toPoint:self.photoPoint
                                                                      func:BounceEaseOut
                                                                frameCount:0.3f * 30];
        
        animation;
    });
    
    [self.photoView.layer addAnimation:photoPointAnimation forKey:@"nil"];
    
    //创建Describe关键帧动画
    CAKeyframeAnimation *describePointAnimation = ({
        
        CAKeyframeAnimation *animation = \
        [CAKeyframeAnimation animationWithKeyPath:@"position"];
        
        animation.removedOnCompletion  = NO;
        animation.fillMode             = kCAFillModeForwards;
        animation.duration             = 0.3 + 0.05;
        animation.calculationMode      = kCAAnimationCubicPaced;
        animation.values               = [YXEasing calculateFrameFromPoint:self.plusPoint
                                                                   toPoint:self.describePoint
                                                                      func:BounceEaseOut
                                                                frameCount:0.3f * 30];
        
        animation;
    });
    
    [self.describeView.layer addAnimation:describePointAnimation forKey:@"nil"];
    
}

- (void)dismissAction {
    
    //[self removeFromSuperview];
}

- (CAAnimationGroup *)foldAnimationFromPoint:(CGPoint)endPoint
                                withFarPoint:(CGPoint)farPoint {
    // 1.Configure rotation animation
    //
    CAKeyframeAnimation *rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.values = @[@(0), @(M_PI), @(M_PI * 2)];
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAnimation.duration = 0.3 + 0.05f;
    
    // 2.Configure moving animation
    //
    CAKeyframeAnimation *movingAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    // Create moving path
    //
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, endPoint.x, endPoint.y);
    CGPathAddLineToPoint(path, NULL, farPoint.x, farPoint.y);
    CGPathAddLineToPoint(path, NULL, self.plusPoint.x, self.plusPoint.y);
    
    movingAnimation.keyTimes = @[@(0.0f), @(0.75), @(1.0)];
    
    movingAnimation.path = path;
    movingAnimation.duration = 0.3 + 0.05f;
    CGPathRelease(path);
    
    // 3.Merge animation together
    //
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    animations.animations = @[rotationAnimation, movingAnimation];
    animations.duration = 0.3 + 0.05f;
    
    return animations;
}

@end
