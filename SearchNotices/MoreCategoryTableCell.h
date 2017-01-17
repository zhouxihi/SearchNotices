//
//  MoreCategoryTableCell.h
//  SearchNotices
//
//  Created by Jackey on 2016/12/25.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreCategoryTableCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;         //加载图片
@property (nonatomic, strong) UILabel     *nameLable;       //姓名
@property (nonatomic, strong) UILabel     *genderLable;     //性别
@property (nonatomic, strong) UILabel     *cityLable;       //城市

/**
 根据模型设置cell

 @param model 模型
 */
- (void)configureWithModel:(id)model;

@end
