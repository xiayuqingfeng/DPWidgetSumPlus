//
//  DPAppEventObject.h
//  DPWidgetSumDemo
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPBaseViewController.h"

typedef NS_ENUM(NSUInteger, GoIntoEnumType) {
    ///判断address是否有效
    GoIntoEnumTypePompareAddress,
    ///根据address判断需要打开的页面是否与当前展示控制器相同
    GoIntoEnumTypePompareVC,
    ///根据address打开控制器,通用事件调用,直接打开新界面
    GoIntoEnumTypePushVC,
    ///根据address打开控制器,JPush事件调用,判断若是当前页,直接在当前页刷新(比如：指定菜单位置)
    GoIntoEnumTypeJGPushVC
};

@interface DPAppEventObject : NSObject
/**
 *  打开原生界面 或 浏览器
 *
 *  @param aAddress 原生界面判断参数 或 浏览器网页地址
 *  @param aDeleteNum 打开新的控制器之前需要删除的层级
 *  @param aCurrentNav 当前展示顶层展示NavigationController, 为空时函数获取
 *  @param aCurrentVC 当前展示顶层展示ViewController, 为空时函数获取
 *  @param aBlock pushVc 将要进入的控制器，aData 扩展参数
 *
*/
+ (void)goIntoVCOrWebForAddress:(nonnull NSString *)aAddress deleteNum:(NSUInteger)aDeleteNum nav:(UINavigationController *_Nullable)aCurrentNav vc:(UIViewController *_Nullable)aCurrentVc block:(void (^_Nullable)(DPBaseViewController * _Nullable pushVc, id _Nullable aData))aBlock;

/**
 *  打开浏览器
 *
 *  @param aAddress 网页地址
 *  @param aDeleteNum 打开新的控制器之前需要删除的层级
 *  @param aCurrentNav 当前展示顶层展示NavigationController, 为空时函数获取
 *  @param aCurrentVC 当前展示顶层展示ViewController, 为空时函数获取
 *  @param aBlock: pushVc 将要进入的控制器，aData 扩展参数
 *
*/
+ (void)goIntoWebForAddress:(nonnull NSString *)aAddress deleteNum:(NSUInteger)aDeleteNum nav:(nullable UINavigationController *)aCurrentNav vc:(nullable id)aCurrentVc block:(void (^_Nullable)(DPBaseViewController * _Nullable pushVc, id _Nullable aData))aBlock;

/**
 *  打开原生界面
 *
 *  @param aAddress 判断参数
 *  @param aDeleteNum 打开新的控制器之前需要删除的层级
 *  @param aCurrentNav 当前展示顶层展示NavigationController, 为空时函数获取
 *  @param aCurrentVC 当前展示顶层展示ViewController, 为空时函数获取
 *  @param aCurrentWeb 当前展示顶层展示webview
 *  @param aType GoIntoEnumType
 *  @param aBlock pushVc 将要进入的控制器，aData 扩展参数
 *
 *  @return BOOL 判断address是否有效 或 判断需要打开的页面是否与当前展示控制器相同
 */
+ (BOOL)goIntoVCForAddress:(nonnull NSString *)aAddress deleteNum:(NSUInteger)aDeleteNum nav:(nullable UINavigationController *)aCurrentNav vc:(nullable id)aCurrentVc webView:(nullable id)aCurrentWeb type:(GoIntoEnumType)aType block:(void (^_Nullable)(DPBaseViewController * _Nullable pushVc, id _Nullable aData))aBlock;
@end
