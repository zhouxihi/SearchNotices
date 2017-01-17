//
//  DetailHeader.m
//  SearchNotices
//
//  Created by Jackey on 2016/12/27.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "DetailHeader.h"

@implementation DetailHeader

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.textField = ({
        
            UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH - 20, 35)];
            
            [text setBackgroundColor:[UIColor whiteColor]];
            text;
        });
        
        [self addSubview:self.textField];
    }
    
    return self;
}

- (void)configureWithString:(NSString *)str {
    
    //设置描述信息
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing              = 3;// 字体的行间距
    paragraphStyle.paragraphSpacingBefore   = 0;
    paragraphStyle.firstLineHeadIndent      = 8;
    
    //创建富文本
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:12],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    self.textField.attributedText = [[NSAttributedString alloc] initWithString:str \
                                                                       attributes:attributes];
    
    //调整描述信息textview的大小
    CGRect frame            = self.textField.frame;
    frame.size.height       = self.textField.contentSize.height;
    self.textField.frame = frame;

}

@end
