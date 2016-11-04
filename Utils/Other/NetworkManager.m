//
//  NetworkManager.m
//  MShop
//
//  Created by 陈 福权 on 11-9-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NetworkManager.h"
#import "ASIFormDataRequest.h"
#import "GTMBase64.h"
#import "GlobalVariables.h"
#import "NSObject+SBJson.h"
#import "DB.h"
#import "ExtendNSString.h"
#import "Reachability.h"
#import "ExtendNSDictionary.h"

@implementation NetworkManager
@synthesize delegate;
@synthesize urlString;

+(BOOL)isExistenceNetwork
{
    return YES;
    
	BOOL isExistenceNetwork;
    //GlobalVariables *fanweApp = [GlobalVariables sharedInstance];
    //NSLog(@"begin ========isExistenceNetwork");
	Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    //Reachability *r = [Reachability reachabilityWithHostName:fanweApp.system_url];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
			isExistenceNetwork=FALSE;
              // NSLog(@"没有网络");
            break;
        case ReachableViaWWAN:
			isExistenceNetwork=TRUE;
               //NSLog(@"正在使用3G网络");
            break;
        case ReachableViaWiFi:
			isExistenceNetwork=TRUE;
              //NSLog(@"正在使用wifi网络");        
            break;
    }
    //NSLog(@"end ========isExistenceNetwork");
	return isExistenceNetwork;
}

-(NSDictionary *)startAsynImageResponse:(NSMutableDictionary *) parmDict 
                            withImagePath:(NSString *)imagePath
                            withImageName:(NSString *)imageName{
    fanweApp = [GlobalVariables sharedInstance];
    
    [parmDict setObject:[fanweApp toValue:fanweApp.user_name] forKey:@"email"];
    [parmDict setObject:[fanweApp toValue:fanweApp.user_pwd] forKey:@"pwd"];	
//    [parmDict setObject:[NSString stringWithFormat:@"%d",fanweApp.curCityID] forKey:@"city_id"];   // [parmDict setObject:[fanweApp toValue:fanweApp.curCityID] forKey:@"city_id"];
    //[parmDict setObject:[fanweApp toValue:fanweApp.user_pwd] forKey:@"password"];
	
	NSString *requestData = [GTMBase64 encodeBase64:[parmDict JSONRepresentation]];
		
	//NSLog(@"%@",requestData);
	
	//NSLog(@"%@",[fanweApp.system_url stringByAppendingFormat:@"?requestData=%@&r_type=2",requestData]);
	//调试时使用,正式发布时要删除
	//[self api_log:parmDict urlString:[fanweApp.system_url stringByAppendingFormat:@"?requestData=%@&r_type=2",requestData]];
	
   
    //NSLog(@"%@",[GTMBase64 decodeBase64:requestData]);
    //ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:system_url]];
    //[asiRequest setURL:[NSURL URLWithString:system_url]];
    //[asiRequest clearDelegatesAndCancel];
    ASIFormDataRequest *request2 = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:fanweApp.system_url]];
    request2.tag = 0;
    [request2 setRequestMethod:@"POST"];
    [request2 setPostValue:requestData forKey:@"requestData"];
    [request2 setPostValue:@"0" forKey:@"i_type"];
    [request2 setPostValue:@"0" forKey:@"r_type"];
    
    //[request setData:imageData forKey:imageName];
    [request2 setFile:imagePath forKey:imageName];
    
    [request2 setShowAccurateProgress:NO];
    
    [request2 setTimeOutSeconds:20];
    
    if(delegate != nil) {
        [request setDelegate:self];
    }   
    [request2 startAsynchronous];
    
    return nil;
}


