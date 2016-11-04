//
//  RepaymentDetails.h
//  fanwe_p2p
//
//  Created by mac on 14-8-18.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RepaymentDetails : NSObject

@property (nonatomic, assign) float month_need_all_repay_money; //待还金额
@property (nonatomic, retain) NSString *month_need_all_repay_money_format; //格式化后的待还金额
@property (nonatomic, retain) NSString *month_has_repay_money_all_format; //已还金额
@property (nonatomic, retain) NSString *repay_day_format; //还款日期
@property (nonatomic, retain) NSString *month_manage_money_format; //管理费
@property (nonatomic, retain) NSString *month_repay_money_format; //待还本息
@property (nonatomic, retain) NSString *impose_money_format; //逾期费
@property (nonatomic, assign) int has_repay; //1：已还款;0:未还款

-(void) setJson:(NSDictionary *) dict;

@end
