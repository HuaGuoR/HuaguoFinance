//
//  RepaymentCell.h
//  fanwe_p2p
//
//  Created by mac on 14-8-15.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Repayment.h"

@protocol RepaymentCellDelegate;

@interface RepaymentCell : UITableViewCell{
    
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_borrowingMoneyLabel;
    IBOutlet UILabel *_rateLabel;
    IBOutlet UILabel *_timeLabel;
    IBOutlet UILabel *_payBackMoneyLabel;
    IBOutlet UILabel *_defaultInterestLabel;
    IBOutlet UILabel *_nextRepayTimeLabel;
}

@property (nonatomic, retain) NSString *repayment_id;
@property (nonatomic, retain) id<RepaymentCellDelegate> delegate;

-(void)setCellContent:(Repayment *)repayment;

//还款
- (IBAction)repaymentAction:(id)sender;

//提前还款
- (IBAction)advanceRepaymentAction:(id)sender;

@end

@protocol RepaymentCellDelegate <NSObject>

@required

- (void)repaymentAction:(NSString *)repayment_id; //还款
- (void)advanceRepaymentAction:(NSString *)repayment_id; //提前还款

@end
