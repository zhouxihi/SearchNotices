//
//  DetailCell.h
//  SearchNotices
//
//  Created by Jackey on 2016/12/27.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;     //ImageView显示图片

/**
 根据模型设置cell

 @param path 图片地址
 */
- (void)configureCellWithImagePath:(NSString *)path;

@end
