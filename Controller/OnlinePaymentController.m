//
//  OnlinePaymentController.m
//  fanwe_p2p
//
//  Created by mac on 14-8-7.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "OnlinePaymentController.h"
#import "NetworkManager.h"
#import "GlobalVariables.h"
#import "FanweMessage.h"
#import "OnlinePayment.h"

@interface OnlinePaymentController ()<HttpDelegate,UITableViewDataSource,UITableViewDelegate>{
    NetworkManager *netHttp;
    GlobalVariables *fanweApp;
    
    NSString *myPaymentId;
}

@property(strong, nonatomic) NSMutableArray *onlinePaymentList;

@end

@implementation OnlinePaymentController

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
    self.onlinePaymentList = [[NSMutableArray alloc] init];
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
    
//    _tableViewImg.frame = rect1;
    
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
        id tmpList  = [jsonDict objectForKey:@"payment_list"];
        if (tmpList && tmpList != [NSNull null]){
            NSDictionary *tmpListDict = [jsonDict objectForKey:@"payment_list"];
            for (NSDictionary *dict in tmpListDict) {
                OnlinePayment *onlinePayment = [[OnlinePayment alloc] init];
                [onlinePayment setJson:dict];
                [self.onlinePaymentList addObject:onlinePayment];
            }
        }
    
        [self.myTableView reloadData];
        
        myPaymentId = [NSString stringWithFormat:@"%d",[[self.onlinePaymentList objectAtIndex:0] payment_id]];
        
        NSInteger selectedIndex = 0;
        
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        
        [self.myTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }else{
        [FanweMessage alert:@"服务器访问失败"];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.onlinePaymentList count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 70.0f;
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.onlinePaymentList count] * 70 < self.myTableView.frame.size.height ) {
        CGRect rect1 =  self.myTableView.frame;
        rect1.size.height = [self.onlinePaymentList count] * 70 + 2;
        self.myTableView.frame = rect1;
    }
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    int index = (int)indexPath.row;
    OnlinePayment *onlinePayment = [self.onlinePaymentList objectAtIndex:index];
    
    
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:onlinePayment.logo]]];
    
    cell.backgroundColor = [UIColor clearColor];
    if (index == [self.onlinePaymentList count]-1) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_recharge_item_bottom_normal.png"]];
    }else{
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_recharge_item_normal.png"]];
    }
    
    cell.imageView.frame = CGRectMake(0,0,44,44);
    cell.textLabel.text = onlinePayment.class_name;
    
    
    cell.textLabel.textColor = [UIColor blackColor];
    
    if (index == [self.onlinePaymentList count]-1) {
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_recharge_item_bottom_select.png"]];
    }else{
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_recharge_item_select.png"]];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    OnlinePayment *onlinePayment = [self.onlinePaymentList objectAtIndex:row];
    myPaymentId = [NSString stringWithFormat:@"%d",onlinePayment.payment_id];

}

- (IBAction)rechargeAction:(id)sender {
    if ([_moneyTextField.text length] == 0) {
        [FanweMessage alert:@"请输入充值金额"];
        [_moneyTextField becomeFirstResponder];
        
    }else{
        if(delegate != nil) {
            if ([delegate respondsToSelector:@selector(onlinePaymentAction: money:)]) {
                [delegate performSelector:@selector(onlinePaymentAction: money:) withObject:myPaymentId withObject:_moneyTextField.text];
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
