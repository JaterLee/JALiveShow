//
//  JAHomeLiveRoomListRequest.m
//  JALiveShow
//
//  Created by Jater on 2018/12/16.
//  Copyright © 2018 Jater. All rights reserved.
//

#import "JAHomeLiveRoomListRequest.h"

@implementation JAHomeLiveRoomListRequest

- (NSString *)requestUrl {
    return @"/Room/GetHotLive_v2";
}

- (id)requestArgument {
    return @{
             @"isNewapp" : @"1",
             @"page" : @(self.pageNo),
             @"type" : @"1",
             @"useridx" : @"73326729"
             };
}

@end
