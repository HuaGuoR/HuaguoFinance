//
//  HomePageController.h
//  fanwe_p2p
//
//  Created by mac on 14-7-31.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Advs.h"

@interface HomePageController : UIViewController{
    
    IBOutlet UIView *_titleView;
    IBOutlet UILabel *_programTitle; //程序标题
    IBOutlet UILabel *_siteDomain; //网址
    IBOutlet UIView *_advsView; //广告轮播页
    
}

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

- (void)didSelectAdvAtIndex:(NSString *) index;

@end
