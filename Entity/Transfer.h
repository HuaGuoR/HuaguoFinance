//
//  Transfer.h
//  fanwe_p2p
//
//  Created by mac on 14-8-13.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transfer : NSObject

@property(nonatomic, retain) NSString *user_id; //该标拥有者的id
@property(nonatomic, retain) NSString *transfer_id; //该投标项目的id
@property(nonatomic, retain) NSString *title; //标题
@property(nonatomic, retain) NSString *user_name; //转让者
@property(nonatomic, assign) float left_benjin; //本金
@property(nonatomic, retain) NSString *left_benjin_format; //格式化后的本金
@property(nonatomic, assign) float left_lixi; //利息
@property(nonatomic, retain) NSString *left_lixi_format; //格式化后的利息
@property(nonatomic, assign) float transfer_amount; //转让价
@property(nonatomic, retain) NSString *transfer_amount_format; //格式化后的转让价
@property(nonatomic, assign) float rate; //利率
@property(nonatomic, assign) int t_user_id; //t_user_id > 0 已转让
@property(nonatomic, assign) int status; //1:可转让
@property(nonatomic, retain) NSString *remain_time_format; //剩余时间
@property(nonatomic, retain) NSString *tuser_name; //承接人
@property(nonatomic, retain) NSString *transfer_time_format; //承接时间
@property(nonatomic, assign) int repay_time; //总时间
@property(nonatomic, assign) int repay_time_type; //总时间的单位 0：天  1：月
@property(nonatomic, retain) NSString *near_repay_time_format; //下还款日
@property(nonatomic, retain) NSString *transfer_income_format; //受让收益
@property(nonatomic, retain) NSString *app_url; //详情

-(void) setJson:(NSDictionary *) dict;

@end
