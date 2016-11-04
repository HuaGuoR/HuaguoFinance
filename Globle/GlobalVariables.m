//
//  GlobalVariables.m
//  fanwe_p2p
//
//  Created by mac on 14-8-21.
//  Copyright (c) 2014年 mac. All rights reserved.
//

// http://maniacdev.com/2009/07/global-variables-in-iphone-objective-c/

#import "GlobalVariables.h"
#import "DB.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@implementation GlobalVariables

+ (GlobalVariables *)sharedInstance{
    // the instance of this class is stored here
    static GlobalVariables *myInstance = nil;
	
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
		
        NSMutableDictionary *config = [[NSMutableDictionary alloc] init];
		myInstance.config = config;
        
		NSBundle *bundle = [NSBundle mainBundle];
		NSString *plistPath = [bundle pathForResource:@"appchange" ofType:@"plist"];
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
		
		for (NSString *key in dict) {
			[myInstance.config setObject:[dict objectForKey:key] forKey:key];
		}
		
		UserSyncUtil *usUtil = [[UserSyncUtil alloc] init];
		myInstance.usUtil = usUtil;
        
		NSMutableDictionary *thirdInfo = [[NSMutableDictionary alloc] init];
		myInstance.thirdInfo = thirdInfo;
		
		DB *db = [DB initFanweDb:NO];
		FMResultSet *rs = [db executeQuery:@"select name,val from sys_conf"];
		while ([rs next]) {
    		//host 绑定域名头
    		//domain 绑定域名
    		//api的文件地址
			if ([[rs stringForColumn:@"name"] isEqualToString:@"host"] || [[rs stringForColumn:@"name"] isEqualToString:@"domain"] || [[rs stringForColumn:@"name"] isEqualToString:@"api"]){
				if (![[rs stringForColumn:@"val"] isEqualToString:@""]) {
					[myInstance.config setObject:[myInstance toValue:[rs stringForColumn:@"val"]] forKey:[rs stringForColumn:@"name"]];
				}
			}else {
				[myInstance.config setObject:[myInstance toValue:[rs stringForColumn:@"val"]] forKey:[rs stringForColumn:@"name"]];
			}
			
			//用户名
			if ([[rs stringForColumn:@"name"] isEqualToString:@"user_name"]){
				myInstance.user_name = [rs stringForColumn:@"val"];
			}
			
			//用户密码
			if ([[rs stringForColumn:@"name"] isEqualToString:@"user_pwd"]){
				myInstance.user_pwd = [rs stringForColumn:@"val"];
			}
			
			//用户ID
			if ([[rs stringForColumn:@"name"] isEqualToString:@"user_id"]){
				myInstance.user_id = [rs stringForColumn:@"val"];
			}
            
            //2G/3G下使用无图模式 0表示: 否  1:是
			if ([[rs stringForColumn:@"name"] isEqualToString:@"is_nopic"]){
				myInstance.is_nopic = [rs stringForColumn:@"val"];
			}
			
		}
		[rs close];
		[db close];
		
		//用户的接口地址
		if ([[myInstance.config objectForKey:@"host"] isEqualToString:@""]) {
			myInstance.system_url = [@"http://" stringByAppendingFormat:@"%@/%@?", [myInstance.config objectForKey:@"domain"], [myInstance.config objectForKey:@"api"]];
		}else {
			myInstance.system_url = [@"http://" stringByAppendingFormat:@"%@.%@/%@?",[myInstance.config objectForKey:@"host"], [myInstance.config objectForKey:@"domain"], [myInstance.config objectForKey:@"api"]];
		}
		
    }
    return myInstance;
}

#pragma 判断是否为整形
- (BOOL)isPureInt:(NSString*) string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt: &val] && [scan isAtEnd];
}

#pragma 判断是否为浮点形
- (BOOL)isPureFloat:(NSString *) string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

-(NSString *) toValue:(NSString *) value{
    if ( [value isKindOfClass:[NSNull class]] || value == NULL){
		return @"";
	}
    @try {
        if ([self isPureInt:value]){
            return value;
        }else{
            @try {
				if (!value || value == nil ||![value respondsToSelector:@selector(length)] || [value length] == 0){
					return @"";
				}else {
					return value;
				}
            } @catch (NSException* e) {
				return @"";
			}
        }
    } @catch (NSException* e) {
        return @"";
    }
}

#pragma 判断用户是否登录
-(BOOL)is_login{
    if (self.user_name == nil || self.user_name == NULL || [self.user_name length] <= 0){
        return NO;
    }else{
        return YES;
    }
}

#pragma 登录后保存用户信息到数据库
-(void)setUserInfo:(NSString *) userid user_name:(NSString *) username user_pwd:(NSString *) userpwd{
    
	self.user_id = userid;
	self.user_name = username;
	self.user_pwd = userpwd;
    
	[self setSysConf:@"user_id" val:userid];
	[self setSysConf:@"user_name" val:username];
	[self setSysConf:@"user_pwd" val:userpwd];
	
}

-(void)setSysConf:(NSString *) name
			  val:(NSString *) val{
    if (name == nil || name == NULL || [name isEqualToString:@""] || [name length] == 0){
        return;
    }
	DB *db = [DB initFanweDb:NO];
	
	int a = [db intForQuery:@"select count(*) from sys_conf where name = ?", name];
	if (a >0){
		if (![db executeUpdate:@"update sys_conf set val = ? where name = ?", val,name]){
            NSLog(@"executeUpdate error");
        }
	}else {
		if (![db executeUpdate:@"insert into sys_conf (name, val) values (?,?)", name, val]){
            NSLog(@"executeUpdate error");
        }
	}
	[db close];
	
	[self.config setObject:[self toValue:val] forKey:name];
}


@end
