//
//  DPTabMenuButton.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DPTabMenuButton : UIButton
+ (DPTabMenuButton *)tabMenuButtonWithType:(UIButtonType)buttonType;
///按钮默认font
@property (nonatomic, strong) UIFont *normalFont;
///按钮点击font
@property (nonatomic, strong) UIFont *selectFont;
///菜单区域，指定按钮默认字体颜色，默认：DP_RGBCOLOR(255, 0, 0)
@property (nonatomic, strong) UIColor *normalColor;
///菜单区域，指定按钮点击字体颜色，默认：DP_RGBCOLOR(255, 0, 0)
@property (nonatomic, strong) UIColor *selectedColor;
@end
