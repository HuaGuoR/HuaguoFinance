//
//  BankList.h
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-13.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankList : NSObject

@property (nonatomic,assign) NSInteger bankid;
@property (nonatomic,copy) NSString *bankcard;
@property (nonatomic,copy) NSString *bankName;
@property (nonatomic,copy) NSString *bankimage;
@property (nonatomic,copy) NSString *realName;

- (id)initWithDict:(NSDictionary*)Dict;
@end
