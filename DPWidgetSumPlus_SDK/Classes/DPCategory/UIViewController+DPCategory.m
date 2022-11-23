//
//  UIViewController+DPCategory.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import "UIViewController+DPCategory.h"
#import "DPWidgetSumPlus.h"
#import "DPUIBaseNavigationController.h"
#import "DPBaseViewController.h"

@implementation UIViewController (DPCategory)
#pragma mark - 获取APP窗口当前展示的页面
+ (UIViewController *_Nonnull)dp_topVC {
    UIViewController *vc = [[UIApplication sharedApplication] delegate].window.rootViewController;
    UIViewController *topVc = [UIViewController dp_topVCRunTime:vc];
    if (topVc != nil) {
        vc = topVc;
    }
    return vc;
}

#pragma mark - 循环遍历多类型下级控制器
+ (UIViewController *)dp_topVCRunTime:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [UIViewController dp_topVCRunTime:[(UINavigationController *)vc topViewController]];
    }else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [UIViewController dp_topVCRunTime:[(UITabBarController *)vc selectedViewController]];
    }else if (vc.presentedViewController) {
        return vc.presentedViewController;
    }else {
        return vc;
    }
    return nil;
}

#pragma mark - 控制器push、present
//aVc：即将打开的控制器；animated 是否动画进入；
- (void)dp_pushVc:(UIViewController *)aVc animated:(BOOL)animated {
    [UIViewController dp_pushVc:aVc superNav:nil superVc:self deleteNum:0 animated:animated];
}
//aVc：即将打开的控制器；aDeleteNum：打开新的控制器之前需要删除的层级；animated 是否动画进入；
- (void)dp_pushVc:(UIViewController *)aVc deleteNum:(NSUInteger)aDeleteNum animated:(BOOL)animated {
    [UIViewController dp_pushVc:aVc superNav:nil superVc:self deleteNum:aDeleteNum animated:animated];
}
//aVc：即将打开的控制器；aSuperNav：当前响应链；aSuperVc 当前控制器；aDeleteNum：打开新的控制器之前需要删除的层级；animated 是否动画进入；
+ (void)dp_pushVc:(UIViewController *)aVc superNav:(UINavigationController *)aSuperNav superVc:(UIViewController *)aSuperVc deleteNum:(NSUInteger)aDeleteNum animated:(BOOL)animated {
    if (aVc != nil) {
        aVc.hidesBottomBarWhenPushed = YES;
        if (aSuperNav != nil && [aSuperNav isKindOfClass:[UINavigationController class]]) {
            if (aDeleteNum <= 0) {
                //记录fontController
                if ([aVc isKindOfClass:[DPBaseViewController class]] && ((DPBaseViewController *)aVc).fontController == nil) {
                    ((DPBaseViewController *)aVc).fontController = aSuperNav.viewControllers.lastObject;
                }
                //push
                [aSuperNav pushViewController:aVc animated:animated];
            }else {
                NSArray *vcArray = aSuperNav.viewControllers;
                if (aDeleteNum >= vcArray.count) {
                    aDeleteNum = vcArray.count-1;
                }
                vcArray = [vcArray subarrayWithRange:NSMakeRange(0, vcArray.count-aDeleteNum)];
                //记录fontController
                if ([aVc isKindOfClass:[DPBaseViewController class]] && ((DPBaseViewController *)aVc).fontController == nil) {
                    ((DPBaseViewController *)aVc).fontController = vcArray.lastObject;
                }
                vcArray = [vcArray arrayByAddingObject:aVc];
                //push
                [aSuperNav setViewControllers:vcArray animated:animated];
            }
        }else {
            if (aSuperVc != nil) {
                if (aSuperVc.navigationController != nil) {
                    if (aDeleteNum <= 0) {
                        //push
                        [aSuperVc.navigationController pushViewController:aVc animated:animated];
                    }else {
                        NSArray *vcArray = aSuperVc.navigationController.viewControllers;
                        if (aDeleteNum >= vcArray.count) {
                            aDeleteNum = vcArray.count-1;
                        }
                        vcArray = [vcArray subarrayWithRange:NSMakeRange(0, vcArray.count-aDeleteNum)];
                        //记录fontController
                        if ([aVc isKindOfClass:[DPBaseViewController class]] && ((DPBaseViewController *)aVc).fontController == nil) {
                            ((DPBaseViewController *)aVc).fontController = vcArray.lastObject;
                        }
                        vcArray = [vcArray arrayByAddingObject:aVc];
                        //push
                        [aSuperVc.navigationController setViewControllers:vcArray animated:animated];
                    }
                }else {
                    UINavigationController *nav = [[DPUIBaseNavigationController alloc] initWithRootViewController:aVc];
                    nav.navigationBarHidden = YES;
                    //记录fontController
                    if ([aVc isKindOfClass:[DPBaseViewController class]] && ((DPBaseViewController *)aVc).fontController == nil) {
                        ((DPBaseViewController *)aVc).fontController = aSuperVc;
                    }
                    //present
                    nav.modalPresentationStyle = UIModalPresentationFullScreen;
                    [aSuperVc presentViewController:nav animated:animated completion:nil];
                }
            }
        }
    }
}

