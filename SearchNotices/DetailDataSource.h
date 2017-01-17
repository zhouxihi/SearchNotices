//
//  DetailDataSource.h
//  SearchNotices
//
//  Created by Jackey on 2016/12/27.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DetailDataSource : NSObject<UICollectionViewDataSource>

@property (nonatomic, strong) NSArray  *imgArray;            //图片地址数组
@property (nonatomic, strong) NSString *info;                //描述信息
@property (nonatomic, strong) NSString *cellIdentifier;      //cell标识
@property (nonatomic, strong) NSString *headerIdentifer;     //header标识

/**
 获取外部数据

 @param imgArray 图片地址数组
 @param cellIdentifier cell标识
 @param headerIdentifer header标识
 @return 返回获取数据的实例对象
 */
- (id)initWithImageArray:(NSArray *)imgArray
                withInfo:(NSString *)info
      withCellIdentifier:(NSString *)cellIdentifier
     withHeaderIdentifer:(NSString *)headerIdentifer;

@end
