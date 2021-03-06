//
//  JAHomePageRequestService.m
//  JALiveShow
//
//  Created by Jater on 2018/12/14.
//  Copyright © 2018 Jater. All rights reserved.
//

#import "JAHomePageRequestService.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "JAGetHotRecAnchorReuqest.h"
#import "JAHomeLiveRoomListRequest.h"

@implementation JAHomePageRequestService

- (RACCommand *)getHotRecAnchorReuqestCommand {
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            JAGetHotRecAnchorReuqest *request = [JAGetHotRecAnchorReuqest new];
            [request startWithCompletionBlockWithSuccess:^(__kindof JABaseRequest * _Nonnull request) {
                if ([request.responseJSONObject[@"code"] isEqualToString:@"100"]) {
                    [subscriber sendNext:request.responseJSONObject[@"data"][@"roomList"]];
                    [subscriber sendCompleted];
                } else {
                    [subscriber sendError:[NSError errorWithDomain:NSCocoaErrorDomain code:[request.responseJSONObject[@"code"] integerValue] userInfo:@{NSLocalizedDescriptionKey : request.responseJSONObject}]];
                }
            } failure:^(__kindof JABaseRequest * _Nonnull request) {
                [subscriber sendError:[NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"接口报错了"}]];
            }];
            return [RACDisposable disposableWithBlock:^{
                [request stop];
            }];
        }];
    }];
}

- (RACCommand *)fetchHomePageLiveListRequestCommand {
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            JAHomeLiveRoomListRequest *request = [[JAHomeLiveRoomListRequest alloc] init];
            request.pageNo = [input integerValue];
            [request startWithCompletionBlockWithSuccess:^(__kindof JABaseRequest * _Nonnull request) {
                if ([request.responseJSONObject[@"code"] isEqualToString:@"100"]) {
                    [subscriber sendNext:request.responseJSONObject[@"data"][@"list"]];
                    [subscriber sendCompleted];
                } else {
                    [subscriber sendError:[NSError errorWithDomain:NSCocoaErrorDomain code:[request.responseJSONObject[@"code"] integerValue] userInfo:@{NSLocalizedDescriptionKey : request.responseJSONObject}]];
                }
            } failure:^(__kindof JABaseRequest * _Nonnull request) {
                [subscriber sendError:[NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"接口报错了"}]];
            }];
            return [RACDisposable disposableWithBlock:^{
                [request stop];
            }];
        }];
    }];
}

@end

