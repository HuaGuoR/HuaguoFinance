//
//  Home.m
//  fanwe_p2p
//
//  Created by mac on 14-8-1.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "Home.h"
#import "ExtendNSDictionary.h"

@implementation Home

-(void) setJson:(NSDictionary *) dict{
    
    @try {
        self.borrow_id = [dict toInt:@"id"];
        self.name = [dict toString:@"name"];
        self.sub_name = [dict toString:@"sub_name"];
        self.rate = [dict toFloat:@"rate"];
        self.rate_foramt_w = [dict toString:@"rate_foramt_w"];
        self.deal_status = [dict toInt:@"deal_status"];
        self.borrow_amount = [dict toFloat:@"borrow_amount"];
        self.borrow_amount_format = [dict toString:@"borrow_amount_format"];
        self.progress_point = [dict toFloat:@"progress_point"];
        self.repay_time = [dict toInt:@"repay_time"];
        self.repay_time_type = [dict toInt:@"repay_time_type"];
        self.need_money = [dict toString:@"need_money"];
        self.min_loan_money = [dict toFloat:@"min_loan_money"];
        self.min_loan_money_format = [dict toString:@"min_loan_money_format"];
        self.loantype = [dict toInt:@"loantype"];
        self.risk_rank = [dict toInt:@"risk_rank"];
        self.remain_time_format = [dict toString:@"remain_time_format"];
        self.app_url = [dict toString:@"app_url"];
        self.r_userId = [dict toString:@"user_id"];
    }
    @catch (NSException *exception) {
        NSLog(@"返回参数部分有问题");
    }
    
}

@end
