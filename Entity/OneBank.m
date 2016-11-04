//
//  OneBank.m
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-13.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "OneBank.h"

@implementation OneBank
- (id)initWithDict:(NSDictionary*)dict
{
    @try {
        self = [super init];
        if(self){
            self.bankId = [dict[@"id"]intValue];
            self.bankName = dict[@"name"];
        }
        return self;
    }
    @catch (NSException *exception) {
        NSLog(@"返回参数部分有问题");
    }
    
}
@end
