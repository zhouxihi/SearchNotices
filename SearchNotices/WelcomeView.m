//
//  WelcomeView.m
//  SearchNotices
//
//  Created by Jackey on 2017/1/19.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import "WelcomeView.h"
#import "YXEasing.h"

@interface WelcomeView()

@property (nonatomic, assign) CGFloat precessnum;
@property (nonatomic, strong) CAShapeLayer *circle;
@property (nonatomic, strong) CADisplayLink *link;

@end

@implementation WelcomeView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *infoLable = ({
        
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT - 20 - 15, SCREEN_WIDTH - 40, 15)];
            lable.text = @"Copyright © 2017年 com.zhouxi. All rights reserved.";
            lable.textAlignment = NSTextAlignmentCenter;
            lable.textColor = [UIColor darkGrayColor];
            lable.font      = [UIFont systemFontOfSize:12];
            lable.adjustsFontSizeToFitWidth = YES;
            
            lable;
        });
        
        [self addSubview:infoLable];
        
        UIButton *infoButton = ({
        
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(20, SCREEN_HEIGHT - 40 - 29, SCREEN_WIDTH - 40, 29);
            [button setTitle:@" 互助寻人" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"startIcon29x29.png"] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:24]];
            
            button;
        });
        
        [self addSubview:infoButton];
        [self createAnimate];
    }
    
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(circleAction)];
    
    [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    return self;
}

