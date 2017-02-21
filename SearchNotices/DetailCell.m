//
//  DetailCell.m
//  SearchNotices
//
//  Created by Jackey on 2016/12/27.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "DetailCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Image.h"

@implementation DetailCell

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //初始化控件
        self.imgView = ({
        
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /6, 5, SCREEN_WIDTH / 3 * 2, SCREEN_WIDTH / 3 * 2)];
            
            img;
        });
        
        //添加控件到UI
        [self addSubview:self.imgView];
    }
    return self;
}

- (void)configureCellWithImagePath:(NSString *)path {
    
    //根据model设置imageView的图片
    NSURL *imgURL         = [NSURL URLWithString:path];
    [self.imgView           sd_setImageWithURL:imgURL
                              placeholderImage:[UIImage imageWithColor:[UIColor whiteColor]]];
}

@end
