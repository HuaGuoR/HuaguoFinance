//
//  HomeTableViewTopCell.h
//  fanwe_p2p
//
//  Created by mac on 14-8-1.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Home.h"

@interface HomeTableViewTopCell : UITableViewCell{
    
    IBOutlet UILabel *_statusLabel;
    IBOutlet UILabel *_nameLabel;
    IBOutlet UILabel *_moneyLabel;
    IBOutlet UILabel *_rateLabel;
    IBOutlet UILabel *_timeLabel;
    IBOutlet UIImageView *_headBgImg;
}

-(float)setCellContent:(Home *) home;

@end
