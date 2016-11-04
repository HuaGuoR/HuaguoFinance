//
//  HomeTableViewBottomCell.h
//  fanwe_p2p
//
//  Created by mac on 14-8-4.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewBottomCell : UITableViewCell{
    
    IBOutlet UILabel *_transactionAmountLabel;
    IBOutlet UILabel *_profitLabel;
    IBOutlet UILabel *_securityLabel;
}

-(float)setCellContent:(NSString *) virtual_money_1 virtual_money_2:(NSString *)virtual_money_2 virtual_money_3:(NSString *) virtual_money_3;

@end
