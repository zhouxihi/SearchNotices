//
//  HomeDataSource.h
//  SearchNotices
//
//  Created by Jackey on 2016/12/22.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SNType.h"
#import "SDCHeader.h"

@class HomeDataSource;

@protocol HomeHeaderProtocol <NSObject>

- (void)headerDidClickedWithCategoryType:(CategoryType)type;

@end



@interface HomeDataSource : NSObject <UICollectionViewDataSource>

@property (nonatomic, strong) NSArray  *models;                     //模型数组
@property (nonatomic, strong) NSString *categoryCellIdentifier;     //分类Cell标识
@property (nonatomic, strong) NSString *homeCellIdentifer;          //HomeCell分类标识
@property (nonatomic, strong) NSString *homeHeaderIdentifier;       //homeCellHeader标识

@property (nonatomic, strong) id<HomeHeaderProtocol, SDCycleScrollViewDelegate> delegate;

/**
 导入外部数据

 @param models 模型数组
 @param categoryCellIdentifier CategoryCell标识
 @param homeCellIdentifer HomeCell标识
 @param homeHeaderIdentifer HomeCell头标识
 @return 返回实例
 */
- (id)initWithModels:(NSArray *)models
        CategoryCellIdentifer:(NSString *)categoryCellIdentifier
        HomeCellIdentifer:(NSString *)homeCellIdentifer
        HomeHeaderIdentifer:(NSString *)homeHeaderIdentifer;


/**
 根据索引查询相应的模型

 @param indexPath 索引
 @return 返回索引后的模型
 */
- (id)modelAtIndexPath:(NSIndexPath *)indexPath;
@end
