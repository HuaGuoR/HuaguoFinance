//
//  ResetPasswordController.h
//  fanwe_p2p
//
//  Created by mac on 14-7-30.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "MBProgressHUD.h"

@interface ResetPasswordController : UIViewController<UITextFieldDelegate,HttpDelegate,MBProgressHUDDelegate>{
    
    IBOutlet UITextField *_telNumField;
    IBOutlet UITextField *_verificationCodeField;
    IBOutlet UIButton *_obtainVerifiBtn;
    
    IBOutlet UITextField *_passwordField;
    IBOutlet UITextField *_passConfirmField;
    
}

- (IBAction)obtainVerifiAction:(id)sender;
- (IBAction)submitAction:(id)sender;

@end
