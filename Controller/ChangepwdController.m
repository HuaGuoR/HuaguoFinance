//
//  ChangepwdController.m
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-19.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "ChangepwdController.h"
#import "MBProgressHUD.h"
#import "FanweMessage.h"
#import "NetworkManager.h"
#import "ExtendNSDictionary.h"
#import "HomePageController.h"

@interface ChangepwdController ()<HttpDelegate, MBProgressHUDDelegate>
{
    GlobalVariables *_fanweapp;
	NetworkManager *_netHttp;
    MBProgressHUD *HUD;
}

@end

@implementation ChangepwdController


- (void)viewDidLoad
{
    [super viewDidLoad];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
		self.edgesForExtendedLayout = UIRectEdgeNone;
		self.extendedLayoutIncludesOpaqueBars = NO;
		self.modalPresentationCapturesStatusBarAppearance = NO;
		self.navigationController.navigationBar.translucent = NO;
		[self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
		                                                                 [UIColor whiteColor], UITextAttributeTextColor,
		                                                                 [UIColor whiteColor], UITextAttributeTextShadowColor,
		                                                                 [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0], UITextAttributeFont, nil]];
	}
#endif
    _fanweapp = [GlobalVariables sharedInstance];
	_netHttp = [[NetworkManager alloc] init];
	_netHttp.delegate = self;
    
}

- (void)showHUD {
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
    
	HUD.delegate = self;
	[HUD show:YES];
}

- (void)hideHUD {
	if (HUD)
		[HUD hide:YES];
}

- (void)lodeNet
{
	NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
	[dict setValue:@"uc_save_pwd" forKey:@"act"];
    [dict setValue:_fanweapp.user_name forKey:@"email"];
	[dict setValue:self.pwd1.text forKey:@"user_pwd"];
    [dict setValue:self.pwd2.text forKey:@"user_pwd_confirm"];
	[dict setValue:self.oldPwd.text forKey:@"pwd"];
	[_netHttp startAsynchronous:dict addUserPwd:NO useDataCached:YES];
}

- (void)requestDone:(NSDictionary *)jsonDict error:(NSError *)error {
	if (jsonDict != nil) {
		if ([jsonDict[@"act"] isEqualToString:@"uc_save_pwd"]) {
			if ([jsonDict toInt:@"response_code"] == 1) {
				[FanweMessage alert:@"密码修改成功,请重新登录！"];
                [_fanweapp setUserInfo:@"" user_name:@"" user_pwd:@""];
                HomePageController *home = [[HomePageController alloc]init];
                _fanweapp.indexNum = 1;
                [self.navigationController pushViewController:home animated:YES];
                
			}
			else {
				[FanweMessage alert:jsonDict[@"show_err"]];
			}
		
		[self hideHUD];
        }
    }else {
		[FanweMessage alert:@"服务器连接失败，请检查您的网络"];
		[self hideHUD];
	}
}


- (IBAction)submitAction:(id)sender {
    NSString *old = self.oldPwd.text;
    NSString *new1 = self.pwd1.text;
    NSString *new2 = self.pwd2.text;
    if([old isEqualToString:@""] || [new1 isEqualToString:@""] || [new2 isEqualToString:@""]){
        [FanweMessage alert:@"请填写完整信息！"];
        return;
    }else if(![old isEqualToString:_fanweapp.user_pwd]){
        [FanweMessage alert:@"您输入的旧密码错误，请重新输入!"];
        return;
    }else if(![new1 isEqualToString:new2]){
        [FanweMessage alert:@"您输入的两次新密码不一致，请重新输入！"];
        return;
    }else{
        [self lodeNet];
    }
}
@end
