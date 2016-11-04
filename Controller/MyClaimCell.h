//
//  MyClaimCell.h
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-15.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransList.h"

@interface MyClaimCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *hmonth;//待还期数
@property (weak, nonatomic) IBOutlet UILabel *smonth;//总期数

@property (weak, nonatomic) IBOutlet UILabel *benjin;

@property (weak, nonatomic) IBOutlet UILabel *lixi;
@property (weak, nonatomic) IBOutlet UILabel *tansfermoney;//转让金额

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UIButton *status;
@property (weak, nonatomic) IBOutlet UIImageView *titleBg;
@property (weak, nonatomic) IBOutlet UILabel *statuesTitle;

- (void)setContenCell:(TransList*)transList;

@end
