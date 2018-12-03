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
    CGFloat alpha = 0.0, red, blue = 0.0, green = 0.0;
    switch (colorString.length) {
        case 3: //RGB
            alpha = 1;
            red = [self colorComponentWithString:colorString start:0 length:1];
            blue = [self colorComponentWithString:colorString start:1 length:1];
            green = [self colorComponentWithString:colorString start:2 length:1];
            break;
        case 4: //ARGB
            alpha = [self colorComponentWithString:colorString start:0 length:1];
            red = [self colorComponentWithString:colorString start:1 length:1];
            blue = [self colorComponentWithString:colorString start:2 length:1];
            green = [self colorComponentWithString:colorString start:3 length:1];
            break;
        case 6: //RRGGBB
            alpha = 1;
            red = [self colorComponentWithString:colorString start:0 length:2];
            blue = [self colorComponentWithString:colorString start:2 length:2];
            green = [self colorComponentWithString:colorString start:4 length:2];
            break;
        case 8: //AARRGGBB
            alpha = [self colorComponentWithString:colorString start:0 length:1];
            red = [self colorComponentWithString:colorString start:1 length:1];
            blue = [self colorComponentWithString:colorString start:2 length:1];
            green = [self colorComponentWithString:colorString start:3 length:1];
            break;
        default:
            return UIColor.redColor;
            break;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGFloat)colorComponentWithString:(NSString *)string start:(NSInteger)start length:(NSInteger)length {
    NSString *subString = [string substringWithRange:NSMakeRange(start, length)];
    unsigned int hexInt;
    [[NSScanner scannerWithString:subString] scanHexInt:&hexInt];
    return hexInt/255.0f;
}

@end
