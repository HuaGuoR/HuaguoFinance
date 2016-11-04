//
//  WithCashCell.h
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-13.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BankList;

@interface WithCashCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *bankCard;
@property (weak, nonatomic) IBOutlet UILabel *RealName;
@property (assign,nonatomic) NSInteger bankid;

-(void)setCellContent:(BankList*)list;
@end
