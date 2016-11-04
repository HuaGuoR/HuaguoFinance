//
//  AdvController.m
//  fanwe_p2p
//
//  Created by mac on 14-8-1.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "AdvController.h"
#import "FanweMessage.h"
#import "Advs.h"
#import "EGOImageButton.h"
#import "GlobalVariables.h"
#import "NetworkManager.h"
#define RYJSW [UIScreen mainScreen].bounds.size.width
@interface AdvController()<UIScrollViewDelegate>{
    GlobalVariables *fanweApp;
    NetworkManager *netHttp;
    BOOL is_fisrt;
}

@end

@implementation AdvController

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
    
	fanweApp = [GlobalVariables sharedInstance];
 
}

/**
 展示广告位
 */
-(void)showAdvs{
//    CGRect cellFrame = [self.scrollView frame];
//    cellFrame.origin.y = 0;
    self.scrollView.frame = CGRectMake(0, 0,RYJSW , RYJSW *0.4);
//    [self.scrollView setFrame:cellFrame];
    
    [self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.scrollView setDelegate:self];
    [self.scrollView setBackgroundColor:[UIColor blackColor]];
    [self.scrollView setAutoresizesSubviews:YES];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];    
    
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width * self.advsList.count,self.view.frame.size.height)];
    
    for (UIView *view in [self.scrollView subviews]){
        [view removeFromSuperview];
    }
    
    [self.pageControl setNumberOfPages:[self.advsList count]];
    for(int i = 0; i < [self.advsList count]; i ++){
        Advs *advs = [self.advsList objectAtIndex:i];
        
        EGOImageButton *thumbView = [[EGOImageButton alloc] initWithFrame:CGRectZero];
        [thumbView addTarget:self
                      action:@selector(myDidSelectAdvAtIndex:)
            forControlEvents:UIControlEventTouchUpInside]; 
        thumbView.tag = i;
        thumbView.gb_image = YES;

        thumbView.frame = CGRectMake(self.view.frame.size.width * i, 0, self.view.frame.size.width, self.view.frame.size.height);
        thumbView.imageURL = [NSURL URLWithString:advs.img];
        
        [self.scrollView addSubview:thumbView];
    }    
    
    if (self.scrollView.frame.size.height < 90){
        
        CGRect cellFrame2 = [self.pageControl frame];
        cellFrame2.origin.y = 25;
        [self.pageControl setFrame:cellFrame2];
    }
}

/**
 是否显示关闭广告位按钮,该项目中暂未用到
 */
-(void)AllowsCloseAdvs:(BOOL)close{
    self.close_btn.hidden = !close;
}

/**
 点击广告位
 */
- (void)myDidSelectAdvAtIndex:(id) index
{
    EGOImageButton *thumbView = (EGOImageButton *)index;
    
    if(self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(didSelectAdvAtIndex:)]) {
            [self.delegate performSelector:@selector(didSelectAdvAtIndex:) withObject:[NSString stringWithFormat:@"%ld",thumbView.tag]];
        }
    }
}    

/**
 滑动广告位指示器改变事件
 */
-(IBAction)changeValue:(id)sender{
    [self scrollToIndex:self.pageControl.currentPage];
}

- (void)scrollToIndex:(NSInteger)index 
{
    CGRect frame = self.view.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:NO];
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
    
	CGFloat pageWidth = scrollView.frame.size.width;
	int page = floor((scrollView.contentOffset.x - pageWidth / 2) /pageWidth) +1;
    
    [self.pageControl setCurrentPage:page];
}

/**
 关闭广告位
 */
-(IBAction)closeAdv:(id)sender{
    if(self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(closeAdv)]) {
            [self.delegate performSelector:@selector(closeAdv) withObject:Nil];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
