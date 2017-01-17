//
//  MBTableViewCell.m
//  SearchNotices
//
//  Created by Jackey on 2016/12/18.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "MBTableViewCell.h"

@implementation MBTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //创建各个控件
        self.nameLable    = ({
            
            UILabel *lable      = [[UILabel alloc] initWithFrame:\
                                   CGRectMake(10, 5, SCREEN_WIDTH - 20, 25)];
            
            lable.textAlignment = NSTextAlignmentLeft;
            lable.font          = [UIFont systemFontOfSize:12];
            lable;
        });
        
        self.timeLable    = ({
            
            UILabel *lable      = [[UILabel alloc] initWithFrame:\
                                   CGRectMake(10, 30, SCREEN_WIDTH - 20, 20)];
            
            lable.textAlignment = NSTextAlignmentLeft;
            lable.font          = [UIFont systemFontOfSize:8];
            lable;
        });
        
        self.messageText = ({
            
            UITextView *textView            = [[UITextView alloc] initWithFrame:\
                                               CGRectMake(10, 50, SCREEN_WIDTH - 40, 25)];
            
            textView.selectable             = NO;
            textView.editable               = NO;
            textView.userInteractionEnabled = NO;
            textView.backgroundColor        = [UIColor clearColor];
            textView;
        });
        
        //将控件添加到cell上
        [self addSubview:self.nameLable];
        [self addSubview:self.timeLable];
        [self addSubview:self.messageText];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;

}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    //调整描述信息textview的大小
    CGRect myframe         = self.messageText.frame;
    myframe.size.height    = self.messageText.contentSize.height;
    self.messageText.frame = myframe;
}

- (void)configureCellWithModel:(id)model {
    
    [super layoutSubviews];
    //设置留言名字和时间
    self.nameLable.text = [model valueForKey:@"Name"];
    self.timeLable.text = [model valueForKey:@"Time"];
    
    //设置描述信息
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing              = 3;// 字体的行间距
    paragraphStyle.paragraphSpacingBefore   = 0;
    paragraphStyle.firstLineHeadIndent      = 0;
    
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:12],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    NSString *address = [[[model valueForKey:@"Message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    //address = [[address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    
    self.messageText.attributedText = [[NSAttributedString alloc] \
                                       initWithString:address
                                           attributes:attributes];
    //调整描述信息textview的大小
    CGRect myframe         = self.messageText.frame;
    myframe.size.height    = self.messageText.contentSize.height;
    self.messageText.frame = myframe;
    

}

@end
