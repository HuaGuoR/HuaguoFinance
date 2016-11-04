//
//  Advs.h
//  fanwe_p2p
//
//  Created by mac on 14-8-1.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Advs : NSObject

@property(assign) int adv_id;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *img; //广告图片
@property(nonatomic,copy) NSString *page;
@property(assign) int type; //1：url链接址  2：文章ID，调用文章show_article接口展示文章内容
@property(nonatomic,copy) NSString *data; //url链接地址
@property(assign) int sort;
@property(assign) int status;
@property(assign) int open_url_type; //type = 1时，有效；0:使用内部浏览器打开;1:使用外部浏览器打开

-(void) setJson:(NSDictionary *) dict;

@end
