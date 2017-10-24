//
//  UIColor+HHBColorExtension.m
//  HHBKit
//  UIColor扩展
//  Created by DylanHu on 2017/10/18.
//  Copyright © 2017年 DylanHu. All rights reserved.
//

#import "UIColor+HHBColorExtension.h"

@implementation UIColor (HHBColorExtension)

/*
 通过16进制计算颜色
 */
+ (UIColor *)hb_colorFromHexRGB:(NSString *)colorString {
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != colorString) {
        NSScanner *scanner = [NSScanner scannerWithString:colorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

+ (UIColor *)hb_randomColor {
    int R = (arc4random() % 256) ;
    int G = (arc4random() % 256) ;
    int B = (arc4random() % 256) ;
    return [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:1.0];
}

+ (UIColor *)hb_colorWithRGB:(NSString *)rgb {
    if ([rgb rangeOfString:@"#"].location != NSNotFound) {
        return [UIColor hb_colorWithHtmlColor:rgb];
    }
    
    NSArray *arr = [rgb componentsSeparatedByString:@","];
    if (arr.count!=3) return [UIColor clearColor];
    
    return [UIColor colorWithRed:[[arr objectAtIndex:0] floatValue]/255.
                           green:[[arr objectAtIndex:1] floatValue]/255.
                            blue:[[arr objectAtIndex:2] floatValue]/255.
                           alpha:1.];
}

+ (UIColor *)hb_colorWithHtmlColor:(NSString *)htmlColor {
    if (!htmlColor) return [UIColor clearColor];
    unsigned int rr, gg, bb;
    @autoreleasepool {
        NSString *r, *g, *b;
        if ([htmlColor hasPrefix:@"#"] && htmlColor.length==4) {
            r = [htmlColor substringWithRange:NSMakeRange(1, 1)];
            g = [htmlColor substringWithRange:NSMakeRange(2, 1)];
            b = [htmlColor substringWithRange:NSMakeRange(3, 1)];
        } else if (![htmlColor hasPrefix:@"#"] && htmlColor.length==3) {
            r = [htmlColor substringWithRange:NSMakeRange(0, 1)];
            g = [htmlColor substringWithRange:NSMakeRange(1, 1)];
            b = [htmlColor substringWithRange:NSMakeRange(2, 1)];
        } else if ([htmlColor hasPrefix:@"#"] && htmlColor.length==7) {
            r = [htmlColor substringWithRange:NSMakeRange(1, 2)];
            g = [htmlColor substringWithRange:NSMakeRange(3, 2)];
            b = [htmlColor substringWithRange:NSMakeRange(5, 2)];
        } else if (![htmlColor hasPrefix:@"#"] && htmlColor.length==6) {
            r = [htmlColor substringWithRange:NSMakeRange(0, 2)];
            g = [htmlColor substringWithRange:NSMakeRange(2, 2)];
            b = [htmlColor substringWithRange:NSMakeRange(4, 2)];
        }
        [[NSScanner scannerWithString:r] scanHexInt:&rr];
        [[NSScanner scannerWithString:g] scanHexInt:&gg];
        [[NSScanner scannerWithString:b] scanHexInt:&bb];
    }
    return [UIColor colorWithRed:rr/255. green:gg/255. blue:bb/255. alpha:1.0f];
}

@end
