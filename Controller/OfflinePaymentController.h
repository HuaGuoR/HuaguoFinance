//
//  OnlinePaymentController.h
//  fanwe_p2p
//
//  Created by mac on 14-8-7.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OfflinePaymentDelegate;

@interface OfflinePaymentController : UIViewController{
    
    IBOutlet UIView *_myTabView;
    IBOutlet UITextField *_moneyTextField;
    IBOutlet UITextField *_serialNumTextField;
    
    id<OfflinePaymentDelegate> delegate;
}

@property (nonatomic, retain) id<OfflinePaymentDelegate> delegate;

- (IBAction)rechargeAction:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end

@protocol OfflinePaymentDelegate <NSObject>

@required
//线下充值
- (void)offlinePaymentAction:(NSMutableDictionary *) tmpDict;
@end
