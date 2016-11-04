//
//  ConfirmationTransfer.m
//  fanwe_p2p
//
//  Created by mac on 14-8-14.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "ConfirmationTransfer.h"
#import "MyWebViewController.h"
#import "FanweMessage.h"
#import "NetworkManager.h"
#import "GlobalVariables.h"
#import "ExtendNSDictionary.h"
#import "LoginController.h"
#import "RechargeController.h"
#import "LoginController.h"

@interface ConfirmationTransfer ()<HttpDelegate>{
    UIButton *backButton;
    UIButton *rightButton;
    NetworkManager *netHttp;
    GlobalVariables *fanweApp;
}

@end

@implementation ConfirmationTransfer


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
    self.navigationItem.title = @"确认转让";
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
    
    CGSize rightButtonSize = CGSizeMake(46, 26);
	
	rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
	[rightButton setTitle:@"详情" forState:UIControlStateNormal];
	rightButton.frame = CGRectMake(0, 0, rightButtonSize.width, rightButtonSize.height);
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
	[rightButton setBackgroundImage:[UIImage imageNamed:@"btn_confirmation_transfer_right.png"] forState:UIControlStateNormal];
	
	UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
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
        MyWebViewController *tmpController = [[MyWebViewController alloc]
                                              initWithNibName:@"MyWebViewController"
                                              bundle:nil];
        tmpController.url = self.transfer.app_url;
        tmpController.titleStr = @"详情";
        [[self navigationController] pushViewController:tmpController animated:YES];
    }
	
}

-(void)initMyView{
    
    _nameLabel.text = self.transfer.title;
    
    CGSize size = [_nameLabel.text sizeWithFont:_nameLabel.font constrainedToSize:CGSizeMake(_nameLabel.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    if (size.height > 40) {
        //根据计算结果重新设置UILabel的尺寸
        [_nameLabel setFrame:CGRectMake(14, 20, _nameLabel.frame.size.width, size.height)];
        
        [_headBg setFrame:CGRectMake(8, _headBg.frame.origin.y, self.view.frame.size.width - 16, _nameLabel.frame.size.height + 20)];
        
        [_bottomView setFrame:CGRectMake(0, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + 10, _bottomView.frame.size.width, 460)];
        
        CGSize newSize = CGSizeMake(self.view.frame.size.width,410 + size.height);
        [self.scrollview setContentSize:newSize];
    }
    
    if (self.transfer.t_user_id > 0) {
        //repay_time_type 总时间的单位 0：天  1：月
        if (self.transfer.repay_time_type == 0) {
            _remainingTimeLabel.text = [NSString stringWithFormat:@"%d天",self.transfer.repay_time];
        }else{
            _remainingTimeLabel.text = [NSString stringWithFormat:@"%d个月",self.transfer.repay_time];
        }
    }else{
        _remainingTimeLabel.text = self.transfer.remain_time_format;
    }
    
    //repay_time_type 总时间的单位 0：天  1：月
    if (self.transfer.repay_time_type == 0) {
        _totalTimeLabel.text = [NSString stringWithFormat:@"%d天",self.transfer.repay_time];
    }else{
        _totalTimeLabel.text = [NSString stringWithFormat:@"%d个月",self.transfer.repay_time];
    }
    
    _nextRepayTimeLabel.text = self.transfer.near_repay_time_format;
    _transferMenoyLabel.text = self.transfer.transfer_amount_format;
    _remainingMoneyLabel.text = self.transfer.left_benjin_format;
    _remainingInterestLabel.text = self.transfer.left_lixi_format;
    _transferProfitLabel.text = self.transfer.transfer_income_format;
    if (self.transfer.t_user_id > 0) {
        _notTransferView.hidden = YES;
        _undertakePeopleLabel.text = self.transfer.tuser_name;
        _undertakeTimeLabel.text = self.transfer.transfer_time_format;
    }else{
        _transferedView.hidden = YES;
        CGRect tmp = _notTransferView.frame;
        tmp.origin.y = 290;
        tmp.size.height = 80;
        _notTransferView.frame = tmp;
        
        [_buyBtn setBackgroundColor:[UIColor colorWithRed:0.36 green: 0.72  blue:0.96 alpha:1]];
    }
    
}

-(void)loadNetData{
	
	NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
	[parmDict setObject:@"transfer_dobid" forKey:@"act"];
    [parmDict setObject:fanweApp.user_name forKey:@"email"];
    [parmDict setObject:fanweApp.user_pwd forKey:@"pwd"];
    [parmDict setObject:self.transfer.transfer_id forKey:@"id"];
    [parmDict setObject:_passwordTextField.text forKey:@"paypassword"];
	
    netHttp.delegate = self;
    [netHttp startAsynchronous:parmDict addUserPwd:false useDataCached:false];
	
}

#pragma 刷新余额
-(void)loadNetData2{
	
	NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
	[parmDict setObject:@"refresh_user" forKey:@"act"];
    [parmDict setObject:fanweApp.user_name forKey:@"email"];
    [parmDict setObject:fanweApp.user_pwd forKey:@"pwd"];
    [parmDict setObject:self.transfer.transfer_id forKey:@"id"];
	
    netHttp.delegate = self;
    [netHttp startAsynchronous:parmDict addUserPwd:false useDataCached:false];
	
}

-(void)requestDone:(NSDictionary *) jsonDict error:(NSError *) error{
    if (jsonDict != nil){
        
        //response_code 服务器返回成功（1：成功；0：失败）
        if([jsonDict toInt:@"response_code"] == 1){
            if ([@"transfer_dobid" isEqualToString:[jsonDict toString:@"act"]]) {
                [FanweMessage alert:[jsonDict toString:@"show_err"]];
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

- (IBAction)buyAction:(id)sender {
    
    if (self.transfer.t_user_id > 0) {
        return;
    }
    
    if ([fanweApp.user_id isEqualToString:self.transfer.user_id]) {
        
        [FanweMessage alert:@"不能购买自己的债权"];
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
