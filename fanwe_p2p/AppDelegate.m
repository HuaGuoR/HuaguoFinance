//
//  AppDelegate.m
//  fanwe_p2p
//
//  Created by mac on 14-7-28.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "AppDelegate.h"
#import "HomePageController.h"
#import "SideMenuViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "NetworkManager.h"
#import "MyNaController.h"
#import "ExtendNSDictionary.h"
#import "FanweMessage.h"
#import "MyWebViewController.h"
#import "ArticleDetailsController.h"
#import "DealCate.h"
#import "APService.h"

@interface AppDelegate()
{
    NSString *_content;
}
@end

@implementation AppDelegate

- (HomePageController *)demoController {
    return [[HomePageController alloc] initWithNibName:@"HomePageController" bundle:nil];
}

- (UINavigationController *)navigationController {
    return [[MyNaController alloc]
            initWithRootViewController:[self demoController]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    fanweApp = [GlobalVariables sharedInstance];
    
    SideMenuViewController *leftMenuViewController = [[SideMenuViewController alloc] init];
    //    SideMenuViewController *rightMenuViewController = [[SideMenuViewController alloc] init];
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:[self navigationController]
                                                    leftMenuViewController:leftMenuViewController
                                                    rightMenuViewController:nil];
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
	[parmDict setObject:@"init" forKey:@"act"];
    
	NetworkManager *netHttp = [[NetworkManager alloc] init];
	NSDictionary *initDict =[netHttp sendAndWaitResponse:parmDict addUserPwd:true useDataCached:true];
    netHttp = nil;
    
    if (initDict != nil){
//        [[fanweApp sysCfg] setJson:initDict];
        
        fanweApp.program_title = [initDict toString:@"program_title"];
        fanweApp.site_domain = [initDict toString:@"site_domain"];
        fanweApp.kf_phone = [initDict toString:@"kf_phone"];
        fanweApp.kf_email = [initDict toString:@"kf_email"];
        fanweApp.about_info = [initDict toString:@"about_info"];
        
        NSArray *iddealcate  = [initDict objectForKey:@"deal_cate_list"];
        
        NSMutableArray *tmp_list2 = [[NSMutableArray alloc] init];
        fanweApp.deal_cate_list = tmp_list2;
        
        if (iddealcate != nil && [iddealcate count] > 0){
            NSDictionary *tmpListDict = [initDict objectForKey:@"deal_cate_list"];
            for (NSDictionary *dict in tmpListDict) {
                DealCate *dealCate = [[DealCate alloc] init];
                [dealCate setJson:dict];
                [fanweApp.deal_cate_list addObject:dealCate];
                
            }
        }
    }
    
    
#pragma mark --极光推送
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)];
    [APService setupWithOption:launchOptions];
    
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.window.rootViewController = container;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
#pragma mark 极光
    
    [APService registerDeviceToken:deviceToken];
}

//在app被中断之后，先进入后台：
- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	//NSLog(@"applicationDidEnterBackground");
    EnterForeground = NO;
}


//在app被中断后继续时，要从后台模式切换到前台：
- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    //NSLog(@"applicationWillEnterForeground");
    
    [application setApplicationIconBadgeNumber:0];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    EnterForeground = YES;
}

#ifdef __IPHONE_7_0
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    MyLog(@"ssssssssssss%@",userInfo);
    _content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSString *customizeField1 = [userInfo valueForKey:@"type"]; //自定义参数，key是自己定义的


    if (EnterForeground){ //程序在前台时

        if(customizeField1 != nil && ![customizeField1 isEqualToString:@""])
        {
            //咱不处理
            /*if([customizeField1 isEqualToString:@"1"]){
                [FanweMessage alert:customizeField1];
            }else if ([customizeField1 isEqualToString:@"2"]){
            
            }else if ([customizeField1 isEqualToString:@"3"]){
                
                NSString *dlid = [userInfo valueForKey:@"data"];
                [self jpushActionOnforground:dlid url:@"" title:@""];
                
            }else if ([customizeField1 isEqualToString:@"4"]){
                
               NSString *dlid = [userInfo valueForKey:@"data"];
               NSString *title = [userInfo valueForKey:@"title"];
                [self jpushActionOnforground:@"" url:dlid title:title];
                
            }*/
        }
        [application setApplicationIconBadgeNumber:0];
    }else{
        if(customizeField1 != nil && ![customizeField1 isEqualToString:@""])
        {
            //在后台时typy为1不用处理
            if([customizeField1 isEqualToString:@"1"]){
            }else if ([customizeField1 isEqualToString:@"2"]){
                
            }else if ([customizeField1 isEqualToString:@"3"]){
                 NSString *dlid = [userInfo valueForKey:@"data"];
                [self jpushAction:dlid url:@"" title:@""];
                
            }else if ([customizeField1 isEqualToString:@"4"]){
                
                NSString *dlid = [userInfo valueForKey:@"data"];
                NSString *title = [userInfo valueForKey:@"title"];
                [self jpushAction:@"" url:dlid title:title];
            }
        }
    }
    
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNoData);
}
#endif
//当应用从后台到前台
- (void)jpushAction:(NSString*)dlid url:(NSString*)url title:(NSString*)title{
    //获取导航控制器
    MFSideMenuContainerViewController *conro = (MFSideMenuContainerViewController*)self.window.rootViewController;
    
    if([dlid isEqualToString:@""]){
        MyWebViewController *web = [[MyWebViewController alloc]init];
        web.url = url;
        web.titleStr = title;
        [conro.centerViewController pushViewController:web animated:YES];
    }else{

        ArticleDetailsController *artile = [[ArticleDetailsController alloc]init];
        artile.article_id = dlid;
        [conro.centerViewController pushViewController:artile animated:YES];

    }
}
//当应用在前台时
- (void)jpushActionOnforground:(NSString*)dlid url:(NSString*)url title:(NSString*)title{
     MFSideMenuContainerViewController *conro = (MFSideMenuContainerViewController*)self.window.rootViewController;
    FanweMessage *fanwealert = [[FanweMessage alloc]initWithTitle:@"温馨提示" message:_content cancelButtonTitle:@"取消" otherButtonTitles:@"确定" YESblock:^{
        if([dlid isEqualToString:@""]){
            MyWebViewController *web = [[MyWebViewController alloc]init];
            web.url = url;
            web.titleStr = title;
            [conro.centerViewController pushViewController:web animated:YES];
        }else{
            ArticleDetailsController *artile = [[ArticleDetailsController alloc]init];
            artile.article_id = dlid;
            [conro.centerViewController pushViewController:artile animated:YES];
        }
    } NOblock:^{
        
    }];
    [fanwealert show];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
