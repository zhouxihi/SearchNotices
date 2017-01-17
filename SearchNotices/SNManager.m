//
//  SNManager.m
//  SearchNotices
//
//  Created by Jackey on 2016/12/24.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "SNManager.h"
#import "AFNetworking.h"
#import <SMS_SDK/SMSSDK.h>

#define ACCOUNTARCHIVEPATH [NSTemporaryDirectory() stringByAppendingPathComponent:@"account.archive"]
#define LOGINARCHIVEPATH   [NSTemporaryDirectory() stringByAppendingPathComponent:@"loginStatus.archive"]

@interface SNManager()

@property (nonatomic, strong) AFHTTPSessionManager *afnManager;

@end

@implementation SNManager

static SNManager *_instance = nil;

+ (instancetype)shareInstance {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance             = [[super allocWithZone:NULL] init];
        _instance.loginStatus = NO;
        _instance.account     = @"";
        
        [_instance unArchiveAccount];

        _instance.afnManager  = ({
        
            AFHTTPSessionManager *manager           = [AFHTTPSessionManager manager];
            AFSecurityPolicy *securityPolicy        = \
            [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
            
            securityPolicy.allowInvalidCertificates = YES;
            manager.securityPolicy                  = securityPolicy;
            
            manager;

        });
        

    });
    
    return _instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    
    return [SNManager shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    
    return [SNManager shareInstance];
}

- (void)registerWithAccount:(NSString *)account
                   Password:(NSString *)password
                    Success:(Success)success
                       Fail:(Fail)fail {
    
    NSString *str = [RegisterStringWithoutUserNameAndPassword stringByAppendingString:\
                     [NSString stringWithFormat:@"%@/%@", account, password]];
    
    [self.afnManager POST:str
               parameters:nil
                 progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
                      if ([[(NSDictionary *)responseObject objectForKey:@"Result"]\
                                isEqualToString:@"Success"]) {
            
                          self.account     = account;
                          self.loginStatus = YES;
                          [self archiveAccount];
                          success(@"Success");
        
                      } else {
            
                          fail(@"Repeat");
                      }
                  }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
                      fail(@"Network Error");
                  }];
}

- (void)getPhoneCodeWithPhoneNumer:(NSString *)number Success:(Success)success Fail:(Fail)fail {
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                            phoneNumber:number
                                   zone:@"86"
                       customIdentifier:nil
                                 result:^(NSError *error) {
        
                                     LRLog(@"Error: %@", error);
                                     LRLog(@"Error code: %ld", error.code);
                                     if (!error) {
            
                                         success(@"Success");
        
                                     } else {
            
                                         if (error.code == 477) {
                                             
                                             fail(@"outOfTimes");
                                         } else {
                                             
                                             fail(@"Fail");
                                         }
                                     }
                                 }];
}

- (void)verifyPhoneCode:(NSString *)code
            PhoneNumber:(NSString *)number
                Success:(Success)success
                   Fail:(Fail)fail {
    
    [SMSSDK commitVerificationCode:code
                       phoneNumber:number
                              zone:@"86"
                            result:^(SMSSDKUserInfo *userInfo, NSError *error) {
        
                                LRLog(@"Error: %@", error);
                                if (!error) {
            
                                    success(@"True");
                                } else {
            
                                    fail(@"False");
                                }
                            }];
}

- (void)loginWithAccount:(NSString *)account
                Password:(NSString *)password
                 Success:(Success)success
                    Fail:(Fail)fail {
    
    LRWeakSelf(self)
    [self.afnManager POST:[LonginStringWithoutUserNameAndPassword stringByAppendingString:\
                           [NSString stringWithFormat:@"%@/%@", account, password]]
               parameters:nil
                 progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
                      LRStrongSelf(self)
                      NSString *tempStr = [(NSDictionary *)responseObject objectForKey:@"Result"];
        
                      if ([tempStr isEqualToString:@"Success"]) {
            
                          self.account     = account;
                          self.loginStatus = YES;
                          [self archiveAccount];
                          success(@"Success");
                      }
        
                      else if ([tempStr isEqualToString:@"NotMatch"]) {
            
                          fail(@"NotMatch");
                      }
        
                      else if ([tempStr isEqualToString:@"NoAccount"]) {
            
                          fail(@"NoAccount");
                      }
                      else {
            
                          fail(@"Fail");
                      }
                  }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
                      LRLog(@"Error: %@", error);
                      fail(@"Network Error");
    
                  }];
}

- (void)exit {
    
    self.account     = @"";
    self.loginStatus = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    if ([fileManager fileExistsAtPath:ACCOUNTARCHIVEPATH]) {
        
        [fileManager removeItemAtPath:ACCOUNTARCHIVEPATH error:&error];
    }
    
    if ([fileManager fileExistsAtPath:LOGINARCHIVEPATH]) {
        
        [fileManager removeItemAtPath:LOGINARCHIVEPATH error:&error];
    }
}

