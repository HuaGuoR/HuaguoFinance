//
//  MyLogCell.h
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-12.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogList.h"

@interface MyLogCell : UITableViewCell
@property (assign,nonatomic)CGFloat cllHeigh;
- (void)setcellFrame:(LogList*)list;
@end