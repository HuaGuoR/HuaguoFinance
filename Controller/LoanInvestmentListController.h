//
//  LoanInvestmentListController.h
//  fanwe_p2p
//
//  Created by mac on 14-8-6.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoanInvestmentListController : UIViewController

@property (nonatomic, assign) BOOL is_back;
@property (nonatomic, retain) NSString *cid;
@property (nonatomic, retain) NSString *level;
@property (nonatomic, retain) NSString *interest;
@property (nonatomic, retain) NSString *deal_status;

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end
