//
//  ChangepwdController.h
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-19.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangepwdController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *oldPwd;
@property (weak, nonatomic) IBOutlet UITextField *pwd1;
@property (weak, nonatomic) IBOutlet UITextField *pwd2;
- (IBAction)submitAction:(id)sender;

@end
