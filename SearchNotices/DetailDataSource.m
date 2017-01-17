//
//  DetailDataSource.m
//  SearchNotices
//
//  Created by Jackey on 2016/12/27.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "DetailDataSource.h"
#import "DetailCell.h"
#import "DetailHeader.h"

@implementation DetailDataSource

- (id)initWithImageArray:(NSArray *)imgArray
                withInfo:(NSString *)info
      withCellIdentifier:(NSString *)cellIdentifier
     withHeaderIdentifer:(NSString *)headerIdentifer {
    
    self = [super init];
    if (self) {
        
        self.imgArray        = imgArray;
        self.info            = info;
        self.cellIdentifier  = cellIdentifier;
        self.headerIdentifer = headerIdentifer;
    }
    
    return  self;
}

#pragma mark - CollectionView DataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.imgArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier
                                                                 forIndexPath:indexPath];
    
    [cell configureCellWithImagePath:[self.imgArray objectAtIndex:indexPath.row]];
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        DetailHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:self.headerIdentifer forIndexPath:indexPath];
        
        [header configureWithString:self.info];
        
        return header;
    }
    
    return nil;
}

@end
