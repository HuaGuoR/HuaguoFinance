//
//  GlobalVariables.h
//  fanwe_p2p
//
//  Created by mac on 14-8-21.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "UserSyncUtil.h"

@interface GlobalVariables : NSObject<ASIHTTPRequestDelegate>

@property(nonatomic,copy) NSString *user_id;
@property(nonatomic,copy) NSString *user_name;
@property(nonatomic,copy) NSString *user_pwd;

@property(assign) int indexNum; //左侧菜单栏点击到的index
@property(nonatomic,copy) NSString *program_title; //程序标题
@property(nonatomic,copy) NSString *site_domain; //网址
@property(nonatomic,copy) NSString *kf_phone; //客服电话
@property(nonatomic,copy) NSString *kf_email; //客服email
@property(nonatomic,copy) NSString *about_info; //关于我们
@property(assign) int rowTag;
@property(retain) NSMutableArray *deal_cate_list; //借款投资的搜索页中的认证标识
@property(nonatomic,copy) NSString *is_nopic; //判断是否需要加载图片 ==》暂时没用到

@property(retain) NSMutableDictionary *config;
@property(retain) UserSyncUtil *usUtil;
@property(nonatomic, retain) NSMutableDictionary *thirdInfo;
@property(nonatomic,copy) NSString *system_url; //用户的接口地址


+ (GlobalVariables *)sharedInstance;

#pragma 登录后保存用户信息到数据库
-(void)setUserInfo:(NSString *) userid user_name:(NSString *) username user_pwd:(NSString *) userpwd;

#pragma 判断是否登录
-(BOOL)is_login;

-(NSString *) toValue:(NSString *) value;

//判断是否为浮点形
- (BOOL)isPureFloat:(NSString *) string;

@end
