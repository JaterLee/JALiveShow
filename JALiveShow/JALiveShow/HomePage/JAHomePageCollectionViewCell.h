//
//  JAHomePageCollectionViewCell.h
//  JALiveShow
//
//  Created by Jater on 2018/12/16.
//  Copyright © 2018 Jater. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JAHomePageCollectionViewCell : UICollectionViewCell

- (void)configLiveLink:(NSString *)liveLink;

- (void)configCoverImageLink:(NSString *)coverImageLink;

- (void)configNickName:(NSString *)nickName;

- (void)play;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
