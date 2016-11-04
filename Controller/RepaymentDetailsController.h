//
//  RepaymentDetailsController.h
//  fanwe_p2p
//
//  Created by mac on 14-8-15.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepaymentDetailsController : UIViewController{
    
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_loanMoneyLabel;
    IBOutlet UILabel *_rateLabel;
    IBOutlet UILabel *_timeLabel;
    IBOutlet UILabel *_repaymentedLabel;
    IBOutlet UILabel *_shouldRepaymentLabel;
    
    IBOutlet UIView *_myTabView;
    
    IBOutlet UILabel *_totalMoneyLabel;
    
}

@property (nonatomic, retain) NSString *repayment_id;

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

#pragma 充值
- (IBAction)rechargeAction:(id)sender;

#pragma 确认还款
- (IBAction)confirmRepaymentAction:(id)sender;

@end
