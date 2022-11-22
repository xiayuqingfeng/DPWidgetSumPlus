//
//  DPUIBaseNavigationController.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import "DPUIBaseNavigationController.h"
#import "DPWidgetSum.h"
#import "DPBaseViewController.h"

@interface DPUIBaseNavigationController ()

@end

@implementation DPUIBaseNavigationController
#pragma mark <--------------基类函数-------------->
//是否隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return self.topViewController.prefersStatusBarHidden;
}
//状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.topViewController.preferredStatusBarStyle;
}
//屏幕旋转控制权限传递给当前显示的控制器
- (BOOL)shouldAutorotate{
    return self.topViewController.shouldAutorotate;
}
//当前viewcontroller支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.topViewController.supportedInterfaceOrientations;
}
//当前viewcontroller支持哪些转屏方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    DPUIBaseViewController *currentVc = [self.viewControllers lastObject];
    DPUIBaseViewController *pushVc = (DPUIBaseViewController *)viewController;
    [self dp_interfaceOrientationForCurrentVC:currentVc pushVC:pushVc];
    [super pushViewController:viewController animated:animated];
}
- (void)dp_setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated{
    if (![[self.viewControllers lastObject] isEqual:[viewControllers lastObject]]) {
        DPUIBaseViewController *currentVc = [self.viewControllers lastObject];
        if ([self.viewControllers containsObject:[viewControllers lastObject]]) {
            DPUIBaseViewController *popVc = [viewControllers lastObject];
            [self dp_interfaceOrientationForCurrentVC:currentVc popVC:popVc];
        }else{
            DPUIBaseViewController *pushVc = [viewControllers lastObject];
            [self dp_interfaceOrientationForCurrentVC:currentVc pushVC:pushVc];
        }
    }
    [super setViewControllers:viewControllers animated:animated];
}

- (UIViewController *)dp_popViewControllerAnimated:(BOOL)animated{
    DPUIBaseViewController *currentVc = [self.viewControllers lastObject];
    DPUIBaseViewController *popVc = [self.viewControllers dp_objectAtIndex:self.viewControllers.count-2];
    [self dp_interfaceOrientationForCurrentVC:currentVc popVC:popVc];
    return [super popViewControllerAnimated:animated];
}
- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    DPUIBaseViewController *currentVc = [self.viewControllers lastObject];
    DPUIBaseViewController *popVc = [self.viewControllers firstObject];
    [self dp_interfaceOrientationForCurrentVC:currentVc popVC:popVc];
    //ios14 (pop……animated:YES 函数) tabBar 消失，错误兼容
    if (animated) {
        UIViewController *popController = self.viewControllers.lastObject;
        popController.hidesBottomBarWhenPushed = NO;
    }
    return [super popToRootViewControllerAnimated:animated];
}
- (NSArray<UIViewController *> *)dp_popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    DPUIBaseViewController *currentVc = (DPUIBaseViewController*)viewController;
    DPUIBaseViewController *popVc = (DPUIBaseViewController *)viewController;
    [self dp_interfaceOrientationForCurrentVC:currentVc popVC:popVc];
    //ios14 (pop……animated:YES 函数) tabBar 消失，错误兼容
    if (animated && [viewController isEqual:self.viewControllers.firstObject]) {
        UIViewController *popController = self.viewControllers.lastObject;
        popController.hidesBottomBarWhenPushed = NO;
    }
    return [super popToViewController:viewController animated:animated];
}

- (void)dp_interfaceOrientationForCurrentVC:(DPUIBaseViewController *)aCurrentVC pushVC:(DPUIBaseViewController *)aPushVC{
    if ([aCurrentVC isKindOfClass:[DPUIBaseViewController class]]) {
        aCurrentVC.disappearPresentationBase = [UIApplication sharedApplication].statusBarOrientation;
        if ([aPushVC isKindOfClass:[DPUIBaseViewController class]]) {
            if (aPushVC.defaultPresentationBase != [UIApplication sharedApplication].statusBarOrientation) {
                [aCurrentVC tempMandatoryRotationWithOrientation:aPushVC.defaultPresentationBase];
            }
        }else{
            if (aCurrentVC.disappearPresentationBase != UIInterfaceOrientationPortrait) {
                [aCurrentVC tempMandatoryRotationWithOrientation:UIInterfaceOrientationPortrait];
            }
        }
    }
}
- (void)dp_interfaceOrientationForCurrentVC:(DPUIBaseViewController *)aCurrentVC popVC:(DPUIBaseViewController *)aPopVC{
    if ([aCurrentVC isKindOfClass:[DPUIBaseViewController class]]) {
        if ([aPopVC isKindOfClass:[DPUIBaseViewController class]]) {
            if (aPopVC.disappearPresentationBase != [UIApplication sharedApplication].statusBarOrientation) {
                [aCurrentVC tempMandatoryRotationWithOrientation:aPopVC.disappearPresentationBase];
            }
        }else{
            if (aCurrentVC.disappearPresentationBase != UIInterfaceOrientationPortrait) {
                [aCurrentVC tempMandatoryRotationWithOrientation:UIInterfaceOrientationPortrait];
            }
        }
    }
}
@end
