//
//  CashApplyController.m
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-13.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "CashApplyController.h"
#import "MBProgressHUD.h"
#import "NetworkManager.h"
#import "FanweMessage.h"
#import "GlobalVariables.h"
#import "BankList.h"
#import "FreeConfig.h"

@interface CashApplyController ()<HttpDelegate,MBProgressHUDDelegate>
{
    GlobalVariables *_fanweapp;
	NetworkManager *_netHttp;
    MBProgressHUD *HUD;
    NSMutableArray *_lits;
    float _userrealMoney;//用户余额
    UIButton *_rightButton;
}

@end

@implementation CashApplyController


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
    self.title = @"申请提现";
    _fanweapp = [GlobalVariables sharedInstance];
	_netHttp = [[NetworkManager alloc] init];
	_netHttp.delegate = self;
    _lits = [[NSMutableArray alloc]init];
    self.crashMoney.delegate = self;
    self.view.backgroundColor = kColor(243, 243, 243);
    
    
    self.bancard.text = self.banlist.bankcard;
    self.realName.text = self.banlist.realName;
    self.bankimage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.banlist.bankimage]]];
    [self lodeRefreshNet];
    
    [self layoutNavButton];
    
    CGRect rect1 =  self.submitBtn.frame;
    rect1.origin.y = [UIScreen mainScreen].applicationFrame.size.height - 92;
    [self.submitBtn setFrame:rect1];
    
    self.pwd.secureTextEntry = YES;
    self.crashMoney.keyboardType = UIKeyboardTypeNumberPad;
    self.pwd.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
}

-(void) viewDidAppear:(BOOL)animated{
    
    self.scrollview.frame = CGRectMake(0, 0, 320, 480);
    
    [self.scrollview setContentSize:CGSizeMake(320, 600)];
    
}

- (void)layoutNavButton {
	CGSize leftButtonSize = CGSizeMake(33, 29);
	_rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
	[_rightButton addTarget:self action:@selector(refreshUserbyNet) forControlEvents:UIControlEventTouchUpInside];
    
	_rightButton.frame = CGRectMake(0, 0, leftButtonSize.width, leftButtonSize.height);
	_rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
	[_rightButton setTitle:@"刷新" forState:UIControlStateNormal];
    
	UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
	self.navigationItem.rightBarButtonItem = right;
}

- (void)refreshUserbyNet
{
    [self lodeRefreshNet];
}


- (void)showHUD
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	HUD.delegate = self;
	[HUD show:YES];
}

- (void)hideHUD
{
    if (HUD)
        [HUD hide:YES];
    
}

#pragma  mark - 刷新用户余额
- (void)lodeRefreshNet {
    [self showHUD];
	NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
	[dict setValue:@"refresh_user" forKey:@"act"];
	[dict setValue:_fanweapp.user_name forKey:@"email"];
	[dict setValue:_fanweapp.user_pwd forKey:@"pwd"];
    [dict setValue:_fanweapp.user_id forKey:@"Id"];
	[_netHttp startAsynchronous:dict addUserPwd:NO useDataCached:YES];
}


#pragma  mark - 银行提现
- (void)submitNet {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
	[dict setValue:@"uc_save_carry" forKey:@"act"];
	[dict setValue:_fanweapp.user_name forKey:@"email"];
	[dict setValue:_fanweapp.user_pwd forKey:@"pwd"];
    [dict setValue:[NSString stringWithFormat:@"%d",self.banlist.bankid] forKey:@"bid"];
    [dict setValue:self.pwd.text forKey:@"paypassword"];
    [dict setValue:self.crashMoney.text forKey:@"amount"];
	[_netHttp startAsynchronous:dict addUserPwd:NO useDataCached:YES];
    [self showHUD];
}

- (void)requestDone:(NSDictionary *)jsonDict error:(NSError *)error {
	if (jsonDict != nil) {
		if ([jsonDict[@"act"] isEqualToString:@"refresh_user"]) {
			if ([jsonDict[@"user_login_status"] intValue] == 1 && [jsonDict[@"response_code"] intValue] == 1) {
                self.userMoney.text = jsonDict[@"user_money_format"];
                _userrealMoney = [jsonDict[@"user_money"] floatValue];
            }else{
                [FanweMessage alert:jsonDict[@"show_err"]];
            }
            [self hideHUD];
		}else if([jsonDict[@"act"] isEqualToString:@"uc_save_carry"]){
            if([jsonDict[@"response_code"]intValue] == 1){
                
                [FanweMessage alert:@"提现成功！"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [FanweMessage alert:@"提现失败,请检查您的密码，或稍后再试！"];
            }
            [self hideHUD];
        }
	}
	else {
		[FanweMessage alert:@"服务器连接失败，请检查您的网络"];
        [self hideHUD];
	}
}



#pragma mark -金额输入框代理
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    float amout = [textField.text floatValue];
//    int commsion = -1;
    if(amout >= self.freeconfig.free1_1 && amout <= self.freeconfig.free1_2)
    {
        self.commission.text = self.freeconfig.freeMoney1;
    }else if(amout >= self.freeconfig.free2_1 && amout <= self.freeconfig.free2_2){
        self.commission.text = self.freeconfig.freeMoney1;
         self.realPayMoney.text =[NSString stringWithFormat:@"%.2f",(amout + [self.commission.text floatValue])];
    }else{
        self.commission.text = self.freeconfig.freeMoney2;
         self.realPayMoney.text =[NSString stringWithFormat:@"%.2f",(amout + [self.commission.text floatValue])];
    }
    
   
}
- (IBAction)sumbitAction:(id)sender {
    if([self.crashMoney.text isEqualToString:@""]){
        [FanweMessage alert:@"请输入提取金额。"];
    }else if([self.pwd.text isEqualToString:@""]){
        [FanweMessage alert:@"请输入支付密码。"];
    }else{
        if(_userrealMoney < [self.crashMoney.text floatValue]){
           [FanweMessage alert:@"您的余额不足。"];
        }else{
            
        [self submitNet];
        }
    }
}
@end
