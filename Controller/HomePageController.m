//
//  HomePageController.m
//  fanwe_p2p
//
//  Created by mac on 14-7-31.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "HomePageController.h"
#import "MFSideMenuContainerViewController.h"
#import "GlobalVariables.h"
#import "MineController.h"
#import "LoginController.h"
#import "AdvController.h"
#import "MJRefresh.h"
#import "NetworkManager.h"
#import "FanweMessage.h"
#import "ExtendNSDictionary.h"
#import "Advs.h"
#import "Home.h"
#import "HomeTableViewTopCell.h"
#import "HomeTableViewBottomCell.h"
#import "MyWebViewController.h"
#import "ProjectDetailsController.h"
#import "DealCate.h"
#import "EGOImageView.h"

#define RYJSW [UIScreen mainScreen].bounds.size.width
@interface HomePageController ()<HttpDelegate,AdvViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    UIButton *leftButton;
    UIButton *rightButton;
    GlobalVariables *fanweApp;
    AdvController *advController;
    NetworkManager *netHttp;
    NSString *ios_down_url;
    
    NSString *virtual_money_1;
    NSString *virtual_money_2;
    NSString *virtual_money_3;
}

@property(strong, nonatomic) NSMutableArray *advsList;
@property(strong, nonatomic) NSMutableArray *dealList;

@end

@implementation HomePageController

@synthesize myTableView;

- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}

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
    
    //初始化控件
    [self initCommponent];
    //菜单栏左右按钮
    [self layoutNavButton];
    // 集成刷新控件
    [self setupRefresh];
}

/**
 初始化控件
 */
- (void)initCommponent{
    fanweApp = [GlobalVariables sharedInstance];
    netHttp = [[NetworkManager alloc] init];
    self.advsList = [[NSMutableArray alloc] init];
    self.dealList = [[NSMutableArray alloc] init];
    self.navigationItem.title = nil;
    self.myTableView.delegate = self;
	self.myTableView.dataSource = self;
    
    //初始化广告类
    advController = [[AdvController alloc] init];
    advController.view.tag = -99;
//    advController.view.frame = CGRectMake(0, 0,_advsView.frame.size.width, _advsView.frame.size.height);
    advController.view.frame = CGRectMake(0, 0, RYJSW, RYJSW *0.4);
    advController.delegate = self;
    [advController AllowsCloseAdvs:NO];
    [_advsView addSubview:advController.view];
}

/**
 菜单栏左右按钮
 */
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
    
    
    CGSize rightButtonSize = CGSizeMake(30, 30);
	
	rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [rightButton addTarget:self action:@selector(rightSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	rightButton.frame = CGRectMake(0, 0, rightButtonSize.width, rightButtonSize.height);
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
	[rightButton setImage:[UIImage imageNamed:@"ic_mine.png"] forState:UIControlStateNormal];
	
	UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
}

/**
 相应左侧侧滑点击事件
 */
- (void)leftSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

/**
 相应右侧按钮点击事件
 */
- (void)rightSideMenuButtonPressed:(id)sender {
    fanweApp.indexNum = 0;
    if (fanweApp.is_login) {
        MineController *tmpController = [[MineController alloc] init];
        [[self navigationController] pushViewController:tmpController animated:YES];
        
    }else{
        LoginController *tmpController = [[LoginController alloc] init];
        [[self navigationController] pushViewController:tmpController animated:YES];
    }
    
}

/**
 页面想要出现时添加菜单栏中间标题栏
 */
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _titleView.center = CGPointMake(self.navigationController.navigationBar.bounds.size.width / 2, self.navigationController.navigationBar.bounds.size.height / 2);
    [self.navigationController.navigationBar addSubview:_titleView];
    _programTitle.text = fanweApp.program_title;
    _siteDomain.text = fanweApp.site_domain;
    
}

/**
 页面想要消失时移除菜单栏中间标题栏
 */
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_titleView removeFromSuperview];
}

/**
 集成刷新控件
 */
- (void)setupRefresh
{
    //下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.myTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //自动刷新(一进入程序就下拉刷新)
    [self.myTableView headerBeginRefreshing];
}

/**
 开始进入头部刷新状态
 */
- (void)headerRereshing
{
    [self loadNetData];
    [self.advsList removeAllObjects];
    [self.dealList removeAllObjects];
    
}

/**
 加载init接口
 */
-(void)loadNetData{
	
	NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
	[parmDict setObject:@"init" forKey:@"act"];
	
    netHttp.delegate = self;
    [netHttp startAsynchronous:parmDict addUserPwd:false useDataCached:false];
	
}

/**
 加载检测版本（version）接口
 */
//-(void)loadNetData2{
//    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
//    [parmDict setObject:@"version" forKey:@"act"];
//    [parmDict setObject:@"ios" forKey:@"dev_type"];
//    [parmDict setObject:[fanweApp.config objectForKey:@"version_version"] forKey:@"version"];
//    
//    netHttp.delegate = self;
//    [netHttp startAsynchronous:parmDict addUserPwd:YES useDataCached:YES];
//}

/**
 相应网络请求，并解析提取json数据
 */
