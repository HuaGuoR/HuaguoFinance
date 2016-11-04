//
//  transList.h
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-18.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransList : NSObject
@property (copy , nonatomic)NSString *title;
@property (copy, nonatomic) NSString *hmonth;//待还
@property (copy, nonatomic)NSString *smonth;//总期数
@property (copy, nonatomic)NSString *benjin;
@property (copy,nonatomic)NSString *lixi;
@property (copy,nonatomic)NSString *tranfermoney;
@property (copy,nonatomic)NSString *statues;
@property (assign,nonatomic)NSInteger transop;
@property (copy,nonatomic)NSString *appurl;
@property (copy,nonatomic)NSString *timeUp;//到期时间
@property (copy,nonatomic)NSString *transferTime;//转让时间
@property (assign,nonatomic)NSInteger dlid;
@property (assign,nonatomic)NSInteger dltid;
- (id)initWithDict:(NSDictionary*)dict;
@end
