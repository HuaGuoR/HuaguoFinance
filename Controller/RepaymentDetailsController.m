//
//  RepaymentDetailsController.m
//  fanwe_p2p
//
//  Created by mac on 14-8-15.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "RepaymentDetailsController.h"
#import "NetworkManager.h"
#import "MJRefresh.h"
#import "FanweMessage.h"
#import "RepaymentDetails.h"
#import "RepaymentDetailsCell.h"
#import "ExtendNSDictionary.h"
#import "RechargeController.h"

@interface RepaymentDetailsController ()<HttpDelegate,UITableViewDataSource,UITableViewDelegate>{
    NetworkManager *netHttp;
    GlobalVariables *fanweApp;
    UIButton *backButton;
    
    RepaymentDetailsCell *cell;
    
    NSMutableArray *tagArray;
    int i;
    int index_tag; //标记点击到了哪个可偿还项
    float totalMoney; //合计还款
}

@property(strong, nonatomic) NSMutableArray *repaymentDetailsList;

@end

@implementation RepaymentDetailsController

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
    
    [self layoutNavButton];
    
    CGRect rect1 =  _myTabView.frame;
    rect1.origin.y = [UIScreen mainScreen].applicationFrame.size.height - 94;
    [_myTabView setFrame:rect1];
    
    self.navigationItem.title = @"偿还贷款";
    fanweApp = [GlobalVariables sharedInstance];
    netHttp = [[NetworkManager alloc] init];
    self.repaymentDetailsList = [[NSMutableArray alloc] init];
    self.myTableView.delegate = self;
	self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tagArray = [[NSMutableArray alloc]init];
    
    // 集成刷新控件
    [self setupRefresh];
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

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.myTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //自动刷新(一进入程序就下拉刷新)
    [self.myTableView headerBeginRefreshing];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self loadNetData:1];
    [tagArray removeAllObjects];
    [self.repaymentDetailsList removeAllObjects];
    // 刷新表格
    
}

#pragma 加载数据
-(void)loadNetData:(int)page{
	
	NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
	[parmDict setObject:@"uc_quick_refund" forKey:@"act"];
    [parmDict setObject:self.repayment_id forKey:@"id"];
	
    netHttp.delegate = self;
    [netHttp startAsynchronous:parmDict addUserPwd:YES useDataCached:false];
	
}

#pragma 确认还款
-(void)loadNetData{
	
	NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
	[parmDict setObject:@"uc_do_quick_refund" forKey:@"act"];
    [parmDict setObject:self.repayment_id forKey:@"id"];
    [parmDict setObject:[NSString stringWithFormat:@"%d",index_tag] forKey:@"ids"];
	
    netHttp.delegate = self;
    [netHttp startAsynchronous:parmDict addUserPwd:YES useDataCached:false];
	
}

