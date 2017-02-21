//
//  HomeCell.m
//  SearchNotices
//
//  Created by Jackey on 2016/12/21.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "HomeCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Image.h"

@implementation HomeCell

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //创建控件
        self.imageView = ({
        
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:\
                            CGRectMake(5, 5, SCREEN_WIDTH / 4 - 5, (SCREEN_WIDTH / 4 - 5) * 1)];
            
            //imgView.contentMode  = UIViewContentModeScaleAspectFit;
            
            imgView;
        });
        
        self.titleLable = ({
        
            UILabel *lable = [[UILabel alloc] initWithFrame:\
                              CGRectMake(SCREEN_WIDTH / 4 + 5, 5, SCREEN_WIDTH / 4 - 10, 25)];
            
            lable.textAlignment = NSTextAlignmentLeft;
            lable.font          = [UIFont systemFontOfSize:12 weight:0.1];
    
            lable;
        });
        
        self.nameLable = ({
        
            UILabel *lable = [[UILabel alloc] initWithFrame:\
                              CGRectMake(SCREEN_WIDTH / 4 + 5, 35, SCREEN_WIDTH / 4 - 10, 20)];
            
            lable.textAlignment = NSTextAlignmentLeft;
            lable.font          = [UIFont systemFontOfSize:10 weight:-0.2];
            
            lable;
        });
        
        self.genderLable = ({
        
            UILabel *lable = [[UILabel alloc] initWithFrame:\
                              CGRectMake(SCREEN_WIDTH / 4 + 5, 40, SCREEN_WIDTH / 4 - 10, 20)];
            
            lable.textAlignment = NSTextAlignmentLeft;
            lable.font          = [UIFont systemFontOfSize:10 weight:-0.2];
            
            lable;
        });
        
        self.hujiLable = ({
        
            UILabel *lable = [[UILabel alloc] initWithFrame:\
                              CGRectMake(SCREEN_WIDTH / 4 + 5, 60, SCREEN_WIDTH / 4 - 10, 25)];
            
            lable.textAlignment = NSTextAlignmentLeft;
            lable.font          = [UIFont systemFontOfSize:10 weight:-0.2];
            lable.numberOfLines = 0;
            
            lable;
        });
        
        //将控件添加到界面
        [self addSubview:self.imageView];
        [self addSubview:self.titleLable];
        //[self addSubview:self.nameLable];
        [self addSubview:self.genderLable];
        [self addSubview:self.hujiLable];
        
        //设置背景颜色
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    
    return self;
}

- (void)configureCellWithModel:(id)model {
    
    //设置imageView图片
    NSURL *imgURL = [NSURL URLWithString:[model valueForKey:@"CoverImagePath"]];
    [self.imageView sd_setImageWithURL:imgURL
                      placeholderImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    
    //设置lable
    self.titleLable.text  = [model valueForKey:@"Name"];
    self.nameLable.text   = [NSString stringWithFormat:@"姓名: %@", [model valueForKey:@"Name"]];
    self.genderLable.text = [NSString stringWithFormat:@"性别: %@", [model valueForKey:@"Gender"]];
    self.hujiLable.text   = [NSString stringWithFormat:@"户籍: %@", [model valueForKey:@"HuJi"]];
}

@end
