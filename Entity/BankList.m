//
//  BankList.m
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-13.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "BankList.h"
#import "ExtendNSDictionary.h"

@implementation BankList
- (id)initWithDict:(NSDictionary*)Dict
{
    
    @try {
        self = [super init];
        if(self){
            self.bankid = [Dict toInt:@"id"];
            self.bankcard = [Dict toString:@"bankcard"];
            self.bankName = [Dict toString:@"bank_name"];
            self.bankimage = [Dict toString:@"img"];
            self.realName = [Dict toString:@"real_name"];
        }
        return self;
    }
    @catch (NSException *exception) {
        NSLog(@"返回参数部分有问题");
    }
    
}
@end
