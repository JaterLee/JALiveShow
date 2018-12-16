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
#import <pthread/pthread.h>
#import "JABaseRequestPrivate.h"

#define Lock() pthread_mutex_lock(&_lock)
#define Unlock() pthread_mutex_unlock(&_lock)

@implementation JANetworkAgent {
    AFHTTPSessionManager * _manager;
    AFJSONResponseSerializer *_jsonResponseSerializer;
    NSMutableDictionary<NSNumber *, JABaseRequest *> *_requestsRecord;
    pthread_mutex_t _lock;
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
        
        _requestsRecord = [NSMutableDictionary dictionary];
        
        pthread_mutex_init(&_lock, NULL);
    }
    return self;
}

#pragma mark - Public Methods

- (void)addRequest:(JABaseRequest *)request {
    NSParameterAssert(request);
    NSError *__autoreleasing error = nil;
    request.requestTask = [self sessionTaskForRequest:request error:&error];
    if (error) {
        NSLog(@"error = %@", error);
    }
    [self addRequestToRecord:request];
    [request.requestTask resume];
}

- (void)cancelRequest:(JABaseRequest *)request {
    NSParameterAssert(request);
    [request.requestTask cancel];
    [self removeRequestAtRecord:request];
    [request clearCompletionBlock];
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
                               [self handleRequestResult:dataTask urlResponse:response responseObject:responseObject error:error];
    }];
    return dataTask;
}

- (void)handleRequestResult:(NSURLSessionTask *)task urlResponse:(NSURLResponse *)response responseObject:(id)responseObject error:(NSError *)error {
    Lock();
    JABaseRequest *request = _requestsRecord[@(task.taskIdentifier)];
    Unlock();
    
    if (!request) {
        return;
    }
    
    NSLog(@"Finished Request: %@", NSStringFromClass(request.class));
    
    NSError *__autoreleasing serializerError = nil;
    request.responseObject = responseObject;
    if ([request.responseObject isKindOfClass:[NSData class]]) {
        request.responseString = [[NSString alloc] initWithData:request.responseObject encoding:NSUTF8StringEncoding];
    }
    request.responseJSONObject = [_jsonResponseSerializer responseObjectForResponse:response data:responseObject error:&serializerError];
    
    NSError *resultError = nil;
    BOOL succeed = NO;
    if (error) {
        succeed = NO;
        resultError = error;
    } else if (serializerError) {
        succeed = NO;
        serializerError = resultError;
    } else {
        succeed = YES;
    }
    
    if (succeed) {
        [self requestDidSucceedWithRequest:request];
    } else {
        [self requestDidFailedWithRequest:request];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeRequestAtRecord:request];
    });
    
}

- (void)requestDidSucceedWithRequest:(JABaseRequest *)request {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (request.requestSuccessBlock) {
            request.requestSuccessBlock(request);
        }
    });
}

- (void)requestDidFailedWithRequest:(JABaseRequest *)request {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (request.requestFailBlock) {
            request.requestFailBlock(request);
        }
    });
}

- (void)addRequestToRecord:(JABaseRequest *)request {
    Lock();
    _requestsRecord[@(request.requestTask.taskIdentifier)] = request;
    Unlock();
}

- (void)removeRequestAtRecord:(JABaseRequest *)request {
    Lock();
    [_requestsRecord removeObjectForKey:@(request.requestTask.taskIdentifier)];
    Unlock();
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
    requestSerializer.timeoutInterval = 30;
    requestSerializer.allowsCellularAccess = YES;
    return requestSerializer;
}

@end
