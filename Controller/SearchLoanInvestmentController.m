//
//  SearchLoanInvestmentController.m
//  fanwe_p2p
//
//  Created by mac on 14-8-11.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "SearchLoanInvestmentController.h"
#import "NetworkManager.h"
#import "GlobalVariables.h"
#import "DealCate.h"
#import "LoanInvestmentListController.h"

@interface SearchLoanInvestmentController (){
    UIButton *backButton;
    GlobalVariables *fanweApp;
    NSMutableArray *certificationMarkBtn;
    NSMutableArray *levelBtn;
    NSMutableArray *rateBtn;
    NSMutableArray *borrowingStateBtn;
    
    NSString *cid;
    NSString *level;
    NSString *interest;
    NSString *deal_status;
}

@end

@implementation SearchLoanInvestmentController

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
    self.navigationItem.title = @"搜索";
    [self layoutNavButton];
    fanweApp = [GlobalVariables sharedInstance];
    certificationMarkBtn = [[NSMutableArray alloc] init];
    levelBtn = [[NSMutableArray alloc] init];
    rateBtn = [[NSMutableArray alloc] init];
    borrowingStateBtn = [[NSMutableArray alloc] init];
    
    [self.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].applicationFrame.size.height)];
    CGRect rect =  self.scrollview.frame;
    rect.size.height = [UIScreen mainScreen].applicationFrame.size.height - 105;
    rect.origin.x = 0;
    rect.origin.y = 44;
    [self.scrollview setFrame:rect];
    
    CGRect rect1 =  _myTabView.frame;
    rect1.origin.y = [UIScreen mainScreen].applicationFrame.size.height - 94;
    [_myTabView setFrame:rect1];
    
    cid = @"0";
    level = @"0";
    interest = @"0";
    deal_status = @"0";
    
    [self initMyView];
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

-(void)initMyView{
    
    [levelBtn addObject:_level_all];
    [levelBtn addObject:_level_b];
    [levelBtn addObject:_level_c];
    [levelBtn addObject:_level_d];
    [levelBtn addObject:_level_e];
    _level_all.selected = YES;
    
    [rateBtn addObject:_rate_all];
    [rateBtn addObject:_rate_10];
    [rateBtn addObject:_rate_12];
    [rateBtn addObject:_rate_15];
    [rateBtn addObject:_rate_18];
    _rate_all.selected = YES;
    
    [borrowingStateBtn addObject:_borrowing_state_all];
    [borrowingStateBtn addObject:_borrowing_state_goon];
    [borrowingStateBtn addObject:_borrowing_state_full_scale];
    [borrowingStateBtn addObject:_borrowing_state_flow_standard];
    [borrowingStateBtn addObject:_borrowing_state_repayment];
    [borrowingStateBtn addObject:_borrowing_state_repaid];
    
    _borrowing_state_all.selected = YES;
    
    CGFloat _certificationMarkView_y = 8.0f;
    
    _certificationMarkView_y = [self createBtn:fanweApp.deal_cate_list
                        btn_x:140.0f
                        btn_y:_certificationMarkView_y];
    
    CGRect tmp = _certificationMarkView.frame;
    tmp.size.height = _certificationMarkView_y + 8;
    _certificationMarkView.frame = tmp;
    
    CGRect tmp2 = _certificationLine.frame;
    tmp2.origin.y = _certificationMarkView_y + 7;
    _certificationLine.frame = tmp2;
    
    CGSize newSize = CGSizeMake(self.view.frame.size.width, 290+_certificationMarkView_y);
    [self.scrollview setContentSize:newSize];
    
}

