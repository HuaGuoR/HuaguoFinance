//
//  Advs.m
//  fanwe_p2p
//
//  Created by mac on 14-8-1.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "Advs.h"
#import "ExtendNSDictionary.h"

@implementation Advs

-(void) setJson:(NSDictionary *) dict{
    
    @try {
        self.adv_id = [dict toInt:@"adv_id"];
        self.name = [dict toString:@"name"];
        self.img = [dict toString:@"img"];
        self.page = [dict toString:@"page"];
        self.type = [dict toInt:@"type"];
        self.data = [dict toString:@"data"];
        self.sort = [dict toInt:@"sort"];
        self.status = [dict toInt:@"status"];
        self.open_url_type = [dict toInt:@"open_url_type"];
    }
    @catch (NSException *exception) {
        NSLog(@"返回参数部分有问题");
    }
    
}

@end
