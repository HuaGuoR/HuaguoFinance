//
//  MyWebViewController.h
//  fanwe_p2p
//
//  Created by mac on 14-8-4.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleDetailsController : UIViewController{
    
    IBOutlet UIWebView *_myWebView;
}

@property(nonatomic, retain) NSString *article_id;
@property(nonatomic, retain) NSString *titleStr; 

@end
