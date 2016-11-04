//
//  MineController.h
//  fanwe_p2p
//
//  Created by mac on 14-7-29.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UIButton *goupName;

@property (weak, nonatomic) IBOutlet UILabel *toalMoney;

@property (weak, nonatomic) IBOutlet UILabel *money;

@property (weak, nonatomic) IBOutlet UILabel *lockMoney;
/**
 *  充值提现
 */
- (IBAction)myCharge:(id)sender;
/**
 *  我的投资
 */
- (IBAction)myInvestAction:(id)sender;
/**
 *  债权转让
 */
- (IBAction)myTransferAction:(id)sender;
/**
 *  我关注的标
 */
- (IBAction)myCollectAction:(id)sender;
/**
 *  投标记录
 */
- (IBAction)myLendAction:(id)sender;
/**
 *  偿还贷款
 */
- (IBAction)reFundAction:(id)sender;
/**
 *  已发布的贷款
 */
- (IBAction)myBorrowedAction:(id)sender;
/**
 *  修改密码
 */
- (IBAction)resetPwdAction:(id)sender;

@end
