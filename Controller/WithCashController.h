//
//  WithCashController.h
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-13.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithCashController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *headView;
- (IBAction)addBankAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *myTableVIew;
@property (weak, nonatomic) IBOutlet UIView *deleteView;
- (IBAction)deleteAction:(id)sender;

@end
