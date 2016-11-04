//
//  transList.m
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-18.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "transList.h"
#import "ExtendNSDictionary.h"

@implementation TransList

- (id)initWithDict:(NSDictionary*)dict{
    
    @try {
        self = ([super init]);
        if(self){
            self.title = dict[@"sub_name"];
            self.hmonth = [NSString stringWithFormat:@"%d",[dict toInt:@"how_much_month"]];
            self.smonth = [NSString stringWithFormat:@"%d",[dict toInt:@"how_much_month"]];
            self.benjin = dict[@"left_benjin_format"];
            self.lixi = dict[@"left_lixi_format"];
            self.tranfermoney = dict[@"transfer_amount_format"];
            self.transop = [dict toInt:@"tras_status_op"];
            self.timeUp = dict[@"final_repay_time_format"];
            self.transferTime = dict[@"tras_create_time_format"];
            self.statues = dict[@"tras_status_format"];
            self.appurl = dict[@"app_url"];
            self.dlid = [dict toInt:@"dlid"];
            self.dltid = [dict toInt:@"dltid"];
        }
        return  self;
    }
    @catch (NSException *exception) {
        NSLog(@"返回参数部分有问题");
    }
    
}
@end