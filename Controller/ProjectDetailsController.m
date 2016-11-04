//
//  ProjectDetailsController.m
//  fanwe_p2p
//
//  Created by mac on 14-8-5.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "ProjectDetailsController.h"
#import "MyWebViewController.h"
#import "FanweMessage.h"
#import "NetworkManager.h"
#import "GlobalVariables.h"
#import "ExtendNSDictionary.h"
#import "LoginController.h"
#import "ConfirmationTenderController.h"

@interface ProjectDetailsController ()<HttpDelegate>{
    UIButton *backButton;
    UIButton *nextButton;
    NetworkManager *netHttp;
    GlobalVariables *fanweApp;
}

@end

@implementation ProjectDetailsController

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
    self.navigationItem.title = @"项目详情";
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
    if (fanweApp.is_login) {
        [self loadNetData];
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
	
    CGSize nextButtonSize = CGSizeMake(50, 30);
    
	UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
	
	nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
	
	nextButton.frame = CGRectMake(nextButton.frame.origin.x, nextButton.frame.origin.y, nextButtonSize.width, nextButtonSize.height);
    nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [nextButton setTitle:@"关注" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[nextButton setBackgroundImage:[UIImage imageNamed:@"bg_btn_project_detail_title_right_interest.png"] forState:UIControlStateNormal];
	
	UIBarButtonItem *nextButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    self.navigationItem.rightBarButtonItem = nextButtonItem;
    
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
        if (fanweApp.is_login) {
            [self loadNetData2];
        }else{
            LoginController *tmpController = [[LoginController alloc] init];
            [[self navigationController] pushViewController:tmpController animated:YES];
        }
        
    }
	
}

-(void)initMyView{
    
    _nameLabel.text = self.home.name;
    
    CGSize size = [_nameLabel.text sizeWithFont:_nameLabel.font constrainedToSize:CGSizeMake(_nameLabel.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    if (size.height > 40) {
        //根据计算结果重新设置UILabel的尺寸
        [_nameLabel setFrame:CGRectMake(14, 20, _nameLabel.frame.size.width, size.height)];
        
        [_headBg setFrame:CGRectMake(8, _headBg.frame.origin.y, self.view.frame.size.width - 16, _nameLabel.frame.size.height + 20)];
        
        [_middleView setFrame:CGRectMake(0, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + 10, _middleView.frame.size.width, 160)];
        
        [_bottomView setFrame:CGRectMake(0, _middleView.frame.origin.y + _middleView.frame.size.height + 10, self.view.frame.size.width, 200)];
        
        CGSize newSize = CGSizeMake(self.view.frame.size.width, _bottomView.frame.origin.y + _bottomView.frame.size.height + 10);
        [self.scrollview setContentSize:newSize];
    }
    
    _idLabel.text = [NSString stringWithFormat:@"借款编号%d",self.home.borrow_id];
    _borrowingBalanceLabel.text = self.home.borrow_amount_format;
    _investmentAmountLabel.text = self.home.need_money;
    _minimumAmountLabel.text = self.home.min_loan_money_format;
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
    if (self.home.risk_rank == 0) {
        _riskRankLabel.text = @"低";
    }else if(self.home.risk_rank == 1){
        _riskRankLabel.text = @"中";
    }else if(self.home.risk_rank == 2){
        _riskRankLabel.text = @"高";
    }
    _remainingTimeLabel.text = self.home.remain_time_format;
}

-(void)loadNetData{
	
	NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
	[parmDict setObject:@"deal_collect" forKey:@"act"];
    [parmDict setObject:fanweApp.user_name forKey:@"email"];
    [parmDict setObject:fanweApp.user_pwd forKey:@"pwd"];
    [parmDict setObject:[NSString stringWithFormat:@"%d",self.home.borrow_id] forKey:@"id"];
	
    netHttp.delegate = self;
    [netHttp startAsynchronous:parmDict addUserPwd:false useDataCached:false];
	
}

-(void)loadNetData2{
	
	NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
	[parmDict setObject:@"uc_do_collect" forKey:@"act"];
    [parmDict setObject:fanweApp.user_name forKey:@"email"];
    [parmDict setObject:fanweApp.user_pwd forKey:@"pwd"];
    [parmDict setObject:[NSString stringWithFormat:@"%d",self.home.borrow_id] forKey:@"id"];
	
    netHttp.delegate = self;
    [netHttp startAsynchronous:parmDict addUserPwd:false useDataCached:false];
	
}

-(void)requestDone:(NSDictionary *) jsonDict error:(NSError *) error{
    if (jsonDict != nil){
        if ([@"deal_collect" isEqualToString:[jsonDict toString:@"act"]]) {
            //0：未关注;>0:已关注
            if ([jsonDict toInt:@"is_faved"] > 0) {
                [nextButton setBackgroundImage: [UIImage imageNamed:@"bg_btn_project_detail_title_right_faved.png"] forState:UIControlStateNormal];
                [nextButton setTitle:@"已关注" forState:UIControlStateNormal];
                [nextButton setEnabled:NO];
            }
        }else{
            //服务器返回成功（1：成功；0：失败）
            if ([jsonDict toInt:@"response_code"] == 1) {
                [nextButton setBackgroundImage: [UIImage imageNamed:@"bg_btn_project_detail_title_right_faved.png"] forState:UIControlStateNormal];
                [nextButton setTitle:@"已关注" forState:UIControlStateNormal];
                [nextButton setEnabled:NO];
            }else{
                [FanweMessage alert:[jsonDict toString:@"show_err"]];
            }
        }
		
    }else{
        [FanweMessage alert:@"服务器访问失败"];
    }
    
}

- (IBAction)seeDetailsAction:(id)sender {
    MyWebViewController *tmpController = [[MyWebViewController alloc]
                                          initWithNibName:@"MyWebViewController"
                                          bundle:nil];
    tmpController.url = self.home.app_url;
    tmpController.titleStr = @"全部详情";
    [[self navigationController] pushViewController:tmpController animated:YES];
}

- (IBAction)investAction:(id)sender {
    if (fanweApp.is_login) {
        //状态；0待等材料，1借款中，2满标，3流标，4还款中，5已还清
        if (self.home.deal_status == 1) {
            if ([self.home.r_userId isEqualToString:fanweApp.user_id]) {
                
                [FanweMessage alert:@"您不能给自己投标！"];
            }else{
                ConfirmationTenderController *tmpController = [[ConfirmationTenderController alloc] init];
                tmpController.home = self.home;
                [[self navigationController] pushViewController:tmpController animated:YES];
            }
        }else{
            [FanweMessage alert:@"当前标不可投！"];
        }
    }else{
        LoginController *tmpController = [[LoginController alloc] init];
        tmpController.is_mine = NO;
        [[self navigationController] pushViewController:tmpController animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
