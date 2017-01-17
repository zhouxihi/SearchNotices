//
//  CategoryCell.h
//  SearchNotices
//
//  Created by Jackey on 2016/12/21.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;   //显示分类图片
@property (nonatomic, strong) UILabel     *lable;       //显示分类字符

/**
 配置Cell属性

 @param dict 带有分类信息的字典
 */
- (void)configureCellWithDict:(NSDictionary *)dict;

@end
