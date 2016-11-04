//
//  MoreSettingController.h
//  fanwe_p2p
//
//  Created by mac on 14-7-31.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreSettingController : UIViewController{
    
    IBOutlet UIButton *_clearCacheBtn;
    IBOutlet UIButton *_serviceNumBtn;
    IBOutlet UIButton *_serviceEmailBtn;
    IBOutlet UIButton *_aboutUsBtn;
    IBOutlet UIButton *_checkVersionBtn;
    
    IBOutlet UIButton *_exitLoginBtn;
}

- (IBAction)clearCacheAction:(id)sender;
- (IBAction)serviceNumAction:(id)sender;
- (IBAction)aboutUsAction:(id)sender;
- (IBAction)checkVersionAction:(id)sender;

- (IBAction)exitLoginAction:(id)sender;

@end
