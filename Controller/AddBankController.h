//
//  AddBankController.h
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-13.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBankController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *dealBank;
@property (weak, nonatomic) IBOutlet UITextField *bankCard;
- (IBAction)sumbitAction:(id)sender;
- (IBAction)openTableAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *bankName;
@property (weak, nonatomic) IBOutlet UIButton *sumbitBtn;

@property (weak, nonatomic) IBOutlet UILabel *realName;
@property (weak, nonatomic) IBOutlet UITableView *banTable;
- (IBAction)hideBankMenu:(id)sender;


@end
