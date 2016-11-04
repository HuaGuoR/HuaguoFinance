//
//  RepaymentedCell.m
//  fanwe_p2p
//
//  Created by mac on 14-8-19.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "RepaymentedCell.h"

@implementation RepaymentedCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellContent:(Repaymented *)repaymented
{
    _titleLabel.text = repaymented.sub_name;
    _timeLabel.text = repaymented.publis_time_format;
    _rateLabel.text = repaymented.rate_foramt_w;
    //repay_time_type 期限的单位 0：天  1：月
    if (repaymented.repay_time_type == 1) {
        _limitTimeLabel.text = [NSString stringWithFormat:@"%d个月",repaymented.repay_time];
    }else{
        _limitTimeLabel.text = [NSString stringWithFormat:@"%d天",repaymented.repay_time];
    }
    _payMoneyLabel.text = repaymented.borrow_amount_format;
}

@end
