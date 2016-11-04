//
//  RepaymentDetailsCell.h
//  fanwe_p2p
//
//  Created by mac on 14-8-18.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepaymentDetails.h"

@interface RepaymentDetailsCell : UITableViewCell{
    
    IBOutlet UILabel *_needRepaymentLabel;
    IBOutlet UILabel *_timeLabel;
    IBOutlet UILabel *_repaymentedLabel;
    IBOutlet UILabel *_manageMoneyLabel;
    IBOutlet UILabel *_needInterestLabel;
    IBOutlet UILabel *_overdueMoneyLabel;
}
@property (strong, nonatomic) IBOutlet UIImageView *sgsmentImg;

-(void)setCellContent:(RepaymentDetails *)repaymentDetails;

@end
