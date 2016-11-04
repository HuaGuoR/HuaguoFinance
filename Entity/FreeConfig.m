//
//  freeConfig.m
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-14.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "FreeConfig.h"

@implementation FreeConfig
- (id)initWithArray:(NSMutableArray*)array
{
    @try {
        self = [super init];
        if(self){
            self.free1_1 = [((NSDictionary*)array[0])[@"min_price"]intValue];
            self.free1_2 = [((NSDictionary*)array[0])[@"max_price"]intValue];
            self.free2_1 = [((NSDictionary*)array[1])[@"min_price"]intValue];
            self.free2_2 = [((NSDictionary*)array[1])[@"max_price"]intValue];
            self.freeMoney1 = ((NSDictionary*)array[0])[@"fee_format"];
            self.freeMoney2 = ((NSDictionary*)array[1])[@"fee_format"];
            
            self.freeIntMoney1 = [((NSDictionary*)array[0])[@"fee"]floatValue];
            self.freeIntMoney2 = [((NSDictionary*)array[1])[@"fee"]floatValue];
            
            self.money1 = [((NSDictionary*)array[0])[@"fee"]intValue];
            self.money2 = [((NSDictionary*)array[1])[@"fee"]intValue];
        }
        return  self;
    }
    @catch (NSException *exception) {
        NSLog(@"返回参数部分有问题");
    }
    
}
@end
