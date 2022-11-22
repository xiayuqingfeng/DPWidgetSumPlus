//
//  UIFont+DPCategory.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIFont (DPCategory)
///指定字体库
+ (UIFont *)dp_customFontWithName:(NSString *)fontFileName size:(CGFloat)size;
@end
