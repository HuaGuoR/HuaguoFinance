//
//  ExtendNSString.m
//  MShop
//
//  Created by 陈 福权 on 11-11-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExtendNSString.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (util)

- (int) indexOf:(NSString *)text {
    NSRange r = [self rangeOfString:text];
	if(r.location == NSNotFound) {
		return -1;
	} else {
		return r.location;
	}
}

- (int) lastIndexOf:(NSString *)text{
	NSRange r = [self rangeOfString:text options:NSBackwardsSearch];	
	if(r.location == NSNotFound) {
		return -1;
	} else {
		return r.location;
	}
}

- (NSString *) MD5Hash:(NSString*)concat {
    const char *concat_str = [concat UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, strlen(concat_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];    
}

/*
-(NSString *) toValue:(NSString *) text{
	if (text == nil){
		return @"";
	}else {
		return text;
	}
}
*/
@end
