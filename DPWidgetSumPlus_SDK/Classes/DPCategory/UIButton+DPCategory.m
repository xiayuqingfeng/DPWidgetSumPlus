//
//  UIButton+DPCategory.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import "UIButton+DPCategory.h"
#import "DPWidgetSumPlus.h"

@implementation UIButton (DPCategory)
- (void)dp_setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
    UIImage *backgroundColorImage = [UIImage dp_imageWithColor:color];
    [self setBackgroundImage:backgroundColorImage forState:state];
}
@end
