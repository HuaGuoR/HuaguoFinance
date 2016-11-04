//
//  UserSync.h
//  Canvas
//
//  Created by awfigq on 12-3-29.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@protocol UserSyncBaseDelegate <NSObject>
@optional

-(void)didBaseLogin:(NSString *)type Status:(int)status; //0:未登陆，1:登陆成功，-1:登录失败，-2:用户取消登录
-(void)didBaseGetUser:(NSString *)type Info:(NSDictionary *)info;
-(void)didBaseAddShare:(NSString *)type Status:(int)status Msg:(NSString *)err; //1:发送成功，-1:发送失败
-(void)didBaseGetFriendships:(NSString *)type List:(NSArray *)data Type:(NSString *)getType IsNext:(BOOL)isNext;

@end

@interface UserSyncBase : NSObject {
	id <UserSyncBaseDelegate> delegate;
	int loginStatus;
	NSString *_type;
	NSMutableDictionary *user;
}

@property (nonatomic,assign) id <UserSyncBaseDelegate> delegate;
@property (readonly) int loginStatus;
@property (nonatomic,retain) NSMutableDictionary *user;

- (void)bind:(NSDictionary *)info;
- (NSDictionary *)getBindInfo;
- (BOOL)getIsBind;
- (void)login;
- (void)logout;
- (void)getUser;
- (void)addShare:(NSString *)content image:(UIImage *)img;
- (void)getFriends:(int) num;
- (void)getFollowers:(int) num;
@end


