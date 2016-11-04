//
//  LogList.h
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-12.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogList : NSObject
@property (nonatomic,copy) NSString *loginfo;
@property (nonatomic,copy) NSString *logtime;
@property (nonatomic,copy) NSString *logmoney;
@property (nonatomic,copy) NSString *loglockMoney;
-(id)initWithDict:(NSDictionary*)dict;
@end
