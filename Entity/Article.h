//
//  Article.h
//  fanwe_p2p
//
//  Created by mac on 14-8-14.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject

@property (nonatomic, retain) NSString *article_id;
@property (nonatomic, retain) NSString *title;

-(void) setJson:(NSDictionary *) dict;

@end
