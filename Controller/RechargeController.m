//
//  RechargeController.m
//  fanwe_p2p
//
//  Created by mac on 14-8-7.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "RechargeController.h"
#import "STSegmentedControl.h"
#import "OnlinePaymentController.h"
#import "OfflinePaymentController.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "ExtendNSDictionary.h"
#import "FanweMessage.h"
#import "MyWebViewController.h"

@interface RechargeController ()<HttpDelegate,MBProgressHUDDelegate,OnlinePaymentDelegate,OfflinePaymentDelegate>{
    STSegmentedControl* segment;
    UIButton *backButton;
    NSMutableDictionary *ctlCache;
    
    MBProgressHUD *HUD;
	NetworkManager *netHttp;
    NSString *paymentIdStr;
    NSString *bankIdStr;
    NSString *moneyStr;
    NSString *serialNumStr;
}

@end

@implementation RechargeController

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
    self.navigationItem.title = nil;
    [self layoutNavButton];
    netHttp = [[NetworkManager alloc] init];
    
    ctlCache = [[NSMutableDictionary alloc] init];
    
    NSArray *buttonNames = [NSArray arrayWithObjects:@"线上支付", @"线下支付", nil];
	segment = [[STSegmentedControl alloc] initWithItems:buttonNames];
	segment.frame = CGRectMake(10, 10, 180, 40);
	[segment addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
	segment.selectedSegmentIndex = -1;
	segment.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    segment.center = CGPointMake(self.navigationController.navigationBar.bounds.size.width / 2, self.navigationController.navigationBar.bounds.size.height / 2);
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar addSubview:segment];
    
}

- (void)viewDidAppear:(BOOL)animated {
    if (segment.selectedSegmentIndex == -1){
        segment.selectedSegmentIndex = 0;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [segment removeFromSuperview];
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

- (void)valueChanged:(id)sender {
    
	STSegmentedControl *control = sender;
    
    NSString *segIndexKey = [NSString stringWithFormat:@"%ld",(long)control.selectedSegmentIndex];
    if (control.selectedSegmentIndex == 0){
        OnlinePaymentController *onlinePaymentController = (OnlinePaymentController *)[ctlCache objectForKey:segIndexKey];
        if (!onlinePaymentController){
            onlinePaymentController = [[OnlinePaymentController alloc] init];
            onlinePaymentController.delegate = self;
            [ctlCache setObject:onlinePaymentController forKey:segIndexKey];
        }
        
        for (UIView *view in [self.view subviews]) {
            [view removeFromSuperview];
        }
        
        
        [self.view addSubview:onlinePaymentController.view];
        
    }else if (control.selectedSegmentIndex == 1){
        OfflinePaymentController *offlinePaymentController = (OfflinePaymentController *)[ctlCache objectForKey:segIndexKey];
        if (!offlinePaymentController){
            offlinePaymentController = [[OfflinePaymentController alloc] init];
            offlinePaymentController.delegate = self;
            [ctlCache setObject:offlinePaymentController forKey:segIndexKey];
        }
        
        for (UIView *view in [self.view subviews]) {
            [view removeFromSuperview];
        }
        
        [self.view addSubview:offlinePaymentController.view];
    }
    
}

#pragma 线上充值
- (void)onlinePaymentAction:(NSString *) payment_id money:(NSString *)money{
    [self loadNetData:payment_id money:money];
}

#pragma 线下充值
- (void)offlinePaymentAction:(NSMutableDictionary *) tmpDict{
    paymentIdStr = [tmpDict objectForKey:@"0"];
    bankIdStr = [tmpDict objectForKey:@"1"];
    moneyStr = [tmpDict objectForKey:@"2"];
    serialNumStr = [tmpDict objectForKey:@"3"];
    
    [self loadNetData:paymentIdStr bank_id:bankIdStr money:moneyStr serialNum:serialNumStr];
}

-(void)loadNetData:(NSString *) payment_id money:(NSString *)money{
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	HUD.delegate = self;
	[HUD show:YES];
	
	NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
	[parmDict setObject:@"uc_save_incharge" forKey:@"act"];
    [parmDict setObject:payment_id forKey:@"payment_id"];
    [parmDict setObject:money forKey:@"money"];
	
    netHttp.delegate = self;
    [netHttp startAsynchronous:parmDict addUserPwd:YES useDataCached:false];
	
}

-(void)loadNetData:(NSString *)pay_id bank_id:(NSString *)bank_id money:(NSString *)money serialNum:(NSString *)serialNum{
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	HUD.delegate = self;
	[HUD show:YES];
	
	NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
	[parmDict setObject:@"uc_save_incharge" forKey:@"act"];
    [parmDict setObject:pay_id forKey:@"payment_id"];
    [parmDict setObject:bank_id forKey:@"bank_id"];
    [parmDict setObject:money forKey:@"money"];
    [parmDict setObject:serialNum forKey:@"memo"];
	
    netHttp.delegate = self;
    [netHttp startAsynchronous:parmDict addUserPwd:YES useDataCached:false];
	
}

-(void)requestDone:(NSDictionary *) jsonDict error:(NSError *) error{
    if (HUD)
        [HUD hide:YES];
    if (jsonDict != nil){
        //response_code:服务器返回成功（1：成功；0：失败）
        if ([jsonDict toInt:@"response_code"] == 1){
            //pay_type 1:wap网页支付; 2:线下充值
            if ([jsonDict toInt:@"pay_type"] == 1) {
                MyWebViewController *tmpController = [[MyWebViewController alloc]
                                                      initWithNibName:@"MyWebViewController"
                                                      bundle:nil];
                tmpController.url = [jsonDict toString:@"pay_wap"];
                tmpController.titleStr = @"支付";
                [[self navigationController] pushViewController:tmpController animated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
                [FanweMessage alert:[jsonDict toString:@"show_err"]];
            }
            
        }else {
            [FanweMessage alert:[jsonDict toString:@"show_err"]];
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
