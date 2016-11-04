//
//  LoginController.h
//  fanwe_p2p
//
//  Created by mac on 14-7-29.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "MBProgressHUD.h"

@interface LoginController : UIViewController<HttpDelegate,MBProgressHUDDelegate>{
    IBOutlet UITextField *_userNameField;
    IBOutlet UITextField *_passwordField;
    BOOL is_mine; //登录成功后是否跳转到个人中心
}

@property (nonatomic,assign) BOOL is_mine;

- (IBAction)loginAction:(id)sender;
- (IBAction)ResetPwdAction:(id)sender;
- (IBAction)registerAction:(id)sender;

@end
