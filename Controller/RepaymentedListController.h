//
//  RepaymentListController.h
//  fanwe_p2p
//
//  Created by mac on 14-8-15.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RepaymentedListDelegate;

@interface RepaymentedListController : UITableViewController

@property (nonatomic, retain) id<RepaymentedListDelegate> delegate;

@end

@protocol RepaymentedListDelegate <NSObject>

@required

- (void)repaymentedDetailsAction:(NSString *)app_url; //点击详情

@end
