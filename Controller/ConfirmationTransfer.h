//
//  ConfirmationTransfer.h
//  fanwe_p2p
//
//  Created by mac on 14-8-14.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transfer.h"

@interface ConfirmationTransfer : UIViewController{
    
    IBOutlet UIView *_myTabView;
    
    IBOutlet UILabel *_nameLabel;
    IBOutlet UILabel *_remainingTimeLabel;
    IBOutlet UILabel *_totalTimeLabel;
    IBOutlet UILabel *_nextRepayTimeLabel;
    IBOutlet UILabel *_transferMenoyLabel;
    IBOutlet UILabel *_remainingMoneyLabel;
    IBOutlet UILabel *_remainingInterestLabel;
    IBOutlet UILabel *_transferProfitLabel;
    
    IBOutlet UIView *_transferedView;
    IBOutlet UILabel *_undertakePeopleLabel;
    IBOutlet UILabel *_undertakeTimeLabel;
    
    IBOutlet UIView *_notTransferView;
    IBOutlet UILabel *_balanceLabel;
    IBOutlet UITextField *_passwordTextField;
    
    IBOutlet UIButton *_buyBtn;
    
    IBOutlet UIButton *_headBg;
    IBOutlet UIView *_bottomView;
    
}

@property (nonatomic, retain) Transfer *transfer;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

- (IBAction)rechargeAction:(id)sender;
- (IBAction)buyAction:(id)sender;

@end
