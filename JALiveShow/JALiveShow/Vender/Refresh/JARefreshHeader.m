//
//  JARefreshHeader.m
//  JALiveShow
//
//  Created by Jater on 2018/12/25.
//  Copyright © 2018 Jater. All rights reserved.
//

#import "JARefreshHeader.h"

@interface JARefreshHeader ()

@property (nonatomic, strong) UIImageView *gifImageView;

@end

@implementation JARefreshHeader {
    NSArray *_stateImages;
}

- (void)prepare {
    [super prepare];
    self.stateLabel.hidden = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
}

- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    NSArray *images = self.stateImages;
    if (self.state != MJRefreshStateIdle || images.count == 0) {
        return;
    }
    [self.gifImageView stopAnimating];
    NSUInteger index = images.count * pullingPercent;
    if (index >= images.count) {
        index = images.count - 1;
    }
    self.gifImageView.image = images[index];
}

- (void)placeSubviews {
    [super placeSubviews];
    if (self.gifImageView.constraints.count) {
        return;
    }
    self.gifImageView.frame = self.bounds;
    self.gifImageView.contentMode = UIViewContentModeCenter;
}

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState
    
    if (state == MJRefreshStatePulling || state == MJRefreshStateRefreshing) {
        NSArray *images = self.stateImages;
        if (images.count == 0) {
            return;
        }
        [self.gifImageView stopAnimating];
        if (images.count == 1) {
            self.gifImageView.image = images.lastObject;
        } else {
            self.gifImageView.animationImages = images;
            self.gifImageView.animationDuration = 2;
            [self.gifImageView startAnimating];
        }
    } else if (state == MJRefreshStateIdle) {
        [self.gifImageView stopAnimating];
    }
}


- (NSArray *)stateImages {
    if (_stateImages) {
        return _stateImages;
    }
    NSMutableArray *temp = [NSMutableArray array];
    for (NSInteger i = 1; i < 13; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"r2VSkzO%@", @(i)]];
        [temp addObject:image];
    }
    _stateImages = [temp copy];
    return _stateImages;
}

- (UIImageView *)gifImageView {
    if (!_gifImageView) {
        _gifImageView = [[UIImageView alloc] init];
        [self addSubview:_gifImageView];
    }
    return _gifImageView;
}

@end
