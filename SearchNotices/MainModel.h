//
//  MainModel.h
//  SearchNotices
//
//  Created by Jackey on 2016/12/22.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainModel : NSObject

@property (nonatomic, strong) NSString *Category;
@property (nonatomic, strong) NSString *CoverImagePath;
@property (nonatomic, strong) NSArray  *DetailImagePathArray;
@property (nonatomic, strong) NSString *DetailInfo;
@property (nonatomic, strong) NSString *Gender;
@property (nonatomic, strong) NSString *HuJi;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *Number;

@end

