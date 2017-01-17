//
//  MapViewController.h
//  SearchNotices
//
//  Created by Jackey on 2016/12/18.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController

@property (nonatomic, assign) double    latitude;
@property (nonatomic, assign) double    longitude;
@property (nonatomic, copy)   NSString *locateInfo;

/**
 初始化方法

 @param latitude 经度
 @param longitude 纬度
 @return 返回实例对象
 */
- (id)initWithLatitude:(double)latitude
             Longitude:(double)longitude
          LocationInfo:(NSString *)locationInfo;
@end