-(void)requestDone:(NSDictionary *) jsonDict error:(NSError *) error{
    if (jsonDict != nil){
        if ([@"uc_quick_refund" isEqualToString:[jsonDict toString:@"act"]]) {
            id idLoanList  = [jsonDict objectForKey:@"loan_list"];
            if (idLoanList && idLoanList != [NSNull null]){
                NSDictionary *tmpListDict = [jsonDict objectForKey:@"loan_list"];
                for (NSDictionary *dict in tmpListDict) {
                    RepaymentDetails *repaymentDetails = [[RepaymentDetails alloc] init];
                    [repaymentDetails setJson:dict];
                    [self.repaymentDetailsList addObject:repaymentDetails];
                    
                }
            }
            [self.myTableView reloadData];
            
            
            id iddeal = [jsonDict objectForKey:@"deal"];
            _titleLabel.text = [iddeal toString:@"sub_name"];
            _loanMoneyLabel.text = [iddeal toString:@"borrow_amount_format"];
            _rateLabel.text = [iddeal toString:@"rate_foramt_w"];
            //repay_time_type 期限的单位 0：天  1：月
            if ([iddeal toInt:@"repay_time_type"] == 1) {
                _timeLabel.text = [NSString stringWithFormat:@"%d个月",[iddeal toInt:@"repay_time"]];
            }else{
                _timeLabel.text = [NSString stringWithFormat:@"%d天",[iddeal toInt:@"repay_time"]];
            }
            
            _repaymentedLabel.text = [NSString stringWithFormat:@"￥%.2f",[iddeal toFloat:@"repay_money"]];
            _shouldRepaymentLabel.text = [NSString stringWithFormat:@"￥%.2f",[iddeal toFloat:@"need_remain_repay_money"]];
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.myTableView headerEndRefreshing];
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.myTableView footerEndRefreshing];
            
            for (i = 0; i < [self.repaymentDetailsList count]; i ++) {
                RepaymentDetails *repaymentDetails = [self.repaymentDetailsList objectAtIndex:i];
                if (repaymentDetails.has_repay == 0) {
                    NSInteger selectedIndex = i;
                    
                    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
                    
                    [self.myTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                    [tagArray addObject:[NSString stringWithFormat:@"%d",i]];
                    
                    _totalMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",repaymentDetails.month_need_all_repay_money];
                    
                    totalMoney = repaymentDetails.month_need_all_repay_money;
                    
                    index_tag = i;
                    
                    return;
                }
            }
        }else{
            if ([[jsonDict objectForKey:@"response_code"] intValue] == 1){
                
                [FanweMessage alert:@"操作成功！"];
                // 集成刷新控件
                [self setupRefresh];
            }else {
                [FanweMessage alert:[jsonDict toString:@"show_err"]];
            }
        }
        
        
    }else{
        [FanweMessage alert:@"服务器访问失败"];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.myTableView headerEndRefreshing];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.myTableView footerEndRefreshing];
    }
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.repaymentDetailsList count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 122.0f;
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
    
    static NSString *IndexCellIdentifier = @"IndexCellIdentifier";
    
    
    cell = (RepaymentDetailsCell *)[tableView dequeueReusableCellWithIdentifier:IndexCellIdentifier];
    if (cell == nil)
    {
        cell = (RepaymentDetailsCell *)[[[NSBundle mainBundle] loadNibNamed: @"RepaymentDetailsCell"
                                                              owner: self
                                                            options: nil] lastObject];
    }
    if (self.repaymentDetailsList && [self.repaymentDetailsList count] != 0){
        RepaymentDetails *repaymentDetails = [self.repaymentDetailsList objectAtIndex:row];
        [cell setCellContent:repaymentDetails];
        
        for (int j = 0; j < [tagArray count]; j ++) {
            if ([tagArray[j] intValue] == row ) {
                cell.sgsmentImg.image = [UIImage imageNamed:@"sgsment_select.png"];
            }
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger row = [indexPath row];
    RepaymentDetails *repaymentDetails = [self.repaymentDetailsList objectAtIndex:row];
    
    cell = (RepaymentDetailsCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
    
    if (repaymentDetails.has_repay == 0 && row == index_tag) {
        cell.sgsmentImg.image = [UIImage imageNamed:@"sgsment_normal.png"];
        [tagArray removeObject:[NSString stringWithFormat:@"%d",index_tag]];
        index_tag--;
        totalMoney -= repaymentDetails.month_need_all_repay_money;
         _totalMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];
    }else{
        if (repaymentDetails.has_repay == 0 && row == ++index_tag) {
            cell.sgsmentImg.image = [UIImage imageNamed:@"sgsment_select.png"];
            [tagArray addObject:[NSString stringWithFormat:@"%lu",(unsigned long)row]];
            totalMoney += repaymentDetails.month_need_all_repay_money;
            _totalMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];
        }else{
            if (repaymentDetails.has_repay == 0) {
                [FanweMessage alert:@"还款应遵循先借先还的准则"];
                index_tag--;
            }
        }
    }
    
}

#pragma 充值
- (IBAction)rechargeAction:(id)sender {
    RechargeController *tmpController = [[RechargeController alloc] init];
    [[self navigationController]pushViewController:tmpController animated:YES];
}

#pragma 确认还款
- (IBAction)confirmRepaymentAction:(id)sender {
    if (index_tag < i) {
        [FanweMessage alert:@"请至少选择一个还款项"];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确认还款吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

#pragma mark uialertViewdail
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    if (buttonIndex == 1) {
        [self loadNetData];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
