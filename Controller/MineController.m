//
//  MineController.m
//  fanwe_p2p
//
//  Created by mac on 14-7-29.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "MineController.h"
#import "MFSideMenuContainerViewController.h"
#import "MJRefresh.h"
#import "NetworkManager.h"
#import "FanweMessage.h"
#import "GlobalVariables.h"
#import "MyLogController.h"
#import "MyInvestmentController.h"
#import "MyClaimController.h"
#import "MyTenderController.h"
#import "ChangePwdController.h"
#import "MyLoanInvestmentListController.h"
#import "RepaymentController.h"
#import "BidRecordListController.h"

@interface MineController () <HttpDelegate>
{
	GlobalVariables *_fanweapp;
	NetworkManager *_netHttp;
	NSMutableArray *_lits;
    UIButton *leftButton;
}

@end

@implementation MineController

- (MFSideMenuContainerViewController *)menuContainerViewController {
	return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
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

	self.navigationItem.title = @"我的";
	CGSize newSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
	[self.scrollview setContentSize:newSize];

	_fanweapp = [GlobalVariables sharedInstance];
	_netHttp = [[NetworkManager alloc] init];
	_netHttp.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
	[self setupRefresh];
    [self layoutNavButton];
}

- (void)layoutNavButton {
    
    CGSize leftButtonSize = CGSizeMake(33, 29);
	
	leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [leftButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	leftButton.frame = CGRectMake(0, 0, leftButtonSize.width, leftButtonSize.height);
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
	[leftButton setImage:[UIImage imageNamed:@"menu-icon.png"] forState:UIControlStateNormal];
	
	UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

- (void)leftSideMenuButtonPressed:(id)sender {
	[self.menuContainerViewController toggleLeftSideMenuCompletion: ^{}];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh {
	// 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
	[self.scrollview addHeaderWithTarget:self action:@selector(headerReresh)];
	//自动刷新(一进入程序就下拉刷新)
	[self.scrollview headerBeginRefreshing];
}

#pragma mark 开始进入刷新状态
- (void)headerReresh {
	[self lodeNet];
}

- (void)lodeNet {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
	[dict setValue:@"uc_center" forKey:@"act"];
	[dict setValue:_fanweapp.user_name forKey:@"email"];
	[dict setValue:_fanweapp.user_pwd forKey:@"pwd"];
	[_netHttp startAsynchronous:dict addUserPwd:NO useDataCached:YES];
}

- (void)requestDone:(NSDictionary *)jsonDict error:(NSError *)error {
	if (jsonDict != nil) {
		if ([jsonDict[@"response_code"] intValue] == 1 && [jsonDict[@"user_login_status"] intValue] == 1) {
			[self.goupName setTitle:jsonDict[@"group_name"] forState:UIControlStateNormal];
            self.userName.text = jsonDict[@"user_name"];
			self.money.text = jsonDict[@"money_format"];
			self.lockMoney.text = jsonDict[@"lock_money_format"];
			self.toalMoney.text = jsonDict[@"total_money_format"];
			[self.scrollview headerEndRefreshing];
            
            CGSize size = [self.userName.text sizeWithFont:self.userName.font constrainedToSize:CGSizeMake(self.userName.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            //根据计算结果重新设置UILabel的尺寸
            [self.userName setFrame:CGRectMake(20, 27, size.width, 20)];
            
            CGRect tmpRect = self.goupName.frame;
            tmpRect.origin.x = self.userName.frame.origin.x + self.userName.frame.size.width + 20;
            self.goupName.frame = tmpRect;
            
            
            CGSize size2 = [self.toalMoney.text sizeWithFont:self.toalMoney.font constrainedToSize:CGSizeMake(99, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            if (size2.width > 99 ) {
                [self.toalMoney setFrame:CGRectMake(4, 86, size2.width, size2.height)];
            }
            
            CGSize size3 = [self.money.text sizeWithFont:self.money.font constrainedToSize:CGSizeMake(99, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            if (size3.width > 99 ) {
                [self.money setFrame:CGRectMake(111, 86, size3.width, size3.height)];
            }
            
            CGSize size4 = [self.lockMoney.text sizeWithFont:self.lockMoney.font constrainedToSize:CGSizeMake(99, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            if (size4.width > 99) {
                [self.lockMoney setFrame:CGRectMake(219, 86, size4.width, size4.height)];
            }
            
		}
	}
	else {
		[FanweMessage alert:@"服务器连接失败，请检查您的网络"];
		[self.scrollview headerEndRefreshing];
	}
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing {
//    [self.dealList removeAllObjects];
	// 刷新表格
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)myCharge:(id)sender {
    MyLogController *mylog = [[MyLogController alloc]init];
    [self.navigationController pushViewController:mylog animated:YES];
}

- (IBAction)myInvestAction:(id)sender {
    MyInvestmentController *investment = [[MyInvestmentController alloc]init];
    [self.navigationController pushViewController:investment animated:YES];
}

- (IBAction)myTransferAction:(id)sender {
    MyClaimController *tran = [[MyClaimController alloc]init];
    [self.navigationController pushViewController:tran animated:YES];
}

- (IBAction)myCollectAction:(id)sender {
    MyTenderController *tender = [[MyTenderController alloc]init];
    [self.navigationController pushViewController:tender animated:YES];
}

- (IBAction)myLendAction:(id)sender {
    BidRecordListController *tmpController = [[BidRecordListController alloc]init];
    [[self navigationController]pushViewController:tmpController animated:YES];
}

- (IBAction)reFundAction:(id)sender {
    RepaymentController *tmpController = [[RepaymentController alloc] init];
    [[self navigationController]pushViewController:tmpController animated:YES];
}

- (IBAction)myBorrowedAction:(id)sender {
    MyLoanInvestmentListController *tmpController = [[MyLoanInvestmentListController alloc] init];
    [[self navigationController] pushViewController:tmpController animated:YES];
}

- (IBAction)resetPwdAction:(id)sender {
    
    ChangepwdController *pwd = [[ChangepwdController alloc]init];
    [self.navigationController pushViewController:pwd animated:YES];
}

@end
