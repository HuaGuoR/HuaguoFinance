//
//  RepaymentedCell.h
//  fanwe_p2p
//
//  Created by mac on 14-8-19.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Repaymented.h"

@interface RepaymentedCell : UITableViewCell{
    
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_timeLabel;
    IBOutlet UILabel *_rateLabel;
    IBOutlet UILabel *_limitTimeLabel;
    IBOutlet UILabel *_payMoneyLabel;
}

-(void)setCellContent:(Repaymented *)repaymented;

@end