#pragma mark - 控制器pop、dismiss
//animated 是否动画进入；
- (void)dp_popVcWithAnimated:(BOOL)animated {
    [UIViewController dp_popVc:nil superNav:nil superVc:self num:1 animated:animated];
}
//aNum：返回控制器之前需要删除的层级；animated 是否动画进入；
- (void)dp_popVcWithNum:(NSUInteger)aNum animated:(BOOL)animated {
    [UIViewController dp_popVc:nil superNav:nil superVc:self num:aNum animated:animated];
}
//aVc：即将返回的控制器；animated 是否动画进入；
- (void)dp_popVc:(UIViewController *)aVc animated:(BOOL)animated {
    [UIViewController dp_popVc:aVc superNav:nil superVc:self num:1 animated:animated];
}
//aVc：即将返回的控制器；aSuperNav：当前响应链；aSuperVc 当前控制器；aNum：返回控制器之前需要删除的层级；animated 是否动画进入；
+ (void)dp_popVc:(UIViewController *)aVc superNav:(UINavigationController *)aSuperNav superVc:(UIViewController *)aSuperVc num:(NSUInteger)aNum animated:(BOOL)animated {
    if (aSuperNav == nil) {
        aSuperNav = aSuperVc.navigationController;
    }
    
    if (aSuperNav == nil && aSuperVc == nil) {
        aSuperVc = [UIViewController dp_topVC];
        if ([aSuperVc isKindOfClass:[UIViewController class]]) {
            aSuperNav = aSuperVc.navigationController;
        }else {
            aSuperVc = nil;
        }
    }
    
    if (aVc == nil) {
        if (aNum > 0) {
            if (aSuperNav && aNum < aSuperNav.viewControllers.count) {
                if (aNum == 1) {
                    [aSuperNav popViewControllerAnimated:animated];
                }else {
                    NSArray *vcArray = aSuperNav.viewControllers;
                    if (aNum >= vcArray.count) {
                        aNum = vcArray.count-1;
                    }
                    vcArray = [aSuperNav.viewControllers subarrayWithRange:NSMakeRange(0, aSuperNav.viewControllers.count-aNum)];
                    [aSuperNav setViewControllers:vcArray animated:animated];
                }
            }else if (aSuperVc && aSuperVc.presentingViewController) {
                [aSuperVc dismissViewControllerAnimated:animated completion:nil];
            }
        }
    }else {
        if (aSuperNav) {
            if ([aSuperNav.viewControllers containsObject:aVc]) {
                [aSuperNav popToViewController:aVc animated:animated];
            }else {
                if (aNum < aSuperNav.viewControllers.count) {
                    NSArray *vcArray = [aSuperNav.viewControllers subarrayWithRange:NSMakeRange(0, aSuperNav.viewControllers.count-aNum)];
                    vcArray = [vcArray arrayByAddingObject:aVc];
                    [aSuperNav setViewControllers:vcArray animated:animated];
                }else if (aSuperVc && aSuperVc.presentingViewController) {
                    dp_arc_block(aVc);
                    dp_arc_block(aSuperNav);
                    dp_arc_block(aSuperVc);
                    [aSuperVc dismissViewControllerAnimated:animated completion:^{
                        [UIViewController dp_pushVc:weak_aVc superNav:weak_aSuperNav superVc:weak_aSuperVc deleteNum:0 animated:animated];
                    }];
                }
            }
        }else if (aSuperVc && aSuperVc.presentingViewController) {
            dp_arc_block(aVc);
            dp_arc_block(aSuperNav);
            dp_arc_block(aSuperVc);
            [aSuperVc dismissViewControllerAnimated:animated completion:^{
                [UIViewController dp_pushVc:weak_aVc superNav:weak_aSuperNav superVc:weak_aSuperVc deleteNum:0 animated:animated];
            }];
        }
    }
}

#pragma mark - 返回Window根控制器
+ (void)dp_appPopRootVC {
    UIViewController *vc = [[UIApplication sharedApplication] delegate].window.rootViewController;
    [UIViewController dp_appPopRootVCRunTime:vc];
}

#pragma mark - 根据当前展示控制器，返回根控制器
+ (void)dp_appPopRootVCRunTime:(UIViewController *)vc {
    if (vc.presentedViewController) {
        [vc dismissViewControllerAnimated:NO completion:^{
            [UIViewController dp_appPopRootVCRunTime:[UIViewController dp_topVC]];
        }];
    }else if ([vc isKindOfClass:[UITabBarController class]]) {
        if (vc.tabBarController) {
            [UIViewController dp_appPopRootVCRunTime:vc.tabBarController];
        }else{
            UITabBarController *aTabBarController = (UITabBarController *)vc;
            if (aTabBarController.selectedViewController.navigationController) {
                UINavigationController *aNavigationController = aTabBarController.selectedViewController.navigationController;
                [UIViewController dp_appPopRootVCRunTime:aNavigationController.viewControllers.lastObject];
            }else{
                [UIViewController dp_appPopRootVCRunTime:aTabBarController.selectedViewController];
            }
        }
    }else if ([vc isKindOfClass:[UIViewController class]]) {
        UINavigationController *aNavigationController = (UINavigationController *)vc;
        if (aNavigationController.viewControllers.count > 1) {
            [aNavigationController.viewControllers.lastObject.navigationController popToRootViewControllerAnimated:NO];
        }
    }
}
@end
