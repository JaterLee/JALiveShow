//
//  JANetworkAgent.m
//  JALiveShow
//
//  Created by Jater on 2018/12/4.
//  Copyright © 2018 Jater. All rights reserved.
//

#import "JANetworkAgent.h"
#import "JABaseRequest.h"
#import <AFNetworking/AFNetworking.h>

@implementation JANetworkAgent {
    AFHTTPSessionManager * _manager;
    AFJSONResponseSerializer *_jsonResponseSerializer;
}

+ (JANetworkAgent *)sharedAgent {
    static JANetworkAgent *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JANetworkAgent alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:nil];
        _manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [self jsonResponseSerializer];
    }
    return self;
}

#pragma mark - Public Methods

- (void)addRequest:(JABaseRequest *)request {
    NSParameterAssert(request);
    NSError *__autoreleasing error = nil;
    NSURLSessionTask *task = [self sessionTaskForRequest:request error:&error];
    if (error) {
        NSLog(@"error = %@", error);
    }
    [task resume];
}

- (NSURLSessionTask *)sessionTaskForRequest:(JABaseRequest *)request error:(NSError * _Nullable __autoreleasing *)error {
    JARequestMethod requestMethod = [request requestMethod];
    NSString *url = [self buildRequestUrl:request];
    id param = request.requestArgument;
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerForRequest:request];
    switch (requestMethod) {
        case JARequestMethodGet:
            return [self dataTaskWithHttpMethod:@"Get" requestSerializer:requestSerializer urlString:url parameters:param error:error];
            break;
            
        default:
            break;
    }
    return nil;
}

- (NSURLSessionDataTask *)dataTaskWithHttpMethod:(NSString *)method
                               requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                       urlString:(NSString *)urlString
                                      parameters:(id)parameters
                                           error:(NSError * _Nullable __autoreleasing *)error {
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:method URLString:urlString parameters:parameters error:error];
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [_manager dataTaskWithRequest:request
                              uploadProgress:nil
                            downloadProgress:nil
                           completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                               NSLog(@"response %@\nresponseObject %@\nerror %@",response, responseObject, error);
    }];
    return dataTask;
}

#pragma mark - Setter and Getter

- (AFJSONResponseSerializer *)jsonResponseSerializer {
    if (!_jsonResponseSerializer) {
        _jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        _jsonResponseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", @"text/css", nil];
    }
    return _jsonResponseSerializer;
}

- (NSString *)buildRequestUrl:(JABaseRequest *)request {
    NSParameterAssert(request != nil);
    
    NSString *detailUrl = [request requestUrl];
    NSURL *temp = [NSURL URLWithString:detailUrl];
    if (temp && temp.host && temp.scheme) {
        return detailUrl;
    }
    
    NSString *baseUrl;
    if ([request baseUrl].length > 0) {
        baseUrl = [request baseUrl];
    }
    NSURL *url = [NSURL URLWithString:baseUrl];
    if (baseUrl.length > 0 && ![baseUrl hasSuffix:@"/"]) {
        url = [url URLByAppendingPathComponent:@""];
    }
    return [NSURL URLWithString:detailUrl relativeToURL:url].absoluteString;
}

- (AFHTTPRequestSerializer *)requestSerializerForRequest:(JABaseRequest *)request {
    AFHTTPRequestSerializer *requestSerializer = nil;
    requestSerializer = [AFHTTPRequestSerializer serializer];
    requestSerializer.timeoutInterval = 60;
    requestSerializer.allowsCellularAccess = YES;
    return requestSerializer;
}

@end
