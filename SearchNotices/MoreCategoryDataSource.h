//
//  MoreCategoryDataSource.h
//  SearchNotices
//
//  Created by Jackey on 2016/12/25.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MoreCategoryDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, strong) NSArray *models;
@property (nonatomic, strong) NSString *cellIdentifier;

/**
 初始化并导入外部数据

 @param models 模型数组
 @param cellIdentifier cell标识
 @return 返回加载数据后的实例
 */
- (id)initWithModels:(NSArray *)models withIdentifier:(NSString *)cellIdentifier;

/**
 根据位置信息索引出对于的模型

 @param indexPath 位置信息
 @return 返回索引后的模型
 */
- (id)modelAtIndexPath:(NSIndexPath *)indexPath;

@end
