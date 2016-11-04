//
//  BidRecordListController.m
//  fanwe_p2p
//
//  Created by mac on 14-8-19.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "BidRecordListController.h"
#import "NetworkManager.h"
#import "MJRefresh.h"
#import "FanweMessage.h"
#import "BidRecordCell.h"
#import "ProjectDetailsController.h"
#import "MJRefreshConst.h"
#import "SearchLoanInvestmentController.h"
#import "BidRecord.h"
#import "MyWebViewController.h"
#import "ExtendNSDictionary.h"

@interface BidRecordListController ()<HttpDelegate,UITableViewDataSource,UITableViewDelegate>{
    UIButton *backButton;
    NetworkManager *netHttp;
    GlobalVariables *fanweApp;
    int cur_page;
    int total_page;
}

@property(strong, nonatomic) NSMutableArray *dealList;

@end

@implementation BidRecordListController

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
    
    [self layoutNavButton];
    self.navigationItem.title = @"投标记录";
    fanweApp = [GlobalVariables sharedInstance];
    netHttp = [[NetworkManager alloc] init];
    self.dealList = [[NSMutableArray alloc] init];
    self.myTableView.delegate = self;
	self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 集成刷新控件
    [self setupRefresh];
}

- (void)layoutNavButton {
    
    CGSize backButtonSize = CGSizeMake(50, 30);
    
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.tag = 0;
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    backButton.frame = CGRectMake(backButton.frame.origin.x, backButton.frame.origin.y, backButtonSize.width, backButtonSize.height);
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [backButton setImage:[UIImage imageNamed:@"ico_back.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
}

- (void)backAction:(id)sender
{
	UIButton *btn = sender;
	if (btn.tag == 0){
		[self.navigationController popViewControllerAnimated:YES];
	}else {
		[self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:btn.tag] animated:YES];
	}
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.myTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //自动刷新(一进入程序就下拉刷新)
    [self.myTableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.myTableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self loadNetData:1];
    cur_page = 1;
    total_page = 0;
    [self.myTableView setFooterHidden:NO];
    [self.dealList removeAllObjects];
    // 刷新表格
    
}

- (void)footerRereshing
{
    if (cur_page < total_page) {
        cur_page ++;
        [self loadNetData:cur_page];
    }else{
        [self.myTableView footerEndRefreshing];
        [self.myTableView setFooterHidden:YES];
    }
    
}

-(void)loadNetData:(int)page{
	
	NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
	[parmDict setObject:@"uc_lend" forKey:@"act"];
    [parmDict setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
	
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
                BidRecord *bidRecord = [[BidRecord alloc] init];
                [bidRecord setJson:dict];
                [self.dealList addObject:bidRecord];
                
            }
        }
        [self.myTableView reloadData];
    }else{
        [FanweMessage alert:@"服务器访问失败"];
    }
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.myTableView headerEndRefreshing];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.myTableView footerEndRefreshing];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dealList count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 148.0f;
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
    
    static NSString *IndexCellIdentifier = @"IndexCellIdentifier";
    BidRecordCell *cell = nil;
    
    cell = (BidRecordCell *)[tableView dequeueReusableCellWithIdentifier:IndexCellIdentifier];
    if (cell == nil)
    {
        cell = (BidRecordCell *)[[[NSBundle mainBundle] loadNibNamed: @"BidRecordCell"
                                                                      owner: self
                                                                    options: nil] lastObject];
    }
    if (self.dealList && [self.dealList count] != 0){
        BidRecord *bidRecord = [self.dealList objectAtIndex:row];
        [cell setCellContent:bidRecord];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    BidRecord *bidRecord = [self.dealList objectAtIndex:row];
    
    MyWebViewController *tmpController = [[MyWebViewController alloc]init];
    tmpController.url = bidRecord.app_url;
    tmpController.titleStr = @"详情";
    [[self navigationController] pushViewController:tmpController animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
