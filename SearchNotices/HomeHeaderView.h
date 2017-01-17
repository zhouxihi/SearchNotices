//
//  HomeHeaderView.h
//  SearchNotices
//
//  Created by Jackey on 2016/12/21.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeHeaderView : UICollectionReusableView

@property (nonatomic, strong) UIButton   *titleBtn;    //分类标题
@property (nonatomic, strong) UIButton  *moreBtn;       //更多

/**
 配置cell

 @param dict 字典
 */
- (void)configureWithDict:(NSDictionary *)dict;

@end
