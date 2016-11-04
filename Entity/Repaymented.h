//
//  Repaymented.h
//  fanwe_p2p
//
//  Created by mac on 14-8-19.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Repaymented : NSObject

@property (nonatomic, retain) NSString *sub_name; //名称
@property (nonatomic, retain) NSString *publis_time_format; //时间
@property (nonatomic, retain) NSString *rate_foramt_w; //年利率
@property (nonatomic, assign) int repay_time; //期限
@property (nonatomic, assign) int repay_time_type; //期限的单位 0：天  1：月
@property (nonatomic, retain) NSString *borrow_amount_format; //借款金额
@property (nonatomic, retain) NSString *app_url; //url链接地址

-(void) setJson:(NSDictionary *) dict;

@end
