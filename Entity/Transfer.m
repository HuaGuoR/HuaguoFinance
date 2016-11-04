//
//  Transfer.m
//  fanwe_p2p
//
//  Created by mac on 14-8-13.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "Transfer.h"
#import "ExtendNSDictionary.h"

@implementation Transfer

-(void) setJson:(NSDictionary *) dict{
    
    @try {
        self.user_id = [dict toString:@"user_id"];
        self.transfer_id = [dict toString:@"id"];
        self.title = [dict toString:@"name"];
        if ([dict objectForKey:@"user"] != [NSNull null]) {
            self.user_name = [[dict objectForKey:@"user"] toString:@"user_name"];
        }
        self.left_benjin = [dict toFloat:@"left_benjin"];
        self.left_benjin_format = [dict toString:@"left_benjin_format"];
        self.left_lixi = [dict toFloat:@"left_lixi"];
        self.left_lixi_format = [dict toString:@"left_lixi_format"];
        self.transfer_amount = [dict toFloat:@"transfer_amount"];
        self.transfer_amount_format = [dict toString:@"transfer_amount_format"];
        self.rate = [dict toFloat:@"rate"];
        self.t_user_id = [dict toInt:@"t_user_id"];
        self.status = [dict toInt:@"status"];
        self.remain_time_format = [dict toString:@"remain_time_format"];
        
        if ([dict objectForKey:@"tuser"] != [NSNull null]) {
            self.tuser_name = [[dict objectForKey:@"tuser"] toString:@"user_name"];
        }
        self.transfer_time_format = [dict toString:@"transfer_time_format"];
        self.repay_time = [dict toInt:@"repay_time"];
        self.repay_time_type = [dict toInt:@"repay_time_type"];
        self.near_repay_time_format = [dict toString:@"near_repay_time_format"];
        self.transfer_income_format = [dict toString:@"transfer_income_format"];
        self.app_url = [dict toString:@"app_url"];
    }
    @catch (NSException *exception) {
        NSLog(@"返回参数部分有问题");
    }
}

@end
