//
//  RepaymentListController.h
//  fanwe_p2p
//
//  Created by mac on 14-8-15.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RepaymentListDelegate;

@interface RepaymentListController : UITableViewController{
    
    id<RepaymentListDelegate> delegate;
    
}

@property (nonatomic, retain) id<RepaymentListDelegate> delegate;

- (void)repaymentAction:(NSString *)repayment_id; //还款
- (void)advanceRepaymentAction:(NSString *)repayment_id; //提前还款

@end

@protocol RepaymentListDelegate <NSObject>

@required

- (void)repaymentAction:(NSString *)repayment_id; //还款
- (void)advanceRepaymentAction:(NSString *)repayment_id; //提前还款

@end
