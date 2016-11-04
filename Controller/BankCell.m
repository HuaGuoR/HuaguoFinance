//
//  BankCell.m
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-13.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "BankCell.h"
#import "OneBank.h"
@implementation BankCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCellContent:(OneBank*)list{
    _bankName.text = list.bankName;
     MyLog(@"%@,%@",self.bankName.text,list.bankName);
}

- (void)setFrame:(CGRect)frame
{
    frame = CGRectMake(frame.origin.x, frame.origin.y, 179, frame.size.height);
    [super setFrame:frame];
    
}
@end
