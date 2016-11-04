//
//  RepaymentedListController.m
//  fanwe_p2p
//
//  Created by mac on 14-8-15.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "RepaymentedListController.h"
#import "NetworkManager.h"
#import "MJRefresh.h"
#import "FanweMessage.h"
#import "MJRefreshConst.h"
#import "RepaymentedCell.h"
#import "Repaymented.h"
#import "ExtendNSDictionary.h"

@interface RepaymentedListController ()<HttpDelegate,UITableViewDataSource,UITableViewDelegate>{
    NetworkManager *netHttp;
    GlobalVariables *fanweApp;
    int cur_page;
    int total_page;
}

@property(strong, nonatomic) NSMutableArray *repaymentList;

@end

@implementation RepaymentedListController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
		
    CGRect cellFrame = [self.view frame];
    cellFrame.origin.y = 0;
    cellFrame.size.height = [UIScreen mainScreen].applicationFrame.size.height - 44;
    
    [self.view setFrame:cellFrame];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    fanweApp = [GlobalVariables sharedInstance];
    netHttp = [[NetworkManager alloc] init];
    self.repaymentList = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
	self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [ UIColor colorWithRed: 0.96
                                                      green: 0.96
                                                       blue: 0.96
                                                      alpha: 1.0
                                      ];
    
    // 集成刷新控件
    [self setupRefresh];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self loadNetData:1];
    cur_page = 1;
    total_page = 0;
    [self.tableView setFooterHidden:NO];
    [self.repaymentList removeAllObjects];
    // 刷新表格
    
}

- (void)footerRereshing
{
    if (cur_page < total_page) {
        cur_page ++;
        [self loadNetData:cur_page];
    }else{
        [self.tableView footerEndRefreshing];
        [self.tableView setFooterHidden:YES];
    }
    
}

-(void)loadNetData:(int)page{
	
	NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
	[parmDict setObject:@"uc_refund" forKey:@"act"];
    [parmDict setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    [parmDict setObject:@"1" forKey:@"status"]; //0:还款列表;1:已还清借款
	
    netHttp.delegate = self;
    [netHttp startAsynchronous:parmDict addUserPwd:YES useDataCached:false];
	
}

-(void)requestDone:(NSDictionary *) jsonDict error:(NSError *) error{
    if (jsonDict != nil){
        total_page = [[jsonDict objectForKey:@"page"] toInt:@"page_total"];
        
        id iddeal  = [jsonDict objectForKey:@"item"];
        if (iddeal && iddeal != [NSNull null]){
            NSDictionary *tmpListDict = [jsonDict objectForKey:@"item"];
            for (NSDictionary *dict in tmpListDict) {
                Repaymented *repamented = [[Repaymented alloc] init];
                [repamented setJson:dict];
                [self.repaymentList addObject:repamented];
                
            }
        }
        [self.tableView reloadData];
    }else{
        [FanweMessage alert:@"服务器访问失败"];
    }
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.tableView headerEndRefreshing];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.tableView footerEndRefreshing];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.repaymentList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 81.0f;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    static NSString *RepaymentCellIdentifier = @"RepaymentCellIdentifier";
    RepaymentedCell *cell = nil;
    
    cell = (RepaymentedCell *)[tableView dequeueReusableCellWithIdentifier:RepaymentCellIdentifier];
    if (cell == nil)
    {
        cell = (RepaymentedCell *)[[[NSBundle mainBundle] loadNibNamed: @"RepaymentedCell"
                                                              owner: self
                                                            options: nil] lastObject];
    }
    if (self.repaymentList && [self.repaymentList count] != 0){
        Repaymented *repaymented = [self.repaymentList objectAtIndex:row];
        [cell setCellContent:repaymented];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    Repaymented *repaymented = [self.repaymentList objectAtIndex:row];
    
    if(self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(repaymentedDetailsAction:)]) {
            [self.delegate performSelector:@selector(repaymentedDetailsAction:) withObject:repaymented.app_url];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
