//
//  LogList.m
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-12.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "LogList.h"
#import "ExtendNSDictionary.h"

@implementation LogList
-(id)initWithDict:(NSDictionary*)dict{
    
    @try {
        self= [super init];
        if(self){
            self.loginfo = [dict toString:@"log_info"];
            self.logtime = [dict toString:@"log_time_format"];
            self.logmoney = [dict toString:@"money_format"];
            self.loglockMoney = [dict toString:@"lock_money_format"];
        }
        return self;
    }
    @catch (NSException *exception) {
        NSLog(@"返回参数部分有问题");
    }
    
}
@end
