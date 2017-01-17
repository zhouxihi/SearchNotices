//
//  messageBoardModel.m
//  SearchNotices
//
//  Created by Jackey on 2016/12/18.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "messageBoardModel.h"

#define TEMPHEIGHT 50

@implementation messageBoardModel

- (void)calculateHeight {
    
    self.Height = TEMPHEIGHT + [self textViewHeight];
}

//计算textview高度
- (CGFloat)textViewHeight {
    
    UITextView *textView                    = [[UITextView alloc] initWithFrame:\
                            CGRectMake(10, 50, SCREEN_WIDTH - 20, 25)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing              = 3;// 字体的行间距
    paragraphStyle.paragraphSpacingBefore   = 0;
    paragraphStyle.firstLineHeadIndent      = 0;
    
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:12],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    textView.attributedText = [[NSAttributedString alloc] initWithString:self.Message
                                                              attributes:attributes];
    
    return textView.contentSize.height;
}

@end
