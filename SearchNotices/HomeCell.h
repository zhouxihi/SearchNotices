//
//  HomeCell.h
//  SearchNotices
//
//  Created by Jackey on 2016/12/21.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;       //显示图片
@property (nonatomic, strong) UILabel     *titleLable;      //大写显示Name
@property (nonatomic, strong) UILabel     *nameLable;       //姓名标签
@property (nonatomic, strong) UILabel     *genderLable;     //性别标签
@property (nonatomic, strong) UILabel     *hujiLable;       //户籍标签

/**
 配置Cell信息

 @param model 模型
 */
- (void)configureCellWithModel:(id)model;

@end
