//
//  AdvanceRepaymentDetailsController.m
//  fanwe_p2p
//
//  Created by mac on 14-8-15.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "AdvanceRepaymentDetailsController.h"
#import "FanweMessage.h"
#import "NetworkManager.h"
#import "ExtendNSDictionary.h"
#import "MBProgressHUD.h"
#import "RechargeController.h"

@interface AdvanceRepaymentDetailsController ()<HttpDelegate,MBProgressHUDDelegate>{
    UIButton *backButton;
    NetworkManager *netHttp;
    MBProgressHUD *HUD;
}

@end

@implementation AdvanceRepaymentDetailsController

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
    
    netHttp = [[NetworkManager alloc] init];
    self.navigationItem.title = @"提前还款";
    [self layoutNavButton];
    
    [self.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].applicationFrame.size.height)];
    CGRect rect =  self.scrollview.frame;
    rect.size.height = [UIScreen mainScreen].applicationFrame.size.height - 105;
    rect.origin.x = 0;
    rect.origin.y = 44;
    [self.scrollview setFrame:rect];
    
    CGRect rect1 =  _myTabView.frame;
    rect1.origin.y = [UIScreen mainScreen].applicationFrame.size.height - 94;
    [_myTabView setFrame:rect1];
    
    CGSize newSize = CGSizeMake(self.view.frame.size.width, 445);
    [self.scrollview setContentSize:newSize];
    
    [self loadNetData];
}

- (void)layoutNavButton{
	
    CGSize backButtonSize = CGSizeMake(50, 30);
	
	backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	backButton.tag = 0;
    [backButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
	
	backButton.frame = CGRectMake(backButton.frame.origin.x, backButton.frame.origin.y, backButtonSize.width, backButtonSize.height);
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
	[backButton setImage:[UIImage imageNamed:@"ico_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

- (void)btnAction:(id)sender
{
    UIButton *btn = sender;
    if (btn.tag == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:btn.tag] animated:YES];
    }
}

#pragma 加载数据
-(void)loadNetData{
	
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	HUD.delegate = self;
	[HUD show:YES];
    
	NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
	[parmDict setObject:@"uc_inrepay_refund" forKey:@"act"];
    [parmDict setObject:self.repayment_id forKey:@"id"];
	
    netHttp.delegate = self;
    [netHttp startAsynchronous:parmDict addUserPwd:YES useDataCached:false];
	
}

#pragma 确认还款
-(void)loadNetData2{
	
	NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
	[parmDict setObject:@"uc_do_inrepay_refund" forKey:@"act"];
    [parmDict setObject:self.repayment_id forKey:@"id"];
	
    netHttp.delegate = self;
    [netHttp startAsynchronous:parmDict addUserPwd:YES useDataCached:false];
	
}

-(void)requestDone:(NSDictionary *) jsonDict error:(NSError *) error{
    [HUD hide:YES];
    
    if (jsonDict != nil){
        
        if ([@"uc_inrepay_refund" isEqualToString:[jsonDict toString:@"act"]]) {
            id tmpJsoinDict = [jsonDict objectForKey:@"deal"];
            
            _titleLabel.text = [tmpJsoinDict toString:@"sub_name"];
            _loanMoneyLabel.text = [tmpJsoinDict toString:@"borrow_amount_format"];
            _rateLabel.text = [tmpJsoinDict toString:@"rate_foramt_w"];
            _repaymentedLabel.text = [NSString stringWithFormat:@"￥%.2f",[tmpJsoinDict toFloat:@"repay_money"]];
            //repay_time_type 总时间的单位 0：天  1：月
            if ([tmpJsoinDict toInt:@"repay_time_type"] == 1) {
                _timeLabel.text = [NSString stringWithFormat:@"%d个月",[tmpJsoinDict toInt:@"repay_time"]];
            }else{
                _timeLabel.text = [NSString stringWithFormat:@"%d天",[tmpJsoinDict toInt:@"repay_time"]];
            }
            
            _manageMoneyLabel.text = [tmpJsoinDict toString:@"month_manage_money_format"];
            _punitiveInterestLabel.text = [jsonDict toString:@"impose_money_format"];
            _shouldPayLabel.text = [jsonDict toString:@"total_repay_money_format"];
            
            _totalPayLabel.text = [jsonDict toString:@"true_total_repay_money_format"];
            
        }else if([@"uc_do_inrepay_refund" isEqualToString:[jsonDict toString:@"act"]]){
            //response_code 服务器返回成功（1：成功；0：失败）
            if([jsonDict toInt:@"response_code"] == 1){
                [FanweMessage alert:@"操作成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [FanweMessage alert:[jsonDict toString:@"show_err"]];
            }

        }
        
    }else{
        [FanweMessage alert:@"服务器访问失败"];
    }
    
}

#pragma 充值
- (IBAction)rechargeAction:(id)sender {
    RechargeController *tmpController = [[RechargeController alloc] init];
    [[self navigationController]pushViewController:tmpController animated:YES];
}

#pragma 确认还款
- (IBAction)confirmPayAction:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确认还款吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark uialertViewdail
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    if (buttonIndex == 1) {
        [self loadNetData2];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
