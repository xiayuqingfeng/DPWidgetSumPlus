//
//  DPTabMenuBarAttribute.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DPTabMenuBarAttribute : NSObject
///主线显示区域内容加载方式，0 显示时加载当前内容（节省资源），1 预先全部加载所有内容，默认 0
@property (nonatomic, assign) NSInteger loadType;
///菜单列数
@property (nonatomic, assign) NSInteger count;
///菜单按钮显示类型：0 按钮水平一排，1 按钮表格排列，默认 0
@property (nonatomic, assign) NSInteger menuStyle;

///菜单背景颜色，默认：DP_RGBA(255, 255, 255, 1)
@property (nonatomic, strong) UIColor *topBGColor;
///菜单居上间隙，默认：0
@property (nonatomic, assign) float topTGap;
///菜单按钮高度，默认：40
@property (nonatomic, assign) float topHeight;
///菜单左右边界间隙，默认：0
@property (nonatomic, assign) float topLRGap;

///按钮间隙，为-1不使用，间隙等分，默认：1
@property (nonatomic, assign) float btnLRGap;

///菜单区域，按钮标注线圆角比值，以高度为基础父值，最大值1，最小值0，默认：0
@property (nonatomic, assign) CGFloat tagLineRadius;
///菜单区域，按钮标注线宽度，默认：0 使用按钮宽度 + tagLineWidthMax 按钮标注线宽度增加值
@property (nonatomic, assign) float tagLineWidth;
///菜单区域，按钮标注线宽度增加值，默认：按钮宽度
@property (nonatomic, assign) float tagLineWidthMax;
///菜单区域，按钮标注线高度，默认：2
@property (nonatomic, assign) float tagLineHeight;

///底部分割线高度，默认：0.5
@property (nonatomic, assign) float gapLineHeight;
///底部分割线颜色，默认：DP_RGBCOLOR(200, 199, 204)
@property (nonatomic, strong) UIColor *gapLineColor;

///主内容背景颜色，默认：DP_RGBA(255, 255, 255, 0)
@property (nonatomic, strong) UIColor *bottomBGColor;
@end
