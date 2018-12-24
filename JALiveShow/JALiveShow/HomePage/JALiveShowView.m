//
//  JALiveShowView.m
//  JALiveShow
//
//  Created by Jater on 2018/12/14.
//  Copyright © 2018 Jater. All rights reserved.
//

#import "JALiveShowView.h"
#import <IJKMediaFramework/IJKFFMoviePlayerController.h>

@interface JALiveShowView ()

@property (nonatomic, strong) IJKFFMoviePlayerController *player;

@property (nonatomic, strong) NSString *liveLink;

@end

@implementation JALiveShowView

- (instancetype)initWithURLString:(NSString *)urlString {
    if (self = [super init]) {
        [self configLiveWithURLString:urlString];
        
    }
    return self;
}

- (void)configLiveWithURLString:(NSString *)urlString {
    self.liveLink = urlString;
}

- (void)play {
    if (self.player) {
        [self.player play];
        return;
    }
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURLString:self.liveLink withOptions:[IJKFFOptions optionsByDefault]];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_SILENT];
    [self.player setPlaybackVolume:0];
    self.player.shouldAutoplay = YES;
    [self addSubview:self.player.view];
    [self.player.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.player prepareToPlay];
    [self.player play];
}

- (void)stop {
    [self.player stop];
    [self.player.view removeFromSuperview];
    [self.player shutdown];
    self.player = nil;
}

- (void)pause {
    if ([self.player isPlaying]) {
        [self.player pause];
    }
}

@end
