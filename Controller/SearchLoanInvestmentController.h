//
//  SearchLoanInvestmentController.h
//  fanwe_p2p
//
//  Created by mac on 14-8-11.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchLoanInvestmentController : UIViewController{
    
    IBOutlet UIView *_myTabView;
    IBOutlet UIView *_certificationMarkView; //认证标识
    IBOutlet UIImageView *_certificationLine;
    
    //level:等级; 0:全部;2:E以上; 3:D以上；4：C以上；5：B以上
    IBOutlet UIButton *_level_all;
    IBOutlet UIButton *_level_b;
    IBOutlet UIButton *_level_c;
    IBOutlet UIButton *_level_d;
    IBOutlet UIButton *_level_e;
    
    //interest：利率；0:不限; 10: 10%以上；12：12%以上；15：15%以上; 18:18%以上；
    IBOutlet UIButton *_rate_all;
    IBOutlet UIButton *_rate_10;
    IBOutlet UIButton *_rate_12;
    IBOutlet UIButton *_rate_15;
    IBOutlet UIButton *_rate_18;
    
    //deal_status：状态；0待等材料，1进行中，2满标，3流标，4还款中，5已还清；
    IBOutlet UIButton *_borrowing_state_all;
    IBOutlet UIButton *_borrowing_state_goon;
    IBOutlet UIButton *_borrowing_state_full_scale;
    IBOutlet UIButton *_borrowing_state_flow_standard;
    IBOutlet UIButton *_borrowing_state_repayment;
    IBOutlet UIButton *_borrowing_state_repaid;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

- (IBAction)levelAction:(id)sender;
- (IBAction)rateAction:(id)sender;
- (IBAction)borrowingStateAction:(id)sender;
- (IBAction)searchAction:(id)sender;

@end
