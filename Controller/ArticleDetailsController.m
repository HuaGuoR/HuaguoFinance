//
//  MyWebViewController.m
//  fanwe_p2p
//
//  Created by mac on 14-8-4.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "ArticleDetailsController.h"
#import "MBProgressHUD.h"
#import "NetworkManager.h"
#import "GlobalVariables.h"
#import "ExtendNSDictionary.h"
#import "FanweMessage.h"

@interface ArticleDetailsController ()<UIWebViewDelegate,MBProgressHUDDelegate,HttpDelegate>{
    
    MBProgressHUD *HUD;
	GlobalVariables *fanweApp;
    NetworkManager *netHttp;
    
    UIButton *backButton;
    UIButton *rightButton;
    
}
@end

@implementation ArticleDetailsController

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

    _myWebView.delegate = self;
    fanweApp = [GlobalVariables sharedInstance];
	netHttp = [[NetworkManager alloc] init];

    
    if (_titleStr != nil && ![_titleStr isEqualToString:@""]) {
        self.navigationItem.title = _titleStr;
    }else{
        self.navigationItem.title = @"文章";
    }
    
    [self layoutNavButton];
    
    [self loadNetData];
}

- (void)layoutNavButton{
	
    CGSize backButtonSize = CGSizeMake(50, 30);
	
	backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	backButton.tag = 0;
    [backButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
	
	backButton.frame = CGRectMake(backButton.frame.origin.x, backButton.frame.origin.y, backButtonSize.width, backButtonSize.height);
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
	[backButton setImage:[UIImage imageNamed:@"ico_back.png"] forState:UIControlStateNormal];
	
	UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    CGSize rightButtonSize = CGSizeMake(46, 26);
	
	rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
	[rightButton setTitle:@"刷新" forState:UIControlStateNormal];
	rightButton.frame = CGRectMake(0, 0, rightButtonSize.width, rightButtonSize.height);
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
	[rightButton setBackgroundImage:[UIImage imageNamed:@"btn_confirmation_transfer_right.png"] forState:UIControlStateNormal];
	
	UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)btnAction:(id)sender
{
    if (sender == backButton) {
        UIButton *btn = sender;
        if (btn.tag == 0){
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:btn.tag] animated:YES];
        }
    }else{
        [self loadNetData];
    }
	
}

-(void)loadNetData{
	
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	HUD.delegate = self;
	[HUD show:YES];
    
	NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
	[parmDict setObject:@"show_article" forKey:@"act"];
    [parmDict setObject:self.article_id forKey:@"id"];
	
    netHttp.delegate = self;
    [netHttp startAsynchronous:parmDict addUserPwd:false useDataCached:false];
	
}

-(void)requestDone:(NSDictionary *) jsonDict error:(NSError *) error{
    
    [HUD hide:YES];
    
    if (jsonDict != nil){
        
        if ([jsonDict toString:@"content"] != nil && ![[jsonDict toString:@"content"] isEqualToString:@""]){
            [_myWebView loadHTMLString:[jsonDict toString:@"content"] baseURL:nil];
        }
        
    }else{
        [FanweMessage alert:@"服务器访问失败"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
