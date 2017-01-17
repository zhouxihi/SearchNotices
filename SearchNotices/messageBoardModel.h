//
//  messageBoardModel.h
//  SearchNotices
//
//  Created by Jackey on 2016/12/18.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface messageBoardModel : NSObject

@property (nonatomic, copy) NSString *Message;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Number;
@property (nonatomic, copy) NSString *Time;

@property (nonatomic, assign) CGFloat  Height;             //计算出的Cell高度

/**
 计算cell高度
 */
- (void)calculateHeight;

@end