- (void)requestDone:(NSDictionary *) jsonDict error:(NSError *) error{
    if (jsonDict != nil){
        
        if ([@"init" isEqualToString:[jsonDict toString:@"act"]]) {
            virtual_money_1 = [jsonDict toString:@"virtual_money_1"];
            virtual_money_2 = [jsonDict toString:@"virtual_money_2"];
            virtual_money_3 = [jsonDict toString:@"virtual_money_3"];
            
            id tmpDict = [jsonDict objectForKey:@"index_list"];
            id idadvs  = [tmpDict objectForKey:@"adv_list"];
            if (idadvs && idadvs != [NSNull null]){
                NSDictionary *tmpListDict = [tmpDict objectForKey:@"adv_list"];
                for (NSDictionary *dict in tmpListDict) {
                    Advs *advs = [[Advs alloc] init];
                    [advs setJson:dict];
                    [self.advsList addObject:advs];
                }
            }
            
            if ([self.advsList count]>0) {
                Advs *tmpAdvs = [self.advsList objectAtIndex:0];
                if ([tmpAdvs.img isEqualToString:@"img"]) {
                    UIImage *tmpImg = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tmpAdvs.img]]];
                    UIImageView *tmpImageView = [[UIImageView alloc]initWithImage:tmpImg];
                    
//                    float tmpRate = tmpImageView.bounds.size.width / tmpImageView.bounds.size.height;
                    
//                    advController.view.frame = CGRectMake(0, 0,_advsView.frame.size.width, RYJSW );
                }
                
                advController.advsList = self.advsList;
                [advController showAdvs];
            }
            
            id iddeal  = [tmpDict objectForKey:@"deal_list"];
            if (iddeal && iddeal != [NSNull null]){
                NSDictionary *tmpListDict = [tmpDict objectForKey:@"deal_list"];
                for (NSDictionary *dict in tmpListDict) {
                    Home *home = [[Home alloc] init];
                    [home setJson:dict];
                    [self.dealList addObject:home];
                    
                }
            }
            
            [self.myTableView reloadData];
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.myTableView headerEndRefreshing];
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.myTableView footerEndRefreshing];
            
//            [self performSelector:@selector(loadNetData2) withObject:nil afterDelay:0.1];
        }else{
            ios_down_url = [jsonDict toString:@"ios_down_url"];
            
            if ([jsonDict toInt:@"has_upgrade"] == 1) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示：" message:@"发现新版本，需要升级吗？" delegate:self cancelButtonTitle:@"以后再说吧" otherButtonTitles:@"马上升级", nil];
                [alert show];
            }
        }
        
    }else{
        [FanweMessage alert:@"服务器访问失败"];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.myTableView headerEndRefreshing];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.myTableView footerEndRefreshing];
    }
    
}

#pragma mark uialertViewdail
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    if (buttonIndex == 1) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ios_down_url]];
    }
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0){
        return [self.dealList count];
    }else{
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 142.0f;
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    
    if (section == 0){
    
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
    }else{
        static NSString *IndexCellIdentifier = @"IndexCellIdentifier";
        HomeTableViewBottomCell *cell = nil;
        
        cell = (HomeTableViewBottomCell *)[tableView dequeueReusableCellWithIdentifier:IndexCellIdentifier];
        if (cell == nil)
        {
            cell = (HomeTableViewBottomCell *)[[[NSBundle mainBundle] loadNibNamed: @"HomeTableViewBottomCell"
                                                                          owner: self
                                                                        options: nil] lastObject];
        }
        [cell setCellContent:virtual_money_1 virtual_money_2:virtual_money_2 virtual_money_3:virtual_money_3];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        return cell;
    }
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    if (section == 0){
        Home *home = [self.dealList objectAtIndex:row];
        
        ProjectDetailsController *tmpController = [[ProjectDetailsController alloc] init];
        tmpController.home = home;
        [[self navigationController] pushViewController:tmpController animated:YES];
    }
}

/**
 广告位点击事件
 */
- (void)didSelectAdvAtIndex:(NSString *) index{
    if (self.advsList && [self.advsList count] > [index intValue]){
        Advs *advs = [self.advsList objectAtIndex:[index intValue]];
        [self didSelect:advs type:@"adv"];
    }
}

-(void)didSelect:(Advs *) advs type:(NSString *) type{
    //type  1：文章ID，调用文章show_article接口展示文章内容  2：url链接址
    if (advs.type == 1){
        MyWebViewController *tmpController = [[MyWebViewController alloc]
                                              initWithNibName:@"MyWebViewController"
                                              bundle:nil];
        tmpController.url = advs.data;
        tmpController.titleStr = advs.name;
        [[self navigationController] pushViewController:tmpController animated:YES];
        
    }else if(advs.type == 2){
        //open_url_type = 1时，有效；0:使用内部浏览器打开;1:使用外部浏览器打开
        if (advs.open_url_type == 0) {
            MyWebViewController *tmpController = [[MyWebViewController alloc]
                                                  initWithNibName:@"MyWebViewController"
                                                  bundle:nil];
            tmpController.url = advs.data;
            tmpController.titleStr = advs.name;
            [[self navigationController] pushViewController:tmpController animated:YES];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:advs.data]];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
