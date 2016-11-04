//
//  RepaymentListController.m
//  fanwe_p2p
//
//  Created by mac on 14-8-15.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "RepaymentListController.h"
#import "NetworkManager.h"
#import "MJRefresh.h"
#import "FanweMessage.h"
#import "MJRefreshConst.h"
#import "RepaymentCell.h"
#import "Repayment.h"

@interface RepaymentListController ()<HttpDelegate,UITableViewDataSource,UITableViewDelegate,RepaymentCellDelegate>{
    NetworkManager *netHttp;
    GlobalVariables *fanweApp;
    int cur_page;
}

@property(strong, nonatomic) NSMutableArray *repaymentList;

@end

@implementation RepaymentListController

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
    [self.repaymentList removeAllObjects];
    // 刷新表格
    
}

- (void)footerRereshing
{
    cur_page ++;
    [self loadNetData:cur_page];
    
    //    [self.dealList removeAllObjects];
    // 刷新表格
    
}

-(void)loadNetData:(int)page{
	
	NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
	[parmDict setObject:@"uc_refund" forKey:@"act"];
    [parmDict setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    [parmDict setObject:@"0" forKey:@"status"]; //0:还款列表;1:已还清借款
	
    netHttp.delegate = self;
    [netHttp startAsynchronous:parmDict addUserPwd:YES useDataCached:false];
	
}

-(void)requestDone:(NSDictionary *) jsonDict error:(NSError *) error{
    if (jsonDict != nil){
        id iddeal  = [jsonDict objectForKey:@"item"];
        if (iddeal && iddeal != [NSNull null]){
            NSDictionary *tmpListDict = [jsonDict objectForKey:@"item"];
            for (NSDictionary *dict in tmpListDict) {
                Repayment *repament = [[Repayment alloc] init];
                [repament setJson:dict];
                [self.repaymentList addObject:repament];
                
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
	return 152.0f;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    static NSString *RepaymentCellIdentifier = @"RepaymentCellIdentifier";
    RepaymentCell *cell = nil;
    
    cell = (RepaymentCell *)[tableView dequeueReusableCellWithIdentifier:RepaymentCellIdentifier];
    if (cell == nil)
    {
        cell = (RepaymentCell *)[[[NSBundle mainBundle] loadNibNamed: @"RepaymentCell"
                                                              owner: self
                                                            options: nil] lastObject];
    }
    if (self.repaymentList && [self.repaymentList count] != 0){
        Repayment *repayment = [self.repaymentList objectAtIndex:row];
        cell.delegate = self;
        [cell setCellContent:repayment];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma 还款
- (void)repaymentAction:(NSString *)repayment_id{
    if(self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(repaymentAction:)]) {
            [self.delegate performSelector:@selector(repaymentAction:) withObject:repayment_id];
        }
    }
}

#pragma 提前还款
- (void)advanceRepaymentAction:(NSString *)repayment_id{
    if(self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(advanceRepaymentAction:)]) {
            [self.delegate performSelector:@selector(advanceRepaymentAction:) withObject:repayment_id];
        }
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
