//
//  RepaymentDetails.m
//  fanwe_p2p
//
//  Created by mac on 14-8-18.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "RepaymentDetails.h"
#import "ExtendNSDictionary.h"

@implementation RepaymentDetails

-(void) setJson:(NSDictionary *) dict{
    
    @try {
        self.month_need_all_repay_money = [dict toFloat:@"month_need_all_repay_money"];
        self.month_need_all_repay_money_format = [dict toString:@"month_need_all_repay_money_format"];
        self.month_has_repay_money_all_format = [dict toString:@"month_has_repay_money_all_format"];
        self.repay_day_format = [dict toString:@"repay_day_format"];
        self.month_manage_money_format = [dict toString:@"month_manage_money_format"];
        self.month_repay_money_format = [dict toString:@"month_repay_money_format"];
        self.impose_money_format = [dict toString:@"impose_money_format"];
        self.has_repay = [dict toInt:@"has_repay"];
    }
    @catch (NSException *exception) {
        NSLog(@"返回参数部分有问题");
    }
    
}

@end
