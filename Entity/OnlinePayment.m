//
//  OnlinePayment.m
//  fanwe_p2p
//
//  Created by mac on 14-8-8.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "OnlinePayment.h"
#import "ExtendNSDictionary.h"

@implementation OnlinePayment

-(void)setJson:(NSDictionary *)dict{
    
    @try {
        self.payment_id = [dict toInt:@"id"];
        self.class_name = [dict toString:@"class_name"];
        self.logo = [dict toString:@"logo"];
        self.fee_amount = [dict toFloat:@"fee_amount"];
        self.fee_type = [dict toInt:@"fee_type"];
    }
    @catch (NSException *exception) {
        NSLog(@"返回参数部分有问题");
    }
    
}

@end
