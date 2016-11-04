//
//  MyLogController.h
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-12.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLogController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *myTable;
- (IBAction)rechargeAction:(id)sender;//充值
- (IBAction)withdrawAction:(id)sender;//提现

@end
