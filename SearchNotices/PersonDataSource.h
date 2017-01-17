//
//  PersonDataSource.h
//  SearchNotices
//
//  Created by Jackey on 2017/1/2.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PersonDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, strong) NSArray  *array;
@property (nonatomic, strong) NSString *identifier;

/**
 获取外部数据

 @param array 数据数组
 @param identifier 标识
 @return 返回实例
 */
- (instancetype)initWithArray:(NSArray *)array Identifier:(NSString *)identifier;
@end
