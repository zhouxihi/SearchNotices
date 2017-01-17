//
//  SNManager.h
//  SearchNotices
//
//  Created by Jackey on 2016/12/24.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNType.h"

#define zx_SN [SNManager shareInstance]

typedef void(^Success)(id responseObject);
typedef void(^Fail)(NSString *errorCode);

@interface SNManager : NSObject

@property (nonatomic, strong) NSString *account;        //账号
@property (nonatomic, assign) BOOL      loginStatus;    //登录状态

/**
 创建单例

 @return 返回单例对象
 */
+ (instancetype)shareInstance;

/**
 注册方法

 @param account 账号
 @param password 密码
 @param success 注册成功回调
 @param fail 注册失败回调
 */
- (void)registerWithAccount:(NSString *)account
                   Password:(NSString *)password
                    Success:(Success)success
                       Fail:(Fail)fail;

/**
 获取手机验证码

 @param number 电话号码
 @param success 获取成功回调
 @param fail 失败回调
 */
- (void)getPhoneCodeWithPhoneNumer:(NSString *)number
                           Success:(Success)success
                              Fail:(Fail)fail;

/**
 验证手机验证码

 @param code 验证码
 @param number 手机号
 @param success 成功回调
 @param fail 失败回调
 */
- (void)verifyPhoneCode:(NSString *)code
            PhoneNumber:(NSString *)number
                Success:(Success)success
                   Fail:(Fail)fail;


/**
 登录方法

 @param account 账号
 @param password 密码
 @param success 成功回调
 @param fail 失败回调
 */
- (void)loginWithAccount:(NSString *)account
                Password:(NSString *)password
                 Success:(Success)success
                    Fail:(Fail)fail;

/**
 退出
 */
- (void)exit;

/**
 获取昵称

 @param success 成功回调
 @param fail 失败回调
 */
- (void)getNichengSuccess:(Success)success
                     Fail:(Fail)fail;

/**
 修改昵称

 @param str 昵称
 @param success 成功回调
 @param fail 失败回调
 */
- (void)setNichengWithString:(NSString *)str
                     Success:(Success)success
                        Fail:(Fail)fail;

/**
 修改密码

 @param pwd 密码
 @param success 成功回调
 @param fail 失败回调
 */
- (void)setPasswordWithString:(NSString *)pwd
                      Success:(Success)success
                         Fail:(Fail)fail;

/**
 留言方法

 @param message 留言内容
 @param number 编号
 @param success 成功回调
 @param fail 失败回调
 */
- (void)addMessageWithString:(NSString *)message
                toItemNumber:(NSString *)number
                     Success:(Success)success
                        Fail:(Fail)fail;

/**
 发布随拍

 @param info 描述信息
 @param imageArray 图片数组
 @param latitude 纬度
 @param longitude 经度
 @param success 成功回调
 @param fail 失败回调
 */
- (void)submitSuipaiWithInfo:(NSString *)info
                        City:(NSString *)city
                      Jiedao:(NSString *)jiedao
                  ImageArray:(NSArray *)imageArray
                    Latitude:(float)latitude
                   longitude:(float)longitude
                     Success:(Success)success
                        Fail:(Fail)fail;

/**
 发布寻人

 @param info 描述信息
 @param imageArray 图片数组
 @param type 寻人分类
 @param success 成功回调
 @param fail 失败回调
 */
- (void)submitXunRenWithInfo:(NSString *)info
                  ImageArray:(NSArray *)imageArray
                CategoryType:(CategoryType)type
                     Success:(Success)success
                        Fail:(Fail)fail;

/**
 获取登录状态

 @return 返回登录状态
 */
- (BOOL)getLonginStatus;

/**
 检查密码格式

 @param password 密码
 @return 返回检查结果
 */
- (BOOL)checkPassword:(NSString *)password;

/**
 检查账号格式

 @param account 账号
 @return 返回检查结果
 */
- (BOOL)checkAccount:(NSString *)account;

/**
 检查昵称格式

 @param nicheng 昵称
 @return 返回检查结果
 */
- (BOOL)checkNicheng:(NSString *)nicheng;

/**
 检查账号是否存在

 @param account 账号
 @param success 存在回调
 @param fail 不存在回调
 */
- (void)checkAccount:(NSString *)account
             Success:(Success)success
                Fail:(Fail)fail;

/**
 获取留言信息

 @param number 编号
 @param success 成功回调
 @param fail 失败回调
 */
- (void)getMessageWithNumber:(NSString *)number
                     Success:(Success)success
                        Fail:(Fail)fail;

/**
 归档
 */
- (void)archiveAccount;

/**
 解档

 @return 返回是否解档成功
 */
- (BOOL)unArchiveAccount;

@end
