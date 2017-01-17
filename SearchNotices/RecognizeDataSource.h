//
//  RecognizeDataSource.h
//  SearchNotices
//
//  Created by Jackey on 2016/12/16.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kMainUI = 0,
    kMap,
    kMessage,
    kShare
} kRecognize;

@interface RecognizeDataSource : NSObject <UICollectionViewDataSource>

@property (nonatomic, strong) NSArray  *models;                 //models数组
@property (nonatomic, copy)   NSString *cellIdentifier;         //cell标识
@property (nonatomic, copy)   NSString *btnIdentifer;           //btn标识
//@property (nonatomic, strong) id<RecognizeButtonDelegate> delegate;

/**
 将外部数据导入内部

 @param models 模型数组
 @param identifier MainCell标识
 @param btnIdentifier btn标识
 @return 返回dataSource
 */
- (id)initWithModel:(NSArray *)models
     cellIdentifier:(NSString *)identifier
      btnIdentifier: (NSString *)btnIdentifier;


/**
 根据索引返回对应的模型

 @param indexPath cel位置
 @return 返回索引后的模型
 */
- (id)modelAtIndexPath:(NSIndexPath *)indexPath;

@end
