//
//  RecognizeCollectionCell.h
//  SearchNotices
//
//  Created by Jackey on 2016/12/15.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface RecognizeCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *personImageView;   //头像照片
@property (nonatomic, strong) UILabel     *personNameLable;   //用户名
@property (nonatomic, strong) UILabel     *timeLable;         //发布时间
@property (nonatomic, strong) UIImageView *showImageView;     //随拍图片
@property (nonatomic, strong) UITextView  *infoTextView;      //描述信息
@property (nonatomic, strong) UILabel     *locationLable;     //发布地址

/**
 设置Cell

 @param model 模型
 */
- (void)configWithModel:(id)model;
@end
