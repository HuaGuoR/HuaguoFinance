//
//  LoanInvestmentListController.m
//  fanwe_p2p
//
//  Created by mac on 14-8-6.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "LoanInvestmentListController.h"
#import "MFSideMenuContainerViewController.h"
#import "NetworkManager.h"
#import "MJRefresh.h"
#import "FanweMessage.h"
#import "HomeTableViewTopCell.h"
#import "ProjectDetailsController.h"
#import "MJRefreshConst.h"
#import "SearchLoanInvestmentController.h"
#import "ExtendNSDictionary.h"

@interface LoanInvestmentListController ()<HttpDelegate,UITableViewDataSource,UITableViewDelegate>{
    UIButton *leftButton;
    UIButton *rightButton;
    UIButton *backButton;
    NetworkManager *netHttp;
    GlobalVariables *fanweApp;
    int cur_page;
    int total_page;
}

@property(strong, nonatomic) NSMutableArray *dealList;

@end

@implementation LoanInvestmentListController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
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
    if (self.is_back) {
        self.navigationItem.title = @"借款投资搜索";
    }else{
        self.navigationItem.title = @"借款投资";
    }
    
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
    
    if (self.is_back) {
        CGSize backButtonSize = CGSizeMake(50, 30);
        
        backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.tag = 0;
        [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        
        backButton.frame = CGRectMake(backButton.frame.origin.x, backButton.frame.origin.y, backButtonSize.width, backButtonSize.height);
        backButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [backButton setImage:[UIImage imageNamed:@"ico_back.png"] forState:UIControlStateNormal];
        
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backButtonItem;
    }else{
        CGSize leftButtonSize = CGSizeMake(33, 29);
        
        leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [leftButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        leftButton.frame = CGRectMake(0, 0, leftButtonSize.width, leftButtonSize.height);
        leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [leftButton setImage:[UIImage imageNamed:@"menu-icon.png"] forState:UIControlStateNormal];
        
        UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftButtonItem;
        
        CGSize rightButtonSize = CGSizeMake(25, 25);
        
        rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [rightButton addTarget:self action:@selector(rightSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        rightButton.frame = CGRectMake(0, 0, rightButtonSize.width, rightButtonSize.height);
        rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [rightButton setImage:[UIImage imageNamed:@"ic_title_search.png"] forState:UIControlStateNormal];
        
        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    
}

- (void)leftSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

- (void)rightSideMenuButtonPressed:(id)sender {
    SearchLoanInvestmentController *tmpController = [[SearchLoanInvestmentController alloc] init];
    [[self navigationController] pushViewController:tmpController animated:YES];
    
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
	[parmDict setObject:@"deals" forKey:@"act"];
    [parmDict setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    if (self.cid) {
        [parmDict setObject:self.cid forKey:@"cid"];
        [parmDict setObject:self.level forKey:@"level"];
        [parmDict setObject:self.interest forKey:@"interest"];
        [parmDict setObject:self.deal_status forKey:@"deal_status"];
    }
	
    netHttp.delegate = self;
    [netHttp startAsynchronous:parmDict addUserPwd:false useDataCached:false];
	
}

-(void)requestDone:(NSDictionary *) jsonDict error:(NSError *) error{
    if (jsonDict != nil){
        total_page = [[jsonDict objectForKey:@"page"] toInt:@"page_total"];
        
        id iddeal  = [jsonDict objectForKey:@"item"];
        if (iddeal && iddeal != [NSNull null]){
            NSDictionary *tmpListDict = [jsonDict objectForKey:@"item"];
            for (NSDictionary *dict in tmpListDict) {
                Home *home = [[Home alloc] init];
                [home setJson:dict];
                [self.dealList addObject:home];
                
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
	return 142.0f;
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
    
    static NSString *IndexCellIdentifier = @"IndexCellIdentifier";
    HomeTableViewTopCell *cell = nil;
    
    cell = (HomeTableViewTopCell *)[tableView dequeueReusableCellWithIdentifier:IndexCellIdentifier];
    if (cell == nil)
    {
        cell = (HomeTableViewTopCell *)[[[NSBundle mainBundle] loadNibNamed: @"HomeTableViewTopCell"
                                                                      owner: self
                                                                    options: nil] lastObject];
    }
    if (self.dealList && [self.dealList count] != 0){
        Home *home = [self.dealList objectAtIndex:row];
        [cell setCellContent:home];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    Home *home = [self.dealList objectAtIndex:row];
    
    ProjectDetailsController *tmpController = [[ProjectDetailsController alloc] init];
    tmpController.home = home;
    [[self navigationController] pushViewController:tmpController animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
