//
//  DPAlertLoadingView.h
//  DPWidgetSumDemo
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
///刷新停留时间
#define DPAlertLoadingViewStayTime 0.5

@interface DPAlertLoadingView : UIView
+ (void)showAlertLoadingViewToView:(UIView *)view;
+ (void)showAlertLoadingViewToView:(UIView *)view rect:(CGRect)rect;
+ (void)showAlertLoadingViewToView:(UIView *)view rect:(CGRect)rect message:(NSString *)message;
+ (void)showAlertLoadingViewToView:(UIView *)view message:(NSString *)message;

///类方法自动隐藏并移除
+ (void)hideAllAlertLoadingViewAtView:(UIView *)view;
@end
