//
//  SubmitViewController.h
//  SearchNotices
//
//  Created by Jackey on 2017/1/13.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKPSMTPMessage.h"

@interface SubmitViewController : UIViewController<SKPSMTPMessageDelegate>

@property (nonatomic, strong) NSMutableArray *imageMutableArray;

@end
