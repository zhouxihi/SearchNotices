//
//  RecognizeModel.m
//  SearchNotices
//
//  Created by Jackey on 2016/12/15.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "RecognizeModel.h"

#define TEMPHEIGHT 50 + 5 + SCREEN_WIDTH * 2 / 2.5

@implementation RecognizeModel

- (void)calculateHeight {
    
    self.Height = TEMPHEIGHT + [self textViewHeight] + 25;
}

//计算textview高度
- (CGFloat)textViewHeight {
    
    UITextView *textView                     = [[UITextView alloc] initWithFrame:\
                            CGRectMake(5, 50 + 5 + SCREEN_WIDTH * 2 / 2.5, SCREEN_WIDTH - 30, 35)];
    NSMutableParagraphStyle *paragraphStyle  = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing               = 3;// 字体的行间距
    paragraphStyle.paragraphSpacingBefore    = 0;
    paragraphStyle.firstLineHeadIndent       = 0;
    
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:12],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    textView.attributedText = [[NSAttributedString alloc] initWithString:self.InfoText
                                                              attributes:attributes];

    return textView.contentSize.height;
}

@end
