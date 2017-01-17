//
//  PlusView.h
//  SearchNotices
//
//  Created by Jackey on 2017/1/8.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlusView : UIView

@property (nonatomic, strong) UIView    *actionView;
@property (nonatomic, strong) UIView    *cameraView;
@property (nonatomic, strong) UIView    *photoView;
@property (nonatomic, strong) UIView    *describeView;
@property (nonatomic, assign) CGFloat    radius;

/**
 创建单例

 @return 返回单例对象
 */
+ (instancetype)shareInstance;

@end
