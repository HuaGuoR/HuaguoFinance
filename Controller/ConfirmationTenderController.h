//
//  ConfirmationTenderController.h
//  fanwe_p2p
//
//  Created by mac on 14-8-5.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Home.h"

@interface ConfirmationTenderController : UIViewController{
    
    IBOutlet UIView *_myTabView;
    
    IBOutlet UILabel *_nameLabel;
    IBOutlet UILabel *_borrowingBalanceLabel;
    IBOutlet UILabel *_schedule;
    IBOutlet UILabel *_rateLabel;
    IBOutlet UILabel *_timeLabel;
    IBOutlet UILabel *_repaymentMethodLabel;
    IBOutlet UILabel *_investmentAmountLabel;
    
    IBOutlet UILabel *_balanceLabel;
    IBOutlet UITextField *_tenderMoneyTextField;
    IBOutlet UITextField *_passwordTextField;
    
    IBOutlet UIButton *_headBg;
    IBOutlet UIView *_bottomView;
    IBOutlet UIView *_payView;
}

@property (nonatomic, retain) Home *home;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

- (IBAction)rechargeAction:(id)sender;
- (IBAction)investAction:(id)sender;

@end
