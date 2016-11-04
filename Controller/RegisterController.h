//
//  RegisterController.h
//  fanwe_p2p
//
//  Created by mac on 14-7-29.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "MBProgressHUD.h"


@interface RegisterController : UIViewController<UITextFieldDelegate,HttpDelegate,MBProgressHUDDelegate>{
    
    IBOutlet UITextField *_userNameField;
    IBOutlet UITextField *_passwordField;
    IBOutlet UITextField *_passConfirmField;
    
    IBOutlet UITextField *_telNumField;
    IBOutlet UITextField *_verificationCodeField;
    
    IBOutlet UIButton *_obtainVerifiBtn;
}

- (IBAction)obtainVerifiAction:(id)sender;
- (IBAction)registerAction:(id)sender;

@end
