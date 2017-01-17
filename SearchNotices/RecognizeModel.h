//
//  RecognizeModel.h
//  SearchNotices
//
//  Created by Jackey on 2016/12/15.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RecognizeModel : NSObject

@property (nonatomic, copy) NSString *City;                 //城市
@property (nonatomic, copy) NSArray  *ImageArray;           //图片地址数组
@property (nonatomic, copy) NSString *InfoText;             //描述信息
@property (nonatomic, copy) NSString *Latitude;             //纬度
@property (nonatomic, copy) NSString *Location;             //详细地址
@property (nonatomic, copy) NSString *Longitude;            //经度
@property (nonatomic, copy) NSString *Number;               //编号
@property (nonatomic, copy) NSString *PersonImagePath;      //头像图片地址
@property (nonatomic, copy) NSString *PersonName;           //用户名
@property (nonatomic, copy) NSString *Time;                 //发布时间

@property (nonatomic, assign) CGFloat  Height;             //计算出的Cell高度

- (void)calculateHeight;

@end
