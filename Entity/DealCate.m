//
//  DealCate.m
//  fanwe_p2p
//
//  Created by mac on 14-8-11.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "DealCate.h"
#import "ExtendNSDictionary.h"

@implementation DealCate

-(void)setJson:(NSDictionary *)dict{
    
    @try {
        self.deal_id = [dict toInt:@"id"];
        self.pid = [dict toInt:@"pid"];
        self.name = [dict toString:@"name"];
        self.icon = [dict toString:@"icon"];
    }
    @catch (NSException *exception) {
        NSLog(@"返回参数部分有问题");
    }
    
}

@end
