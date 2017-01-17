//
//  selectedImageCell.m
//  SearchNotices
//
//  Created by Jackey on 2017/1/14.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import "selectedImageCell.h"

@implementation selectedImageCell

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.imgView = [[UIImageView alloc] initWithFrame:\
                        CGRectMake(0, 0, (SCREEN_WIDTH - 40) / 5, (SCREEN_WIDTH - 40) / 5)];
        
        [self addSubview:self.imgView];
    }
    
    return self;
}

- (void)configureWithImage:(UIImage *)image {
    
    self.imgView.image = image;
}

@end
