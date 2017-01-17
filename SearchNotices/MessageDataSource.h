//
//  MessageDataSource.h
//  SearchNotices
//
//  Created by Jackey on 2016/12/20.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MessageDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSArray  *models;         //模型数组
@property (nonatomic, strong) NSString *identifier;     //cell标识

/**
 导入外部数据

 @param models 模型数组
 @param identifer cell标识
 @return 返回取得数据后的实例
 */
- (id)initWithModels:(NSArray *)models withIdentifier:(NSString *)identifer;

/**
 根据索引取得model

 @param indexPath 索引
 @return 返回索引后的摩西
 */
- (id)modelAtIndexPath:(NSIndexPath *)indexPath;

@end
