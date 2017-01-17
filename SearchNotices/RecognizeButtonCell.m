//
//  RecognizeButtonCell.m
//  SearchNotices
//
//  Created by Jackey on 2016/12/16.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "RecognizeButtonCell.h"
#import "UIImageView+WebCache.h"

#define BTNWIDTH (SCREEN_WIDTH - 22.4)/ 3
#define BTNHEIGHT 30

@implementation RecognizeButtonCell

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //初始化控件
        self.btn = ({
            
            UIButton *button                  = [UIButton buttonWithType:UIButtonTypeSystem];
            
            button.frame                      = CGRectMake(0, 0, BTNWIDTH, BTNHEIGHT);
            button.titleLabel.textAlignment   = NSTextAlignmentCenter;
            button.titleLabel.font            = [UIFont systemFontOfSize:12];
            button.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            button.tintColor                  = [UIColor blackColor];
            button.userInteractionEnabled     = NO;
            button;
        });
        
        //添加控件到cell上
        [self addSubview:self.btn];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];

}

- (void)configWithDict:(NSDictionary *)dict {
    
    [self.btn setImage:[UIImage imageNamed:[dict objectForKey:@"ImageName"]] \
              forState:UIControlStateNormal];
    [self.btn setTitle:[dict valueForKey:@"Title"] forState:UIControlStateNormal];

}


@end
