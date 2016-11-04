//
//  TransferController.h
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-19.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransList.h"

@interface TransferController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *hmonth;//待还
@property (weak, nonatomic) IBOutlet UILabel *smonth;//总期数
@property (weak, nonatomic) IBOutlet UILabel *benjin;
@property (weak, nonatomic) IBOutlet UILabel *lixi;
@property (weak, nonatomic) IBOutlet UILabel *maxMoney;
@property (weak, nonatomic) IBOutlet UITextField *tranferMoney;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UIButton *sumbit_btn;

@property (strong, nonatomic) IBOutlet UIButton *headBg;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

@property (strong,nonatomic) TransList *translist;
@property (assign,nonatomic)NSInteger dlid;


- (IBAction)submitAction:(id)sender;

@end