- (void)getNichengSuccess:(Success)success Fail:(Fail)fail {
    
    [self.afnManager GET:[GetNiChengStringWithoutUserName stringByAppendingString:self.account]
              parameters:nil
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
                     success([[responseObject objectForKey:@"Result"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     
                     LRLog(@"Error: %@", error);
                     fail(@"Network Fail");
                 }];

}

- (void)setNichengWithString:(NSString *)str Success:(Success)success Fail:(Fail)fail {
    
    NSString *address = [SetNiChengStringWithoutUserNameAndNiCheng stringByAppendingString:\
                         [NSString stringWithFormat:@"%@/%@", self.account, str]];
    
    address = [[address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    address = [[address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] mutableCopy];

    
    [self.afnManager POST:address
               parameters:nil
                 progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
                      success([responseObject objectForKey:@"Result"]);
                  }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
                      LRLog(@"Error: %@", error);
                      fail(@"Network Fail");
                  }];
}

- (void)setPasswordWithString:(NSString *)pwd Success:(Success)success Fail:(Fail)fail {
    
    [self.afnManager POST:[SetPasswordStringWithoutUserNameAndPassword stringByAppendingString:\
                           [NSString stringWithFormat:@"%@/%@", self.account, pwd]]
               parameters:nil
                 progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      
                      success(@"Success");
                  }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      
                      LRLog(@"Error: %@", error);
                      fail(@"Network Fail");
                  }];
}

- (void)addMessageWithString:(NSString *)message
                toItemNumber:(NSString *)number
                     Success:(Success)success
                        Fail:(Fail)fail {
    
    NSString *address = [AddMessageStringWithoutNumberAndUserNameAndMessage \
                         stringByAppendingString:\
                         [NSString stringWithFormat:@"%@/%@/%@", number, self.account, message]];
    
    address = [[address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    address = [[address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] mutableCopy];

    
    [self.afnManager POST:address
               parameters:nil
                 progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      
                      success(@"成功");
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      
                      LRLog(@"Error: %@", error);
                      fail(@"Network Fail");
                  }];
}

- (BOOL)getLonginStatus {
    
    return self.loginStatus;
}

- (BOOL)checkPassword:(NSString *)password {
    
    //验证密码格式是否为6-8位数字或字母组成
    NSString    *passWordRegex     = @"^[a-zA-Z0-9]{6,8}$";
    NSPredicate *passWordPredicate = \
                        [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    
    return [passWordPredicate evaluateWithObject:password];
}

- (BOOL)checkAccount:(NSString *)account {
    
    //验证账号格式是否为13/15/18开头的11位数字
    NSString    *number    = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    
    return [numberPre evaluateWithObject:account];
}

- (BOOL)checkNicheng:(NSString *)nicheng {
    
    //验证昵称是否为8位以内的汉字
    NSString    *number    = @"^[\u4e00-\u9fa5]{1,8}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    
    return [numberPre evaluateWithObject:nicheng];
}

- (void)checkAccount:(NSString *)account Success:(Success)success Fail:(Fail)fail {
    
    [self.afnManager POST:[CheckAccountStringWithoutAccount stringByAppendingString:account]
               parameters:nil
                 progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
                      LRLog(@"%@", [responseObject objectForKey:@"Result"]);
                      if ([[responseObject objectForKey:@"Result"] isEqualToString:@"YES"]) {
                          
                          success(@"YES");
                      } else {
                          
                          fail(@"NO");
                      }
                  }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
                      LRLog(@"%@", error);
                      fail(@"Network Fail");
                  }];
}

- (void)getMessageWithNumber:(NSString *)number Success:(Success)success Fail:(Fail)fail {
    
    [self.afnManager GET:[GetMessageStringWithoutNumber stringByAppendingString:number]
              parameters:nil
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     
                     LRLog(@"结果: %@", responseObject);
                     success(responseObject);
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     
                     LRLog(@"Error: %@", error);
                     fail(@"Network Fail");
                 }];
}

- (void)archiveAccount {
    
    NSString *lg;
    
    if (self.loginStatus) {
        
        lg = @"YES";
    } else {
        
        lg = @"NO";
    }
    
    //归档
    [NSKeyedArchiver archiveRootObject:self.account toFile:ACCOUNTARCHIVEPATH];
    [NSKeyedArchiver archiveRootObject:lg toFile:LOGINARCHIVEPATH];
    
    LRLog(@"账号归档成功");
}

- (BOOL)unArchiveAccount {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:ACCOUNTARCHIVEPATH]) {
        
        self.account = [NSKeyedUnarchiver unarchiveObjectWithFile:ACCOUNTARCHIVEPATH];
    } else {
        
        return FALSE;
    }
    
    if ([fileManager fileExistsAtPath:LOGINARCHIVEPATH]) {
        
        if ([[NSKeyedUnarchiver unarchiveObjectWithFile:LOGINARCHIVEPATH] isEqualToString:@"YES"]) {
            
            self.loginStatus = YES;
        } else {
            
            self.loginStatus = NO;
        }
    } else {
        
        return FALSE;
    }
    
    LRLog(@"账号解档成功");
    return YES;
}

@end
