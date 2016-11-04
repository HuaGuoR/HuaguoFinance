//
//  OnlinePayment.h
//  fanwe_p2p
//
//  Created by mac on 14-8-8.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OfflinePayment : NSObject

@property (nonatomic, assign) int pay_id;
@property (nonatomic, assign) int bank_id;
@property (nonatomic, retain) NSString *pay_name; //银行名称
@property (nonatomic, retain) NSString *pay_account_name; //收款人
@property (nonatomic, retain) NSString *pay_account; //卡号
@property (nonatomic, retain) NSString *pay_bank; //开卡地区

-(void) setJson:(NSDictionary *) dict;

@end