- (void)createAnimate {
    
    self.circle = ({
        
        //// Color Declarations
        UIColor* fillColor = [UIColor colorWithRed: 0.8 green: 0 blue: 0.04 alpha: 1];

        //// Bezier Drawing
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(69.18, 62.84)];
        [bezierPath addCurveToPoint: CGPointMake(53.12, 44.15) controlPoint1: CGPointMake(60.02, 61.51) controlPoint2: CGPointMake(52.3, 53.68)];
        [bezierPath addCurveToPoint: CGPointMake(71.31, 28.27) controlPoint1: CGPointMake(53.93, 34.64) controlPoint2: CGPointMake(62.07, 27.51)];
        [bezierPath addCurveToPoint: CGPointMake(86.52, 46.86) controlPoint1: CGPointMake(80.53, 29.01) controlPoint2: CGPointMake(88.03, 37.41)];
        [bezierPath addCurveToPoint: CGPointMake(69.18, 62.84) controlPoint1: CGPointMake(84.73, 58.29) controlPoint2: CGPointMake(78.11, 64.17)];
        [bezierPath closePath];
        [bezierPath moveToPoint: CGPointMake(107.97, 109.73)];
        [bezierPath addCurveToPoint: CGPointMake(103.98, 108.19) controlPoint1: CGPointMake(106.74, 109.87) controlPoint2: CGPointMake(105.2, 109.15)];
        [bezierPath addCurveToPoint: CGPointMake(80.49, 106.65) controlPoint1: CGPointMake(97.23, 102.94) controlPoint2: CGPointMake(85.23, 86.36)];
        [bezierPath addCurveToPoint: CGPointMake(101.86, 160.13) controlPoint1: CGPointMake(78.34, 122.2) controlPoint2: CGPointMake(81, 134.11)];
        [bezierPath addCurveToPoint: CGPointMake(101, 163.76) controlPoint1: CGPointMake(102.77, 161.26) controlPoint2: CGPointMake(103.03, 163.66)];
        [bezierPath addCurveToPoint: CGPointMake(96.76, 162.63) controlPoint1: CGPointMake(98.96, 163.86) controlPoint2: CGPointMake(96.76, 162.63)];
        [bezierPath addCurveToPoint: CGPointMake(75.98, 145.03) controlPoint1: CGPointMake(90, 159.68) controlPoint2: CGPointMake(85.61, 154.48)];
        [bezierPath addCurveToPoint: CGPointMake(58.05, 144.91) controlPoint1: CGPointMake(67.85, 137.12) controlPoint2: CGPointMake(59.45, 135.14)];
        [bezierPath addCurveToPoint: CGPointMake(57.95, 146.36) controlPoint1: CGPointMake(57.99, 145.4) controlPoint2: CGPointMake(57.95, 145.89)];
        [bezierPath addCurveToPoint: CGPointMake(58.59, 162.33) controlPoint1: CGPointMake(57.99, 152.47) controlPoint2: CGPointMake(58.11, 158.15)];
        [bezierPath addCurveToPoint: CGPointMake(54.1, 164.09) controlPoint1: CGPointMake(58.89, 164.79) controlPoint2: CGPointMake(55.64, 166.08)];
        [bezierPath addCurveToPoint: CGPointMake(39.45, 100.13) controlPoint1: CGPointMake(47.03, 154.93) controlPoint2: CGPointMake(38.3, 133.13)];
        [bezierPath addCurveToPoint: CGPointMake(16.84, 114.07) controlPoint1: CGPointMake(39.45, 94.36) controlPoint2: CGPointMake(33.77, 93.68)];
        [bezierPath addCurveToPoint: CGPointMake(15.21, 100.65) controlPoint1: CGPointMake(11.97, 119.93) controlPoint2: CGPointMake(7.91, 116.63)];
        [bezierPath addCurveToPoint: CGPointMake(64.51, 68.95) controlPoint1: CGPointMake(15.21, 100.65) controlPoint2: CGPointMake(31.41, 68.15)];
        [bezierPath addCurveToPoint: CGPointMake(107.83, 103.89) controlPoint1: CGPointMake(87.75, 71.04) controlPoint2: CGPointMake(100.16, 88.41)];
        [bezierPath addCurveToPoint: CGPointMake(109.41, 107.45) controlPoint1: CGPointMake(108.59, 105.4) controlPoint2: CGPointMake(109.16, 106.57)];
        [bezierPath addCurveToPoint: CGPointMake(107.97, 109.73) controlPoint1: CGPointMake(109.75, 108.48) controlPoint2: CGPointMake(109.04, 109.62)];
        [bezierPath closePath];
        [bezierPath moveToPoint: CGPointMake(149.43, 114.11)];
        [bezierPath addCurveToPoint: CGPointMake(131.68, 104.29) controlPoint1: CGPointMake(142.42, 115.52) controlPoint2: CGPointMake(133.22, 111.51)];
        [bezierPath addCurveToPoint: CGPointMake(143.91, 87.92) controlPoint1: CGPointMake(130.16, 97.04) controlPoint2: CGPointMake(136.89, 89.32)];
        [bezierPath addCurveToPoint: CGPointMake(159.38, 98.48) controlPoint1: CGPointMake(150.92, 86.51) controlPoint2: CGPointMake(157.83, 91.24)];
        [bezierPath addCurveToPoint: CGPointMake(149.43, 114.11) controlPoint1: CGPointMake(160.9, 105.71) controlPoint2: CGPointMake(156.46, 112.72)];
        [bezierPath closePath];
        [bezierPath moveToPoint: CGPointMake(186.35, 110.83)];
        [bezierPath addCurveToPoint: CGPointMake(173.13, 122.35) controlPoint1: CGPointMake(185.1, 113.29) controlPoint2: CGPointMake(182.27, 116.16)];
        [bezierPath addCurveToPoint: CGPointMake(166.68, 132.08) controlPoint1: CGPointMake(170.23, 124.3) controlPoint2: CGPointMake(167.25, 128.7)];
        [bezierPath addCurveToPoint: CGPointMake(168.85, 146.38) controlPoint1: CGPointMake(166.02, 136.34) controlPoint2: CGPointMake(167.34, 140.46)];
        [bezierPath addCurveToPoint: CGPointMake(169.34, 161.92) controlPoint1: CGPointMake(169.94, 150.85) controlPoint2: CGPointMake(170.98, 157.63)];
        [bezierPath addCurveToPoint: CGPointMake(165.86, 162.25) controlPoint1: CGPointMake(168.71, 163.54) controlPoint2: CGPointMake(166.58, 163.86)];
        [bezierPath addCurveToPoint: CGPointMake(153.91, 150.05) controlPoint1: CGPointMake(163.83, 157.64) controlPoint2: CGPointMake(161.39, 151.39)];
        [bezierPath addCurveToPoint: CGPointMake(143.38, 161.71) controlPoint1: CGPointMake(146.35, 149.46) controlPoint2: CGPointMake(143.5, 154.6)];
        [bezierPath addCurveToPoint: CGPointMake(139.3, 162.84) controlPoint1: CGPointMake(143.34, 163.86) controlPoint2: CGPointMake(141.05, 164.58)];
        [bezierPath addCurveToPoint: CGPointMake(134.14, 149.75) controlPoint1: CGPointMake(137.27, 160.75) controlPoint2: CGPointMake(135.51, 157.76)];
        [bezierPath addCurveToPoint: CGPointMake(130.8, 131.71) controlPoint1: CGPointMake(132.44, 139.64) controlPoint2: CGPointMake(135.04, 134.95)];
        [bezierPath addCurveToPoint: CGPointMake(108.91, 121.16) controlPoint1: CGPointMake(127.83, 129.42) controlPoint2: CGPointMake(114.77, 127.66)];
        [bezierPath addCurveToPoint: CGPointMake(110.18, 117.9) controlPoint1: CGPointMake(107.83, 119.97) controlPoint2: CGPointMake(108.57, 118.11)];
        [bezierPath addCurveToPoint: CGPointMake(149.75, 118.21) controlPoint1: CGPointMake(117.19, 117) controlPoint2: CGPointMake(129.39, 120.59)];
        [bezierPath addCurveToPoint: CGPointMake(183.48, 106.8) controlPoint1: CGPointMake(164.88, 116.24) controlPoint2: CGPointMake(176.91, 109.13)];
        [bezierPath addCurveToPoint: CGPointMake(186.35, 110.83) controlPoint1: CGPointMake(185.68, 106.02) controlPoint2: CGPointMake(187.7, 108.09)];
        [bezierPath closePath];
        //[fillColor setFill];
        //[bezierPath fill];
        
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.bounds        = CGRectMake(0, 0, 200, 200);
        layer.position      = self.center;
        layer.path          = bezierPath.CGPath;
        layer.fillColor     = [UIColor whiteColor].CGColor;
        layer.strokeColor   = fillColor.CGColor;
        layer.lineCap       = @"round";
        layer.lineWidth     = 2;
        layer.strokeEnd     = self.precessnum / 150;
        
        CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation1.toValue           = @(0);
        animation1.fromValue         = @(1);
        animation1.duration          = 1.5;
        animation1.removedOnCompletion = NO;
        animation1.fillMode          = kCAFillModeForwards;
        
        CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation2.duration             = 1.5;
        animation2.removedOnCompletion  = NO;
        animation2.fillMode             = kCAFillModeForwards;
        animation2.values               = [YXEasing calculateFrameFromValue:0.5
                                                                    toValue:2
                                                                       func:BackEaseOut
                                                                 frameCount:1.5f * 30];
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations        = @[animation1, animation2];
        group.duration          = 1.5;
        group.fillMode          = kCAFillModeForwards;
        group.beginTime         = CACurrentMediaTime() + 4;
        group.removedOnCompletion = NO;
        
        [layer addAnimation:group forKey:nil];
        
        layer;
    });
    
    [self.layer addSublayer:self.circle];
}

- (void)circleAction  {
    
    self.precessnum ++;
    self.circle.strokeEnd = self.precessnum / 150;
//    NSLog(@"%f", self.precessnum);
//    NSLog(@"%f", self.precessnum / 150);
    if (self.precessnum >149) {
        
        self.circle.fillColor = [UIColor colorWithRed: 0.8 green: 0 blue: 0.04 alpha: 1].CGColor;
        [self.link invalidate];
    }
}
@end
