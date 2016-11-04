//
//  RepaymentController.m
//  fanwe_p2p
//
//  Created by mac on 14-8-15.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "RepaymentController.h"
#import "STSegmentedControl.h"
#import "RepaymentedListController.h"
#import "MyWebViewController.h"
#import "RepaymentListController.h"
#import "RepaymentDetailsController.h"
#import "AdvanceRepaymentDetailsController.h"
#import "MyWebViewController.h"

@interface RepaymentController ()<RepaymentListDelegate,RepaymentedListDelegate>{
    STSegmentedControl* segment;
    UIButton *backButton;
    NSMutableDictionary *ctlCache;
    
}

@end

@implementation RepaymentController

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
    self.navigationItem.title = nil;
    [self layoutNavButton];
    
    ctlCache = [[NSMutableDictionary alloc] init];
    
    NSArray *buttonNames = [NSArray arrayWithObjects:@"还款列表", @"已还清借款", nil];
	segment = [[STSegmentedControl alloc] initWithItems:buttonNames];
	segment.frame = CGRectMake(10, 10, 180, 40);
	[segment addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
	segment.selectedSegmentIndex = -1;
	segment.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    segment.center = CGPointMake(self.navigationController.navigationBar.bounds.size.width / 2, self.navigationController.navigationBar.bounds.size.height / 2);
    
    self.view.backgroundColor = [ UIColor colorWithRed: 0.96
                                                 green: 0.96
                                                  blue: 0.96
                                                 alpha: 1.0
                                 ];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar addSubview:segment];
    
}

- (void)viewDidAppear:(BOOL)animated {
    if (segment.selectedSegmentIndex == -1){
        segment.selectedSegmentIndex = 0;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [segment removeFromSuperview];
}

- (void)layoutNavButton{
	
    CGSize backButtonSize = CGSizeMake(50, 30);
	
	backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	backButton.tag = 0;
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
	
	backButton.frame = CGRectMake(backButton.frame.origin.x, backButton.frame.origin.y, backButtonSize.width, backButtonSize.height);
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
	[backButton setImage:[UIImage imageNamed:@"ico_back.png"] forState:UIControlStateNormal];
	
	UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
}

- (void)backAction:(id)sender
{
	UIButton *btn = sender;
	if (btn.tag == 0){
		[self.navigationController popViewControllerAnimated:YES];
	}else {
		[self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:btn.tag] animated:YES];
	}
}

- (void)valueChanged:(id)sender {
    
	STSegmentedControl *control = sender;
    
    NSString *segIndexKey = [NSString stringWithFormat:@"%ld",(long)control.selectedSegmentIndex];
    if (control.selectedSegmentIndex == 0){
        RepaymentListController *repaymentListController = (RepaymentListController *)[ctlCache objectForKey:segIndexKey];
        if (!repaymentListController){
            repaymentListController = [[RepaymentListController alloc] init];
            repaymentListController.delegate = self;
            [ctlCache setObject:repaymentListController forKey:segIndexKey];
        }
        
        for (UIView *view in [self.view subviews]) {
            [view removeFromSuperview];
        }
        
        
        [self.view addSubview:repaymentListController.view];
        
    }else if (control.selectedSegmentIndex == 1){
        RepaymentedListController *repaymentedListController = (RepaymentedListController *)[ctlCache objectForKey:segIndexKey];
        if (!repaymentedListController){
            repaymentedListController = [[RepaymentedListController alloc] init];
            repaymentedListController.delegate = self;
            [ctlCache setObject:repaymentedListController forKey:segIndexKey];
        }
        
        for (UIView *view in [self.view subviews]) {
            [view removeFromSuperview];
        }
        
        [self.view addSubview:repaymentedListController.view];
    }
    
}

#pragma 还款
- (void)repaymentAction:(NSString *)repayment_id{
    RepaymentDetailsController *tmpController = [[RepaymentDetailsController alloc]init];
    tmpController.repayment_id = repayment_id;
    [[self navigationController] pushViewController:tmpController animated:YES];
}

#pragma 提前还款
- (void)advanceRepaymentAction:(NSString *)repayment_id{
    AdvanceRepaymentDetailsController *tmpController = [[AdvanceRepaymentDetailsController alloc]init];
    tmpController.repayment_id = repayment_id;
    [[self navigationController] pushViewController:tmpController animated:YES];
}

#pragma 已还清借款列表的点击详情事件
- (void)repaymentedDetailsAction:(NSString *)app_url{
    MyWebViewController *tmpController = [[MyWebViewController alloc]init];
    tmpController.url = app_url;
    tmpController.titleStr = @"详情";
    [[self navigationController] pushViewController:tmpController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
