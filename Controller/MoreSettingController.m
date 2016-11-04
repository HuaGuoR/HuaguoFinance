//
//  MoreSettingController.m
//  fanwe_p2p
//
//  Created by mac on 14-7-31.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "MoreSettingController.h"
#import "MFSideMenuContainerViewController.h"
#import "GlobalVariables.h"
#import "LoginController.h"
#import "ArticleDetailsController.h"
#import "FanweMessage.h"
#import "NetworkManager.h"
#import "ExtendNSDictionary.h"

@interface MoreSettingController ()<UIAlertViewDelegate,HttpDelegate>{
    UIButton *leftButton;
    GlobalVariables *fanweApp;
    NetworkManager *netHttp;
    
    NSString *ios_down_url;
    UIAlertView *alert1;
    UIAlertView *alert2;
}

@end

@implementation MoreSettingController

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
    
    self.navigationItem.title = @"更多设置";
    self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
    fanweApp = [GlobalVariables sharedInstance];
    netHttp = [[NetworkManager alloc] init];
    
    [self initCommponent];
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

- (void)leftSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

-(void)initCommponent{
    [_serviceNumBtn setTitle:[NSString stringWithFormat:@"客服电话   %@",fanweApp.kf_phone] forState:UIControlStateNormal];
    
    [_serviceEmailBtn setTitle:[NSString stringWithFormat:@"客服邮箱   %@",fanweApp.kf_email] forState:UIControlStateNormal];
    
    [_checkVersionBtn setTitle:[NSString stringWithFormat:@"版本检测   %@",[fanweApp.config objectForKey:@"version_name"]] forState:UIControlStateNormal];
    
    if (fanweApp.is_login) {
        [_exitLoginBtn setTitle:@"退出账号" forState:UIControlStateNormal];
    }else{
        [_exitLoginBtn setTitle:@"登录" forState:UIControlStateNormal];
    }
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    float allSize = 0;
    for (NSString *p in files) {
        
        NSString *path = [cachPath stringByAppendingPathComponent:p];
        allSize += [self folderSizeAtPath:path];
        [_clearCacheBtn setTitle:[NSString stringWithFormat:@"清除缓存   %.2fM",allSize] forState:UIControlStateNormal];
    }
    
}

- (IBAction)clearCacheAction:(id)sender {
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
//    NSLog(@"files :%d",[files count]);
    for (NSString *p in files) {
        
        NSError *error;
        NSString *path = [cachPath stringByAppendingPathComponent:p];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            [_clearCacheBtn setTitle:[NSString stringWithFormat:@"清除缓存   0M"] forState:UIControlStateNormal];
        }
    }
}

//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    //    NSLog(@"foderSize:%.2fM",folderSize/(1024.0*1024.0));
    //    cachesize.text = [NSString stringWithFormat:@"%.2fM",folderSize/(1024.0*1024.0)];
    return folderSize/(1024.0*1024.0);
}

- (IBAction)serviceNumAction:(id)sender {
    NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",fanweApp.kf_phone]];
    [[UIApplication sharedApplication] openURL:phoneNumberURL];
}

- (IBAction)aboutUsAction:(id)sender {
    
    ArticleDetailsController *tmpController = [[ArticleDetailsController alloc]init];
    tmpController.article_id = fanweApp.about_info;
    tmpController.titleStr = @"关于我们";
    [[self navigationController] pushViewController:tmpController animated:YES];
}

- (IBAction)checkVersionAction:(id)sender {
    [self loadNetData];
}

-(void)loadNetData{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"version" forKey:@"act"];
    [parmDict setObject:@"ios" forKey:@"dev_type"];
    [parmDict setObject:[fanweApp.config objectForKey:@"version_version"] forKey:@"version"];
    
    netHttp.delegate = self;
    [netHttp startAsynchronous:parmDict addUserPwd:YES useDataCached:YES];
}

-(void)requestDone:(NSDictionary *) jsonDict error:(NSError *) error{
    if (jsonDict != nil){
        
        ios_down_url = [jsonDict toString:@"ios_down_url"];
        
        if ([jsonDict toInt:@"has_upgrade"] == 1) {
            
            alert1 = [[UIAlertView alloc] initWithTitle:@"温馨提示：" message:@"发现新版本，需要升级吗？" delegate:self cancelButtonTitle:@"以后再说吧" otherButtonTitles:@"马上升级", nil];
            [alert1 show];
        }else{
            [FanweMessage alert:@"当前已经是最新版本了！"];
        }
        
    }else{
        [FanweMessage alert:@"服务器访问失败"];
    }
}

#pragma mark uialertViewdail
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    if (alertView == alert1) {
        if (buttonIndex == 1) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ios_down_url]];
        }
    }else if(alertView == alert2){
        if (buttonIndex == 1) {
            [fanweApp setUserInfo:@"" user_name:@"" user_pwd:@""];
            [_exitLoginBtn setTitle:@"登录" forState:UIControlStateNormal];
        }
    }
    
}

- (IBAction)exitLoginAction:(id)sender {
    if (fanweApp.is_login) {
        alert2 = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定要退出账户？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert2 show];
        
    }else{
        fanweApp.indexNum = 0;
        LoginController *tmpController = [[LoginController alloc]
                                          initWithNibName:@"LoginController"
                                          bundle:nil];
        tmpController.is_mine = YES;
        [[self navigationController] pushViewController:tmpController animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
