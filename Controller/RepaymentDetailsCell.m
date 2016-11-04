//
//  RepaymentDetailsCell.m
//  fanwe_p2p
//
//  Created by mac on 14-8-18.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "RepaymentDetailsCell.h"

@implementation RepaymentDetailsCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellContent:(RepaymentDetails *)repaymentDetails{
    
    _needRepaymentLabel.text = [NSString stringWithFormat:@"待还金额 %@",repaymentDetails.month_need_all_repay_money_format];
    _timeLabel.text = repaymentDetails.repay_day_format;
    _repaymentedLabel.text = repaymentDetails.month_has_repay_money_all_format;
    _manageMoneyLabel.text = repaymentDetails.month_manage_money_format;
    _needInterestLabel.text = repaymentDetails.month_repay_money_format;
    _overdueMoneyLabel.text =repaymentDetails.impose_money_format;
    
    //1：已还款;0:未还款
    if (repaymentDetails.has_repay == 1) {
        self.sgsmentImg.hidden = YES;
    }
    
}

@end
