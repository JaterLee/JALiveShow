//
//  JANetworkAgent.h
//  JALiveShow
//
//  Created by Jater on 2018/12/4.
//  Copyright © 2018 Jater. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JABaseRequest;

NS_ASSUME_NONNULL_BEGIN

@interface JANetworkAgent : NSObject

+ (JANetworkAgent *)sharedAgent;

- (void)addRequest:(JABaseRequest *)request;

- (void)cancelRequest:(JABaseRequest *)request;

@end

NS_ASSUME_NONNULL_END
