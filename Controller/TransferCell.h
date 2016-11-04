//
//  TransferCell.h
//  fanwe_p2p
//
//  Created by mac on 14-8-13.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transfer.h"

@interface TransferCell : UITableViewCell{
    
    IBOutlet UIButton *_userNameBtn;
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_principalLabel;
    IBOutlet UILabel *_interestLabel;
    IBOutlet UILabel *_transferPriceLabel;
    IBOutlet UILabel *_interestRatesLabel;
    
    IBOutlet UILabel *_transferStateLabel;
    IBOutlet UILabel *_undertakePeopleLabel;
}

-(float)setCellContent:(Transfer *) transfer;

@end
