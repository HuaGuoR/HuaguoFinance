//
//  WithCashController.m
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-13.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "WithCashController.h"
#import "MJRefresh.h"
#import "NetworkManager.h"
#import "FanweMessage.h"
#import "GlobalVariables.h"
#import "WithCashCell.h"
#import "BankList.h"
#import "MBProgressHUD.h"
#import "AddBankController.h"
#import "FreeConfig.h"
#import "CashApplyController.h"

@interface WithCashController () <HttpDelegate, UITableViewDataSource, UITableViewDelegate,MBProgressHUDDelegate>
{
	GlobalVariables *_fanweapp;
	NetworkManager *_netHttp;
	NSMutableArray *_lits;
	UIButton *_rightButton;
	BOOL isEdting;
	NSMutableArray *_deleteArray;
    MBProgressHUD *HUD;
    NSMutableArray *_freeconfig; //手续费区间
    FreeConfig *_freelist; //收手续实体
}
@end

@implementation WithCashController



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
	self.myTableVIew.delegate = self;
	self.myTableVIew.dataSource = self;
	_lits = [[NSMutableArray alloc]init];
	_deleteArray = [[NSMutableArray alloc]init];
    _freeconfig = [[NSMutableArray alloc]init];
	self.title = @"选择银行";
	[self layoutNavButton];
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	CGRect frame = self.myTableVIew.frame;
	self.myTableVIew.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
	self.myTableVIew.separatorStyle = UITableViewCellSeparatorStyleNone;

	isEdting = NO;
}

