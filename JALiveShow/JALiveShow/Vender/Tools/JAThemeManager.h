//
//  JAThemeManager.h
//  JALiveShow
//
//  Created by Jater on 2018/11/26.
//  Copyright © 2018 Jater. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ThemeManager [JAThemeManager shared]

NS_ASSUME_NONNULL_BEGIN

@interface JAThemeManager : NSObject

@property (nonatomic, assign) CGFloat screenWidth;

@property (nonatomic, assign) CGFloat screenHeight;

+ (JAThemeManager *)shared;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end

NS_ASSUME_NONNULL_END
