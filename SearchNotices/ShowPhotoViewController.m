//
//  ShowPhotoViewController.m
//  SearchNotices
//
//  Created by Jackey on 2016/12/19.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "ShowPhotoViewController.h"
#import "ShowPhotoDataSource.h"
#import "ShowPhotoCollectionViewCell.h"
#import "PhotoFlowLayout.h"

static NSString * const PHOTOCELLIDENTIFIER = @"CellIdentiferPhoto";

@interface ShowPhotoViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) ShowPhotoDataSource  *dataSource;

@end

@implementation ShowPhotoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //开始创建并显示界面
    [self initView];
}

//初始化界面
- (void)initView {
    
    [self createCollectionView];
}

//创建CollectionView
- (void)createCollectionView {
    
    //创建DataSource
    self.dataSource = ({
        
        ShowPhotoDataSource *dataSource = [[ShowPhotoDataSource alloc] \
                                       initWithImageLinkArray:self.imglinkArray
                                       withIdentifier:PHOTOCELLIDENTIFIER];
        
        dataSource;
    });
    
    //创建CollectionView
    self.myCollectionView = ({
        
        PhotoFlowLayout *layout = [[PhotoFlowLayout alloc] init];
        layout.itemSize                    = CGSizeMake(SCREEN_WIDTH - 80, SCREEN_HEIGHT - 60);
        //layout.minimumLineSpacing          = 0.;
        //layout.footerReferenceSize         = CGSizeMake(80, SCREEN_HEIGHT - 60);
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        UICollectionView *collection       = [[UICollectionView alloc] initWithFrame:\
                                              CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
        
        [collection registerClass:[ShowPhotoCollectionViewCell class]
       forCellWithReuseIdentifier:PHOTOCELLIDENTIFIER];
        
        collection.showsHorizontalScrollIndicator = NO;
        collection.dataSource                     = self.dataSource;
        collection.delegate                       = self;
        
        collection;
    });
    
    //添加到主界面
    [self.view addSubview:self.myCollectionView];
}

#pragma mark - UICollectionView Delegate Methods
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
