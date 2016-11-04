//
//  freeConfig.h
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-14.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FreeConfig : NSObject
@property (assign,nonatomic) NSInteger free1_1; //min
@property (assign,nonatomic) NSInteger free1_2; //max
@property (assign,nonatomic) NSInteger free2_1; //min
@property (assign,nonatomic) NSInteger free2_2; //max
@property (copy,nonatomic) NSString   *freeMoney1;
@property (copy,nonatomic) NSString *freeMoney2;


@property (assign,nonatomic) float freeIntMoney1;
@property (assign,nonatomic) float freeIntMoney2;


@property (assign,nonatomic) NSInteger money1; //实际金额
@property (assign,nonatomic) NSInteger money2; //实际金额

- (id)initWithArray:(NSMutableArray*)array;
@end
