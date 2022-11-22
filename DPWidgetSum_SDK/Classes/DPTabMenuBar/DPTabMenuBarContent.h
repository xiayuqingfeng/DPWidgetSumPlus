//
//  DPTabMenuBarContent.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DPTabMenuButton.h"

@class DPTabMenuBarContent;

@interface DPTabMenuBarContent : NSObject
///按钮文字修改回调刷新菜单布局事件
@property (nonatomic, copy) void(^aBlock)(DPTabMenuBarContent *aObject);
///当前载体在整体菜单队列中的位置
@property (nonatomic, strong, readonly) NSString *aIndex;
///菜单区域，当前（按钮centerX）距离左边（按钮center）的距离，左边没有按钮为0
@property (nonatomic, strong, readonly) NSString *btnCenterXLGap;
///菜单区域，当前（按钮centerX）距离右边（按钮center）的距离，右边没有按钮为0
@property (nonatomic, strong, readonly) NSString *btnCenterXRGap;

///主显示区域，当前加载 控制器 或 视图
@property (nonatomic, strong) id aVcOrView;
///菜单区域，当前加载 按钮
@property (nonatomic, strong) DPTabMenuButton *btn;
///菜单区域，指定按钮宽度，为-1宽度自适应，默认：-1
@property (nonatomic, assign) CGFloat btnWidth;
///菜单区域，按钮宽度根据文字自适应时，宽度增加值，默认：6
@property (nonatomic, assign) CGFloat btnWidthMax;
///菜单区域，指定按钮默认字体颜色，默认：DP_RGBCOLOR(255, 0, 0)
@property (nonatomic, strong) UIColor *btnNormalColor;
///菜单区域，指定按钮点击字体颜色，默认：DP_RGBCOLOR(255, 0, 0)
@property (nonatomic, strong) UIColor *btnSelectedColor;
///菜单区域，指定按钮默认背景图片
@property (nonatomic, strong) UIImage *btnNormalBackgroundImage;
///菜单区域，指定按钮点击背景图片
@property (nonatomic, strong) UIImage *btnSelectedBackgroundImage;
///菜单区域，按钮默认font，默认 DP_Font(16)
@property (nonatomic, strong) UIFont *btnFont;
///菜单区域，按钮点击font，默认 DP_Font(16)
@property (nonatomic, strong) UIFont *btnSelectFont;
///菜单区域，按钮默认文字
@property (nonatomic, strong) NSString *btnTitle;
///菜单区域，按钮点击文字
@property (nonatomic, strong) NSString *btnSelectTitle;

///菜单区域，按钮标注线颜色，默认：DP_RGBCOLOR(255, 0, 0)
@property (nonatomic, strong) UIColor *tagLineColor;
@end

