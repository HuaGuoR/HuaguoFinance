//
//  MyWebViewController.h
//  fanwe_p2p
//
//  Created by mac on 14-8-4.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWebViewController : UIViewController{
    
    IBOutlet UIWebView *_myWebView;
}

@property(nonatomic, retain) NSString *titleStr;
@property(nonatomic, retain) NSString *content;
@property(nonatomic, retain) NSString *url;

@end