- (void)layoutNavButton {
	CGSize leftButtonSize = CGSizeMake(33, 29);
	_rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
	[_rightButton addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];

	_rightButton.frame = CGRectMake(0, 0, leftButtonSize.width, leftButtonSize.height);
	_rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
	[_rightButton setTitle:@"编辑" forState:UIControlStateNormal];

	UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
	self.navigationItem.rightBarButtonItem = right;
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

- (void)editAction {
	if (isEdting) {
		isEdting = NO;
		self.deleteView.hidden = YES;
		[_rightButton setTitle:@"编辑" forState:UIControlStateNormal];
		[self.myTableVIew setEditing:NO animated:YES];
		[self.myTableVIew setHeaderHidden:NO];
		[self.myTableVIew headerBeginRefreshing];
	}
	else {
		isEdting = YES;
		[_deleteArray removeAllObjects];
		self.deleteView.hidden = NO;
		[self.myTableVIew setEditing:YES animated:YES];
		[_rightButton setTitle:@"取消" forState:UIControlStateNormal];
		[self.myTableVIew setHeaderHidden:YES];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[self setupRefresh];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh {
	// 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
	[self.myTableVIew addHeaderWithTarget:self action:@selector(headerReresh)];
	//自动刷新(一进入程序就下拉刷新)
	[self.myTableVIew headerBeginRefreshing];
}

#pragma mark 开始进入刷新状态
- (void)headerReresh {
	[self lodeNet];
}

- (void)lodeNet {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
	[dict setValue:@"uc_bank" forKey:@"act"];
	[dict setValue:_fanweapp.user_name forKey:@"email"];
	[dict setValue:_fanweapp.user_pwd forKey:@"pwd"];
	[_netHttp startAsynchronous:dict addUserPwd:NO useDataCached:YES];
}

#pragma mark - 删除银行卡
- (void)deleteNet:(NSString *)string {
    [self showHUD];
	NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
	[dict setValue:@"uc_del_bank" forKey:@"act"];
	[dict setValue:_fanweapp.user_name forKey:@"email"];
	[dict setValue:_fanweapp.user_pwd forKey:@"pwd"];
	[dict setValue:string forKey:@"id"];
	[_netHttp startAsynchronous:dict addUserPwd:NO useDataCached:YES];
}

- (void)requestDone:(NSDictionary *)jsonDict error:(NSError *)error {
	if (jsonDict != nil) {
		if ([jsonDict[@"act"] isEqualToString:@"uc_bank"]) {
			if ([jsonDict[@"user_login_status"] intValue] == 1 && [jsonDict[@"response_code"] intValue] == 1) {
				NSMutableArray *dic = jsonDict[@"item"];
				if (dic.count == 0) {
					[self.myTableVIew headerEndRefreshing];
					return;
				}
				NSMutableArray *tempArr = jsonDict[@"item"];
				[_lits removeAllObjects];
				for (NSDictionary *art in tempArr) {
					BankList *list = [[BankList alloc]initWithDict:art];
					[_lits addObject:list];
				}
                _freeconfig = jsonDict[@"fee_config"];
                _freelist = [[FreeConfig alloc]initWithArray:_freeconfig];
				[self.myTableVIew reloadData];
				[self.myTableVIew headerEndRefreshing];
			}
		}else if([jsonDict[@"act"] isEqualToString:@"uc_del_bank"]){
            if([jsonDict[@"response_code"]intValue] == 1){
                [FanweMessage alert:@"删除银行卡成功"];
            }else{
                [FanweMessage alert:@"删除银行卡失败,请稍后再试"];
            }
            isEdting = NO;
            self.deleteView.hidden = YES;
            [_rightButton setTitle:@"编辑" forState:UIControlStateNormal];
            [self.myTableVIew setEditing:NO animated:YES];
            [self.myTableVIew setHeaderHidden:NO];
            [self.myTableVIew headerBeginRefreshing];
             [self hideHUD];
        }
	}
	else {
		[FanweMessage alert:@"服务器连接失败，请检查您的网络"];
		[self.myTableVIew headerEndRefreshing];
         [self hideHUD];
	}
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing {
	//    [self.dealList removeAllObjects];
	// 刷新表格
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _lits.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return self.headView;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
	BankList *list = _lits[row];
	[_deleteArray addObject:[NSString stringWithFormat:@"%ld", (long)list.bankid]];
	[_lits removeObjectAtIndex:row];

	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]

	                 withRowAnimation:UITableViewRowAnimationFade];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *mycell = @"WithCashCell";
	BOOL isResigier = NO;
	if (!isResigier) {
		UINib *nib = [UINib nibWithNibName:@"WithCashCell" bundle:nil];
		[tableView registerNib:nib forCellReuseIdentifier:mycell];
		isResigier = YES;
	}
	WithCashCell *cell = [tableView dequeueReusableCellWithIdentifier:mycell];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;

	long row = indexPath.row;
	BankList *list = [_lits objectAtIndex:row];
	[cell setCellContent:list];
	cell.backgroundView = [self cellBagroundView:row cell:cell];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CashApplyController *detail = [[CashApplyController alloc]init];
    detail.banlist = _lits[[indexPath row]];
    detail.freeconfig = _freelist;
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (UIView *)cellBagroundView:(long)row cell:(UITableViewCell *)cell {
	int count = _lits.count;


	UIView *cellview = [[UIView alloc]init];
	cellview.bounds = cell.bounds;
	UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cellview.bounds.size.width, cellview.frame.size.height)];

	UIImage *image;
	if (count == 1) {
		image = [UIImage imageNamed:@"block_whole_01.png"];
	}
	else if (count > 1) {
		if (row == 0) {
			image = [UIImage imageNamed:@"block_top_01.png"];
		}
		else if (row == count - 1) {
			image = [UIImage imageNamed:@"block_bottom_01.png"];
		}
		else {
			image = [UIImage imageNamed:@"block_middle_01.png"];
		}
	}
	imageview.image = image;
	[cellview addSubview:imageview];
	return cellview;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (IBAction)addBankAction:(id)sender {
    AddBankController *add = [[AddBankController alloc]init];
    [self.navigationController pushViewController:add animated:YES];
}

- (IBAction)deleteAction:(id)sender {
	int count = _deleteArray.count;
	NSString *string = @"";
	if (count > 0) {
		if (_deleteArray.count == 1) {
			string = [NSString stringWithFormat:@"%@", _deleteArray[0]];
		}
		else {
			NSMutableString *st = [[NSMutableString alloc]init];
			for (int i = 0; i < count; i++) {
				[st appendString:_deleteArray[i]];
				if (i != count - 1) {
					[st appendString:@","];
				}
			}
			string = st;
		}

		FanweMessage *alert = [[FanweMessage alloc]initWithTitle:@"温馨提示" message:@"确定删除您指定的银行卡吗？" cancelButtonTitle:@"取消" otherButtonTitles:@"确定" YESblock:^{
            [self deleteNet:string];
        } NOblock:^{
            isEdting = NO;
            self.deleteView.hidden = YES;
            [_rightButton setTitle:@"编辑" forState:UIControlStateNormal];
            [self.myTableVIew setEditing:NO animated:YES];
            [self.myTableVIew setHeaderHidden:NO];
            [self.myTableVIew headerBeginRefreshing];
        }];
		[alert show];
	}
	else {
		[FanweMessage alert:@"请至少在本地选择并删除一张银行卡！"];
	}
}

@end
