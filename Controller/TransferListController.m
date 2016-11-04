//
//  TransferListController.m
//  fanwe_p2p
//
//  Created by mac on 14-8-13.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "TransferListController.h"
#import "MFSideMenuContainerViewController.h"
#import "NetworkManager.h"
#import "MJRefresh.h"
#import "FanweMessage.h"
#import "TransferCell.h"
#import "ProjectDetailsController.h"
#import "MJRefreshConst.h"
#import "SearchLoanInvestmentController.h"
#import "Transfer.h"
#import "ConfirmationTransfer.h"
#import "ExtendNSDictionary.h"

@interface TransferListController ()<HttpDelegate,UITableViewDataSource,UITableViewDelegate>{
    UIButton *leftButton;
    NetworkManager *netHttp;
    GlobalVariables *fanweApp;
    int cur_page;
    int total_page;
}

@property(strong, nonatomic) NSMutableArray *transferList;

@end

@implementation TransferListController

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
    self.navigationItem.title = @"债权转让";
    fanweApp = [GlobalVariables sharedInstance];
    netHttp = [[NetworkManager alloc] init];
    self.transferList = [[NSMutableArray alloc] init];
    self.myTableView.delegate = self;
	self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 集成刷新控件
    [self setupRefresh];
}

- (void)layoutNavButton {
    
    CGSize leftButtonSize = CGSizeMake(33, 29);
    
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [leftButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    leftButton.frame = CGRectMake(0, 0, leftButtonSize.width, leftButtonSize.height);
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [leftButton setImage:[UIImage imageNamed:@"menu-icon.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

- (void)leftSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
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
    [self.transferList removeAllObjects];
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
	[parmDict setObject:@"transfer" forKey:@"act"];
    [parmDict setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
	
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
                Transfer *transfer = [[Transfer alloc] init];
                [transfer setJson:dict];
                [self.transferList addObject:transfer];
                
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
    
    return [self.transferList count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 152.0f;
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
    
    static NSString *IndexCellIdentifier = @"IndexCellIdentifier";
    TransferCell *cell = nil;
    
    cell = (TransferCell *)[tableView dequeueReusableCellWithIdentifier:IndexCellIdentifier];
    if (cell == nil)
    {
        cell = (TransferCell *)[[[NSBundle mainBundle] loadNibNamed: @"TransferCell"
                                                                      owner: self
                                                                    options: nil] lastObject];
    }
    if (self.transferList && [self.transferList count] != 0){
        Transfer *transfer = [self.transferList objectAtIndex:row];
        [cell setCellContent:transfer];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    Transfer *transfer = [self.transferList objectAtIndex:row];
    
    ConfirmationTransfer *tmpController = [[ConfirmationTransfer alloc]init];
    tmpController.transfer = transfer;
    [[self navigationController] pushViewController:tmpController animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
