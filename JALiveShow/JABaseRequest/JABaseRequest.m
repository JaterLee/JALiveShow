//
//  JABaseRequest.m
//  JALiveShow
//
//  Created by Jater on 2018/12/4.
//  Copyright © 2018 Jater. All rights reserved.
//

#import "JABaseRequest.h"
#import <AFNetworking/AFNetworking.h>
#import "JANetworkAgent.h"

@implementation JABaseRequest

- (void)start {
    [JANetworkAgent sharedAgent] 
}



- (void)getHotRecAnchorRequest {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.operationQueue.maxConcurrentOperationCount = 5;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.requestSerializer.timeoutInterval = 30;
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"content-Encoding"];
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml", @"text/html", @"application/json",@"text/plain", nil];
    [manager GET:@"https://live.miaobolive.com/Room/GetHotRecAnchor"
      parameters:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          
      }];
}

- (NSDictionary *)parameters {
    return @{
             @"Cache-Control": @"private",
             @"Content-Type": @"text/html",
//             @"Server":@" Microsoft-IIS/7.5",
//             @"X-AspNetMvc-Version": @"4.0",
//             @"X-AspNet-Version": @"4.0.30319",
//             @"X-Powered-By": @"ASP.NET",
//             @"Date": @"Tue, 04 Dec 2018 14:35:54 GMT",
//             @"Content-Length": @"1172",
//             @"Connection": @"keep-alive",
             
             
//             @"appid": @"500",
//             @"channelid": @"app store",
//             @"version": @"1.2.0",
//             @"Accept": @"*/*",
//             @"blackAreaStatus": @"0",
//             @"bundleid": @"com.sunday.miaolive",
//             @"Accept-Language": @"zh-Hans-CN;q=1",
//             @"Accept-Encoding": @"br, gzip, deflate",
//             @"devicetype": @"ios",
//             @"deviceid": @"9E07A819-E0BA-407C-8E91-5FD00E1E7DC3",
//             @"User-Agent": @"MiaoLive/1.2.0 (iPhone; iOS 12.0; Scale/2.00)",
//             @"Connection": @"keep-alive",
//             @"useridx": @"0",
//             @"areaid": @"0",
             };
}


@end