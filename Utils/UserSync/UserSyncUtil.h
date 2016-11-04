//
//  UserSyncUtil.h
//  draw
//
//  Created by awfigq on 12-4-5.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserSyncDelegate <NSObject>
@optional

-(void)didUserSyncLogin:(NSString *)type Status:(int)status; //0:未登陆，1:登陆成功，-1:登录失败，-2:用户取消登录
-(void)didUserSyncGetUser:(NSString *)type Info:(NSDictionary *)info;
-(void)didUserSyncAddShare:(NSString *)type Status:(int)status Msg:(NSString *)err; //1:发送成功，-1:发送失败
-(void)didUserSyncGetFriends:(NSString *)type List:(NSArray *)data IsNext:(BOOL)isNext;
-(void)didUserSyncGetFollowers:(NSString *)type List:(NSArray *)data IsNext:(BOOL)isNext;
-(void)didUserSyncGetFriendships:(NSString *)type List:(NSArray *)data IsNext:(BOOL)isNext;
@end

@interface UserSyncUtil : NSObject {
	id <UserSyncDelegate> delegate;
	NSMutableDictionary *_syncs;
	NSMutableDictionary *_temps;
}

@property (nonatomic,assign) id <UserSyncDelegate> delegate;
+ (int)getStringLength:(NSString *)str;

- (void)setSyncs:(NSArray *)syncs;
- (BOOL)getIsSync:(NSString *)type;
- (BOOL)getIsBind:(NSString *)type;
- (void)removeSync:(NSString *)type;
- (void)clearSync;
- (NSDictionary *)getSyncInfo:(NSString *)type;
- (NSArray *)getSyncList;
- (void)login:(NSString *)type;
- (void)getUser:(NSString *)type;
- (void)addShare:(NSString *)type content:(NSString *)text image:(UIImage *)img;
- (void)getFriends:(NSString *)type page:(int) num;
- (void)getFollowers:(NSString *)type page:(int) num;
- (void)getFriendships:(NSString *)type page:(int) num;
@end