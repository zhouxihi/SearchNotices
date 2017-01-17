//
//  MoreCategoryTableCell.m
//  SearchNotices
//
//  Created by Jackey on 2016/12/25.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "MoreCategoryTableCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Image.h"

@implementation MoreCategoryTableCell

//初始化
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //初始化控件
        self.imgView = ({
        
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:\
                                      CGRectMake(5, 5, SCREEN_WIDTH / 5, SCREEN_WIDTH / 6)];
            
            imageView;
        });
        
        self.nameLable = ({
        
            UILabel *lable      = [[UILabel alloc] initWithFrame:\
                                   CGRectMake(SCREEN_WIDTH / 5 + 10 + 5, 10, SCREEN_WIDTH / 3, 25)];
            
            lable.textAlignment = NSTextAlignmentLeft;
            lable.font          = [UIFont systemFontOfSize:12];
            
            lable;
        });
        
        self.genderLable = ({
            
            UILabel *lable      = [[UILabel alloc] initWithFrame:\
                                    CGRectMake(SCREEN_WIDTH / 5 + 10 + 5 + SCREEN_WIDTH / 3 + 10,\
                                               10, SCREEN_WIDTH / 3, 25)];
            
            lable.textAlignment = NSTextAlignmentLeft;
            lable.font          = [UIFont systemFontOfSize:12];
            
            lable;
        });
        
        self.cityLable = ({
            
            UILabel *lable      = [[UILabel alloc] initWithFrame:\
                                   CGRectMake(SCREEN_WIDTH / 5 + 10 + 5, SCREEN_WIDTH / 6 - 25, \
                                              SCREEN_WIDTH / 3, 25)];
            
            lable.textAlignment = NSTextAlignmentLeft;
            lable.font          = [UIFont systemFontOfSize:12];
            
            lable;
        });
        
        //将控件添加到View上
        [self addSubview:self.imgView];
        [self addSubview:self.nameLable];
        [self addSubview:self.genderLable];
        [self addSubview:self.cityLable];
        
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
}

- (void)configureWithModel:(id)model {
    
    //根据model设置imageView的图片
    NSURL *imgURL         = [NSURL URLWithString:[model valueForKey:@"CoverImagePath"]];
    [self.imgView           sd_setImageWithURL:imgURL
                              placeholderImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    
    //根据Model设置姓名, 性别, 城市
    self.nameLable.text   = [NSString stringWithFormat:@"姓名:  %@", [model valueForKey:@"Name"]];
    self.genderLable.text = [NSString stringWithFormat:@"性别:  %@", [model valueForKey:@"Gender"]];
    self.cityLable.text   = [NSString stringWithFormat:@"城市:  %@", [model valueForKey:@"HuJi"]];
}

@end
