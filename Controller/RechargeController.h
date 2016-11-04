//
//  RechargeController.h
//  fanwe_p2p
//
//  Created by mac on 14-8-7.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeController : UIViewController

//线上充值
- (void)onlinePaymentAction:(NSString *) payment_id money:(NSString *)money;
//线下充值
- (void)offlinePaymentAction:(NSMutableDictionary *) tmpDict;

@end
