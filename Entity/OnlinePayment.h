//
//  OnlinePayment.h
//  fanwe_p2p
//
//  Created by mac on 14-8-8.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OnlinePayment : NSObject

@property (nonatomic, assign) int payment_id;
@property (nonatomic, retain) NSString *class_name;
@property (nonatomic, retain) NSString *logo;
@property (nonatomic, assign) int fee_type; //手续费类型0:定额;1:比率
@property (nonatomic, assign) float fee_amount; //手续费类型参数值

-(void) setJson:(NSDictionary *) dict;

@end
