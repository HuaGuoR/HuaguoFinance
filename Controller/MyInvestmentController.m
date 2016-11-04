//
//  MyInvestmentController.m
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-15.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "MyInvestmentController.h"
#import "GlobalVariables.h"
#import "FanweMessage.h"
#import "MJRefresh.h"
#import "NetworkManager.h"
#import "Home.h"
#import "HomeTableViewTopCell.h"
#import "MyWebViewController.h"

@interface MyInvestmentController ()<HttpDelegate>
{
    GlobalVariables *_fanweapp;
    NetworkManager *_netHttp;
    NSMutableArray *_lits;
    int _maxpage;
    int _currentpage;//当前页
}
@end

@implementation MyInvestmentController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    _fanweapp = [GlobalVariables sharedInstance];
    _netHttp = [[NetworkManager alloc] init];
    _netHttp.delegate = self;
    _lits= [[NSMutableArray alloc]init];
    [self setupRefresh];
    self.title = @"我的投资";
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerReresh)];
    //头部进入刷新
    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
}


#pragma mark 开始进入刷新状态
- (void)headerReresh
{
    [self lodeNet:@"1"];
    //底部显示刷新控件
    [self.tableView setFooterHidden:NO];
}



- (void)footerRereshing
{
    int page = _currentpage;
    //判断当前是否为最后一页
    if(_currentpage<_maxpage){
        [self lodeNet:[NSString stringWithFormat:@"%d",page+1]];
    }else{
        //底部隐藏刷新控件
        [self.tableView footerEndRefreshing];
        [self.tableView setFooterHidden:YES];
    }
}

- (void)lodeNet:(NSString*)page;
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"uc_invest" forKey:@"act"];
    [dict setValue:_fanweapp.user_name forKey:@"email"];
    [dict setValue:_fanweapp.user_pwd forKey:@"pwd"];
    [dict setValue:page forKey:@"page"];
    [dict setValue:@"index" forKey:@"mode"];
    [_netHttp startAsynchronous:dict addUserPwd:NO useDataCached:YES];
    
}


- (void)requestDone:(NSDictionary *)jsonDict error:(NSError *)error
{
    if(jsonDict != nil){
        NSDictionary *pageDict = [jsonDict objectForKey:@"page"];
        _currentpage = [pageDict[@"page"]intValue];
        _maxpage = [pageDict[@"page_total"]intValue];
        NSDictionary *commentlist = jsonDict[@"item"];
        NSMutableArray *datalist = [[NSMutableArray alloc]init];
        for(NSDictionary *dict in commentlist){
            Home *list = [[Home alloc]init];
            [list setJson:dict];
            [datalist addObject:list];
        }
        //当上拉刷新时
        if(_currentpage == 1){
            //清空当前数据
            [_lits removeAllObjects];
            [_lits addObjectsFromArray:datalist];
            [datalist removeAllObjects];
            // 刷新表格
            [self.tableView reloadData];
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.tableView headerEndRefreshing];
        }else{
            //当加载更多时数据应添加到数组后面
            [_lits addObjectsFromArray:datalist];
            [datalist removeAllObjects];
            [self.tableView reloadData];
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.tableView footerEndRefreshing];
            
        }
    }else{
        [FanweMessage alert:@"服务器连接失败，请检查您的网络"];
        [self.tableView headerEndRefreshing];
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _lits.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 142.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *mycell = @"MyLogCell";
    HomeTableViewTopCell *cell = [tableView dequeueReusableCellWithIdentifier:mycell];
    if(cell == nil){
        cell = (HomeTableViewTopCell *)[[[NSBundle mainBundle] loadNibNamed: @"HomeTableViewTopCell"
                                                                      owner: self
                                                                    options: nil] lastObject];
    }
    //    [cell setContentCell:[_lits objectAtIndex:[indexPath row]]];
    [cell setCellContent:[_lits objectAtIndex:[indexPath row]]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyWebViewController *web = [[MyWebViewController alloc]init];
    Home *home = [_lits objectAtIndex:[indexPath row]];
    web.url = home.app_url;
    web.titleStr = @"详情";
    [self.navigationController pushViewController:web animated:YES];
}

@end
