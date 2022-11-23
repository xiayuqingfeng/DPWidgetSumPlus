//
//  UIViewController+DPCategory.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DPWidgetSumPlus.h"

@interface UIViewController (DPCategory)
#pragma mark - 控制器push、present
///aVc：即将打开的控制器；animated 是否动画进入；
- (void)dp_pushVc:(UIViewController *)aVc animated:(BOOL)animated;
///aVc：即将打开的控制器；aDeleteNum：打开新的控制器之前需要删除的层级；animated 是否动画进入；
- (void)dp_pushVc:(UIViewController *)aVc deleteNum:(NSUInteger)aDeleteNum animated:(BOOL)animated;
///aVc：即将打开的控制器；aSuperNav：当前响应链；aSuperVc 当前控制器；aDeleteNum：打开新的控制器之前需要删除的层级；animated 是否动画进入；
+ (void)dp_pushVc:(UIViewController *)aVc superNav:(UINavigationController *)aSuperNav superVc:(UIViewController *)aSuperVc deleteNum:(NSUInteger)aDeleteNum animated:(BOOL)animated;

#pragma mark - 控制器pop、dismiss
///animated 是否动画进入；
- (void)dp_popVcWithAnimated:(BOOL)animated;
///aNum：返回控制器之前需要删除的层级；animated 是否动画进入；
- (void)dp_popVcWithNum:(NSUInteger)aNum animated:(BOOL)animated;
///aVc：即将返回的控制器；animated 是否动画进入；
- (void)dp_popVc:(UIViewController *)aVc animated:(BOOL)animated;
///aVc：即将返回的控制器；aSuperNav：当前响应链；aSuperVc 当前控制器；aNum：返回控制器之前需要删除的层级；animated 是否动画进入；
+ (void)dp_popVc:(UIViewController *)aVc superNav:(UINavigationController *)aSuperNav superVc:(UIViewController *)aSuperVc num:(NSUInteger)aNum animated:(BOOL)animated;

///获取APP窗口当前展示的页面
+ (UIViewController *)dp_topVC;
///循环遍历多类型下级控制器
+ (UIViewController *)dp_topVCRunTime:(UIViewController *)vc;

///返回Window根控制器
+ (void)dp_appPopRootVC;
///根据当前展示控制器，返回根控制器
+ (void)dp_appPopRootVCRunTime:(UIViewController *)vc;
@end
