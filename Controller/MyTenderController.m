//
//  MyTenderController.m
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-19.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "MyTenderController.h"
#import "GlobalVariables.h"
#import "FanweMessage.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "NetworkManager.h"
#import "Home.h"
#import "HomeTableViewTopCell.h"
#import "MyWebViewController.h"

@interface MyTenderController () <HttpDelegate, UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>
{
	GlobalVariables *_fanweapp;
	NetworkManager *_netHttp;
	NSMutableArray *_lits;
	MBProgressHUD *HUD;
	int _maxpage;
	int _currentpage; //当前页
	UIButton *_rightButton;
	NSMutableArray *_deleteArray;
	BOOL isEdting;
}

@end

@implementation MyTenderController

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
	_deleteArray = [[NSMutableArray alloc]init];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	[self setupRefresh];
	self.title = @"我关注的标";
	self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
	[self layoutNavButton];
	isEdting = NO;
	self.tableView.allowsMultipleSelectionDuringEditing = YES;
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

/**
 *  集成刷新控件
 */
- (void)setupRefresh {
	// 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
	[self.tableView addHeaderWithTarget:self action:@selector(headerReresh)];
	//头部进入刷新
	[self.tableView headerBeginRefreshing];

	// 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
	[self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
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

- (void)editAction {
	if (isEdting) {
		isEdting = NO;
		self.deleteView.hidden = YES;
		[_rightButton setTitle:@"编辑" forState:UIControlStateNormal];
		[self.tableView setEditing:NO animated:YES];
		[self.tableView setHeaderHidden:NO];
		[self.tableView headerBeginRefreshing];
	}
	else {
		isEdting = YES;
		[_deleteArray removeAllObjects];
		self.deleteView.hidden = NO;
		[self.tableView setEditing:YES animated:YES];
		[_rightButton setTitle:@"取消" forState:UIControlStateNormal];
		[self.tableView setHeaderHidden:YES];
	}
}

#pragma mark 开始进入刷新状态
- (void)headerReresh {
	[self lodeNet:@"1"];
	//底部显示刷新控件
	[self.tableView setFooterHidden:NO];
}

- (void)footerRereshing {
	int page = _currentpage;
	//判断当前是否为最后一页
	if (_currentpage < _maxpage) {
		[self lodeNet:[NSString stringWithFormat:@"%d", page + 1]];
	}
	else {
		//底部隐藏刷新控件
		[self.tableView footerEndRefreshing];
		[self.tableView setFooterHidden:YES];
	}
}

#pragma mark - 删除我关注的标
- (void)deleteNet:(NSString *)string {
	[self showHUD];
	NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
	[dict setValue:@"uc_del_collect" forKey:@"act"];
	[dict setValue:_fanweapp.user_name forKey:@"email"];
	[dict setValue:_fanweapp.user_pwd forKey:@"pwd"];
	[dict setValue:string forKey:@"id"];
	[_netHttp startAsynchronous:dict addUserPwd:NO useDataCached:YES];
}

- (void)lodeNet:(NSString *)page;
{
	NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
	[dict setValue:@"uc_collect" forKey:@"act"];
	[dict setValue:_fanweapp.user_name forKey:@"email"];
	[dict setValue:_fanweapp.user_pwd forKey:@"pwd"];
	[dict setValue:page forKey:@"page"];
	[_netHttp startAsynchronous:dict addUserPwd:NO useDataCached:YES];
}


- (void)requestDone:(NSDictionary *)jsonDict error:(NSError *)error {
	if (jsonDict != nil) {
		if ([jsonDict[@"act"] isEqualToString:@"uc_collect"]) {
			NSDictionary *pageDict = [jsonDict objectForKey:@"page"];
			_currentpage = [pageDict[@"page"] intValue];
			_maxpage = [pageDict[@"page_total"] intValue];
			NSDictionary *commentlist = jsonDict[@"item"];
			NSMutableArray *datalist = [[NSMutableArray alloc]init];
			for (NSDictionary *dict in commentlist) {
				Home *list = [[Home alloc]init];
				[list setJson:dict];
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
		else if ([jsonDict[@"act"] isEqualToString:@"uc_del_collect"]) {
			if ([jsonDict[@"response_code"] intValue] == 1) {
				[FanweMessage alert:@"删除关注的标成功"];
                isEdting = NO;
                self.deleteView.hidden = YES;
                [_rightButton setTitle:@"编辑" forState:UIControlStateNormal];
                [self.tableView setEditing:NO animated:YES];
                [self.tableView setHeaderHidden:NO];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _lits.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 142.0f;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *mycell = @"MyLogCell";
	HomeTableViewTopCell *cell = [tableView dequeueReusableCellWithIdentifier:mycell];
	if (cell == nil) {
		cell = (HomeTableViewTopCell *)[[[NSBundle mainBundle] loadNibNamed:@"HomeTableViewTopCell"
		                                                              owner:self
		                                                            options:nil] lastObject];
	}
	[cell setCellContent:[_lits objectAtIndex:[indexPath row]]];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (isEdting) {
		NSUInteger row = [indexPath row];
		Home *list = _lits[row];
		[_deleteArray addObject:[NSString stringWithFormat:@"%d", list.borrow_id]];
	}
	else {
		MyWebViewController *web = [[MyWebViewController alloc]init];
		Home *home = [_lits objectAtIndex:[indexPath row]];
		web.url = home.app_url;
		web.titleStr = @"详情";
		[self.navigationController pushViewController:web animated:YES];
	}
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (isEdting) {
		NSUInteger row = [indexPath row];
		Home *list = _lits[row];
		[_deleteArray removeObject:[NSString stringWithFormat:@"%d", list.borrow_id]];
	}
}

- (IBAction)submitAction:(id)sender {
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

		FanweMessage *alert = [[FanweMessage alloc]initWithTitle:@"温馨提示" message:@"确定删除您指定的标吗？" cancelButtonTitle:@"取消" otherButtonTitles:@"确定" YESblock: ^{
            [self deleteNet:string];
		} NOblock: ^{
		    isEdting = NO;
		    self.deleteView.hidden = YES;
		    [_rightButton setTitle:@"编辑" forState:UIControlStateNormal];
		    [self.tableView setEditing:NO animated:YES];
		    [self.tableView setHeaderHidden:NO];
		    [self.tableView headerBeginRefreshing];
		}];
		[alert show];
	}
	else {
		[FanweMessage alert:@"请至少在本地选择并删除一条记录！"];
	}
}

@end
