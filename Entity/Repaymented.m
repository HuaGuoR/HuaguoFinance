//
//  Repaymented.m
//  fanwe_p2p
//
//  Created by mac on 14-8-19.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "Repaymented.h"
#import "ExtendNSDictionary.h"

@implementation Repaymented

-(void) setJson:(NSDictionary *) dict{
    
    @try {
        self.sub_name = [dict toString:@"sub_name"];
        self.publis_time_format = [dict toString:@"publis_time_format"];
        self.rate_foramt_w = [dict toString:@"rate_foramt_w"];
        self.repay_time = [dict toInt:@"repay_time"];
        self.repay_time_type = [dict toInt:@"repay_time_type"];
        self.borrow_amount_format = [dict toString:@"borrow_amount_format"];
        self.app_url = [dict toString:@"app_url"];
    }
    @catch (NSException *exception) {
        NSLog(@"返回参数部分有问题");
    }
    
}

@end
