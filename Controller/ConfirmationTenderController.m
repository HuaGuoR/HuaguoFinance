//
//  ConfirmationTenderController.m
//  fanwe_p2p
//
//  Created by mac on 14-8-5.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "ConfirmationTenderController.h"
#import "MyWebViewController.h"
#import "FanweMessage.h"
#import "NetworkManager.h"
#import "GlobalVariables.h"
#import "ExtendNSDictionary.h"
#import "LoginController.h"
#import "RechargeController.h"

@interface ConfirmationTenderController ()<HttpDelegate>{
    UIButton *backButton;
    NetworkManager *netHttp;
    GlobalVariables *fanweApp;
}

@end

@implementation ConfirmationTenderController

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
    fanweApp = [GlobalVariables sharedInstance];
    self.navigationItem.title = @"确认投标";
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
    
    CGRect tmp = _payView.frame;
    tmp.size.height = 120;
    _payView.frame = tmp;
    
    CGSize newSize = CGSizeMake(self.view.frame.size.width, 430);
    [self.scrollview setContentSize:newSize];
    
    [self initMyView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (fanweApp.is_login) {
        //刷新余额
        [self loadNetData2];
    }else{
        _balanceLabel.text = @"您还未登录";
    }
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
    if (sender == backButton) {
        UIButton *btn = sender;
        if (btn.tag == 0){
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:btn.tag] animated:YES];
        }
    }else{
        
        
    }
	
}

-(void)initMyView{
    
    _nameLabel.text = self.home.name;
    
    CGSize size = [_nameLabel.text sizeWithFont:_nameLabel.font constrainedToSize:CGSizeMake(_nameLabel.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    if (size.height > 40) {
        //根据计算结果重新设置UILabel的尺寸
        [_nameLabel setFrame:CGRectMake(14, 20, _nameLabel.frame.size.width, size.height)];
        
        [_headBg setFrame:CGRectMake(8, _headBg.frame.origin.y, self.view.frame.size.width - 16, _nameLabel.frame.size.height + 20)];
        
        [_bottomView setFrame:CGRectMake(0, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + 10, self.view.frame.size.width, 380)];
        
        CGSize newSize = CGSizeMake(self.view.frame.size.width, _bottomView.frame.origin.y + _bottomView.frame.size.height + 10);
        [self.scrollview setContentSize:newSize];
    }
    
    _borrowingBalanceLabel.text = self.home.borrow_amount_format;
    _investmentAmountLabel.text = self.home.need_money;
    _rateLabel.text = self.home.rate_foramt_w;
    if (self.home.repay_time_type == 0) {
        _timeLabel.text = [NSString stringWithFormat:@"%d天",self.home.repay_time];
    }else{
        _timeLabel.text = [NSString stringWithFormat:@"%d个月",self.home.repay_time];
    }
    if (self.home.loantype == 0) {
        _repaymentMethodLabel.text = @"等额本息";
    }else if(self.home.loantype == 1){
        _repaymentMethodLabel.text = @"付息还本";
    }else if(self.home.loantype == 2){
        _repaymentMethodLabel.text = @"到期还本息";
    }
    _tenderMoneyTextField.placeholder = [NSString stringWithFormat:@"输入金额，最低投标金额%.1f",self.home.min_loan_money];
    
}

-(void)loadNetData{
	
	NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
	[parmDict setObject:@"deal_dobid" forKey:@"act"];
    [parmDict setObject:fanweApp.user_name forKey:@"email"];
    [parmDict setObject:fanweApp.user_pwd forKey:@"pwd"];
    [parmDict setObject:[NSString stringWithFormat:@"%d",self.home.borrow_id] forKey:@"id"];
    [parmDict setObject:_tenderMoneyTextField.text forKey:@"bid_money"];
    [parmDict setObject:_passwordTextField.text forKey:@"bid_paypassword"];
	
    netHttp.delegate = self;
    [netHttp startAsynchronous:parmDict addUserPwd:false useDataCached:false];
	
}

#pragma 刷新余额
-(void)loadNetData2{
	
	NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
	[parmDict setObject:@"refresh_user" forKey:@"act"];
    [parmDict setObject:fanweApp.user_name forKey:@"email"];
    [parmDict setObject:fanweApp.user_pwd forKey:@"pwd"];
    [parmDict setObject:[NSString stringWithFormat:@"%d",self.home.borrow_id] forKey:@"id"];
	
    netHttp.delegate = self;
    [netHttp startAsynchronous:parmDict addUserPwd:false useDataCached:false];
	
}

-(void)requestDone:(NSDictionary *) jsonDict error:(NSError *) error{
    if (jsonDict != nil){
        
        //response_code 服务器返回成功（1：成功；0：失败）
        if([jsonDict toInt:@"response_code"] == 1){
            if ([@"deal_dobid" isEqualToString:[jsonDict toString:@"act"]]) {
                [FanweMessage alert:@"投标成功!"];
                [self.navigationController popViewControllerAnimated:YES];
            }else if([@"refresh_user" isEqualToString:[jsonDict toString:@"act"]]){
                _balanceLabel.text = [jsonDict toString:@"user_money_format"];
            }
        }else{
            [FanweMessage alert:[jsonDict toString:@"show_err"]];
        }
        
    }else{
        [FanweMessage alert:@"服务器访问失败"];
    }
    
}

- (IBAction)rechargeAction:(id)sender {
    if (fanweApp.is_login) {
        RechargeController *tmpController = [[RechargeController alloc] init];
        [[self navigationController]pushViewController:tmpController animated:YES];
    }else{
        LoginController *tmpController = [[LoginController alloc]init];
        tmpController.is_mine = NO;
        [[self navigationController]pushViewController:tmpController animated:YES];
    }
}

- (IBAction)investAction:(id)sender {
    if ([_tenderMoneyTextField.text length] == 0){
		
		[FanweMessage alert:@"投标金额不能为空"];
		[_tenderMoneyTextField becomeFirstResponder];
		return;
	}
    
    if ([_tenderMoneyTextField.text intValue] < self.home.min_loan_money){
		
		[FanweMessage alert:[NSString stringWithFormat:@"投标金额不能小于%.1f元",self.home.min_loan_money]];
		[_tenderMoneyTextField becomeFirstResponder];
		return;
	}
	
	if ([_passwordTextField.text length] == 0){
		
		[FanweMessage alert:@"密码不能为空"];
        [_passwordTextField becomeFirstResponder];
        
		return;
	}
	
	[self loadNetData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
