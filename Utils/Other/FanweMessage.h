//
//  FanweMessage.h
//  MShop
//
//  Created by 陈 福权 on 11-11-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^YesBlock)(void);
typedef void(^NoBlock)(void);
@interface FanweMessage : UIAlertView {

}

//系统自带的消息提示框
+(void) alert:(NSString *) message;

@property(nonatomic,copy)YesBlock YESblock;
@property(nonatomic,copy)NoBlock NOblock;



//需要自定义初始化方法，调用Block
- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString*)otherButtonTitles
              YESblock:(YesBlock)block
        NOblock:(NoBlock)NOblock;

+ (void) alert:(NSString *)message YESblock:(YesBlock)block
       NOblock:(NoBlock)NOblock;
@end
