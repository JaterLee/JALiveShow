//
//  JAThemeManager.m
//  JALiveShow
//
//  Created by Jater on 2018/11/26.
//  Copyright © 2018 Jater. All rights reserved.
//

#import "JAThemeManager.h"

@implementation JAThemeManager

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    NSString *colorString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    CGFloat alpha, red, blue, green;
    switch (colorString.length) {
        case 3: //RGB
            alpha = 1;
            
            break;
            
        default:
            break;
    }
}

- (CGFloat)colorComponent

@end
