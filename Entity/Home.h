//
//  Home.h
//  fanwe_p2p
//
//  Created by mac on 14-8-1.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Home : NSObject

@property(nonatomic, assign) int borrow_id;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *sub_name; //标题
@property(nonatomic, assign) float rate; //年利率
@property(nonatomic, retain) NSString *rate_foramt_w; //格式化后的年利率
@property(nonatomic, assign) int deal_status; //状态；0待等材料，1借款中，2满标，3流标，4还款中，5已还清
@property(nonatomic, assign) float borrow_amount; //借款金额
@property(nonatomic, retain) NSString *borrow_amount_format; //格式化后的借款金额
@property(nonatomic, assign) float progress_point; //进度
@property(nonatomic, assign) int repay_time; //期限
@property(nonatomic, assign) int repay_time_type; //期限的单位 0：天  1：月
@property(nonatomic, retain) NSString *need_money; //可投金额
@property(nonatomic, assign) float min_loan_money; //最低金额
@property(nonatomic, retain) NSString *min_loan_money_format; //格式化后的最低金额
@property(nonatomic, assign) int loantype; //还款方式 0：等额本息 1：付息还本 2：到期还本息
@property(nonatomic, assign) int risk_rank; //风险等级 0：底 1：中 2：高
@property(nonatomic, retain) NSString *remain_time_format; //剩余时间
@property(nonatomic, retain) NSString *app_url; //详情url链接
@property(nonatomic, retain) NSString *r_userId; //该标的作者

-(void) setJson:(NSDictionary *) dict;

@end
