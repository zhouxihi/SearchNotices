//
//  selectedImageCell.h
//  SearchNotices
//
//  Created by Jackey on 2017/1/14.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface selectedImageCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;

/**
 设置cell

 @param image UIImage对象
 */
- (void)configureWithImage:(UIImage *)image;

@end
