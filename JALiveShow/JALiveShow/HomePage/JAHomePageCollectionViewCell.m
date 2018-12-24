//
//  JAHomePageCollectionViewCell.m
//  JALiveShow
//
//  Created by Jater on 2018/12/16.
//  Copyright © 2018 Jater. All rights reserved.
//

#import "JAHomePageCollectionViewCell.h"
#import "JALiveShowView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface JAHomePageCollectionViewCell()

@property (nonatomic, strong)  UIImageView *coverImageView;

@property (nonatomic, strong)  JALiveShowView *liveShowView;

@property (nonatomic, strong)  UILabel *nickNameLabel;

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
    [self.liveShowView stop];
}

- (void)drawUI {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5.0f;
    self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.coverImageView];
    
    self.liveShowView = [[JALiveShowView alloc] initWithFrame:CGRectZero];
    self.liveShowView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.liveShowView];
    
    self.nickNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nickNameLabel.font = [UIFont systemFontOfSize:15];
    self.nickNameLabel.textColor = UIColor.whiteColor;
    self.nickNameLabel.layer.shadowOffset = CGSizeMake(0, 3);
    self.nickNameLabel.layer.shadowColor = UIColor.blackColor.CGColor;
    [self addSubview:self.nickNameLabel];
    
    [self.coverImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.liveShowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.nickNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImageView).offset(10.0f);
        make.bottom.equalTo(self.coverImageView).offset(-10.0f);
        make.width.lessThanOrEqualTo(self.coverImageView).offset(-20.0f);
    }];
}

- (void)configLiveLink:(NSString *)liveLink {
    [self.liveShowView configLiveWithURLString:liveLink];
}

- (void)configCoverImageLink:(NSString *)coverImageLink {
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:coverImageLink]];
}

- (void)configNickName:(NSString *)nickName {
    self.nickNameLabel.text = nickName;
}

- (void)play {
    [self.liveShowView play];
}

- (void)stop {
    [self.liveShowView stop];
}

@end
