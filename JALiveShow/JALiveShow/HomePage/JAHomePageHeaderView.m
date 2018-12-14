//
//  JAHomePageHeaderView.m
//  JALiveShow
//
//  Created by Jater on 2018/12/13.
//  Copyright © 2018 Jater. All rights reserved.
//

#import "JAHomePageHeaderView.h"
#import "JALiveShowView.h"
#import "JAThemeManager.h"

@interface JAHomePageHeaderView()

@property (nonatomic, strong) JALiveShowView *leftMoviePlayerView;
@property (nonatomic, strong) JALiveShowView *rightMoviePlayerView;

@end

@implementation JAHomePageHeaderView {
    CALayer *_shaodwLayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI {
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"l8RiP6rZRa2YS"]];
    [self addSubview:bgImageView];

    self.leftMoviePlayerView = [[JALiveShowView alloc] init];
    self.leftMoviePlayerView.layer.masksToBounds = YES;
    self.leftMoviePlayerView.layer.cornerRadius = 5.0f;
    [self addSubview:self.leftMoviePlayerView];
    
    self.rightMoviePlayerView = [[JALiveShowView alloc] init];
    self.rightMoviePlayerView.layer.masksToBounds = YES;
    self.rightMoviePlayerView.layer.cornerRadius = 5.0f;
    [self addSubview:self.rightMoviePlayerView];
    
    CGFloat gap = 40.0f;
    CGFloat height = (ThemeManager.screenWidth - 80 -24) * 3/4;
    
    [bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.leftMoviePlayerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(gap);
        make.top.equalTo(self).offset(75.0f);
        make.right.equalTo(self.mas_centerX).offset(-12.0f);
        make.height.mas_equalTo(height);
    }];
    
    [self.rightMoviePlayerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-gap);
        make.top.bottom.height.equalTo(self.leftMoviePlayerView);
        make.left.equalTo(self.mas_centerX).offset(12.0f);
    }];
}

- (void)configHotAnchorList:(NSArray *)list {
    for (NSInteger i = 0; i < list.count; i++) {
        if (i == 0) {
            [self.leftMoviePlayerView configLiveWithURLString:list[i]];
            [self.leftMoviePlayerView play];
        } else {
            [self.rightMoviePlayerView configLiveWithURLString:list[i]];
            [self.rightMoviePlayerView play];
        }
    }
}


@end
