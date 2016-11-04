//
//  DealCate.h
//  fanwe_p2p
//
//  Created by mac on 14-8-11.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DealCate : NSObject

@property (nonatomic, assign) int deal_id;
@property (nonatomic, assign) int pid;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *icon;

-(void) setJson:(NSDictionary *) dict;

@end
