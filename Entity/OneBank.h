//
//  OneBank.h
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-13.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OneBank : NSObject
@property (assign,nonatomic) NSInteger bankId;
@property (copy , nonatomic) NSString *bankName;

- (id)initWithDict:(NSDictionary*)dict;
@end
