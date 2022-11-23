//
//  DPUIBaseTabBarController.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import "DPUIBaseTabBarController.h"
#import "DPWidgetSumPlus.h"

@interface DPUIBaseTabBarController ()

@end

@implementation DPUIBaseTabBarController
#pragma mark <--------------基类函数-------------->
//是否隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return self.selectedViewController.prefersStatusBarHidden;
}
//状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.selectedViewController.preferredStatusBarStyle;
}
//屏幕旋转控制权限传递给当前显示的控制器
- (BOOL)shouldAutorotate{
    return self.selectedViewController.shouldAutorotate;
}
//当前viewcontroller支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.selectedViewController.supportedInterfaceOrientations;
}
//当前viewcontroller默认的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return self.selectedViewController.preferredInterfaceOrientationForPresentation;
}
@end
