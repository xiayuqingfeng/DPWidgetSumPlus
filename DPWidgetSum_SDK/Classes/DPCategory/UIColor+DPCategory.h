//
//  UIColor+Extension.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (DPCategory)
///16进制字符串 转 颜色
+ (UIColor *)dp_hexToColor:(NSString *)hexColor;
///颜色 转 16进制字符串
+ (NSString *)dp_hexToString:(UIColor *)hexColor;
///混合颜色 0~1
+ (UIColor *)dp_sectionColor:(UIColor *)aStartColor endColor:(UIColor *)aEndColor ratio:(CGFloat)aRatio;
@end
