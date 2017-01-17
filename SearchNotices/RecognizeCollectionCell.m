//
//  RecognizeCollectionCell.m
//  SearchNotices
//
//  Created by Jackey on 2016/12/15.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "RecognizeCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Image.h"

@implementation RecognizeCollectionCell

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //初始化各个控件
        self.personImageView = ({
            
            UIImageView *imageView     = [[UIImageView alloc] initWithFrame:\
                                          CGRectMake(5, 8, 35, 35)];
            
            imageView;
        });
        
        self.personNameLable = ({
            
            UILabel *lable      = [[UILabel alloc] initWithFrame:\
                                   CGRectMake(45, 10, SCREEN_WIDTH - 45, 20)];
            
            lable.font          = [UIFont systemFontOfSize:12];
            lable.textAlignment = NSTextAlignmentLeft;
            
            lable;
        });
        
        self.timeLable = ({
            
            UILabel *lable      = [[UILabel alloc] initWithFrame:\
                                   CGRectMake(45, 25, SCREEN_WIDTH - 45, 20)];
            
            lable.font          = [UIFont systemFontOfSize:10];
            lable.textAlignment = NSTextAlignmentLeft;
            
            lable;
        });
        
        self.showImageView = ({
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:\
                                      CGRectMake(5, 50, SCREEN_WIDTH - 30, SCREEN_WIDTH * 2 / 2.5)];
            
            imageView;
        });
        
        self.infoTextView = ({
            
            UITextView *textView            = [[UITextView alloc] initWithFrame:\
                                    CGRectMake(5, 50 + 5 + SCREEN_WIDTH * 2 / 2.5, \
                                               SCREEN_WIDTH - 30, 35)];
            
            textView.selectable             = NO;
            textView.editable               = NO;
            textView.userInteractionEnabled = NO;
            textView;
        });
        
        self.locationLable = ({
            
            UILabel *lable      = [[UILabel alloc] initWithFrame:\
                                   CGRectMake(10, 50 + 5 + SCREEN_WIDTH * 2 / 2.5 + 30, \
                                              SCREEN_WIDTH - 30 - 15, 30)];
            
            lable.font          = [UIFont systemFontOfSize:10];
            lable.textAlignment = NSTextAlignmentLeft;
            lable.numberOfLines = 0;
            
            lable;
        });
        
        //将控件添加到Cell上
        [self addSubview:self.personImageView];
        [self addSubview:self.personNameLable];
        [self addSubview:self.timeLable];
        [self addSubview:self.showImageView];
        [self addSubview:self.infoTextView];
        [self addSubview:self.locationLable];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    //调整描述信息textview的大小
    CGRect frame            = self.infoTextView.frame;
    frame.size.height       = self.infoTextView.contentSize.height;
    self.infoTextView.frame = frame;
    
    //调整描述信息的位置
    CGRect frame2            = self.locationLable.frame;
    frame2.origin.y          = frame.origin.y + frame.size.height - 5;
    self.locationLable.frame = frame2;
}

- (void)configWithModel:(id)model {
    
    //设置头像照片
    NSURL *url = [NSURL URLWithString: [model valueForKey:@"PersonImagePath"]];
    [self.personImageView sd_setImageWithURL:url placeholderImage:\
                                                    [UIImage imageWithColor:[UIColor whiteColor]]];
    
    //设置用户名和发布时间
    self.personNameLable.text = [model valueForKey:@"PersonName"];
    self.timeLable.text       = [model valueForKey:@"Time"];
    
    //设置显示的随拍照片
    NSURL *url2 = [NSURL URLWithString: [model valueForKey:@"ImageArray"][0]];
    [self.showImageView sd_setImageWithURL:url2 placeholderImage:\
                                                    [UIImage imageWithColor:[UIColor whiteColor]]];
    
    //设置描述信息
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing              = 3;// 字体的行间距
    paragraphStyle.paragraphSpacingBefore   = 0;
    paragraphStyle.firstLineHeadIndent      = 0;
    
    //创建富文本
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:12],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    NSString *info                   = [model valueForKey:@"InfoText"];
    self.infoTextView.attributedText = [[NSAttributedString alloc] initWithString:info \
                                                              attributes:attributes];
    
    //调整描述信息textview的大小
    CGRect frame            = self.infoTextView.frame;
    frame.size.height       = self.infoTextView.contentSize.height;
    self.infoTextView.frame = frame;
    
    
    //设置发布地址
    NSString *locat         = [model valueForKey:@"Location"];
    self.locationLable.text = GETSTRING_WITH(@"地点: ", locat);
    
    //调整描述信息的位置
    CGRect frame2            = self.locationLable.frame;
    frame2.origin.y          = frame.origin.y + frame.size.height - 5;
    self.locationLable.frame = frame2;
    
}


@end
