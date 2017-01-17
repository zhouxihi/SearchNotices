//
//  SDCHeader.m
//  SearchNotices
//
//  Created by Jackey on 2017/1/11.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import "SDCHeader.h"

@interface SDCHeader()<SDCycleScrollViewDelegate>

@end

@implementation SDCHeader

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.sdcycleView = ({
        
            SDCycleScrollView *view = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
            view.localizationImageNamesGroup = @[[UIImage imageNamed:@"quanguodaguaipingtai"],
                                                 [UIImage imageNamed:@"guaiangaofa"],
                                                 [UIImage imageNamed:@"gonggao"]];;
            view.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
            view.currentPageDotColor = [UIColor whiteColor];
            view.pageDotColor = [UIColor grayColor];
            view.delegate = self;
            
            view;
        });
        
        [self addSubview:self.sdcycleView];
    }
    
    return self;
}

#pragma mark - SDCycleScrollViewDelegate Methods
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    LRLog(@"点了SDC");
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        LRLog(@"开始传递");
        [self.delegate cycleScrollView:cycleScrollView didSelectItemAtIndex:index];
    }
}

@end
