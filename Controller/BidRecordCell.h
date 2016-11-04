//
//  BidRecordCell.h
//  fanwe_p2p
//
//  Created by mac on 14-8-19.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BidRecord.h"

@interface BidRecordCell : UITableViewCell{
    
    IBOutlet UILabel *_statusLabel;
    IBOutlet UILabel *_nameLabel;
    IBOutlet UILabel *_moneyLabel;
    IBOutlet UILabel *_rateLabel;
    IBOutlet UILabel *_timeLabel;
    IBOutlet UILabel *_bidTimeLabel;
    IBOutlet UIImageView *_headBgImg;
}

-(float)setCellContent:(BidRecord *) home;

@end
