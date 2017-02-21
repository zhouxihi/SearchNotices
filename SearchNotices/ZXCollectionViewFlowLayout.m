//
//  ZXCollectionViewFlowLayout.m
//  SearchNotices
//
//  Created by Jackey on 2017/2/1.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import "ZXCollectionViewFlowLayout.h"

@implementation ZXCollectionViewFlowLayout

//重新调整布局, 消除系统默认间隙
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    for(int i = 1; i < [attributes count]; ++i) {
        
        //当前attributes
        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
        
        //获取当前attributes的indexpath
        NSIndexPath *indexPath = [currentLayoutAttributes valueForKey:@"indexPath"];
        
        //只有在section为0, 即是主分类section时设置默认间距为0
        if (indexPath.section == 0) {
            
            //上一个attributes
            UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];
            
            //我们想设置的最大间距，可根据需要改
            NSInteger maximumSpacing = 0;
            
            //前一个cell的最右边
            NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
            
            //如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，
            //我们改变当前cell的原点位置
            //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有cell的x值都被加到第一行最后
            //一个元素的后面了
            
            if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width <
               self.collectionViewContentSize.width) {
                
                CGRect frame                  = currentLayoutAttributes.frame;
                frame.origin.x                = origin + maximumSpacing;
                currentLayoutAttributes.frame = frame;
            }
            
            if (indexPath.row > 4) {
                
                CGRect frame                  = currentLayoutAttributes.frame;
                frame.origin.y                = currentLayoutAttributes.frame.size.height + SCREEN_HEIGHT / 4.5 - 0.14;
                currentLayoutAttributes.frame = frame;
            }
            

        }
    }
    
//    for (UICollectionViewLayoutAttributes *attr in attributes) {
//        NSLog(@"%@", NSStringFromCGRect([attr frame]));
//    }
//    
    return attributes;
}



@end