-(NSDictionary *)sendAndWaitResponse:(NSMutableDictionary *) parmDict addUserPwd:(BOOL) addUserPwd useDataCached:(BOOL) useDataCached{
    
    
    fanweApp = [GlobalVariables sharedInstance];
	if (addUserPwd){
        [parmDict setObject:[fanweApp toValue:fanweApp.user_name] forKey:@"email"];
        [parmDict setObject:[fanweApp toValue:fanweApp.user_pwd] forKey:@"pwd"];	
        
//		[parmDict setObject:[NSString stringWithFormat:@"%d",fanweApp.curCityID] forKey:@"city_id"];
       // [parmDict setObject:[fanweApp toValue:fanweApp.curCityID] forKey:@"city_id"];
        //[parmDict setObject:[fanweApp toValue:fanweApp.user_pwd] forKey:@"password"];		
	}
    //[parmDict setObject:[NSString stringWithFormat:@"%d", fanweApp.curCityID] forKey:@"cur_city_id"];
	
	
	NSString *requestData = [GTMBase64 encodeBase64:[parmDict JSONRepresentation]];
	
	
	//NSLog(@"%@",requestData);
	
	//NSLog(@"%@",[fanweApp.system_url stringByAppendingFormat:@"?requestData=%@&r_type=2",requestData]);
    
    NSString  *urlString2 = [fanweApp.system_url stringByAppendingFormat:@"?requestData=%@",requestData];
	//NSLog(@"%@",[urlString2 stringByAppendingFormat:@"&r_type=2"]);
	
	//调试时使用,正式发布时要删除
	[self api_log:parmDict urlString:[urlString2 stringByAppendingFormat:@"&r_type=2"]];

	
    if (useDataCached && ![NetworkManager isExistenceNetwork]){
        NSString *jsonStr = [self getDataCache:urlString2];        
        return [jsonStr JSONValue];
    }else{
        
        ASIFormDataRequest *request2 = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:fanweApp.system_url]];
        //request.isNetworkReachableViaWWAN
        [request2 setRequestMethod:@"POST"];
        [request2 setPostValue:requestData forKey:@"requestData"];
        [request2 setPostValue:@"0" forKey:@"i_type"];
        [request2 setPostValue:@"0" forKey:@"r_type"];
        
        [request2 setShowAccurateProgress:NO];
        
        [request2 setTimeOutSeconds:20];
        
        [request2 startSynchronous];
        
        NSError *error = [request2 error];
        if (!error) {
            
            NSString *jsonStr = [request2 responseString];
            
            //NSLog(@"%@",jsonStr);
            
            //if ([r_type isEqual:@"0"]) {
            jsonStr = [GTMBase64 decodeBase64:jsonStr];
            //}	
            //NSLog(@"%@",jsonStr);
            if (useDataCached){
                [self insertDataCache:urlString2 data_json:jsonStr];        
            }
            
            NSDictionary *jsonDict = [jsonStr JSONValue];
            
            return jsonDict;
        }else {
            //NSLog(@"Error: %@", error);
            //获取缓存数据
            NSString *jsonStr = [self getDataCache:urlString2];        
            return [jsonStr JSONValue];            
            //return nil;
        }
        
        [request2 clearDelegatesAndCancel];
        [request2 release];
    }
	//[url release];	
}

