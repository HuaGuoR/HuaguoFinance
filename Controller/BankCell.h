//
//  BankCell.h
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-13.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OneBank;

@interface BankCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bankName;

- (void)setCellContent:(OneBank*)list;
@end
