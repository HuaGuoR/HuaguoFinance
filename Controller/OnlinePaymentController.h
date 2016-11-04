//
//  OnlinePaymentController.h
//  fanwe_p2p
//
//  Created by mac on 14-8-7.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OnlinePaymentDelegate;

@interface OnlinePaymentController : UIViewController{
    
    IBOutlet UIView *_myTabView;
    IBOutlet UITextField *_moneyTextField;
    id<OnlinePaymentDelegate> delegate;
}

@property (nonatomic, retain) id<OnlinePaymentDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

- (IBAction)rechargeAction:(id)sender;

@end

@protocol OnlinePaymentDelegate <NSObject>

@required
//线上充值
- (void)onlinePaymentAction:(NSString *) payment_id money:(NSString *)money;
@end
