//
//  ShowPhotoCollectionViewCell.h
//  SearchNotices
//
//  Created by Jackey on 2016/12/19.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel     *lable;
@property (nonatomic, strong) UIImageView *imageView;

/**
 配置Cell方法
 
 @param imageLink 图片地址
 @param title 标题
 */
- (void)configCellWithImageLink:(NSString *)imageLink withTitle:(NSString *)title;
@end
