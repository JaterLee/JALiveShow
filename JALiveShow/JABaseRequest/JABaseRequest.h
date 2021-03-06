//
//  JABaseRequest.h
//  JALiveShow
//
//  Created by Jater on 2018/12/4.
//  Copyright © 2018 Jater. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class JABaseRequest;

typedef NS_ENUM(NSInteger, JARequestMethod) {
    JARequestMethodGet = 0,
    JARequestMethodPost
};

typedef void(^JARequestCompleteBlock)(__kindof JABaseRequest *request);

@interface JABaseRequest : NSObject

@property (nonatomic, strong, readonly) NSURLSessionTask *requestTask;
@property (nonatomic, strong, readonly, nullable) id responseObject;
@property (nonatomic, strong, readonly, nullable) id responseJSONObject;
@property (nonatomic, strong, readonly, nullable) NSString *responseString;

@property (nonatomic, copy, nullable) JARequestCompleteBlock requestSuccessBlock;
@property (nonatomic, copy, nullable) JARequestCompleteBlock requestFailBlock;

/// 开始请求
- (void)start;

- (void)stop;

- (void)startWithCompletionBlockWithSuccess:(JARequestCompleteBlock)success
                                    failure:(JARequestCompleteBlock)failure;

- (void)clearCompletionBlock;

/// http 请求的类型
- (JARequestMethod)requestMethod;

/// 域名
- (NSString *)baseUrl;

/// 请求地址后缀
- (NSString *)requestUrl;

/// 参数
- (id)requestArgument;

@end

NS_ASSUME_NONNULL_END
