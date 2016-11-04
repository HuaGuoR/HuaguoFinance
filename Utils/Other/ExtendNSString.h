//
//  ExtendNSString.h
//  MShop
//
//  Created by 陈 福权 on 11-11-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (util)

- (int) indexOf:(NSString *)text;
- (int) lastIndexOf:(NSString *)text;
//- (NSString *) toValue:(NSString *) text;
- (NSString *)MD5Hash:(NSString*)concat;

@end
