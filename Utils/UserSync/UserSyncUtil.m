//
//  UserSyncUtil.m
//  draw
//
//  Created by awfigq on 12-4-5.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UserSyncUtil.h"
#import "UserSyncBase.h"

@implementation UserSyncUtil

+ (int)getStringLength:(NSString *)str{
	NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
	NSLog(@"%@ length is: %d",str,[str lengthOfBytesUsingEncoding:enc]);
	return [str lengthOfBytesUsingEncoding:enc];
}

@synthesize delegate;

- (id)init{
	self = [super init];
	if (self) {
		_syncs = [[NSMutableDictionary alloc] init]; 
		_temps = nil;
	}
	return self;
}

- (BOOL)getIsSync:(NSString *)type{
	if ([_syncs objectForKey:type]) {
		return YES;
	}
	else {
		return NO;
	}
}

- (BOOL)getIsBind:(NSString *)type{
	if ([self getIsSync:type]) {
		return [[self getSync:type] getIsBind];
	}
	else {
		return NO;
	}
}

- (id)getSync:(NSString *)type{
	id sync;
	if ([_syncs objectForKey:type]) {
		sync = [_syncs objectForKey:type];
	}
	else {
		sync = [[NSClassFromString(type) alloc] init:self];
		[_syncs setObject:sync forKey:type];
	}
	return sync;
}

- (void)setSyncs:(NSArray *)syncs{
	if (syncs == nil || [syncs isEqual:[NSNull null]]) {
		return;
	}

	UserSyncBase *sync;
	for (NSDictionary *info in syncs){
		NSString *type = [info objectForKey:@"login_type"];
		sync = [self getSync:type];
		[sync bind:info];
		[_syncs setObject:sync forKey:type];
		//[sync release];
	}
}

- (void)removeSync:(NSString *)type{
	if ([self getIsSync:type]) {
		[_syncs removeObjectForKey:type];
	}
}

- (void)clearSync{
	[_syncs removeAllObjects];
}

- (NSDictionary *)getSyncInfo:(NSString *)type{
	if ([self getIsSync:type]) {
		return [[self getSync:type] getBindInfo];
	}
	return nil;
}

- (NSArray *)getSyncList{
	NSMutableArray *list = [[NSMutableArray alloc] init];
	NSDictionary *info;
	for (id type in [_syncs keyEnumerator]){
		info = [[self getSync:type] getBindInfo];
		if (info != nil) {
			[list addObject:info];
		}
	}
	return list;
}

- (void)login:(NSString *)type{
	[[self getSync:type] login];
}

- (void)didBaseLogin:(NSString *)type Status:(int)status{
	if (self.delegate && [self.delegate respondsToSelector:@selector(didUserSyncLogin:Status:)]) {
		[self.delegate didUserSyncLogin:type Status:status];
	}
}

- (void)getUser:(NSString *)type{
	[[self getSync:type] getUser];
}

- (void)didBaseGetUser:(NSString *)type Info:(NSDictionary *)info{
	if (info == nil) {
		[[self getSync:type] logout];
		[_syncs removeObjectForKey:type];
	}
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(didUserSyncGetUser:Info:)]) {
		[self.delegate didUserSyncGetUser:type Info:info];
	}
}

- (void)addShare:(NSString *)type content:(NSString *)text image:(UIImage *)img{
	if ([self getIsBind:type]) {
		[[self getSync:type] addShare:text image:img];
	}
}

- (void)didBaseAddShare:(NSString *)type Status:(int)status Msg:(NSString *)err{
	if (self.delegate && [self.delegate respondsToSelector:@selector(didUserSyncAddShare:Status:Msg:)]) {
		[self.delegate didUserSyncAddShare:type Status:status Msg:err];
	}
}

- (void)getFriends:(NSString *)type page:(int) num{
	_temps = nil;
	[[self getSync:type] getFriends:num];
}

- (void)getFollowers:(NSString *)type page:(int) num{
	_temps = nil;
	[[self getSync:type] getFollowers:num];
}

- (void)getFriendships:(NSString *)type page:(int) num{
	if (_temps != nil) {
		[_temps removeAllObjects];
	}
	_temps = [[NSMutableDictionary alloc] init]; 
	[_temps setObject:[NSNumber numberWithInt:num] forKey:@"page"];
	[[self getSync:type] getFollowers:num];
}

-(void)didBaseGetFriendships:(NSString *)type List:(NSArray *)data Type:(NSString *)getType IsNext:(BOOL)isNext{
	if ([getType isEqualToString:@"Followers"]) {
		if (_temps == nil) {
			if (self.delegate && [self.delegate respondsToSelector:@selector(didUserSyncGetFollowers:List:IsNext:)]) {
				[self.delegate didUserSyncGetFollowers:type List:data IsNext:isNext];
			}
		}
		else {
			if (data == nil) {
				[_temps setObject:[NSNull null] forKey:@"Followers"];
			}
			else {
				[_temps setObject:data forKey:@"Followers"];
			}
			
			if (isNext) {
				[_temps setObject:@"YES" forKey:@"isNext"];
			}
		}

	}
	else if ([getType isEqualToString:@"Friends"]) {
		if (_temps == nil) {
			if (self.delegate && [self.delegate respondsToSelector:@selector(didUserSyncGetFriends:List:IsNext:)]) {
				[self.delegate didUserSyncGetFriends:type List:data IsNext:isNext];
			}
		}
		else {
			if (data == nil) {
				[_temps setObject:[NSNull null] forKey:@"Friends"];
			}
			else {
				[_temps setObject:data forKey:@"Friends"];
			}
			
			if (isNext) {
				[_temps setObject:@"YES" forKey:@"isNext"];
			}
		}
	}
	
	if (_temps != nil) {
		if ([_temps objectForKey:@"Followers"] && [_temps objectForKey:@"Friends"]) {
			NSMutableArray *list = [[NSMutableArray alloc] init];
			if (![[_temps objectForKey:@"Followers"] isEqual:[NSNull null]]) {
				[list addObjectsFromArray:[_temps objectForKey:@"Followers"]];
			}
			
			if (![[_temps objectForKey:@"Friends"] isEqual:[NSNull null]]) {
				[list addObjectsFromArray:[_temps objectForKey:@"Friends"]];
			}
			
			isNext = NO;
			if ([_temps objectForKey:@"isNext"]) {
				isNext = YES;
			}
			
			[_temps release];
			_temps = nil;
			
			if (self.delegate && [self.delegate respondsToSelector:@selector(didUserSyncGetFriendships:List:IsNext:)]) {
				[self.delegate didUserSyncGetFriendships:type List:list IsNext:isNext];
			}
		}
		else {
			
			[[self getSync:type] getFriends:[[_temps valueForKey:@"page"] intValue]];
		}
	}
}

- (void)dealloc {
	[_syncs release];
    [super dealloc];
}

@end