//
//  MBDataSource.h
//  SearchNotices
//
//  Created by Jackey on 2016/12/18.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MBDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSArray  *models;           //模型数组
@property (nonatomic, copy)   NSString *identifier;       //cell标识

/**
 初始化方法, 将外部数据加载进来

 @param models 模型数组
 @param identifier 标识
 @return 返回实例对象
 */
- (id)initWithModels:(NSArray *)models Identifier:(NSString *)identifier;

/**
 根据索引返回模型

 @param indexPath 索引位置
 @return 返回索引后的模型
 */
- (id)modelAtIndexPath:(NSIndexPath *)indexPath;

@end
