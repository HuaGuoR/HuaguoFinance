//
//  FanweMessage.m
//  MShop
//
//  Created by 陈 福权 on 11-11-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FanweMessage.h"


@implementation FanweMessage

+(void) alert:(NSString *) message{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
	[alert show];
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString*)otherButtonTitles
           YESblock:(YesBlock)block
            NOblock:(NoBlock)NOblock
{
   self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];//注意这里初始化父类的
    if(self){
        self.YESblock = block;
        self.NOblock = NOblock;
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //这里调用函数指针_block(要传进来的参数);
    if(buttonIndex == 0){
        _NOblock();
    }else if (buttonIndex == 1){
        _YESblock();
    }
}


+ (void) alert:(NSString *)message YESblock:(YesBlock)block
       NOblock:(NoBlock)NOblock
{
    
}


@end
