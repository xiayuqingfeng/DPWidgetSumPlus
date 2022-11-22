//
//  DPUIBaseViewController.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPUIBaseViewController : UIViewController
///是否隐藏状态栏, 默认值：NO 不隐藏；（警告：当前值必须在init函数中设置；iOS13横屏时会自动隐藏状态栏；）
@property (nonatomic, assign) BOOL statusBarHiddenBase;
///当前状态栏样式, 默认值：UIStatusBarStyleDefault
@property (nonatomic, assign) UIStatusBarStyle superStatusBarStyle;
///当前viewcontroller是否支持转屏, 默认值：NO 不支持转屏; （警告：当前值必须在init函数中设置）
@property (nonatomic, assign) BOOL isAutorotateBase;
///当前viewcontroller支持哪些转屏方向, isAutorotateBase 优先级大于当前参数; （警告：当前值必须在init函数中设置； 当前App屏幕旋转, 只支持向上、向左、向右三个方向；）
@property (nonatomic, assign) UIInterfaceOrientationMask supportedInterfaceOrientationsBase;
///当前viewcontroller默认的屏幕方向, isAutorotateBase、supportedInterfaceOrientationsBase 优先级大于当前参数;  （警告：当前值必须在init函数中设置；当前App屏幕旋转, 只支持向上、向左、向右三个方向；）
@property (nonatomic, assign) UIInterfaceOrientation defaultPresentationBase;
///当前viewcontroller消失时屏幕方向标记；（警告：支持转屏、手动转屏都需要标记）
@property (nonatomic, assign) UIInterfaceOrientation disappearPresentationBase;

///手动旋转屏幕，并设置屏幕旋转权限。(警告：当前App屏幕旋转，只支持向上、向左、向右三个方向)
- (void)mandatoryRotationWithIsAutorotateBase:(BOOL)aIsAutorotateBase supportedInterfaceOrientationsBase:(UIInterfaceOrientationMask)aSupportedInterfaceOrientationsBase orientation:(UIInterfaceOrientation)aOrientation;
///push或pop动作时，屏幕提前旋转为即将进入界面的方向。旋转开始时，屏幕旋转权限设置全开。旋转结束时，屏幕旋转权限设置恢复。（警告：当前App屏幕旋转，只支持向上、向左、向右三个方向）
- (void)tempMandatoryRotationWithOrientation:(UIInterfaceOrientation)aOrientation;
@end
