//
//  RepaymentCell.m
//  fanwe_p2p
//
//  Created by mac on 14-8-15.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "RepaymentCell.h"

@implementation RepaymentCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellContent:(Repayment *)repayment{
    
    self.repayment_id = repayment.repayment_id;
    _titleLabel.text = repayment.sub_name;
    _borrowingMoneyLabel.text = repayment.borrow_amount_format;
    _rateLabel.text = repayment.rate_foramt_w;
    //期限的单位 0：天  1：月
    if (repayment.repay_time_type == 0) {
        _timeLabel.text = [NSString stringWithFormat:@"%d天",repayment.repay_time];
    }else{
        _timeLabel.text = [NSString stringWithFormat:@"%d个月",repayment.repay_time];
    }
    _payBackMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",repayment.true_month_repay_money];
    
    _defaultInterestLabel.text = repayment.need_money;
    _nextRepayTimeLabel.text = repayment.next_repay_time_format;
    
}

- (IBAction)repaymentAction:(id)sender {
    if(self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(repaymentAction:)]) {
            [self.delegate performSelector:@selector(repaymentAction:) withObject:self.repayment_id];
        }
    }
}

- (IBAction)advanceRepaymentAction:(id)sender {
    if(self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(advanceRepaymentAction:)]) {
            [self.delegate performSelector:@selector(advanceRepaymentAction:) withObject:self.repayment_id];
        }
    }
}

@end