-(NSDictionary *)startAsynchronous:(NSMutableDictionary *) parmDict addUserPwd:(BOOL) addUserPwd useDataCached:(BOOL) useDataCached{
    fanweApp = [GlobalVariables sharedInstance];
    
    //[parmDict setObject:[NSString stringWithFormat:@"%d", fanweApp.curCityID] forKey:@"cur_city_id"];    
    
	if (addUserPwd){
        [parmDict setObject:[fanweApp toValue:fanweApp.user_name] forKey:@"email"];
        [parmDict setObject:[fanweApp toValue:fanweApp.user_pwd] forKey:@"pwd"];
		//NSLog(@"%d",fanweApp.curCityID);
	
//		[parmDict setObject:[NSString stringWithFormat:@"%d",fanweApp.curCityID] forKey:@"city_id"];
		
		//[parmDict setObject:[fanweApp toValue:fanweApp.curCityID] forKey:@"city_id"];
        //[parmDict setObject:[fanweApp toValue:fanweApp.user_pwd] forKey:@"password"];		
	}
	NSLog(@"%@",parmDict);

//	NSString *requestData = [GTMBase64 encodeBase64:[parmDict JSONRepresentation]];
    //NSString *requestData = [parmDict JSONRepresentation];
    
    NSArray *arr=[[parmDict allKeys]sortedArrayUsingSelector:@selector(compare:)];
//    
    //NSArray *arr1=[parmDict allValues];
    
	
	//NSLog(@"%@",[system_url stringByAppendingFormat:@"?requestData=%@&i_type=2&r_type=2",requestData]);
//    for (int i = 0; i < [parmDict count]; i++) {
//        if (i == 0) {
//            urlString = [fanweApp.system_url stringByAppendingFormat:@"%@=%@",arr[i],arr1[i]];
//        }else{
//            urlString = [fanweApp.system_url stringByAppendingFormat:@"&%@=%@",arr[i],arr1[i]];
//        }
//        
//        
//    }
    
	//NSLog(@"%@",[system_url stringByAppendingFormat:@"?requestData=%@&i_type=2&r_type=2",requestData]);
    
    urlString = fanweApp.system_url;
    //urlString = [fanweApp.system_url stringByAppendingFormat:@"&%@=%@",arr[i],[parmDict objectForKey:arr[i]]];
        for (int i = 0; i < [parmDict count]; i++) {
            urlString = [urlString stringByAppendingFormat:@"&%@=%@",arr[i],[parmDict objectForKey:arr[i]]];
        }
    
    
    
    //NSString * urlString = [fanweApp.system_url stringByAppendingFormat:@"%@",requestData];
	NSLog(@"%@",[urlString stringByAppendingFormat:@"&i_type=1&r_type=2"]);
    
    //调试时使用,正式发布时要删除
    [self api_log:parmDict urlString:urlString];
		
	//[asiRequest clearDelegatesAndCancel];
    
    if (useDataCached && ![NetworkManager isExistenceNetwork]){
        //NSLog(@"NetworkManager:useDataCached");
        NSString *jsonStr = [self getDataCache:urlString];        
        NSDictionary *jsonDict = [jsonStr JSONValue];        
        if(delegate != nil) {
            if ([delegate respondsToSelector:@selector(requestDone:error:)]) {
                [delegate performSelector:@selector(requestDone:error:) withObject:jsonDict withObject:nil];
            }
        }        
    }else{    
        //[asiRequest setURL:[NSURL URLWithString:system_url]];
        //ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:fanweApp.system_url]];
        //NSLog(@"NetworkManager:startAsynchronous");
        if (request){
            request.delegate = nil;
            //NSLog(@"NetworkManager:startAsynchronous:request");
            if (request.isExecuting){
                //NSLog(@"NetworkManager:startAsynchronous:request cancel");
                [request cancel];
            }
            [request release];
            request = nil;
        }
        
        request =  [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:fanweApp.system_url]];
        
        //request. = urlString;
        if (useDataCached){
            request.tag = 1;
            request.username = urlString;//临时保存
        }
        [request setRequestMethod:@"POST"];
        
        for (int i = 0; i < [parmDict count]; i++) {
            //if (i == 0) {
            //    urlString = [fanweApp.system_url stringByAppendingFormat:@"%@=%@",arr[i],arr1[i]];
            //}else{
            //    urlString = [fanweApp.system_url stringByAppendingFormat:@"&%@=%@",arr[i],arr1[i]];
           // }
            
            [request setPostValue:[parmDict objectForKey:arr[i]] forKey:arr[i]];
        }
        
        
        //[request setPostValue:requestData forKey:@"requestData"];
        [request setPostValue:@"1" forKey:@"i_type"];
        [request setPostValue:@"1" forKey:@"r_type"];
        
        [request setShowAccurateProgress:NO];
        
        [request setTimeOutSeconds:20];
        if(delegate != nil) {
            [request setDelegate:self];
        }   
        [request startAsynchronous];
    }
    return nil;
}

