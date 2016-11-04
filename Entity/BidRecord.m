//
//  BidRecord.m
//  fanwe_p2p
//
//  Created by mac on 14-8-19.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "BidRecord.h"
#import "ExtendNSDictionary.h"

@implementation BidRecord

-(void) setJson:(NSDictionary *) dict{
    
    @try {
        self.name = [dict toString:@"name"];
        self.money_format = [dict toString:@"money_format"];
        self.rate = [dict toFloat:@"rate"];
        self.deal_status = [dict toInt:@"deal_status"];
        self.repay_time_format = [dict toString:@"repay_time_format"];
        self.create_time_format = [dict toString:@"create_time_format"];
        self.app_url = [dict toString:@"app_url"];
    }
    @catch (NSException *exception) {
        NSLog(@"返回参数部分有问题");
    }
    
}

@end
