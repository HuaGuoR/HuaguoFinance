//
//  AdvController.h
//  fanwe_p2p
//
//  Created by mac on 14-8-1.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AdvViewDelegate;

@interface AdvController : UIViewController

@property (nonatomic, retain) NSMutableArray *advsList;

@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIButton *close_btn;

/**
 关闭广告位点击事件
 */
-(IBAction)closeAdv:(id)sender;

/**
 滑动广告位指示器改变事件
 */
-(IBAction)changeValue:(id)sender;

@property (nonatomic, assign) id<AdvViewDelegate> delegate;

/**
 展示广告位
 */
-(void)showAdvs;

/**
 是否显示关闭广告位按钮
 */
-(void)AllowsCloseAdvs:(BOOL)close;

@end

//AdvViewDelegate代理
@protocol AdvViewDelegate <NSObject>

@optional

/**
 关闭广告位
 */
- (void)closeAdv;
/**
 单击广告位
 */
- (void)didSelectAdvAtIndex:(NSString *) index;

@end
