//
//  MyNaController.m
//  managemall
//
//  Created by GuoMS on 14-7-26.
//  Copyright (c) 2014年 GuoMs. All rights reserved.
//

#import "MyNaController.h"



@interface MyNaController () <UINavigationControllerDelegate>

@end

@implementation MyNaController

//一个类只会执行一次
+ (void)initialize {
     
	UINavigationBar *navBar = [UINavigationBar appearance];
	UIBarButtonItem *item = [UIBarButtonItem appearance];
    //设置导航栏为亮色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	
    UIImage *image;
	if (iOS7) {
		image = [UIImage imageNamed:@"navigation_bar_bg.png"];
		//设置导航栏的渐变色为白色 （IOS7中返回箭头的颜色变为白色）
		navBar.tintColor = [UIColor whiteColor];
	}
	else {
		image = [UIImage imageNamed:@"navigation_bar_bg2.png"];
		[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
		//设置导航栏按钮背景图片
//        [item setBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        [item setBackgroundImage:nil forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
		//设置返回按钮背景图片
//        [item setBackButtonBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        [item setBackButtonBackgroundImage:nil forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
	}

	//设置导航栏背景图片
//	[navBar setBackgroundImage:image barMetrics:UIBarMetricsDefault];
    [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

	//设置标题颜色
	[navBar setTitleTextAttributes:@{ UITextAttributeTextColor :[UIColor whiteColor] }];

	//设置导航栏按钮颜色
	[item setTitleTextAttributes:@{
	     UITextAttributeTextColor :[UIColor whiteColor],
	     UITextAttributeFont : [UIFont systemFontOfSize:14]
	 } forState:UIControlStateNormal];
}

- (void)viewDidLoad {
	[super viewDidLoad];

}

#pragma mark 重写push方法添加统一样式返回按钮
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
 
    //	//利用分类添加左上角按钮
	viewController.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
    
	[super pushViewController:viewController animated:animated];

}

- (UIBarButtonItem *)leftMenuBarButtonItem {
    
    CGSize backButtonSize = CGSizeMake(50, 30);
	
	UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	
	leftButton.frame = CGRectMake(0, 0, backButtonSize.width, backButtonSize.height);
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
	[leftButton setImage:[UIImage imageNamed:@"ico_back.png"] forState:UIControlStateNormal];
	
	UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    return leftButtonItem;
}

#pragma mark 当点击导航栏返回按钮时调用
- (void)back {
	UIViewController *view =  self.childViewControllers[0];
	[view.navigationController popViewControllerAnimated:YES];

}

@end
