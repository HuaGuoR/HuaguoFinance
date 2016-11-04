//
//  AppDelegate.h
//  fanwe_p2p
//
//  Created by mac on 14-7-28.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariables.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    GlobalVariables *fanweApp;
    BOOL EnterForeground;//YES在前台，NO在后台或程序还没有启动
}

@property (strong, nonatomic) UIWindow *window;

@end
