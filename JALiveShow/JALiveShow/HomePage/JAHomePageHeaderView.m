//
//  JAHomePageHeaderView.m
//  JALiveShow
//
//  Created by Jater on 2018/12/13.
//  Copyright © 2018 Jater. All rights reserved.
//

#import "JAHomePageHeaderView.h"
#import <IJKMediaFramework/IJKFFMoviePlayerController.h>

@interface JAHomePageHeaderView()

@property (nonatomic, strong) UIView *hotAnchorView;
@property (nonatomic, strong) UIView *leftMoviePlayerView;
@property (nonatomic, strong) IJKFFMoviePlayerController *rightMoviePlayerController;

@property (nonatomic, strong) IJKFFMoviePlayerController *player;

@end

@implementation JAHomePageHeaderView {
    CALayer *_shaodwLayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self drawUI];
        [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:self.hotAnchorView.frame];
    _shaodwLayer.shadowPath = bezierPath.CGPath;
}

- (void)drawUI {
    self.hotAnchorView = [[UIView alloc] initWithFrame:CGRectZero];
    self.hotAnchorView.hidden = YES;
    [self addSubview:self.hotAnchorView];
    self.hotAnchorView.layer.masksToBounds = YES;
    self.hotAnchorView.layer.cornerRadius = 5;
    _shaodwLayer = [CALayer layer];
    _shaodwLayer.backgroundColor = UIColor.whiteColor.CGColor;
    _shaodwLayer.shadowColor = UIColor.blackColor.CGColor;
    _shaodwLayer.shadowOffset = CGSizeMake(0, 2);
    _shaodwLayer.shadowRadius = 5.0f;
    [self.hotAnchorView.layer insertSublayer:_shaodwLayer atIndex:0];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"l8RiP6rZRa2YS"]];
    [self addSubview:bgImageView];

    self.leftMoviePlayerView = [[UIView alloc] init];
    self.leftMoviePlayerView.backgroundColor = UIColor.redColor;
    self.leftMoviePlayerView.autoresizesSubviews = YES;
    [self addSubview:self.leftMoviePlayerView];
    
    self.rightMoviePlayerController = [[IJKFFMoviePlayerController alloc] init];
    [self addSubview:self.rightMoviePlayerController.view];
    
    CGFloat gap = 20.0f;
    
    [self.hotAnchorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(gap);
        make.right.equalTo(self).offset(-gap);
        make.height.mas_equalTo(270.0f);
    }];
    
    [bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.leftMoviePlayerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotAnchorView).offset(gap);
        make.top.equalTo(self.hotAnchorView).offset(75.0f);
        make.right.equalTo(self.hotAnchorView.mas_centerX).offset(-12.0f);
        make.bottom.equalTo(self.hotAnchorView).offset(-10.0f);
    }];
    
    [self.rightMoviePlayerController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.hotAnchorView).offset(-gap);
        make.top.bottom.equalTo(self.leftMoviePlayerView);
        make.left.equalTo(self.hotAnchorView.mas_centerX).offset(12.0f);
    }];
    
    
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURLString:@"http://pili-live-hdl.miaobolive.com/live/3652031e913e1d37457cef6128eb7540.flv" withOptions:[IJKFFOptions optionsByDefault]];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    //            [player play];
    self.player.shouldAutoplay = YES;
    self.player.view.frame = self.leftMoviePlayerView.bounds;
    [self.leftMoviePlayerView addSubview:self.player.view];
    [self.player prepareToPlay];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.player play];
    });

}

- (void)configHotAnchorList:(NSArray *)list {
    for (NSInteger i = 0; i < list.count; i++) {
        if (i == 0) {
        } else {
//            self.rightMoviePlayerController.contentURL = [NSURL URLWithString:list[i]];
        }
    }
}


@end
