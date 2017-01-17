//
//  ShowPhotoDataSource.h
//  SearchNotices
//
//  Created by Jackey on 2016/12/19.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShowPhotoDataSource : NSObject <UICollectionViewDataSource>

@property (nonatomic, strong) NSArray  *imgLinkArray;
@property (nonatomic, strong) NSString *identifier;

/**
 导入外部数据
 
 @param linkArray Image地址数组
 @param identifier cell标识
 @return 返回实例
 */
- (id)initWithImageLinkArray:(NSArray *)linkArray withIdentifier:(NSString *)identifier;

/**
 根据索引返回图片地址
 
 @param indexPath 索引
 @return 返回图片地址
 */
- (id)imgLinkAtIndexPath:(NSIndexPath *)indexPath;

@end
