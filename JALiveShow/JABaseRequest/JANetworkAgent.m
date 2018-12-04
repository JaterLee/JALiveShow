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
        _manager = [AFHTTPSessionManager manager];
    }
    return self;
}

- (void)addRequest:(JABaseRequest *)request {
    NSParameterAssert(request);
    
}

@end
