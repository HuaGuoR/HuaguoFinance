//
//  LoginController.m
//  fanwe_p2p
//
//  Created by mac on 14-7-29.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "LoginController.h"
#import "MFSideMenuContainerViewController.h"
#import "RegisterController.h"
#import "FanweMessage.h"
#import "GlobalVariables.h"
#import "ExtendNSDictionary.h"
#import "MineController.h"
#import "ResetPasswordController.h"
#import "IQKeyboardManager.h"

@interface LoginController (){
    UIButton *leftButton;
    MBProgressHUD *HUD;
	NetworkManager *netHttp;
    GlobalVariables *fanweApp;
}

@end

@implementation LoginController

@synthesize is_mine;

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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:NO];
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
    
    self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
    fanweApp = [GlobalVariables sharedInstance];
    self.navigationItem.title = @"登录";
    netHttp = [[NetworkManager alloc] init];
    
}

- (UIBarButtonItem *)leftMenuBarButtonItem {
    
    CGSize backButtonSize = CGSizeMake(33, 29);
	
	leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [leftButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	leftButton.frame = CGRectMake(0, 0, backButtonSize.width, backButtonSize.height);
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
	[leftButton setImage:[UIImage imageNamed:@"menu-icon.png"] forState:UIControlStateNormal];
	
	UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    return leftButtonItem;
}

#pragma mark -
#pragma mark - UIBarButtonItem Callbacks

- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

- (IBAction)loginAction:(id)sender {
    
    if ([_userNameField.text length] == 0){
		
		[FanweMessage alert:@"帐号不能为空"];
		
		return;
	}
	
	if ([_passwordField.text length] == 0){
		
		[FanweMessage alert:@"密码不能为空"];
        
		return;
	}
	
	[self loadNetData];
}

#pragma mark -- 忘记密码
- (IBAction)ResetPwdAction:(id)sender {
    ResetPasswordController *tmpController = [[ResetPasswordController alloc]
                                              initWithNibName:@"ResetPasswordController"
                                              bundle:nil];
    [[self navigationController] pushViewController:tmpController animated:YES];
}

-(void)loadNetData{
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	HUD.delegate = self;
	[HUD show:YES];
	
	NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
	[parmDict setObject:@"login" forKey:@"act"];
    [parmDict setObject:_userNameField.text forKey:@"email"];
	[parmDict setObject:_passwordField.text forKey:@"pwd"];
	
    netHttp.delegate = self;
    [netHttp startAsynchronous:parmDict addUserPwd:false useDataCached:false];
	
}

-(void)requestDone:(NSDictionary *) jsonDict error:(NSError *) error{
    if (HUD)
        [HUD hide:YES];
    if (jsonDict != nil){
        //response_code:服务器返回成功（1：成功；0：失败）
        if ([[jsonDict objectForKey:@"response_code"] intValue] == 1){
            NSString *userid = [jsonDict toString:@"id"];
            
            [fanweApp setUserInfo:userid user_name:[jsonDict toString:@"user_name"] user_pwd:_passwordField.text];
            
            #pragma mark -- 判断是登录状态时跳转到我的账户界面
            if (is_mine) {
                MineController *tmpController = [[MineController alloc] initWithNibName:@"MineController" bundle:nil];
                [[self navigationController] pushViewController:tmpController animated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }else {
            [FanweMessage alert:[jsonDict toString:@"show_err"]];
        }
		
    }else{
        [FanweMessage alert:@"服务器访问失败"];
    }
    
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
	HUD = nil;
}

- (IBAction)registerAction:(id)sender {
    RegisterController *tmpController = [[RegisterController alloc] init];
    [[self navigationController] pushViewController:tmpController animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
