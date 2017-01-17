//
//  HomeHeaderView.m
//  SearchNotices
//
//  Created by Jackey on 2016/12/21.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "HomeHeaderView.h"

@implementation HomeHeaderView

//初始化
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //初始化控件
        self.titleBtn = ({
        
            UIButton *btn                = [UIButton buttonWithType:UIButtonTypeSystem];
            
            btn.frame                    = CGRectMake(SCREEN_WIDTH / 2 - 30, 0, 60, 25);
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            btn.titleLabel.font          = [UIFont systemFontOfSize:10];
            btn.tintColor                = [UIColor blackColor];
            btn;
        });
        
        self.moreBtn = ({
        
            UIButton *btn                = [UIButton buttonWithType:UIButtonTypeSystem];
            
            btn.frame                    = CGRectMake(SCREEN_WIDTH - 65, 0, 60, 25);
            btn.titleLabel.textAlignment = NSTextAlignmentRight;
            btn.titleLabel.font          = [UIFont systemFontOfSize:10];
            
            [btn setTitle:@"更多 >>" forState:UIControlStateNormal];
            
            btn;
        });
        
        //将控件添加到UI上
        [self addSubview:self.titleBtn];
        [self addSubview:self.moreBtn];
        
        //设置背景颜色
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    
    return self;
}

- (void)configureWithDict:(NSDictionary *)dict {
    
    //self.titleBtn.titleLabel.text = [dict objectForKey:@"Title"];
    [self.titleBtn setTitle:[dict objectForKey:@"Title"] forState:UIControlStateNormal];
}

@end
