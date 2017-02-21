//
//  CategoryCell.m
//  SearchNotices
//
//  Created by Jackey on 2016/12/21.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //创建imageView
        self.imageView = ({
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:\
                                CGRectMake(SCREEN_WIDTH / 30,
                                           10,
                                           SCREEN_WIDTH / 5 - SCREEN_WIDTH / 15,
                                           SCREEN_WIDTH / 5 - SCREEN_WIDTH / 15)];
            
            imgView;
        });
        
        //创建lable
        self.lable = ({
        
            UILabel *lable      = [[UILabel alloc] initWithFrame:\
                        CGRectMake(SCREEN_WIDTH / 30,
                                   10 + SCREEN_WIDTH / 5 - SCREEN_WIDTH / 15,
                                   SCREEN_WIDTH / 5 - SCREEN_WIDTH / 15,
                                   25)];
            
            lable.textAlignment = NSTextAlignmentCenter;
            //lable.font          = [UIFont systemFontOfSize:10];
            lable.font          = [UIFont systemFontOfSize:10 weight:-0.8];
            
            lable;
        });
        
        //添加到UI
        [self addSubview:self.imageView];
        [self addSubview:self.lable];
        
        //设置背景颜色
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    
    return self;
}

- (void)configureCellWithDict:(NSDictionary *)dict {
    
    self.imageView.image = [UIImage imageNamed:[dict objectForKey:@"ImageName"]];
    self.lable.text      = [dict objectForKey:@"Title"];
}

@end