-(CGFloat)createBtn:(NSMutableArray *)arrayList
              btn_x:(CGFloat)btn_x
              btn_y:(CGFloat)btn_y{
	
    //http://www.buildapp.net/iphone/show.asp?id=2970
	
	CGFloat btn_height = 24;
	
	CGFloat btn_x_2 = btn_x;
	CGFloat btn_y_2 = btn_y;
	CGFloat btn_spage = 10;
	
	for(int i = 0; i < [arrayList count]+1; i ++){
        
        UIButton *btnIn = [UIButton buttonWithType:UIButtonTypeCustom];
		btnIn.titleLabel.font = [UIFont systemFontOfSize:12];
		[btnIn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        if (i == 0) {
            btnIn.tag = 0;
            
            btnIn.frame = CGRectMake(btn_x_2, btn_y_2, 57 , btn_height);
            [btnIn setTitle:@"不限" forState:UIControlStateNormal];
            [btnIn setTitle:@"不限" forState:UIControlStateSelected];
            
            btnIn.selected = YES;
        }else{
            DealCate * dealCate = [arrayList objectAtIndex:(i-1)];
            
            CGSize size = [dealCate.name sizeWithFont:btnIn.titleLabel.font constrainedToSize:CGSizeMake(250.0f, btn_height) lineBreakMode:NSLineBreakByCharWrapping];
            btnIn.tag = dealCate.deal_id;
            
            btnIn.frame = CGRectMake(btn_x_2, btn_y_2, size.width + 15 , btn_height);
            [btnIn setTitle:dealCate.name forState:UIControlStateNormal];
            [btnIn setTitle:dealCate.name forState:UIControlStateSelected];
        }
        
        [btnIn setTitleColor:[UIColor colorWithRed: 0.4 green: 0.4 blue: 0.4 alpha: 1.0] forState:UIControlStateNormal];
        [btnIn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
		
		[btnIn.titleLabel setTextAlignment:NSTextAlignmentCenter];  //设置按钮字体对齐方式
        
		[btnIn setBackgroundImage:[UIImage imageNamed:@"bg_search_condition_normal.png"] forState:UIControlStateNormal];
		[btnIn setBackgroundImage:[UIImage imageNamed:@"bg_search_condition_select.png"] forState:UIControlStateSelected];  //设置按钮选中时背景图片
		
		[_certificationMarkView addSubview:btnIn];
		
        [certificationMarkBtn addObject:btnIn];
        
        [btnIn addTarget:self action:@selector(onActionClick:) forControlEvents:UIControlEventTouchUpInside];
		
		//计算下一个按钮的位置
		if (i < [arrayList count]){ //判断是否有下一个按钮
            
            CGSize size2;
            if (i == 0) {
                size2 = [@"不限" sizeWithFont:btnIn.titleLabel.font constrainedToSize:CGSizeMake(250.0f, btn_height) lineBreakMode:NSLineBreakByCharWrapping];
                //列
                if (btnIn.frame.origin.x + btnIn.frame.size.width + btn_spage + size2.width > 310){
                    //换行
                    btn_x_2 = btn_x;
                    btn_y_2 = btnIn.frame.origin.y + btnIn.frame.size.height + 16;
                    
                }else{
                    btn_x_2 = btnIn.frame.origin.x + btnIn.frame.size.width + btn_spage + 20;
                }
            }else{
                DealCate * dealCateNext = [arrayList objectAtIndex:i];
                
                size2 = [dealCateNext.name sizeWithFont:btnIn.titleLabel.font constrainedToSize:CGSizeMake(250.0f, btn_height) lineBreakMode:NSLineBreakByCharWrapping];
                //列
                if (btnIn.frame.origin.x + btnIn.frame.size.width + btn_spage + size2.width > 310){
                    //换行
                    btn_x_2 = btn_x;
                    btn_y_2 = btnIn.frame.origin.y + btnIn.frame.size.height + 16;
                    
                }else{
                    btn_x_2 = btnIn.frame.origin.x + btnIn.frame.size.width + btn_spage;
                }
            }
			
		}
	}
	
 	return btn_y_2 + btn_height;
}

-(void)onActionClick:(id)sender{
    UIButton *button = (UIButton *)sender;
	
	button.selected = !button.selected;
    
    for (int i = 0; i < [certificationMarkBtn count]; i ++) {
		UIButton *btn = (UIButton *)[certificationMarkBtn objectAtIndex:i];
		if (button != btn){
			btn.selected = NO;
		}else{
            btn.selected = YES;
        }
        
	}
    
    cid = [NSString stringWithFormat:@"%ld",(long)button.tag];
	
}

- (IBAction)levelAction:(id)sender {
    UIButton *button = (UIButton *)sender;
	
	button.selected = !button.selected;
    
    for (int i = 0; i < [levelBtn count]; i ++) {
		UIButton *btn = (UIButton *)[levelBtn objectAtIndex:i];
		if (button != btn){
			btn.selected = NO;
		}else{
            btn.selected = YES;
        }
        
	}
    
    level = [NSString stringWithFormat:@"%ld",(long)button.tag];
}

- (IBAction)rateAction:(id)sender {
    UIButton *button = (UIButton *)sender;
	
	button.selected = !button.selected;
    
    for (int i = 0; i < [rateBtn count]; i ++) {
		UIButton *btn = (UIButton *)[rateBtn objectAtIndex:i];
		if (button != btn){
			btn.selected = NO;
		}else{
            btn.selected = YES;
        }
        
	}
    
    interest = [NSString stringWithFormat:@"%ld",(long)button.tag];
}

- (IBAction)borrowingStateAction:(id)sender {
    UIButton *button = (UIButton *)sender;
	
	button.selected = !button.selected;
    
    for (int i = 0; i < [borrowingStateBtn count]; i ++) {
		UIButton *btn = (UIButton *)[borrowingStateBtn objectAtIndex:i];
		if (button != btn){
			btn.selected = NO;
		}else{
            btn.selected = YES;
        }
        
	}
    
    deal_status = [NSString stringWithFormat:@"%ld",(long)button.tag];
}

- (IBAction)searchAction:(id)sender {
    LoanInvestmentListController *tmpController = [[LoanInvestmentListController alloc]init];
    tmpController.is_back = YES;
    tmpController.cid = cid;
    tmpController.level = level;
    tmpController.interest = interest;
    tmpController.deal_status = deal_status;
    [[self navigationController] pushViewController:tmpController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
