//
//  ResetPasswordController.m
//  fanwe_p2p
//
//  Created by mac on 14-7-30.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "ResetPasswordController.h"
#import "FanweMessage.h"
#import "ExtendNSDictionary.h"
#import "MineController.h"

@interface ResetPasswordController (){
    UIButton *backButton;
    MBProgressHUD *HUD;
	NetworkManager *netHttp;
    GlobalVariables *fanweApp;
    
    int djs_end_time; //60秒后重新获取验证码
    NSTimer *addDjsTimer;
}

@end

@implementation ResetPasswordController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=7){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                         [UIColor whiteColor],UITextAttributeTextColor,
                                                                         [UIColor whiteColor], UITextAttributeTextShadowColor,
                                                                         [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0], UITextAttributeFont, nil]];
    }
#endif
    
    self.navigationItem.title = @"找回密码";
    [self layoutNavButton];
    fanweApp = [GlobalVariables sharedInstance];
    netHttp = [[NetworkManager alloc] init];
}

- (void)layoutNavButton{
	
    CGSize backButtonSize = CGSizeMake(50, 30);
	
	backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	backButton.tag = 0;
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
	
	backButton.frame = CGRectMake(backButton.frame.origin.x, backButton.frame.origin.y, backButtonSize.width, backButtonSize.height);
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
	[backButton setImage:[UIImage imageNamed:@"ico_back.png"] forState:UIControlStateNormal];
	
	UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
}

- (void)backAction:(id)sender
{
	UIButton *btn = sender;
	if (btn.tag == 0){
		[self.navigationController popViewControllerAnimated:YES];
	}else {
		[self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:btn.tag] animated:YES];
	}
}

//手机号码正则表达式
- (BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        
        return YES;
    }
    else
    {
        
        return NO;
    }
}

-(void)handleTimer
{
	
	if(djs_end_time>=0)
	{
        [_obtainVerifiBtn setUserInteractionEnabled:NO];
        [_obtainVerifiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		int sec = ((djs_end_time%(24*3600))%3600)%60;
        [_obtainVerifiBtn setTitle:[NSString stringWithFormat:@"(%d)重发验证码",sec] forState:UIControlStateNormal];
        
	}
	else
	{
        [_obtainVerifiBtn setUserInteractionEnabled:YES];
        [_obtainVerifiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_obtainVerifiBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
		
		[addDjsTimer invalidate];
        
	}
	djs_end_time = djs_end_time - 1;
}

- (IBAction)obtainVerifiAction:(id)sender {
    if ([_telNumField.text length] == 0) {
        [FanweMessage alert:@"请输入您的电话号码"];
    }else{
        if ([self validateMobile:_telNumField.text]) {
            
            djs_end_time = 59;
            [self handleTimer];
            addDjsTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
            [self loadNetData];
            
        }else{
            [FanweMessage alert:@"您输入的电话号码格式不正确"];
        }
    }
}

-(void)loadNetData{
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	HUD.delegate = self;
	[HUD show:YES];
	
	NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
	[parmDict setObject:@"send_reset_pwd_code" forKey:@"act"];
    [parmDict setObject:_telNumField.text forKey:@"mobile"];
	
    netHttp.delegate = self;
    [netHttp startAsynchronous:parmDict addUserPwd:false useDataCached:false];
	
}

- (IBAction)submitAction:(id)sender {
	
    if ([_telNumField.text length] == 0){
		
		[FanweMessage alert:@"电话号码不能为空"];
		return;
	}
	
	if ([_verificationCodeField.text length] == 0){
		
		[FanweMessage alert:@"验证码不能为空"];
		return;
	}
    
	if ([_passwordField.text length] == 0) {
        [FanweMessage alert:@"密码不能为空"];
		return;
    }
	
	if (![_passwordField.text isEqualToString:_passConfirmField.text]){
		
		[FanweMessage alert:@"两次输入的密码不相同"];
		return;
	}
    
	[self loadNetData2];
}

-(void)loadNetData2{
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	HUD.delegate = self;
	[HUD show:YES];
	
	NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
	[parmDict setObject:@"save_reset_pwd" forKey:@"act"];
	[parmDict setObject:_passwordField.text forKey:@"user_pwd"];
    [parmDict setObject:_passConfirmField.text forKey:@"user_pwd_confirm"];
    [parmDict setObject:_telNumField.text forKey:@"mobile"];
    [parmDict setObject:_verificationCodeField.text forKey:@"mobile_code"];
	
    netHttp.delegate = self;
    [netHttp startAsynchronous:parmDict addUserPwd:false useDataCached:false];
	
}

-(void)requestDone:(NSDictionary *) jsonDict error:(NSError *) error{
    if (HUD)
        [HUD hide:YES];
    if (jsonDict != nil){
        if ([[jsonDict toString:@"act"] isEqualToString:@"send_reset_pwd_code"]) {
            //response_code: 1:验证码发送成功; 0:验证码发送失败
            if ([jsonDict toInt:@"response_code"] == 1) {
                
            }else{
                [FanweMessage alert:[jsonDict toString:@"show_err"]];
            }
            
        }else if([[jsonDict toString:@"act"] isEqualToString:@"save_reset_pwd"]){
            //response_code: 1:密码更新成功; 0:密码更新失败;
            if ([jsonDict toInt:@"response_code"] == 1) {
                [FanweMessage alert:[NSString stringWithFormat:@"%@，请重新登录！",[jsonDict toString:@"show_err"]]];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [FanweMessage alert:[jsonDict toString:@"show_err"]];
            }
            
        }
		
    }else{
        [FanweMessage alert:@"服务器访问失败"];
    }
    
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
	HUD = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
