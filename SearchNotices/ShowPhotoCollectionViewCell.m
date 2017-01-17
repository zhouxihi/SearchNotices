//
//  ShowPhotoCollectionViewCell.m
//  SearchNotices
//
//  Created by Jackey on 2016/12/19.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "ShowPhotoCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Image.h"

@implementation ShowPhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //开始创建控件
        self.lable = ({
            
            UILabel *lable        = [[UILabel alloc] initWithFrame:\
                                     CGRectMake((SCREEN_WIDTH - 40) / 2, 40, 40, 25)];
            
            lable.textAlignment   = NSTextAlignmentCenter;
            lable.font            = [UIFont systemFontOfSize:12];
            lable.backgroundColor = [UIColor blackColor];
            lable.textColor       = [UIColor whiteColor];
            
            lable;
        });
        
        self.imageView = ({
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 80, SCREEN_WIDTH - 80, SCREEN_HEIGHT - 80 - 80)];
            
            imgView;
        });
        
        //添加控件到UI上
        [self addSubview:self.lable];
        [self addSubview:self.imageView];
    }
    
    return self;
}

- (void)configCellWithImageLink:(NSString *)imageLink withTitle:(NSString *)title {
    
    self.lable.text = title;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageLink]
                      placeholderImage:[UIImage imageWithColor:[UIColor whiteColor]]];
}

@end

