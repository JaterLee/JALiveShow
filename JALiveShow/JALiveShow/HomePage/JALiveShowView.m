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

@end

@implementation JALiveShowView

- (instancetype)initWithURLString:(NSString *)urlString {
    if (self = [super init]) {
        [self configLiveWithURLString:urlString];
        
    }
    return self;
}

- (void)configLiveWithURLString:(NSString *)urlString {
//    if (self.player) {
//        [self.player.view removeFromSuperview];
//    }
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURLString:urlString withOptions:[IJKFFOptions optionsByDefault]];
    [self.player setPlaybackVolume:0];
    self.player.shouldAutoplay = YES;
    [self addSubview:self.player.view];
    
    [self.player.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.player prepareToPlay];
}

- (void)play {
    [self stop];
    [self.player play];
}

- (void)stop {
    if ([self.player isPlaying]) {
        [self.player stop];
    }
}

@end
