//
//  ShowPhotoDataSource.m
//  SearchNotices
//
//  Created by Jackey on 2016/12/19.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "ShowPhotoDataSource.h"
#import "ShowPhotoCollectionViewCell.h"

@implementation ShowPhotoDataSource

- (id)initWithImageLinkArray:(NSArray *)linkArray withIdentifier:(NSString *)identifier{
    
    self = [super init];
    if (self) {
        
        self.imgLinkArray = linkArray;
        self.identifier   = identifier;
    }
    
    return self;
}

- (id)imgLinkAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.imgLinkArray[indexPath.row];
}

#pragma mark - CollectionView dataSource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    return self.imgLinkArray.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ShowPhotoCollectionViewCell *cell = \
    [collectionView dequeueReusableCellWithReuseIdentifier:self.identifier
                                              forIndexPath:indexPath];
    [cell configCellWithImageLink:[self imgLinkAtIndexPath:indexPath]
                        withTitle:\
     [NSString stringWithFormat:@"%d/%d", indexPath.row + 1 , self.imgLinkArray.count]];
    
    return cell;
}


@end
