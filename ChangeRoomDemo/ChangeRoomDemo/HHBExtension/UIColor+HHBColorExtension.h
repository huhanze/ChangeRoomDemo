//
//  UIColor+HHBColorExtension.h
//  HHBKit
//  UIColor扩展
//  Created by DylanHu on 2017/10/18.
//  Copyright © 2017年 DylanHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HHBColorExtension)

/**
   根据十六进制色值转换对应的UIColor

 @param colorString 色值
 @return UIColor对象
 */
+ (UIColor *)hb_colorFromHexRGB:(NSString *)colorString;

/**
  获取随机颜色

 @return UIColor对象
 */
+ (UIColor *)hb_randomColor;

/**
  获取rgb状态下的颜色

 @param rgb rgb值
 @return UIColor对象
 */
+ (UIColor *)hb_colorWithRGB:(NSString* )rgb;

@end
