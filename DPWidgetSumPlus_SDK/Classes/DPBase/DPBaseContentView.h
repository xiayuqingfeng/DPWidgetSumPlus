//
//  DPBaseContentView.h
//  DPWidgetSumPlusDemo
//
//  Created by yupeng xia on 2021/7/26.
//  Copyright © 2021 yupeng xia. All rights reserved.
//

/*
 模块简介：
 使用DPBaseContentView座位根视图，可以良好的自适应上下导航栏之间的有效显示区域，可以（根据子视图显示范围，高度自适应，可垂直滑动）
 */

#import <UIKit/UIKit.h>

@interface DPBaseContentView : UIScrollView
///根据子视图显示范围，高度自适应，默认值：YES 开启
@property (nonatomic, assign) BOOL isAutomaticHeight;
///点击键盘以外区域关闭键盘，默认值：YES 开启
@property (nonatomic, assign) BOOL shouldResignOnTouchOutside;
///当前键盘显示状态，默认值：NO 隐藏
@property (nonatomic, assign, readonly) BOOL keyboardIsVisible;

+ (DPBaseContentView *)initWithSuperView:(UIView *)aSuperView;
@end
