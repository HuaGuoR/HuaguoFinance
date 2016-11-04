//
//  OnlinePayment.m
//  fanwe_p2p
//
//  Created by mac on 14-8-8.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "OfflinePayment.h"
#import "ExtendNSDictionary.h"

@implementation OfflinePayment

-(void)setJson:(NSDictionary *)dict{
    
    @try {
        self.pay_id = [dict toInt:@"pay_id"];
        self.bank_id = [dict toInt:@"bank_id"];
        self.pay_name = [dict toString:@"pay_name"];
        self.pay_account_name = [dict toString:@"pay_account_name"];
        self.pay_account = [dict toString:@"pay_account"];
        self.pay_bank = [dict toString:@"pay_bank"];
    }
    @catch (NSException *exception) {
        NSLog(@"返回参数部分有问题");
    }
    
}

@end
