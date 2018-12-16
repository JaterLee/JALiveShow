//
//  JAHomePageCollectionViewCell.m
//  JALiveShow
//
//  Created by Jater on 2018/12/16.
//  Copyright © 2018 Jater. All rights reserved.
//

#import "JAHomePageCollectionViewCell.h"
#import "JALiveShowView.h"

@interface JAHomePageCollectionViewCell()

@property (nonatomic, strong)  JALiveShowView *liveShowView;

@end

@implementation JAHomePageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self drawUI];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)drawUI {
    self.liveShowView = [[JALiveShowView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.liveShowView];
    [self.liveShowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)configLiveLink:(NSString *)liveLink {
    [self.liveShowView configLiveWithURLString:liveLink];
}

@end
