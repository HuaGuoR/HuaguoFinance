//
//  HomeTableViewBottomCell.m
//  fanwe_p2p
//
//  Created by mac on 14-8-4.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "HomeTableViewBottomCell.h"

@implementation HomeTableViewBottomCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(float)setCellContent:(NSString *) virtual_money_1 virtual_money_2:(NSString *)virtual_money_2 virtual_money_3:(NSString *) virtual_money_3{
    
    _transactionAmountLabel.text = virtual_money_1;
    _profitLabel.text = virtual_money_2;
    _securityLabel.text = virtual_money_3;
    return self.frame.size.height;
}

@end
