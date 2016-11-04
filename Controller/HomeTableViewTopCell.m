//
//  HomeTableViewTopCell.m
//  fanwe_p2p
//
//  Created by mac on 14-8-1.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "HomeTableViewTopCell.h"
#import "KDGoalBar.h"

@implementation HomeTableViewTopCell

- (void)awakeFromNib
{
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(float)setCellContent:(Home *) home{
    
    //deal_status状态；0待等材料，1借款中，2满标，3流标，4还款中，5已还清
    if (home.deal_status == 0) {
        _statusLabel.text = @"待等材料";
    }else if(home.deal_status == 1){
        _statusLabel.text = @"借款中";
        _statusLabel.textColor = [UIColor whiteColor];
        _nameLabel.textColor = [UIColor whiteColor];
        _headBgImg.image = [UIImage imageNamed:@"bg_home_item_head2.png"];
    }else if(home.deal_status == 2){
        _statusLabel.text = @"满标";
    }else if(home.deal_status == 3){
        _statusLabel.text = @"流标";
    }else if(home.deal_status == 4){
        _statusLabel.text = @"还款中";
    }else if(home.deal_status == 5){
        _statusLabel.text = @"已还清";
    }
    _nameLabel.text = home.name;
    _moneyLabel.text = home.borrow_amount_format;
    _rateLabel.text = home.rate_foramt_w;
    
    //repay_time_type期限的单位 0：天  1：月
    if (home.repay_time_type == 0) {
        _timeLabel.text = [NSString stringWithFormat:@"%d天",home.repay_time];
    }else if(home.repay_time_type == 1){
        _timeLabel.text = [NSString stringWithFormat:@"%d个月",home.repay_time];
    }
    
    //圆环百分比组件
    KDGoalBar *firstGoalBar = [[KDGoalBar alloc]initWithFrame:CGRectMake(230, 48, 80, 80)];
    if (home.deal_status == 1) {
        //蓝色
        [firstGoalBar setPercent:home.progress_point myUIColor:[UIColor colorWithRed:59/255.0 green:149/255.0 blue:211/255.0 alpha:1.0] animated:NO];
    }else{
        //粉红色
        [firstGoalBar setPercent:home.progress_point myUIColor:[UIColor colorWithRed:255/255.0 green:146/255.0 blue:18/255.0 alpha:1.0] animated:NO];
    }
    [self addSubview:firstGoalBar];
    
    return self.frame.size.height;
}

@end
