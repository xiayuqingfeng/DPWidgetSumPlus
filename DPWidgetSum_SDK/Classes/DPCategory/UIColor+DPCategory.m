//
//  UIColor+Extension.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import "UIColor+DPCategory.h"
#import "DPWidgetSum.h"

@implementation UIColor (DPCategory)
///16进制字符串 转 颜色
+ (UIColor *)dp_hexToColor:(NSString *)hexColor {
    UIColor *aColor = nil;
    
    NSString *hex = [NSString stringWithString:hexColor];
    if ([hex hasPrefix:@"#"]) {
        hex = [hex substringFromIndex:1];
    }
    
    if (hex.length == 6) {
        hex = [hex stringByAppendingString:@"FF"];
    }
    if (hex.length == 6 || hex.length == 8) {
        unsigned int alpha, red, green, blue;
        NSRange range;
        range.length = 2;
        
        range.location = 0;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&alpha];
        range.location = 2;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
        range.location = 4;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
        range.location = 6;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
        
        aColor = [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:(float)(alpha/255.0f)];
    }
    
    if (aColor == nil) {
        aColor = [UIColor blackColor];
    }
    return aColor;
}

///颜色 转 16进制字符串
+ (NSString *)dp_hexToString:(UIColor *)hexColor {
    NSString *aString = nil;
    if (CGColorSpaceGetModel(CGColorGetColorSpace(hexColor.CGColor)) != kCGColorSpaceModelRGB) {
        if ([hexColor isEqual:[UIColor clearColor]]) {
            aString = @"#00000000";
        } else if ([hexColor isEqual:[UIColor whiteColor]]){
            aString = @"#FFFFFFFF";
        } else if ([hexColor isEqual:[UIColor blackColor]]){
            aString = @"#FF000000";
        } else {
            aString = @"#FF000000";
        }
    }else {
        if (CGColorGetNumberOfComponents(hexColor.CGColor) == 3) {
            const CGFloat *components = CGColorGetComponents(hexColor.CGColor);
            CGFloat r = components[0];
            CGFloat g = components[1];
            CGFloat b = components[2];
            aString = [NSString stringWithFormat:@"#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255)];
        }else {
            const CGFloat *components = CGColorGetComponents(hexColor.CGColor);
            CGFloat r = components[0];
            CGFloat g = components[1];
            CGFloat b = components[2];
            CGFloat a = components[3];
            if (a == 1) {
                aString = [NSString stringWithFormat:@"#FF%02lX%02lX%02lX",
                        lroundf(r * 255),
                        lroundf(g * 255),
                        lroundf(b * 255)] ;
            }else {
                aString = [NSString stringWithFormat:@"#%02lX%02lX%02lX%02lX",
                        lroundf(r * 255),
                        lroundf(g * 255),
                        lroundf(b * 255),
                        lroundf(a * 255)];
            }
        }
    }
    
    if (aString == nil || aString.length < 1) {
        aString = @"#FF000000";
    }
    return aString;
}

///混合颜色 0~1
+ (UIColor *)dp_sectionColor:(UIColor *)aStartColor endColor:(UIColor *)aEndColor ratio:(CGFloat)aRatio {
    if(aRatio > 1) {
        aRatio = 1;
    }else if(aRatio < 0) {
        aRatio = 0;
    }
    const CGFloat *componentsStart = CGColorGetComponents(aStartColor.CGColor);
    const CGFloat *componentsEnd = CGColorGetComponents(aEndColor.CGColor);
    CGFloat r = componentsStart[0]*aRatio + componentsEnd[0]*(1-aRatio);
    CGFloat g = componentsStart[1]*aRatio + componentsEnd[1]*(1-aRatio);
    CGFloat b = componentsStart[2]*aRatio + componentsEnd[2]*(1-aRatio);
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}
@end
