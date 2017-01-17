//
//  RecognizeButtonCell.h
//  SearchNotices
//
//  Created by Jackey on 2016/12/16.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecognizeButtonCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *btn;

/**
 设置按钮Cell

 @param dict 字典(包含图片和标题)
 */
- (void)configWithDict:(NSDictionary *)dict;
@end
