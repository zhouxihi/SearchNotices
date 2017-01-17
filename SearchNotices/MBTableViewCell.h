//
//  MBTableViewCell.h
//  SearchNotices
//
//  Created by Jackey on 2016/12/18.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel    *nameLable;
@property (nonatomic, strong) UITextView *messageText;
@property (nonatomic, strong) UILabel    *timeLable;

/**
 配置cell数据

 @param model 模型
 */
- (void)configureCellWithModel:(id)model;
@end
