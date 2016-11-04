//
//  RepaymentController.h
//  fanwe_p2p
//
//  Created by mac on 14-8-15.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepaymentController : UIViewController

//还款
- (void)repaymentAction:(NSString *)repayment_id;
//提前还款
- (void)advanceRepaymentAction:(NSString *)repayment_id;

//已还清借款列表的点击详情事件
- (void)repaymentedDetailsAction:(NSString *)app_url;

@end
