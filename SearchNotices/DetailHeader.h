//
//  DetailHeader.h
//  SearchNotices
//
//  Created by Jackey on 2016/12/27.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailHeader : UICollectionReusableView

@property (nonatomic, strong) UITextView *textField;

/**
 设置header详细信息

 @param str 详细信息
 */
- (void)configureWithString:(NSString *)str;

@end
