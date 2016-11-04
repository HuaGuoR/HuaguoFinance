//
//  ProjectDetailsController.h
//  fanwe_p2p
//
//  Created by mac on 14-8-5.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Home.h"

@interface ProjectDetailsController : UIViewController{
    
    IBOutlet UIView *_myTabView;
    
    IBOutlet UILabel *_nameLabel;
    IBOutlet UILabel *_idLabel;
    IBOutlet UILabel *_borrowingBalanceLabel;
    IBOutlet UILabel *_investmentAmountLabel;
    IBOutlet UILabel *_minimumAmountLabel;
    
    IBOutlet UILabel *_rateLabel;
    IBOutlet UILabel *_timeLabel;
    IBOutlet UILabel *_repaymentMethodLabel;
    IBOutlet UILabel *_riskRankLabel;
    IBOutlet UILabel *_remainingTimeLabel;
    
    IBOutlet UIButton *_headBg;
    IBOutlet UIView *_middleView;
    IBOutlet UIView *_bottomView;
    
}

@property (nonatomic, retain) Home *home;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

- (IBAction)seeDetailsAction:(id)sender;
- (IBAction)investAction:(id)sender;

@end
