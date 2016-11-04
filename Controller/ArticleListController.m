//
//  ArticleListController.m
//  fanwe_p2p
//
//  Created by mac on 14-8-14.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "ArticleListController.h"
#import "MFSideMenuContainerViewController.h"
#import "NetworkManager.h"
#import "MJRefresh.h"
#import "FanweMessage.h"
#import "Article.h"
#import "ArticleCell.h"
#import "ExtendNSDictionary.h"
#import "ArticleDetailsController.h"

@interface ArticleListController ()<HttpDelegate,UITableViewDataSource,UITableViewDelegate>{
    UIButton *leftButton;
    GlobalVariables *fanweApp;
    NetworkManager *netHttp;
    int cur_page;
    int total_page;
}

@property (nonatomic, retain) NSMutableArray *articleList;

@end

@implementation ArticleListController

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
    fanweApp = [GlobalVariables sharedInstance];
    netHttp = [[NetworkManager alloc] init];
    self.articleList = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"文章资讯";
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
    [self.articleList removeAllObjects];
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
	[parmDict setObject:@"article_list" forKey:@"act"];
    [parmDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
	
    netHttp.delegate = self;
    [netHttp startAsynchronous:parmDict addUserPwd:false useDataCached:false];
	
}

-(void)requestDone:(NSDictionary *) jsonDict error:(NSError *) error{
    if (jsonDict != nil){
        
        total_page = [[jsonDict objectForKey:@"page"] toInt:@"page_total"];
        
        id tmpDict = [jsonDict objectForKey:@"list"];
        if (tmpDict && tmpDict != [NSNull null]){
            NSDictionary *tmpListDict = [jsonDict objectForKey:@"list"];
            for (NSDictionary *dict in tmpListDict) {
                Article *article = [[Article alloc] init];
                [article setJson:dict];
                [self.articleList addObject:article];
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
    
    return [self.articleList count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44.0f;
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
        
    static NSString *IndexCellIdentifier = @"IndexCellIdentifier";
    ArticleCell *cell = nil;
    
    cell = (ArticleCell *)[tableView dequeueReusableCellWithIdentifier:IndexCellIdentifier];
    if (cell == nil)
    {
        cell = (ArticleCell *)[[[NSBundle mainBundle] loadNibNamed: @"ArticleCell"
                                                                      owner: self
                                                                    options: nil] lastObject];
    }
    if (self.articleList && [self.articleList count] != 0){
        Article *article = [self.articleList objectAtIndex:row];
        [cell setCellContent:article];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    Article *article = [self.articleList objectAtIndex:row];
    
    ArticleDetailsController *tmpController = [[ArticleDetailsController alloc]init];
    tmpController.article_id = article.article_id;
    [[self navigationController] pushViewController:tmpController animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
