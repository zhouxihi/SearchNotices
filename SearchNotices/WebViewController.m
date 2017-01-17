//
//  WebViewController.m
//  SearchNotices
//
//  Created by Jackey on 2016/12/21.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "WebViewController.h"
#import "SVProgressHUD.h"

@interface WebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView       *webView;
@property (nonatomic, strong) UIBarButtonItem *shareBarButton;

@end

@implementation WebViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //1.初始化UIWebView, 并添加到View上
    [self initView];
    
    //2.创建request, 开始加载网页
    [self initData];
    [SVProgressHUD showWithStatus:@"加载中"];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    //退出界面时强制关闭HUD
    [SVProgressHUD dismiss];
}

//创建request, 开始加载网页
- (void)initData {
    
    NSURL *url            = [NSURL URLWithString:self.strOfURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    [self.webView loadRequest:request];
}

//初始化UIWebView, 并添加到View上
- (void)initView {
    
    self.title   = self.info;
    
    self.webView = ({
    
        UIWebView *webView = [[UIWebView alloc] initWithFrame:\
                              CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        webView.delegate        = self;
        webView.scalesPageToFit = self.fit;
        
        [webView setBackgroundColor:BackColor];
        webView;
    });
    
    [self.view addSubview:self.webView];
    
    //分享按钮
    self.shareBarButton = [[UIBarButtonItem alloc] initWithTitle:@"分享"
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(shareAction)];
    self.navigationItem.rightBarButtonItem = self.shareBarButton;
    
    //初始化分享控件

}

- (void)shareAction {
        
    UIActivityViewController *activityViewController = ({
        
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                                initWithActivityItems: \
                                                @[self.info, \
                                                  [NSURL URLWithString:self.strOfURL]]
                                                applicationActivities:nil];
        
        activityVC.excludedActivityTypes = \
        @[UIActivityTypeAirDrop, UIActivityTypePrint, \
          UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList];
        
        activityVC;
    });
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark - UIWebView Delegate methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

//网页加载完后关闭HUD
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [SVProgressHUD dismiss];
}

//网页加载失败后关闭HUD
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [SVProgressHUD dismiss];
}

@end
