//
//  PhotoFlowLayout.m
//  SearchNotices
//
//  Created by Jackey on 2017/2/4.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import "PhotoFlowLayout.h"

@implementation PhotoFlowLayout
- (void)prepareLayout
{
    [super prepareLayout];
         //水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    //CGFloat margin = (self.collectionView.frame.size.width - self.itemSize.width) / 2;
    //self.collectionView.contentInset = UIEdgeInsetsMake(0, margin, 0, margin);
}

 /**
    20  * 当collectionView的显示范围发生改变的时候，是否需要重新刷新布局
    21  * 一旦重新刷新布局，就会重新调用下面的方法：
    22  * 1.prepareLayout
    23  * 2.layoutAttributesForElementsInRect:方法
    24  */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
 {
    return YES;
 }

/**
    32  * 这个方法的返回值是一个数组（数组里面存放着rect范围内所有元素的布局属性）
    33  * 这个方法的返回值决定了rect范围内所有元素的排布（frame）
    34  */
//需要在viewController中使用上ZWLineLayout这个类后才能重写这个方法！！
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //让父类布局好样式
     NSArray *arr = [super layoutAttributesForElementsInRect:rect];
    //计算出collectionView的中心的位置
   CGFloat ceterX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;

    /**
            43      * 1.一个cell对应一个UICollectionViewLayoutAttributes对象
            44      * 2.UICollectionViewLayoutAttributes对象决定了cell的frame
            45      */
    for (UICollectionViewLayoutAttributes *attributes in arr) {
         //cell的中心点距离collectionView的中心点的距离，注意ABS()表示绝对值
       CGFloat delta = ABS(attributes.center.x - ceterX);
        //设置缩放比例
         CGFloat scale = 1.1 - delta / self.collectionView.frame.size.width * 2;
        //设置cell滚动时候缩放的比例
        attributes.transform = CGAffineTransformMakeScale(scale, scale);
    }

   return arr;
}

/**
    59  * 这个方法的返回值，就决定了collectionView停止滚动时的偏移量
    60  */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
 {
    // 计算出最终显示的矩形框
     CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;

    //获得super已经计算好的布局的属性
     NSMutableArray *arr = [[super layoutAttributesForElementsInRect:rect] mutableCopy];

    //计算collectionView最中心点的x值
    //CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
     CGFloat centerX = self.collectionView.frame.size.width * 0.5;

   CGFloat minDelta = MAXFLOAT;
   for (UICollectionViewLayoutAttributes *attrs in arr) {
       if (ABS(minDelta) > ABS(attrs.center.x - centerX)) {
            minDelta = attrs.center.x - centerX;
      }
   }
   proposedContentOffset.x += minDelta;
    return proposedContentOffset;
}

@end
