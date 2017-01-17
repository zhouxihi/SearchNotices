//
//  HomeDataSource.m
//  SearchNotices
//
//  Created by Jackey on 2016/12/22.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "HomeDataSource.h"
#import "CategoryCell.h"
#import "HomeCell.h"
#import "HomeHeaderView.h"

static NSString * const SDCHeaderIdentifer = @"SDCHeaderIdentifer";

@interface HomeDataSource() 

@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, strong) NSArray *headerArray;

@end

@implementation HomeDataSource

//初始化, 获取外部数据
- (id)initWithModels:(NSArray *)models
        CategoryCellIdentifer:(NSString *)categoryCellIdentifier
        HomeCellIdentifer:(NSString *)homeCellIdentifer
        HomeHeaderIdentifer:(NSString *)homeHeaderIdentifer {
    
    self = [super init];
    
    if (self) {
        
        self.models                 = models;
        self.categoryCellIdentifier = categoryCellIdentifier;
        self.homeCellIdentifer      = homeCellIdentifer;
        self.homeHeaderIdentifier   = homeHeaderIdentifer;
        
        [self initCategoryArray];
        [self initHeaderArray];
    }
    
    return self;
}

//初始化分类数组
- (void)initCategoryArray {
    
    self.categoryArray = @[@{@"ImageName": @"bao.png", @"Title": @"离家出走"},
                           @{@"ImageName": @"bei.png", @"Title": @"被拐被骗"},
                           @{@"ImageName": @"kuai.png", @"Title": @"迷路走失"},
                           @{@"ImageName": @"hui.png", @"Title": @"不明原因"},
                           @{@"ImageName": @"jia.png", @"Title": @"儿女寻家"},
                           @{@"ImageName": @"ba.png", @"Title": @"新闻中心"},
                           @{@"ImageName": @"ma.png", @"Title": @"防拐防骗"},
                           @{@"ImageName": @"zai.png", @"Title": @"协发通告"},
                           @{@"ImageName": @"deng.png", @"Title": @"本站公告"},
                           @{@"ImageName": @"ni.png", @"Title": @"如何发布"}];
}

//初始化Header数组
- (void)initHeaderArray {
    
    self.headerArray = @[@{@"Title": @"特别寻人"},
                         @{@"Title": @"离家出走"},
                         @{@"Title": @"被拐被骗"},
                         @{@"Title": @"迷路走失"},
                         @{@"Title": @"不明原因"},
                         @{@"Title": @"儿女寻家"}];
}

//获取模型
- (id)modelAtIndexPath:(NSIndexPath *)indexPath {
    
    return [[self.models objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
}

- (void)click:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(headerDidClickedWithCategoryType:)]) {
        
        [self.delegate headerDidClickedWithCategoryType:sender.tag];
    }
}

#pragma mark - CollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    if (section == kMainCategory) {
        
        return self.categoryArray.count;
    }
    
    else {
        
        return [[self.models objectAtIndex: (section - 1)] count];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.models.count + 1;
}

//设置Cell
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == kMainCategory) {
        
        CategoryCell *cell = [collectionView \
                              dequeueReusableCellWithReuseIdentifier:self.categoryCellIdentifier
                                                        forIndexPath:indexPath];
        
        [cell configureCellWithDict:[self.categoryArray objectAtIndex:indexPath.row]];
        
        return cell;
    }
    
    else {
        
        HomeCell *cell = [collectionView \
                          dequeueReusableCellWithReuseIdentifier:self.homeCellIdentifer
                                                    forIndexPath:indexPath];
        
        [cell configureCellWithModel:\
           [[self.models objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row]];
        
        return cell;
    }
}

//设置Header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        if (indexPath.section) {
            
            HomeHeaderView *header = \
            [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                               withReuseIdentifier:self.homeHeaderIdentifier
                                                      forIndexPath:indexPath];
            
            [header configureWithDict:[self.headerArray objectAtIndex:(indexPath.section - 1)]];
            
            if (indexPath.section == kTeBieXunRen) {
                
                [header.moreBtn setHidden:YES];
            } else {
                
                [header.moreBtn setHidden:NO];
            }
            
            [header.moreBtn addTarget:self action:@selector(click:)
                     forControlEvents:UIControlEventTouchUpInside];
            [header.moreBtn setTag:indexPath.section];
            return header;
        } else {
            
            SDCHeader *header = \
            [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                               withReuseIdentifier:SDCHeaderIdentifer
                                                      forIndexPath:indexPath];
            header.delegate = self.delegate;
            
            return header;
        }
    }
    
    return nil;
}

@end
