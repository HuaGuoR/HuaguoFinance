//
//  MyClaimController.m
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-15.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "MyClaimController.h"
#import "NetworkManager.h"
#import "STSegmentedControl.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "ExtendNSDictionary.h"
#import "FanweMessage.h"
#import "MyWebViewController.h"
#import "MyClaimCell.h"
#import "TransList.h"
#import "TransferController.h"

@interface MyClaimController () <HttpDelegate, MBProgressHUDDelegate> {
	STSegmentedControl *segment;
	GlobalVariables *_fanweapp;
	NetworkManager *_netHttp;
	NSMutableArray *_lits;
	MBProgressHUD *HUD;
	int _maxpage;
	int _currentpage; //当前页
	BOOL _isSell; //判断当前列表是否是购买记录
}

@end

@implementation MyClaimController

- (id)initWithStyle:(UITableViewStyle)style {
	self = [super initWithStyle:style];
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

	NSArray *buttonNames = [NSArray arrayWithObjects:@"债权转让", @"购买记录", nil];
	segment = [[STSegmentedControl alloc] initWithItems:buttonNames];
	segment.frame = CGRectMake(10, 10, 180, 40);
	[segment addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
	segment.selectedSegmentIndex = -1;
	segment.autoresizingMask = UIViewAutoresizingFlexibleWidth;

	segment.center = CGPointMake(self.navigationController.navigationBar.bounds.size.width / 2, self.navigationController.navigationBar.bounds.size.height / 2);

	_fanweapp = [GlobalVariables sharedInstance];
	_netHttp = [[NetworkManager alloc] init];
	_netHttp.delegate = self;
	_lits = [[NSMutableArray alloc]init];
	
	self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
	self.tableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
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

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupRefresh];
    [self.navigationController.navigationBar addSubview:segment];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh {
	// 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
	[self.tableView addHeaderWithTarget:self action:@selector(headerReresh)];
	//头部进入刷新
//    [self.tableView headerBeginRefreshing];

	// 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
	[self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

#pragma mark 开始进入刷新状态
- (void)headerReresh {
	if (_isSell) {
		[self lodeSellNet:@"1"];
	}
	else {
		[self lodeNet:@"1"];
	}
	//底部显示刷新控件
	[self.tableView setFooterHidden:NO];
}

- (void)footerRereshing {
	int page = _currentpage;
	//判断当前是否为最后一nu页
	if (_currentpage < _maxpage) {
		if (_isSell) {
			[self lodeSellNet:[NSString stringWithFormat:@"%d", page + 1]];
		}
		else {
			[self lodeNet:[NSString stringWithFormat:@"%d", page + 1]];
		}
	}
	else {
		//底部隐藏刷新控件
		[self.tableView footerEndRefreshing];
		[self.tableView setFooterHidden:YES];
	}
}

- (void)lodeNet:(NSString *)page;
{
	NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
	[dict setValue:@"uc_transfer" forKey:@"act"];
	[dict setValue:_fanweapp.user_name forKey:@"email"];
	[dict setValue:_fanweapp.user_pwd forKey:@"pwd"];
	[dict setValue:page forKey:@"page"];
	[_netHttp startAsynchronous:dict addUserPwd:NO useDataCached:YES];
}

- (void)lodeBackNet:(NSInteger)dltid;
{
	NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
	[dict setValue:@"uc_do_reback" forKey:@"act"];
	[dict setValue:_fanweapp.user_name forKey:@"email"];
	[dict setValue:_fanweapp.user_pwd forKey:@"pwd"];
	[dict setValue:[NSString stringWithFormat:@"%ld", (long)dltid] forKey:@"dltid"];
	[_netHttp startAsynchronous:dict addUserPwd:NO useDataCached:YES];
	[self showHUD];
}


- (void)lodeSellNet:(NSString *)page;
{
	NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
	[dict setValue:@"uc_transfer_buys" forKey:@"act"];
	[dict setValue:_fanweapp.user_name forKey:@"email"];
	[dict setValue:_fanweapp.user_pwd forKey:@"pwd"];
	[dict setValue:page forKey:@"page"];
	[_netHttp startAsynchronous:dict addUserPwd:NO useDataCached:YES];
}

- (void)requestDone:(NSDictionary *)jsonDict error:(NSError *)error {
	if (jsonDict != nil) {
		if ([jsonDict[@"act"] isEqualToString:@"uc_transfer"] || [jsonDict[@"act"] isEqualToString:@"uc_transfer_buys"]) {
			NSDictionary *pageDict = [jsonDict objectForKey:@"page"];
			_currentpage = [pageDict[@"page"] intValue];
			_maxpage = [pageDict[@"page_total"] intValue];
			NSDictionary *commentlist = jsonDict[@"item"];
			if ([commentlist isKindOfClass:[NSNull class]]) {
				[self.tableView headerEndRefreshing];
                [_lits removeAllObjects];
                [self.tableView reloadData];
				return;
			}
			NSMutableArray *datalist = [[NSMutableArray alloc]init];
			for (NSDictionary *dict in commentlist) {
				TransList *list = [[TransList alloc]initWithDict:dict];
				[datalist addObject:list];
			}
			//当上拉刷新时
			if (_currentpage == 1) {
				//清空当前数据
				[_lits removeAllObjects];
				[_lits addObjectsFromArray:datalist];
				[datalist removeAllObjects];
				// 刷新表格
				[self.tableView reloadData];
				// (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
				[self.tableView headerEndRefreshing];
			}
			else {
				//当加载更多时数据应添加到数组后面
				[_lits addObjectsFromArray:datalist];
				[datalist removeAllObjects];
				[self.tableView reloadData];
				// (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
				[self.tableView footerEndRefreshing];
			}
		}
		else if ([jsonDict[@"act"] isEqualToString:@"uc_do_reback"]) {
			if ([jsonDict toInt:@"user_login_status"] == 1 && [jsonDict toInt:@"response_code"] == 1) {
				[FanweMessage alert:@"撤销成功！"];
                [self.tableView headerBeginRefreshing];
			}
			else {
				[FanweMessage alert:jsonDict[@"show_err"]];
			}
		}
		[self hideHUD];
	}
	else {
		[FanweMessage alert:@"服务器连接失败，请检查您的网络"];
		[self.tableView headerEndRefreshing];
		[self hideHUD];
	}
}



- (void)viewDidAppear:(BOOL)animated {
	if (segment.selectedSegmentIndex == -1) {
		segment.selectedSegmentIndex = 0;
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[segment removeFromSuperview];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _lits.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 140.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *mycell = @"MyLogCell";
	MyClaimCell *cell = [tableView dequeueReusableCellWithIdentifier:mycell];
	if (cell == nil) {
		cell = (MyClaimCell *)[[[NSBundle mainBundle] loadNibNamed:@"MyClaimCell"
		                                                     owner:self
		                                                   options:nil] lastObject];
	}
	//    [cell setContentCell:[_lits objectAtIndex:[indexPath row]]];
	[cell setContenCell:[_lits objectAtIndex:[indexPath row]]];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	int statues = [[_lits objectAtIndex:[indexPath row]]transop];
	if (!_isSell) {
		if (statues == 0 || statues == 2 || statues == 3 || statues == 5) {
			[cell.status setBackgroundImage:[UIImage imageNamed:@"btn_transfer_bg3.png"] forState:UIControlStateNormal];
			[cell.titleBg setImage:[UIImage imageNamed:@"transfer_title_bg2.png"]];
		}
		else if (statues == 1) {
			[cell.status setBackgroundImage:[UIImage imageNamed:@"btn_transfer_bg1.png"] forState:UIControlStateNormal];
			[cell.titleBg setImage:[UIImage imageNamed:@"transfer_title_bg1.png"]];
		}
		else if (statues == 4 || statues == 6) {
			[cell.status setBackgroundImage:[UIImage imageNamed:@"btn_transfer_bg2.png"] forState:UIControlStateNormal];
			[cell.titleBg setImage:[UIImage imageNamed:@"transfer_title_bg1.png"]];
		}
	}
	else {
		[cell.status setBackgroundImage:[UIImage imageNamed:@"btn_transfer_bg2.png"] forState:UIControlStateNormal];
		[cell.titleBg setImage:[UIImage imageNamed:@"transfer_title_bg1.png"]];
		[cell.status setTitle:@"详情" forState:UIControlStateNormal];
		[cell.statuesTitle setText:@"详情"];
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (_isSell) {
		MyWebViewController *web = [[MyWebViewController alloc]init];
		web.titleStr = @"详情";
		web.url = [[_lits objectAtIndex:indexPath.row]appurl];
		[self.navigationController pushViewController:web animated:YES];
	}
	else {
		int status = [[_lits objectAtIndex:indexPath.row]transop];
		if (status == 6) {
			FanweMessage *alert = [[FanweMessage alloc]initWithTitle:@"温馨提示" message:@"是否撤销？" cancelButtonTitle:@"取消" otherButtonTitles:@"确定" YESblock: ^{
			    int dltid = [[_lits objectAtIndex:indexPath.row]dltid];
			    [self lodeBackNet:dltid];
			} NOblock: ^{
			}];
			[alert show];
		}
		else if (status == 1 || status == 4) {
			TransferController *transfer = [[TransferController alloc]init];
			transfer.translist = [_lits objectAtIndex:indexPath.row];
			transfer.dlid = [[_lits objectAtIndex:indexPath.row]dlid];
			[self.navigationController pushViewController:transfer animated:YES];
		}
	}
}

- (void)valueChanged:(id)sender {
	STSegmentedControl *control = sender;

	NSString *segIndexKey = [NSString stringWithFormat:@"%ld", (long)control.selectedSegmentIndex];
	if (control.selectedSegmentIndex == 0) {
		_isSell = NO;
		[self lodeNet:@"1"];
	}
	else if (control.selectedSegmentIndex == 1) {
		_isSell = YES;
		[self lodeSellNet:@"1"];
	}
}

@end
