//
//  MyTenderController.h
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-19.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTenderController :UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *deleteView;
- (IBAction)submitAction:(id)sender;

@end
