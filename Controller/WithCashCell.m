//
//  WithCashCell.m
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-13.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "WithCashCell.h"
#import "BankList.h"

@implementation WithCashCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellContent:(BankList*)list
{
    self.bankid = list.bankid;
    self.bankName.text = list.bankName;
    self.bankCard.text = list.bankcard;
    self.RealName.text = list.realName;
    self.image.contentMode = UIViewContentModeScaleAspectFit;
    self.image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:list.bankimage]]];
}

-(void)setFrame:(CGRect)frame
{
    
    frame = CGRectMake(frame.origin.x, frame.origin.y, 300, frame.size.height);
    [super setFrame:frame];
}
@end