-(void)api_log:(NSMutableDictionary *) parmDict urlString:(NSString *) urlString2{
	//调试时使用,正式发布时要删除	
	if (NO) {
		fanweApp = [GlobalVariables sharedInstance];
		
		NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
		[tmpDict setObject:@"api_log" forKey:@"act"];		
		[tmpDict setObject:[parmDict toString:@"act"] forKey:@"api_act"];
		[tmpDict setObject:[urlString2 stringByAppendingFormat:@"&r_type=2"] forKey:@"api"];
		
		NSString *requestData_tmp = [GTMBase64 encodeBase64:[tmpDict JSONRepresentation]];
		
		
		ASIFormDataRequest *request_tmp =  [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:fanweApp.system_url]] autorelease];        
        [request_tmp setRequestMethod:@"POST"];	
        [request_tmp setPostValue:requestData_tmp forKey:@"requestData"];
        [request_tmp setPostValue:@"0" forKey:@"i_type"];
        [request_tmp setPostValue:@"0" forKey:@"r_type"];        
        [request_tmp setShowAccurateProgress:NO];        
        [request_tmp setTimeOutSeconds:20];   
        [request_tmp startAsynchronous];
	}
	
}

- (void)requestFinished:(ASIHTTPRequest *)request2
{
    
//	NSLog(@"%@",[request responseString]);
	//NSString *jsonStr = [GTMBase64 decodeBase64:[request2 responseString]];
	//NSLog(@"%@",jsonStr);
	NSDictionary *jsonDict = [[request2 responseString] JSONValue];
	
    //NSString *tmp = (NSString *)request.tag;
    //request.url
    //request
    if (request2.tag == 1){
        //NSLog(@"request.username:%@",request.username);
        [self insertDataCache:request2.username data_json:[request2 responseString]];
    }
    
	if(delegate != nil) {
        if ([delegate respondsToSelector:@selector(requestDone:error:)]) {
			//[delegate performSelector:@selector(requestDone:error:) withObject:jsonDict];
			[delegate performSelector:@selector(requestDone:error:) withObject:jsonDict withObject:nil];
        }
	}	
}

- (void)requestFailed:(ASIHTTPRequest *)request2
{
	NSError *error = [request2 error];
    NSDictionary *jsonDict = nil;
    //获取缓存数据
    //NSString *jsonStr = [self getDataCache:urlString2];        
    if (request2.tag == 1){
        //获取缓存数据
        NSString *jsonStr = [self getDataCache:request2.username];
        jsonDict = [jsonStr JSONValue];
    }
    
	if(delegate != nil) {
        if ([delegate respondsToSelector:@selector(requestDone:error:)]) {
			//[delegate performSelector:@selector(requestDone:error:) withObject:jsonDict];
			[delegate performSelector:@selector(requestDone:error:) withObject:jsonDict withObject:error];
        }
	}
	/*
	if(delegate != nil) {
        if ([delegate respondsToSelector:@selector(requestFailed:)]) {
			[delegate performSelector:@selector(requestFailed:) withObject:error];			
        }
	}*/	
}

-(void)insertDataCache:(NSString *)url data_json:(NSString *) data_json{
    
    //NSLog(@"url:%@",url);
	NSString *urlmd5 = [url MD5Hash:url];
    
    DB *db = [DB initFanweDb:NO];
	
    //删除旧的缓存
    [db executeUpdate:@"delete from data_cached where urlmd5 =?", urlmd5];
    
    ////插入新的缓存
    [db executeUpdate:@"insert into data_cached (urlmd5, data_json) values (?,?)", urlmd5, data_json];
    
    int new_id = [db lastInsertRowId];
    
    //清除多余的缓存数量,只保留cached_num条数量,算法还有点小问题
    //NSString *sql = @"delete from data_cached where id < %d";
    NSString *sql = [NSString stringWithFormat:@"delete from data_cached where id < %d", new_id - 1000];
    [db executeUpdate:sql];
    
	[db close];
}

- (NSString *) getDataCache:(NSString *)url{
    //NSLog(@"url:%@",url);
	NSString *urlmd5 = [url MD5Hash:url];
    
    DB *db = [DB initFanweDb:NO];
    NSString *data_json = [db stringForQuery:@"select data_json from data_cached where urlmd5 =?", urlmd5];
    [db close];
    
    return data_json;
}

-(void)dealloc{
    //NSLog(@"NetworkManager:dealloc");
    if (request){
        request.delegate = nil;
        //NSLog(@"NetworkManager:dealloc:request");
        if (request.isExecuting){
            //NSLog(@"NetworkManager:dealloc:request cancel");
            [request cancel];
        }
        [request release];
        request = nil;
    }
    
	[super dealloc];
}
@end
