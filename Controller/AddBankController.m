//
//  AddBankController.m
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-13.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "AddBankController.h"
#import "MBProgressHUD.h"
#import "NetworkManager.h"
#import "FanweMessage.h"
#import "GlobalVariables.h"
#import "OneBank.h"
#import "BankCell.h"


@interface AddBankController () <HttpDelegate, MBProgressHUDDelegate, UITableViewDataSource, UITableViewDelegate>
{
	GlobalVariables *_fanweapp;
	NetworkManager *_netHttp;
	MBProgressHUD *HUD;
	NSMutableArray *_lits;
	BOOL tableShow;
	NSInteger selectId;
}
@end

@implementation AddBankController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad {
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
	tableShow = NO;
	selectId = -1;
	self.banTable.delegate = self;
	self.banTable.dataSource = self;
	self.view.backgroundColor = kColor(243, 243, 243);
    self.title = @"添加银行卡";
    
    CGRect rect1 =  self.sumbitBtn.frame;
    rect1.origin.y = [UIScreen mainScreen].applicationFrame.size.height - 93;
    [self.sumbitBtn setFrame:rect1];
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

#pragma  mark - 银行卡列表
- (void)lodeNet {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
	[dict setValue:@"uc_add_bank" forKey:@"act"];
	[dict setValue:_fanweapp.user_name forKey:@"email"];
	[dict setValue:_fanweapp.user_pwd forKey:@"pwd"];
	[_netHttp startAsynchronous:dict addUserPwd:NO useDataCached:YES];
}

#pragma  mark - 提交银行卡
- (void)sumitNet {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
	[dict setValue:@"uc_save_bank" forKey:@"act"];
	[dict setValue:_fanweapp.user_name forKey:@"email"];
	[dict setValue:_fanweapp.user_pwd forKey:@"pwd"];
	[dict setValue:[NSString stringWithFormat:@"%d", selectId] forKey:@"bank_id"];
	[dict setValue:self.dealBank.text forKey:@"bankzone"];
	[dict setValue:self.bankCard.text forKey:@"bankcard"];
	[_netHttp startAsynchronous:dict addUserPwd:NO useDataCached:YES];
	[self showHUD];
}

- (void)requestDone:(NSDictionary *)jsonDict error:(NSError *)error {
	if (jsonDict != nil) {
		if ([jsonDict[@"act"] isEqualToString:@"uc_add_bank"]) {
			if ([jsonDict[@"user_login_status"] intValue] == 1 && [jsonDict[@"response_code"] intValue] == 1) {
				NSMutableArray *dic = jsonDict[@"item"];
				if (dic.count == 0) {
					return;
				}
				self.realName.text = jsonDict[@"real_name"];
				NSMutableArray *tempArr = jsonDict[@"item"];
				[_lits removeAllObjects];
				for (NSDictionary *art in tempArr) {
					OneBank *list = [[OneBank alloc]initWithDict:art];
					MyLog(@"%@", list.bankName);
					[_lits addObject:list];
				}

				[self.banTable reloadData];
			}
		}
		else if ([jsonDict[@"act"] isEqualToString:@"uc_save_bank"]) {
			if ([jsonDict[@"response_code"] intValue] == 1) {
				[FanweMessage alert:@"银行卡添加成功"];
				[self.navigationController popViewControllerAnimated:YES];
			}
			else {
				[FanweMessage alert:@"银行卡添加失败,请稍后再试"];
			}

			[self hideHUD];
		}
	}
	else {
		[FanweMessage alert:@"服务器连接失败，请检查您的网络"];
		[self hideHUD];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _lits.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *mycell = @"BankCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mycell];
	if (cell == nil) {
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mycell];
	}
	OneBank *list = [[OneBank alloc]init];
	list = _lits[indexPath.row];
	[cell.textLabel setFont:[UIFont systemFontOfSize:12]];
	cell.textLabel.text = list.bankName;

	cell.textLabel.highlightedTextColor = [UIColor whiteColor];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	selectId = [_lits[indexPath.row] bankId];
	[self.bankName setTitle:[_lits[indexPath.row] bankName] forState:UIControlStateNormal];
	[self hideTableBank];
}

#pragma mark -提交
- (IBAction)sumbitAction:(id)sender {
	if (selectId == -1) {
		[FanweMessage alert:@"请您选择开卡银行！"];
	}
	else if ([self.dealBank.text isEqualToString:@""]) {
		[FanweMessage alert:@"请输入开卡网点！"];
	}
	else if ([self.bankCard.text isEqualToString:@""]) {
		[FanweMessage alert:@"请输入银行卡号!"];
	}
	else {
		[self sumitNet];
	}
}

- (IBAction)openTableAction:(id)sender {
	if (tableShow) {
		[self hideTableBank];
	}
	else {
		if (_lits.count > 0) {
			[self showTableBank];
		}
		else {
			[self lodeNet];
			[self showTableBank];
		}
	}
}

#pragma mark -显示下拉框
- (void)showTableBank {
	tableShow = YES;
	self.banTable.hidden = NO;
	CGRect fame = self.banTable.frame;
	[UIView animateWithDuration:.5 animations: ^{
	    self.banTable.frame = CGRectMake(fame.origin.x, fame.origin.y, fame.size.width, 240);
	}];
}

#pragma mark -隐藏下拉框
- (void)hideTableBank {
	tableShow = NO;
	CGRect fame = self.banTable.frame;
	[UIView animateWithDuration:.5 animations: ^{
	    self.banTable.frame = CGRectMake(fame.origin.x, fame.origin.y, fame.size.width, 1);
	} completion: ^(BOOL finished) {
	    self.banTable.hidden = YES;
	}];
}

- (IBAction)hideBankMenu:(id)sender {
	[self hideTableBank];
}

@end
