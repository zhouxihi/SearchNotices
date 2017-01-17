//
//  SubmitDataSource.m
//  SearchNotices
//
//  Created by Jackey on 2017/1/14.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import "SubmitDataSource.h"
#import "selectedImageCell.h"

@implementation SubmitDataSource

- (id)initWithImageArray:(NSMutableArray *)array Identifer:(NSString *)identifer {
    
    self = [super init];
    if (self) {
        
        self.array     = array;
        self.identifer = identifer;
        LRLog(@"照片个数: %d", self.array.count);
    }
    
    return self;
}

#pragma mark - CollectionDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    if (self.array.count < 5) {
        
        return self.array.count + 1;
    } else return 5;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.identifer
                                                                        forIndexPath:indexPath];
    if (self.array.count < 5) {
        
        if (indexPath.row == self.array.count) {
            
            [cell configureWithImage:[UIImage imageNamed:@"添加.png"]];
        } else {
            
            [cell configureWithImage:self.array[indexPath.row]];
        }
    } else {
        
        [cell configureWithImage:self.array[indexPath.row]];
    }
    
    return cell;
}

@end
