//
//  SDCHeader.h
//  SearchNotices
//
//  Created by Jackey on 2017/1/11.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@interface SDCHeader : UICollectionReusableView

@property (nonatomic, strong) SDCycleScrollView                 *sdcycleView;
@property (nonatomic, weak)   id<SDCycleScrollViewDelegate>      delegate;

@end
