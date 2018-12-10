//
//  JABaseRequestPrivate.h
//  JALiveShow
//
//  Created by Jater on 2018/12/11.
//  Copyright © 2018 Jater. All rights reserved.
//

#import "JABaseRequest.h"


@interface JABaseRequest (Setter)

@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;
@property (nonatomic, strong, readwrite) id responseObject;
@property (nonatomic, strong, readwrite) id responseJSONObject;
@property (nonatomic, strong, readwrite) NSString *responseString;

@end
