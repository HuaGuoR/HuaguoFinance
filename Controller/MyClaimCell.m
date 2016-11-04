//
//  MyClaimCell.m
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-15.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "MyClaimCell.h"

@implementation MyClaimCell

- (void)setContenCell:(TransList *)transList
{
    NSString *stat= transList.statues;
    self.statuesTitle.text = stat;
    [self.status setTitle:stat forState:UIControlStateNormal];
    self.title.text = transList.title;
    self.hmonth.text = transList.hmonth;
    self.smonth.text = transList.smonth;
    self.benjin.text = transList.benjin;
    self.lixi.text = transList.lixi;
    self.tansfermoney.text = transList.tranfermoney;
    self.time.text = transList.timeUp;
}

@end
