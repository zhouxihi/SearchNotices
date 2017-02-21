//
//  DetailViewController.m
//  SearchNotices
//
//  Created by Jackey on 2016/12/27.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailDataSource.h"
#import "DetailCell.h"
#import "DetailHeader.h"
#import "MessageBoardViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Image.h"

static NSString * const DetailCellIdentifer   = @"DetailCellIdentifer";
static NSString * const DetailHeaderIdentifer = @"DetailHeaderIdentifer";

@interface DetailViewController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) DetailDataSource *dataSource;
@property (nonatomic, strong) UIButton         *btn;
@property (nonatomic, strong) UIBarButtonItem  *shareBarButton;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initView];
}


//初始化UI控件
- (void)initView {
    
    [self createCollectionView];
    
    UIView *view = ({
    
        UIView *view = [[UIView alloc] initWithFrame:\
         CGRectMake(0,
                    SCREEN_HEIGHT - 40 - self.navigationController.navigationBar.frame.size.height - 20,
                    SCREEN_WIDTH,
                    40)];
        
        view.backgroundColor = BackColor;
        view;
    });
    
    [self.view addSubview:view];
    
    //留言按钮
    self.btn = ({
    
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        
        button.frame     = \
        CGRectMake(10,
                   SCREEN_HEIGHT - 35 - self.navigationController.navigationBar.frame.size.height - 20,
                   SCREEN_WIDTH - 20,
                   30);
        
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitle:@"留言板" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"xiaoxi"] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5.0f;
        
        [button addTarget:self
                   action:@selector(buttonDidClicked)
         forControlEvents:UIControlEventTouchUpInside];
        
        button;
    });
    
    [self.view addSubview:self.btn];
    
    
    //分享按钮
    self.shareBarButton = [[UIBarButtonItem alloc] initWithTitle:@"分享"
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(shareAction)];
    self.navigationItem.rightBarButtonItem = self.shareBarButton;
    
    //解决TabBar遮挡
    self.edgesForExtendedLayout               = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myCollectionView.autoresizingMask    = \
        UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

- (void)createCollectionView {
    
    //创建datasource
    self.dataSource = ({
    
        DetailDataSource *dataSource = \
        [[DetailDataSource alloc] initWithImageArray:self.imgArray
                                            withInfo:self.info
                                  withCellIdentifier:DetailCellIdentifer
                                 withHeaderIdentifer:DetailHeaderIdentifer];
        
        dataSource;
    });
    
    //创建CollectionView
    self.myCollectionView = ({
    
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        UICollectionView *collection = \
        [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 35)
                           collectionViewLayout:layout];
        
        collection.dataSource      = self.dataSource;
        collection.delegate        = self;
        collection.backgroundColor = [UIColor whiteColor];
        collection.contentInset    = UIEdgeInsetsMake(0, 0, 20, 0);
        
        [collection registerClass:[DetailCell class] forCellWithReuseIdentifier:DetailCellIdentifer];
        [collection registerClass:[DetailHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DetailHeaderIdentifer];
        
        collection;
    });
    
    [self.view addSubview:self.myCollectionView];
}

- (void)buttonDidClicked {
    
    MessageBoardViewController *MBVC = [[MessageBoardViewController alloc] init];
    MBVC.number = self.number;
    
    [self.navigationController pushViewController:MBVC animated:YES];
}

- (void)shareAction {
    
    UIImageView *imageView = ({
        
        
        UIImageView *imgView = [[UIImageView alloc] init];
        [imgView sd_setImageWithURL:[NSURL URLWithString:self.imgArray[0]]
                   placeholderImage:[UIImage imageWithColor:[UIColor whiteColor]]];
        
        imgView;
    });
    
    UIActivityViewController *activityViewController = ({
        
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                                initWithActivityItems: \
                                                @[self.info, \
                                                  [NSURL URLWithString:APPLINK], \
                                                  imageView.image]
                                                applicationActivities:nil];
        
        activityVC.excludedActivityTypes = \
        @[UIActivityTypeAirDrop, UIActivityTypePrint, \
          UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList];
        
        activityVC;
    });
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

//计算textview高度
- (CGSize)textViewSize {
    
    UITextView *textView                     = [[UITextView alloc] initWithFrame:\
                                                CGRectMake(10, 20, SCREEN_WIDTH - 20, 35)];
    NSMutableParagraphStyle *paragraphStyle  = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing               = 3;// 字体的行间距
    paragraphStyle.paragraphSpacingBefore    = 0;
    paragraphStyle.firstLineHeadIndent       = 0;
    
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:12],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    textView.attributedText = [[NSAttributedString alloc] initWithString:self.info
                                                              attributes:attributes];
    
    return textView.contentSize;
}

#pragma mark - CollectionView FlowLayoutDelegate methods

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH / 3 * 2 + 20);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 20;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    return [self textViewSize];
}

@end
