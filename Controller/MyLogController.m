//
//  MyLogController.m
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-12.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "MyLogController.h"
#import "GlobalVariables.h"
#import "FanweMessage.h"
#import "MJRefresh.h"
#import "NetworkManager.h"
#import "MyLogCell.h"
#import "LogList.h"
#import "RechargeController.h"
#import "WithCashController.h"

@interface MyLogController ()<HttpDelegate,UITableViewDataSource,UITableViewDelegate>
{
    GlobalVariables *_fanweapp;
    NetworkManager *_netHttp;
    NSMutableArray *_lits;
    int _maxpage;
    int _currentpage;//当前页
}
@end

@implementation MyLogController



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
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.title = @"账户日志";
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [self setupRefresh];
}


/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.myTable addHeaderWithTarget:self action:@selector(headerReresh)];
    //头部进入刷新
    [self.myTable headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.myTable addFooterWithTarget:self action:@selector(footerRereshing)];
    
}

#pragma mark 开始进入刷新状态
- (void)headerReresh
{
    [self lodeNet:@"1"];
    //底部显示刷新控件
    [self.myTable setFooterHidden:NO];
}



- (void)footerRereshing
{
    int page = _currentpage;
    //判断当前是否为最后一页
    if(_currentpage<_maxpage){
        [self lodeNet:[NSString stringWithFormat:@"%d",page+1]];
    }else{
        //底部隐藏刷新控件
        [self.myTable footerEndRefreshing];
        [self.myTable setFooterHidden:YES];
    }
}

- (void)lodeNet:(NSString*)page;
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"uc_money_log" forKey:@"act"];
    [dict setValue:_fanweapp.user_name forKey:@"email"];
    [dict setValue:_fanweapp.user_pwd forKey:@"pwd"];
    [dict setValue:page forKey:@"page"];
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
            LogList *list = [[LogList alloc]initWithDict:dict];
            [datalist addObject:list];
        }
        //当上拉刷新时
        if(_currentpage == 1){
            //清空当前数据
            [_lits removeAllObjects];
            [_lits addObjectsFromArray:datalist];
            [datalist removeAllObjects];
            // 刷新表格
            [self.myTable reloadData];
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.myTable headerEndRefreshing];
        }else{
            //当加载更多时数据应添加到数组后面
            [_lits addObjectsFromArray:datalist];
            [datalist removeAllObjects];
            [self.myTable reloadData];
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.myTable footerEndRefreshing];
            
        }
    }else{
        [FanweMessage alert:@"服务器连接失败，请检查您的网络"];
        [self.myTable headerEndRefreshing];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _lits.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyLogCell *cell = [[MyLogCell alloc]init];
    [cell setcellFrame:_lits[indexPath.row]];
    return cell.cllHeigh;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *mycell = @"MyLogCell";
     MyLogCell *cell = [tableView dequeueReusableCellWithIdentifier:mycell];
    if(cell == nil){
        cell = [[MyLogCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mycell];
    }
//    [cell setContentCell:[_lits objectAtIndex:[indexPath row]]];
    [cell setcellFrame:_lits[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    cell.backgroundColor = (indexPath.row%2)?[UIColor lightGrayColor]:[UIColor grayColor];
//    
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -充值
- (IBAction)rechargeAction:(id)sender {
    RechargeController *re = [[RechargeController alloc]init];
    [self.navigationController pushViewController:re animated:YES];
}

- (IBAction)withdrawAction:(id)sender {
    WithCashController *cash = [[WithCashController alloc]init];
    [self.navigationController pushViewController:cash animated:YES];
}
@end
