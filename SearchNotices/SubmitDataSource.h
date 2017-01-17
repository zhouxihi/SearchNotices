//
//  SubmitDataSource.h
//  SearchNotices
//
//  Created by Jackey on 2017/1/14.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SubmitDataSource : NSObject<UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSString       *identifer;

/**
 加载外部数据

 @param array Image数组
 @param identifer 标志
 @return 返回取得数据的实例
 */
- (id)initWithImageArray:(NSMutableArray *)array Identifer:(NSString *)identifer;

@end
