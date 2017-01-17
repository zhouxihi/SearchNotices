//
//  RecognizeDataSource.m
//  SearchNotices
//
//  Created by Jackey on 2016/12/16.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "RecognizeDataSource.h"
#import "RecognizeCollectionCell.h"
#import "RecognizeButtonCell.h"
//#import "RecognizeModel.h"

#define RecognizeCellCounts 4
#define BTNDICT @[@{@"ImageName": @"ditu", @"Title": @" 地图"}, \
                  @{@"ImageName": @"xiaoxi", @"Title": @"留言"}, \
                  @{@"ImageName": @"fenxiang", @"Title": @" 分享"}]

@implementation RecognizeDataSource

- (instancetype)init {
    
    return nil;
}

#pragma mark - Private Methods
- (id)initWithModel:(NSArray *)models
     cellIdentifier:(NSString *)identifier
      btnIdentifier:(NSString *)btnIdentifier {
    
    self = [super init];
    if (self) {
        
        self.models             = models;
        self.cellIdentifier     = identifier;
        self.btnIdentifer       = btnIdentifier;
    }
    
    return self;
}

- (id)modelAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.models[(NSUInteger) indexPath.section];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    return RecognizeCellCounts;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.models.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == kMainUI) {
        
        RecognizeCollectionCell *cell = [collectionView
                                         dequeueReusableCellWithReuseIdentifier:self.cellIdentifier
                                         forIndexPath:indexPath];
        
        id model = [self modelAtIndexPath:indexPath];
        [cell configWithModel:model];
        
        return cell;
    }
    
    if (indexPath.row == kMap) {
        
        RecognizeButtonCell *cell = [collectionView
                                     dequeueReusableCellWithReuseIdentifier:self.btnIdentifer
                                     forIndexPath:indexPath];
        
        [cell configWithDict:BTNDICT[kMap -1]];
        
        return cell;
    }
    
    if (indexPath.row == kMessage) {
        
        RecognizeButtonCell *cell = [collectionView
                                     dequeueReusableCellWithReuseIdentifier:self.btnIdentifer
                                     forIndexPath:indexPath];
        
        [cell configWithDict:BTNDICT[kMessage -1]];
        
        return cell;
    }
    
    if (indexPath.row == kShare) {
        
        RecognizeButtonCell *cell = [collectionView
                                     dequeueReusableCellWithReuseIdentifier:self.btnIdentifer
                                     forIndexPath:indexPath];
        
        [cell configWithDict:BTNDICT[kShare -1]];
        
        return cell;
    }
    
    return nil;
    
}


@end
