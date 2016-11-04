//
//  BidRecord.h
//  fanwe_p2p
//
//  Created by mac on 14-8-19.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BidRecord : NSObject

@property(nonatomic, retain) NSString *name; //名称
@property(nonatomic, retain) NSString *money_format; //金额
@property(nonatomic, assign) float rate; //年利率
@property(nonatomic, assign) int deal_status; //状态；0待等材料，1借款中，2满标，3流标，4还款中，5已还清
@property(nonatomic, retain) NSString *repay_time_format; //期限
@property(nonatomic, retain) NSString *create_time_format; //投标时间
@property(nonatomic, retain) NSString *app_url; //详情url链接

-(void) setJson:(NSDictionary *) dict;

@end
