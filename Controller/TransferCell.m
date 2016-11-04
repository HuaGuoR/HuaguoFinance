//
//  TransferCell.m
//  fanwe_p2p
//
//  Created by mac on 14-8-13.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "TransferCell.h"

@implementation TransferCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(float)setCellContent:(Transfer *) transfer;
{
    [_userNameBtn setTitle:[NSString stringWithFormat:@"%@",transfer.user_name] forState:UIControlStateNormal];
    _titleLabel.text = transfer.title;
    _principalLabel.text = transfer.left_benjin_format;
    _interestLabel.text = transfer.left_lixi_format;
    _transferPriceLabel.text = transfer.transfer_amount_format;
    _interestRatesLabel.text = [NSString stringWithFormat:@"%.2f",transfer.rate];
    
    if (transfer.t_user_id > 0) {
        _transferStateLabel.text = @"已转让";
        _undertakePeopleLabel.text = transfer.tuser_name;
    }else{
        _undertakePeopleLabel.text = @"暂无";
        _transferStateLabel.text = [NSString stringWithFormat:@"剩余时间:%@",transfer.remain_time_format];
    }
    
    
    return self.frame.size.height;
}

@end
