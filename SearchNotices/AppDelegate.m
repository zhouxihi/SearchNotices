//
//  AppDelegate.m
//  ZXTabBarController
//
//  Created by Jackey on 2016/12/14.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import <Bugly/Bugly.h>
#import <CoreLocation/CoreLocation.h>

#import "AppDelegate.h"
#import "ZXTabBarController.h"
#import <SMS_SDK/SMSSDK.h>
#import "IQKeyboardManager.h"
#import "SubmitViewController.h"
#import "SNManager.h"
#import "SVProgressHUD.h"
#import "WelcomeView.h"
#import "PlusViewController.h"

@interface AppDelegate ()<ZXTabBarDelegate>

@property (nonatomic, strong) ZXTabBarController *zxTabBarVC;
@property (nonatomic, strong) CLLocationManager  *locationManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //注册SMSSDK
    [SMSSDK registerApp:@"1784069339db1"
             withSecret:@"27fc388c830b08403a5d63d51ee50673"];
    
    //注册Bugly
    [Bugly startWithAppId:@"900057465"];
    
    //获取定位功能
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestWhenInUseAuthorization];
    
    //设置Keyboard
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable             = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    
    //设置RootWindow
    self.zxTabBarVC= [[ZXTabBarController alloc] init];
    self.zxTabBarVC.delegate = self;
    self.window.rootViewController = self.zxTabBarVC;
    
    //初始化动画UI
    WelcomeView *welcomeView = [[WelcomeView alloc] initWithFrame:self.window.bounds];
    [welcomeView setBackgroundColor:[UIColor whiteColor]];
    welcomeView.alpha = 1;
    [self.window addSubview:welcomeView];
    self.window.rootViewController.view.alpha = 0;
    
    //加载动画
    [UIView animateWithDuration:0.5
                          delay:5
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
        
                         self.window.rootViewController.view.alpha = 1;
                         welcomeView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
        
                         [welcomeView removeFromSuperview];
                         
                     }];
    

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - ZXTabBarDelegate method

- (void)tabBarDidClickPlusButton:(ZXTabBar *)tabBar {
    
    if ([zx_SN loginStatus]) {
    
        LRLog(@"开始");
        SubmitViewController *subVC = [[SubmitViewController alloc] init];
        NSInteger num = [self.zxTabBarVC selectedIndex];
        [self.zxTabBarVC.childViewControllers[num] pushViewController:subVC
                                                            animated:YES];

    } else {
        
        [SVProgressHUD showInfoWithStatus:@"请先登录"];
        [SVProgressHUD dismissWithDelay:1];
    }
}

@end
