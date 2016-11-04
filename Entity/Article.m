//
//  Article.m
//  fanwe_p2p
//
//  Created by mac on 14-8-14.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "Article.h"
#import "ExtendNSDictionary.h"

@implementation Article

-(void) setJson:(NSDictionary *) dict{
    
    @try {
        self.article_id = [dict toString:@"id"];
        self.title = [dict toString:@"title"];
    }
    @catch (NSException *exception) {
        NSLog(@"返回参数部分有问题");
    }
    
}

@end
