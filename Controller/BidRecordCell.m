//
//  BidRecordCell.m
//  fanwe_p2p
//
//  Created by mac on 14-8-19.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "BidRecordCell.h"

@implementation BidRecordCell

- (void)awakeFromNib
{
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(float)setCellContent:(BidRecord *) bidRecord{
    
    //deal_status状态；0待等材料，1借款中，2满标，3流标，4还款中，5已还清
    if (bidRecord.deal_status == 0) {
        _statusLabel.text = @"待等材料";
    }else if(bidRecord.deal_status == 1){
        _statusLabel.text = @"借款中";
        _statusLabel.textColor = [UIColor whiteColor];
        _nameLabel.textColor = [UIColor whiteColor];
        _headBgImg.image = [UIImage imageNamed:@"bg_home_item_head2.png"];
    }else if(bidRecord.deal_status == 2){
        _statusLabel.text = @"满标";
    }else if(bidRecord.deal_status == 3){
        _statusLabel.text = @"流标";
    }else if(bidRecord.deal_status == 4){
        _statusLabel.text = @"还款中";
    }else if(bidRecord.deal_status == 5){
        _statusLabel.text = @"已还清";
    }
    _nameLabel.text = bidRecord.name;
    _moneyLabel.text = bidRecord.money_format;
    NSString *str = [NSString stringWithFormat:@"%.2f",bidRecord.rate];
    _rateLabel.text = [str stringByAppendingString:@"%"];
    _timeLabel.text = bidRecord.repay_time_format;
    _bidTimeLabel.text = bidRecord.create_time_format;
    
    return self.frame.size.height;
}

@end
