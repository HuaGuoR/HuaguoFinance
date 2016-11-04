//
//  CashApplyController.h
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-13.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FreeConfig;
@class BankList;

@interface CashApplyController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *bancard;
@property (weak, nonatomic) IBOutlet UIImageView *bankimage;
@property (weak, nonatomic) IBOutlet UILabel *realName;
@property (weak, nonatomic) IBOutlet UILabel *commission;
@property (weak, nonatomic) IBOutlet UILabel *userMoney;
@property (weak, nonatomic) IBOutlet UILabel *realPayMoney;
@property (weak, nonatomic) IBOutlet UITextField *crashMoney;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@property (strong,nonatomic) FreeConfig *freeconfig;
@property (strong,nonatomic) BankList *banlist;

- (IBAction)sumbitAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end
