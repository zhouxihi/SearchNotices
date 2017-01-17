//
//  SNType.h
//  SearchNotices
//
//  Created by Jackey on 2017/1/9.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kMainMesage = 0,
    kXingWen,
    kFangGuai,
    kXieFa,
    kBenZhan,
} KMessageType;

typedef enum : NSUInteger {
    kMainCategory = 0,
    kTeBieXunRen,
    kLiJiaChuZou,
    kBeiGuaiBeiPian,
    kMiLuZouShi,
    kBuMingYuanYin,
    kErNvXunJia
} CategoryType;
