//
//  TransferController.m
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-19.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "TransferController.h"
#import "ExtendNSDictionary.h"
#import "MBProgressHUD.h"
#import "NetworkManager.h"
#import "FanweMessage.h"

@interface TransferController ()<HttpDelegate, MBProgressHUDDelegate>
{
    GlobalVariables *_fanweapp;
	NetworkManager *_netHttp;
	NSMutableArray *_lits;
    MBProgressHUD *HUD;
    float _max;
    NSInteger _currentdltid;
}

@end

@implementation TransferController

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
	_lits = [[NSMutableArray alloc]init];
    CGRect rect1 =  self.sumbit_btn.frame;
    rect1.origin.y = [UIScreen mainScreen].applicationFrame.size.height - 93;
    [self.sumbit_btn setFrame:rect1];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"确认转让";
    self.pwd.secureTextEntry = YES;
    self.pwd.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.tranferMoney.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    CGSize newSize = CGSizeMake(self.view.frame.size.width, 360);
    [self.scrollview setContentSize:newSize];
    
    CGRect tmp = self.bottomView.frame;
    tmp.size.height = 300;
    self.bottomView.frame = tmp;
    
    [self lodeNet:self.dlid];
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


- (void)lodeNet:(NSInteger)dlid
{
	NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
	[dict setValue:@"uc_to_transfer" forKey:@"act"];
	[dict setValue:_fanweapp.user_name forKey:@"email"];
	[dict setValue:_fanweapp.user_pwd forKey:@"pwd"];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)dlid] forKey:@"id"];
	[_netHttp startAsynchronous:dict addUserPwd:NO useDataCached:YES];
    [self showHUD];
}

- (void)lodeSubmitNet
{
	NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
	[dict setValue:@"uc_do_transfer" forKey:@"act"];
	[dict setValue:_fanweapp.user_name forKey:@"email"];
	[dict setValue:_fanweapp.user_pwd forKey:@"pwd"];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)self.dlid] forKey:@"dlid"];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)_currentdltid] forKey:@"dltid"];
    [dict setValue:self.tranferMoney.text forKey:@"transfer_money"];
    [dict setValue:self.pwd.text forKey:@"paypassword"];
	[_netHttp startAsynchronous:dict addUserPwd:NO useDataCached:YES];
    [self showHUD];
}

- (void)requestDone:(NSDictionary *)jsonDict error:(NSError *)error {
	if (jsonDict != nil) {
        if([jsonDict[@"act"] isEqualToString:@"uc_to_transfer"]){
            if([jsonDict toInt:@"user_login_status"]== 1 && [jsonDict toInt:@"response_code"] == 1){
                NSDictionary *dict = jsonDict[@"transfer"];
                self.subtitle.text = dict[@"name"];
                
                CGSize size = [self.subtitle.text sizeWithFont:self.subtitle.font constrainedToSize:CGSizeMake(self.subtitle.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                if (size.height > 40) {
                    //根据计算结果重新设置UILabel的尺寸
                    [self.subtitle setFrame:CGRectMake(14, 20, self.subtitle.frame.size.width, size.height)];
                    
                    [_headBg setFrame:CGRectMake(8, _headBg.frame.origin.y, self.view.frame.size.width - 16, self.subtitle.frame.size.height + 20)];
                    
                    [_bottomView setFrame:CGRectMake(0, _headBg.frame.origin.y + _headBg.frame.size.height, self.view.frame.size.width, 300)];
                    
                    CGSize newSize = CGSizeMake(self.view.frame.size.width, _bottomView.frame.origin.y + _bottomView.frame.size.height + 10);
                    [self.scrollview setContentSize:newSize];
                }
                
                self.time.text = dict[@"next_repay_time_format"];
                self.hmonth.text =[NSString stringWithFormat:@"%d",[dict toInt:@"how_much_month"]];
                self.smonth.text = [NSString stringWithFormat:@"%d",[dict toInt:@"repay_time"]];
                self.benjin.text =dict[@"left_benjin_format"];
                self.lixi.text = dict[@"left_lixi_format"];
                self.maxMoney.text = [dict toString:@"transfer_amount_format"];
                _max = [dict toFloat:@"all_must_repay_money"];
                _currentdltid = [dict toInt:@"dltid"];
                
            }else{
                [FanweMessage alert:jsonDict[@"show_err"]];
            }
        }else if([jsonDict[@"act"]isEqualToString:@"uc_do_transfer"]){
            if([jsonDict toInt:@"user_login_status"]== 1 && [jsonDict toInt:@"response_code"] == 1){
                [FanweMessage alert:@"转让成功！"];
                [[self navigationController] popToRootViewControllerAnimated:YES];
            }else{
                
                [FanweMessage alert:jsonDict[@"show_err"]];
            }
        }
        [self hideHUD];
	}else {
		[FanweMessage alert:@"服务器连接失败，请检查您的网络"];

        [self hideHUD];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitAction:(id)sender {
    if([self.tranferMoney.text isEqualToString:@""]|| [self.pwd.text isEqualToString:@""]){
        [FanweMessage alert:@"请输入完整信息！"];
    }else if(![_fanweapp isPureFloat:self.tranferMoney.text] ){
       [FanweMessage alert:@"您输入的转让金额有误，请重新输入!"];
    }else if([self.tranferMoney.text floatValue] > _max){
       [FanweMessage alert:@"您输入的转让金额大于最大金额，请重新输入!"];
    }else{
        [self lodeSubmitNet];
    }
}
@end
