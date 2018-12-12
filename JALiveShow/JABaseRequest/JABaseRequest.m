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

@interface JABaseRequest ()

@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;
@property (nonatomic, strong, readwrite) id responseObject;
@property (nonatomic, strong, readwrite) id responseJSONObject;
@property (nonatomic, strong, readwrite) NSString *responseString;

@end

@implementation JABaseRequest

- (JARequestMethod)requestMethod {
    return JARequestMethodGet;
}


- (NSString *)baseUrl {
    return @"";
}

- (NSString *)requestUrl {
    return @"";
}


- (id)requestArgument {
    return nil;
}


#pragma mark - Public

- (void)start {
    [[JANetworkAgent sharedAgent] addRequest:self];
}

- (void)stop {
    [[JANetworkAgent sharedAgent] cancelRequest:self];
}

- (void)startWithCompletionBlockWithSuccess:(JARequestCompleteBlock)success failure:(JARequestCompleteBlock)failure {
    self.requestSuccessBlock = success;
    self.requestFailBlock = failure;
    [self start];
}

- (void)clearCompletionBlock {
    self.requestSuccessBlock = nil;
    self.requestFailBlock = nil;
}

@end
