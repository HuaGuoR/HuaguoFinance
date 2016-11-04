//
//  OnlinePaymentController.m
//  fanwe_p2p
//
//  Created by mac on 14-8-7.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "OfflinePaymentController.h"
#import "NetworkManager.h"
#import "GlobalVariables.h"
#import "FanweMessage.h"
#import "OfflinePayment.h"

@interface OfflinePaymentController ()<HttpDelegate,UITableViewDataSource,UITableViewDelegate>{
    NetworkManager *netHttp;
    GlobalVariables *fanweApp;
    NSString *myBankId;
    NSString *myPaymentid;
    
    NSMutableDictionary *tmpDic;
}

@property(strong, nonatomic) NSMutableArray *offlinePaymentList;

@end

@implementation OfflinePaymentController

@synthesize delegate;

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
    
    fanweApp = [GlobalVariables sharedInstance];
    netHttp = [[NetworkManager alloc] init];
    self.offlinePaymentList = [[NSMutableArray alloc] init];
    self.myTableView.delegate = self;
	self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CGRect rect =  _myTabView.frame;
    rect.origin.y = [UIScreen mainScreen].applicationFrame.size.height - 94;
    [_myTabView setFrame:rect];
    
    CGRect rect1 =  self.myTableView.frame;
    rect1.size.height = _myTabView.frame.origin.y - 15 - self.myTableView.frame.origin.y;
    self.myTableView.frame = rect1;
    self.myTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_recharge_card.png"]];
    
    tmpDic = [[NSMutableDictionary alloc] init];
    
    [self loadNetData];
    
}

-(void)loadNetData{
	
	NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
	[parmDict setObject:@"uc_incharge" forKey:@"act"];
	
    netHttp.delegate = self;
    [netHttp startAsynchronous:parmDict addUserPwd:YES useDataCached:false];
	
}

-(void)requestDone:(NSDictionary *) jsonDict error:(NSError *) error{
    if (jsonDict != nil){
        id tmpList  = [jsonDict objectForKey:@"below_payment"];
        if (tmpList && tmpList != [NSNull null]){
            NSDictionary *tmpListDict = [jsonDict objectForKey:@"below_payment"];
            for (NSDictionary *dict in tmpListDict) {
                OfflinePayment *offlinePayment = [[OfflinePayment alloc] init];
                [offlinePayment setJson:dict];
                [self.offlinePaymentList addObject:offlinePayment];
            }
        }
        myPaymentid = [NSString stringWithFormat:@"%d",[[self.offlinePaymentList objectAtIndex:0] pay_id]];
        myBankId = [NSString stringWithFormat:@"%d",[[self.offlinePaymentList objectAtIndex:0] bank_id]];
        [tmpDic setObject:myPaymentid forKey:@"0"];
        [tmpDic setObject:myBankId forKey:@"1"];
    
        [self.myTableView reloadData];
        NSInteger selectedIndex = 0;
        
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        
        [self.myTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }else{
        [FanweMessage alert:@"服务器访问失败"];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.offlinePaymentList count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 70.0f;
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.offlinePaymentList count] * 70 < self.myTableView.frame.size.height ) {
        CGRect rect1 =  self.myTableView.frame;
        rect1.size.height = [self.offlinePaymentList count] * 70;
        self.myTableView.frame = rect1;
    }
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    int index = (int)indexPath.row;
    OfflinePayment *onlinePayment = [self.offlinePaymentList objectAtIndex:index];
    
    cell.backgroundColor = [UIColor clearColor];
    
    if (index == [self.offlinePaymentList count]-1) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_recharge_item_bottom_normal.png"]];
    }else{
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_recharge_item_normal.png"]];
    }
    cell.imageView.frame = CGRectMake(0,0,44,44);
    
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 260, 70)];
    UILabel *_bankNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 30)];
    _bankNameLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    _bankNameLabel.text = onlinePayment.pay_name;
    
    UILabel *_nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 110, 20)];
    _nameLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    _nameLabel.text = [NSString stringWithFormat:@"收款人：%@",onlinePayment.pay_account_name];
    
    UILabel *_bankEaraLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 30, 140, 20)];
    _bankEaraLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    _bankEaraLabel.text = [NSString stringWithFormat:@"开户行：%@",onlinePayment.pay_bank];
    
    UILabel *_cardNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 360, 20)];
    _cardNumLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    _cardNumLabel.text = [NSString stringWithFormat:@"账号：%@",onlinePayment.pay_account];
    
    [myView addSubview:_bankNameLabel];
    [myView addSubview:_nameLabel];
    [myView addSubview:_bankEaraLabel];
    [myView addSubview:_cardNumLabel];
    
    [cell addSubview:myView];
    
    cell.textLabel.textColor = [UIColor blackColor];
    
    if (index == [self.offlinePaymentList count]-1) {
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_recharge_item_bottom_select.png"]];
    }else{
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_recharge_item_select.png"]];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    OfflinePayment *offlinePayment = [self.offlinePaymentList objectAtIndex:row];
    myPaymentid = [NSString stringWithFormat:@"%d",offlinePayment.pay_id];
    myBankId = [NSString stringWithFormat:@"%d",offlinePayment.bank_id];
    [tmpDic setObject:myPaymentid forKey:@"0"];
    [tmpDic setObject:myBankId forKey:@"1"];
    
}

- (IBAction)rechargeAction:(id)sender {
    if ([_moneyTextField.text length] == 0){
		
        [_moneyTextField becomeFirstResponder];
		[FanweMessage alert:@"充值金额不能为空"];
		return;
	}
    
    if ([_serialNumTextField.text length] == 0){
		
        [_serialNumTextField becomeFirstResponder];
		[FanweMessage alert:@"流水号不能为空"];
		return;
	}
    
    [tmpDic setObject:_moneyTextField.text forKey:@"2"];
    [tmpDic setObject:_serialNumTextField.text forKey:@"3"];
    
    if(delegate != nil) {
        if ([delegate respondsToSelector:@selector(offlinePaymentAction:)]) {
            [delegate performSelector:@selector(offlinePaymentAction:) withObject:tmpDic];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
