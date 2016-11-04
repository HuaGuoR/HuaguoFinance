//
//  Repayment.h
//  fanwe_p2p
//
//  Created by mac on 14-8-15.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Repayment : NSObject

@property (nonatomic, retain) NSString *repayment_id; //该还款项的id
@property (nonatomic, retain) NSString *sub_name; //标题
@property (nonatomic, retain) NSString *borrow_amount_format; //借款金额
@property (nonatomic, retain) NSString *rate_foramt_w; //年利率
@property (nonatomic, assign) int repay_time; //期限
@property (nonatomic, assign) int repay_time_type; //期限的单位 0：天  1：月
@property (nonatomic, assign) float true_month_repay_money; //待还金额
@property (nonatomic, retain) NSString *need_money; //罚息
@property (nonatomic, retain) NSString *next_repay_time_format; //下还款日

-(void) setJson:(NSDictionary *) dict;

@end
