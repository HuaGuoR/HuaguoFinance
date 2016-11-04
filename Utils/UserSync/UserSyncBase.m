//
//  UserSync.m
//  Canvas
//
//  Created by awfigq on 12-3-29.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UserSyncBase.h"


@implementation UserSyncBase

@synthesize delegate,loginStatus,user;

- (id)init{
	self = [super init];
	if (self) {
		loginStatus = 0; //未登陆
		user = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)bind:(NSDictionary *)info{
	
}

- (NSDictionary *)getBindInfo{
	return nil;
}

- (BOOL)getIsBind{
	return NO;
}

- (void)login{
	
}

- (void)logout{
	
}

- (void)getUser{
	
}

- (void)addShare:(NSString *)content image:(UIImage *)img{
	
}

- (void)getFriends:(int) num{
	
}

- (void)getFollowers:(int) num{
	
}

- (void)dealloc {
	[user release];
    [super dealloc];
}

@end
