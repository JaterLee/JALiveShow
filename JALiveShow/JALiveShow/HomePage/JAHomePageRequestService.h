//
//  JAHomePageRequestService.h
//  JALiveShow
//
//  Created by Jater on 2018/12/14.
//  Copyright © 2018 Jater. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RACCommand;

NS_ASSUME_NONNULL_BEGIN

@interface JAHomePageRequestService : NSObject

- (RACCommand *)getHotRecAnchorReuqestCommand;

@end

NS_ASSUME_NONNULL_END
