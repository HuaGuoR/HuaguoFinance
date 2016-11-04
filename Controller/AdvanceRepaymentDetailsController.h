//
//  AdvanceRepaymentDetailsController.h
//  fanwe_p2p
//
//  Created by mac on 14-8-15.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvanceRepaymentDetailsController : UIViewController{
    
    
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_loanMoneyLabel;
    IBOutlet UILabel *_rateLabel;
    IBOutlet UILabel *_repaymentedLabel;
    IBOutlet UILabel *_timeLabel;
    IBOutlet UILabel *_manageMoneyLabel;
    IBOutlet UILabel *_punitiveInterestLabel;
    IBOutlet UILabel *_shouldPayLabel;
    
    IBOutlet UILabel *_totalPayLabel;
    
    IBOutlet UIView *_myTabView;
}

@property (nonatomic, retain) NSString *repayment_id;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

#pragma 充值
- (IBAction)rechargeAction:(id)sender;

#pragma 确认还款
- (IBAction)confirmPayAction:(id)sender;

@end
