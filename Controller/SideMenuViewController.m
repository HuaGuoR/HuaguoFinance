//
//  SideMenuViewController.m
//  fanwe_p2p
//
//  Created by mac on 14-7-29.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "SideMenuViewController.h"
#import "GlobalVariables.h"
#import "MFSideMenuContainerViewController.h"
#import "HomePageController.h"
#import "LoginController.h"
#import "MineController.h"
#import "MoreSettingController.h"
#import "LoanInvestmentListController.h"
#import "MyNaController.h"
#import "TransferListController.h"
#import "ArticleListController.h"
#import "MoreSettingController.h"

@interface SideMenuViewController ()
{
    NSArray *arr_text;
    GlobalVariables *fanweApp;
    NSMutableDictionary *_cateController;
}
@end

@implementation SideMenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:) name:@"reloaded" object:nil];
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
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                         [UIColor whiteColor],UITextAttributeTextColor,
                                                                         [UIColor whiteColor], UITextAttributeTextShadowColor,
                                                                         [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0], UITextAttributeFont, nil]];
    }
#endif
    
    self.clearsSelectionOnViewWillAppear = NO;
    _cateController = [[NSMutableDictionary alloc]init];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_sliding_menu.png"]];
    self.tableView.separatorColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    
    fanweApp = [GlobalVariables sharedInstance];
    fanweApp.indexNum = 1;
    
    arr_text = @[@"网站首页",@"借款投资",@"债券转让",@"文章资讯",@"更多设置"];
    
}

- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.parentViewController;
}

/**
 默认选中某列
 */
-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    
    NSInteger selectedIndex = fanweApp.indexNum;
    
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    
    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [super viewWillAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0f;
}

/**
 设置侧滑菜会员名字
 */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lb_text = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 200, 200.0)];
    lb_text.backgroundColor = [UIColor clearColor];
    lb_text.textColor = [UIColor whiteColor];
    if (fanweApp.is_login) {
        lb_text.text = [NSString stringWithFormat:@"%@，您好！",fanweApp.user_name];
    }else{
        lb_text.text = @"亲，您还没有登录哦";
    }
    
    lb_text.font = [UIFont fontWithName:@"Helvetica" size:15];
    lb_text.textAlignment = NSTextAlignmentCenter;
    return lb_text;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

/**
 设置侧滑菜单图标、文字等
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];    
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    int index = (int)indexPath.row;
    UIImage *img_item;
    
    switch (index) {
        case 0:
            if (index == fanweApp.indexNum) {
                img_item = [UIImage imageNamed:@"ic_menu_login_or_registe_select"];
            }else{
                img_item = [UIImage imageNamed:@"ic_menu_login_or_registe_normal"];
            }
            
            break;
        case 1:
            if (index == fanweApp.indexNum) {
                img_item = [UIImage imageNamed:@"ic_menu_home_select"];
            }else{
                img_item = [UIImage imageNamed:@"ic_menu_home_normal"];
            }
            
            break;
        case 2:
            if (index == fanweApp.indexNum) {
                img_item = [UIImage imageNamed:@"ic_menu_i_want_invest_select"];
            }else{
                img_item = [UIImage imageNamed:@"ic_menu_i_want_invest_normal"];
            }
            
            break;
        case 3:
            if (index == fanweApp.indexNum) {
                img_item = [UIImage imageNamed:@"ic_menu_i_want_borrow_select"];
            }else{
                img_item = [UIImage imageNamed:@"ic_menu_i_want_borrow_normal"];
            }
            
            break;
        case 4:
            if (index == fanweApp.indexNum) {
                img_item = [UIImage imageNamed:@"ic_menu_article_select"];
            }else{
                img_item = [UIImage imageNamed:@"ic_menu_article_normal"];
            }
            
            break;
        case 5:
            if (index == fanweApp.indexNum) {
                img_item = [UIImage imageNamed:@"ic_menu_setting_select"];
            }else{
                img_item = [UIImage imageNamed:@"ic_menu_setting_normal"];
            }
            
            break;
        default:
            break;
    }
    
    cell.imageView.image = img_item;
    cell.backgroundColor = [UIColor clearColor];
    cell.imageView.frame = CGRectMake(0,0,44,44);
    if (index == 0) {
        if (fanweApp.is_login) {
            cell.textLabel.text = @"我的账户";
        }else{
            cell.textLabel.text = @"登录/注册";
        }
    }else{
        cell.textLabel.text = [arr_text objectAtIndex:index-1];
    }
    
    
    cell.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_menu_item_select.png"]];
    cell.textLabel.highlightedTextColor = [ UIColor colorWithRed: 0.31
                                                           green: 0.67
                                                            blue: 0.9
                                                           alpha: 1.0
                                           ];
    
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

/**
 点击菜单切换视图
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    int row = (int)indexPath.row;
    UIImage *img_item;
    
    switch (row) {
        case 0:
            img_item = [UIImage imageNamed:@"ic_menu_login_or_registe_select"];
            
            break;
        case 1:
            img_item = [UIImage imageNamed:@"ic_menu_home_select"];
            
            break;
        case 2:
            img_item = [UIImage imageNamed:@"ic_menu_i_want_invest_select"];
            
            break;
        case 3:
            img_item = [UIImage imageNamed:@"ic_menu_i_want_borrow_select"];
            
            break;
        case 4:
            img_item = [UIImage imageNamed:@"ic_menu_article_select"];
            
            break;
        case 5:
            img_item = [UIImage imageNamed:@"ic_menu_setting_select"];
            
            break;
        default:
            break;
    }
    cell.imageView.image = img_item;
    
    UIViewController *viewController = nil;
    //设置视图缓存
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HomePageController *homePageController = [[HomePageController alloc] init];
         LoanInvestmentListController *loanInvestmentListController = [[LoanInvestmentListController alloc] init];
        TransferListController *transferListController = [[TransferListController alloc] init];
       [_cateController setObject:transferListController forKey:@"3"];
        [_cateController setObject:loanInvestmentListController forKey:@"2"];
        [_cateController setObject:homePageController forKey:@"1"];
    });

    switch (row) {
        case 0:
        {
            if (fanweApp.is_login) {
                MineController *secondController = [[MineController alloc] init];
                viewController = secondController;
                
            }else{
                LoginController *loginController = [[LoginController alloc] init];
                loginController.is_mine = YES;
                viewController = loginController;
            }
            
        }
            break;
        case 1:
        {
          viewController = _cateController[@"1"];
        }
            break;
        case 2:
        {
           
            viewController = _cateController[@"2"];
        }
            break;
        case 3:
        {
            viewController = _cateController[@"3"];
        }
            break;
        case 4:
        {
            ArticleListController *articleListController = [[ArticleListController alloc] init];
            viewController = articleListController;
        }
            break;
        case 5:
        {
            MoreSettingController *secondController = [[MoreSettingController alloc] init];
            viewController = secondController;
        }
            break;
            
        default:
            break;
    }
    fanweApp.indexNum = row;

    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
   
    NSArray *controllers = [NSArray arrayWithObject:viewController];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
