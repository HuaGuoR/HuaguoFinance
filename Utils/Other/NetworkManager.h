//
//  NetworkManager.h
//  MShop
//
//  Created by 陈 福权 on 11-9-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "GlobalVariables.h"

@protocol HttpDelegate;

@interface NetworkManager : NSObject<ASIHTTPRequestDelegate> {
    id<HttpDelegate> delegate;
    GlobalVariables *fanweApp;
    //NSString *urlString;
    ASIFormDataRequest *request;
    NSString * urlString;
}
@property(nonatomic,retain) NSString * urlString;
@property(nonatomic,assign) id <HttpDelegate> delegate;

+(BOOL)isExistenceNetwork;

-(NSDictionary *)sendAndWaitResponse:(NSMutableDictionary *) parmDict 
						  addUserPwd:(BOOL) addUserPwd
                          useDataCached:(BOOL) useDataCached;

-(NSString *)startAsynchronous:(NSMutableDictionary *) parmDict
					addUserPwd:(BOOL) addUserPwd
                 useDataCached:(BOOL) useDataCached;

-(NSDictionary *)startAsynImageResponse:(NSMutableDictionary *) parmDict 
                            withImagePath:(NSString *)imagePath
                            withImageName:(NSString *)imageName;

- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;
-(void)insertDataCache:(NSString *)url data_json:(NSString *) data_json;

- (NSString *) getDataCache:(NSString *)url;

-(void)api_log:(NSMutableDictionary *) parmDict 
	 urlString:(NSString *) urlString2;
@end


@protocol HttpDelegate <NSObject>

@optional

//-(void)requestFinished:(NSDictionary *) jsonDict;
//-(void)requestFailed:(NSError *) error;
-(void)requestDone:(NSDictionary *) jsonDict error:(NSError *) error;

@end