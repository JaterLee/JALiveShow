//
//  JALiveShowView.h
//  JALiveShow
//
//  Created by Jater on 2018/12/14.
//  Copyright © 2018 Jater. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JALiveShowView : UIView

- (instancetype)initWithURLString:(NSString *)urlString;

- (void)configLiveWithURLString:(NSString *)urlString;

- (void)play;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
