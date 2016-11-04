//
//  Repayment.m
//  fanwe_p2p
//
//  Created by mac on 14-8-15.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "Repayment.h"
#import "ExtendNSDictionary.h"

@implementation Repayment

-(void) setJson:(NSDictionary *) dict{
    
    @try {
        self.repayment_id = [dict toString:@"id"];
        self.sub_name = [dict toString:@"sub_name"];
        self.borrow_amount_format = [dict toString:@"borrow_amount_format"];
        self.rate_foramt_w = [dict toString:@"rate_foramt_w"];
        self.repay_time = [dict toInt:@"repay_time"];
        self.repay_time_type = [dict toInt:@"repay_time_type"];
        self.true_month_repay_money = [dict toFloat:@"true_month_repay_money"];
        self.need_money = [dict toString:@"need_money"];
        self.next_repay_time_format = [dict toString:@"next_repay_time_format"];
    }
    @catch (NSException *exception) {
        NSLog(@"返回参数部分有问题");
    }
    
}

@end
