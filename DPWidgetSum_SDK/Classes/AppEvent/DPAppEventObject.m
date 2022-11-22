//
//  DPAppEventObject.m
//  DPWidgetSumDemo
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import "DPAppEventObject.h"
#import "DPWidgetSum.h"
#import "DPBaseViewController.h"
#import "DPWebViewController.h"

@implementation DPAppEventObject
+ (void)goIntoVCOrWebForAddress:(nonnull NSString *)aAddress deleteNum:(NSUInteger)aDeleteNum nav:(UINavigationController *_Nullable)aCurrentNav vc:(UIViewController *_Nullable)aCurrentVc block:(void (^_Nullable)(DPBaseViewController * _Nullable pushVc, id _Nullable aData))aBlock {
    if (dp_isNil(aAddress) || aAddress.length < 1) {
        return;
    }

    //查询下发参数是否有效, 调用push事件
    BOOL bol = [DPAppEventObject goIntoVCForAddress:aAddress deleteNum:aDeleteNum nav:aCurrentNav vc:aCurrentVc webView:nil type:GoIntoEnumTypePompareAddress block:nil];
    if (bol == YES) {
        [DPAppEventObject goIntoVCForAddress:aAddress deleteNum:aDeleteNum nav:aCurrentNav vc:aCurrentVc webView:nil type:GoIntoEnumTypePushVC block:nil];
        return;
    }
    
    [DPAppEventObject goIntoWebForAddress:aAddress deleteNum:aDeleteNum nav:aCurrentNav vc:aCurrentVc block:aBlock];
}

#pragma mark <--------------推入页面-------------->
/**
 *  打开浏览器
 *
 *  @param aAddress 网页地址
 *  @param aCurrentNav 当前展示顶层展示NavigationController, 为空时函数获取
 *  @param aCurrentVC 当前展示顶层展示ViewController, 为空时函数获取
 *
 */
+ (void)goIntoWebForAddress:(nonnull NSString *)aAddress deleteNum:(NSUInteger)aDeleteNum nav:(nullable UINavigationController *)aCurrentNav vc:(nullable id)aCurrentVc block:(void (^_Nullable)(DPBaseViewController * _Nullable pushVc, id _Nullable aData))aBlock {
    if (dp_isNil(aAddress) || aAddress.length < 1) {
        return;
    }
    
    if (aCurrentVc == nil || ![aCurrentVc isKindOfClass:[UIViewController class]]) {
        aCurrentVc = [UIViewController dp_topVC];
    }
    
    NSLog(@"\nDPAppEventObject_Web_通用跳转事件:%@",aAddress);
    
    DPWebViewController *vc = [DPWebViewController webViewUrl:dp_notEmptyStr(aAddress) withTitle:nil isDocumentTitle:YES];
    vc.fontController = aCurrentVc;
    if (aBlock) {
        aBlock(vc, nil);
    }
    [UIViewController dp_pushVc:vc superNav:aCurrentNav superVc:aCurrentVc deleteNum:aDeleteNum animated:YES];
}

/**
 *  打开原生界面,根据传入参数address
 *
 *  @param aAddress 判断参数
 *  @param aCurrentNav 当前展示顶层展示NavigationController, 为空时函数获取
 *  @param aCurrentVC 当前展示顶层展示ViewController, 为空时函数获取
 *  @param aCurrentWeb 当前展示顶层展示webview
 *  @param aType: GoIntoEnumType
 *
 *  @return BOOL: 判断address是否有效 或 判断需要打开的页面是否与当前展示控制器相同
 */
+ (BOOL)goIntoVCForAddress:(nonnull NSString *)aAddress deleteNum:(NSUInteger)aDeleteNum nav:(nullable UINavigationController *)aCurrentNav vc:(nullable id)aCurrentVc webView:(nullable id)aCurrentWeb type:(GoIntoEnumType)aType block:(void (^_Nullable)(DPBaseViewController * _Nullable pushVc, id _Nullable aData))aBlock {
    
    if (dp_isNil(aAddress) || aAddress.length < 1) {
        return NO;
    }
    
    if (aCurrentVc == nil || ![aCurrentVc isKindOfClass:[UIViewController class]]) {
        aCurrentVc = [UIViewController dp_topVC];
    }
    
    if (dp_isNil(aCurrentVc)) {
        return NO;
    }
    
    if (aType == GoIntoEnumTypePompareAddress) {
        NSLog(@"\nDPAppEventObject_VC_通用跳转事件_GoIntoEnumTypePompareAdress:%@",aAddress);
    }else if (aType == GoIntoEnumTypePompareVC) {
        NSLog(@"\nDPAppEventObject_VC_通用跳转事件_GoIntoEnumTypePompareVC:%@",aAddress);
    }else if (aType == GoIntoEnumTypePushVC) {
        NSLog(@"\nDPAppEventObject_VC_通用跳转事件_GoIntoEnumTypePushVC:%@",aAddress);
    }else if (aType == GoIntoEnumTypeJGPushVC) {
        NSLog(@"\nDPAppEventObject_VC_通用跳转事件_GoIntoEnumTypeJGPushVC:%@",aAddress);
    }
    
    //************************若是URL，临时去除“控制web”前缀字符串************************/
    NSString *tempAddress = [NSString stringWithFormat:@"%@",aAddress];
    //服务器使用,客户端删除
    if ([tempAddress hasPrefix:shujufenxiHasPrefix]) {
        tempAddress = [tempAddress stringByReplacingOccurrencesOfString:shujufenxiHasPrefix withString:@""];
    }

    //************************isEqualToString 全符串比对函数,push控制器不需要传参************************/
    if ([tempAddress isEqualToString:@"demoTest"]) {
#pragma mark isEqualToString 登录页
        if (aType == GoIntoEnumTypePompareAddress) {
            return YES;
        }else if (aType == GoIntoEnumTypePompareVC) {
            if ([aCurrentVc isKindOfClass:[UIViewController class]]) {
                return YES;
            }
        }else if (aType == GoIntoEnumTypePushVC || aType == GoIntoEnumTypeJGPushVC) {
            DPBaseViewController *vc = [[DPBaseViewController alloc] init];
            if (aBlock) {
                aBlock(vc, nil);
            }
            [UIViewController dp_pushVc:vc superNav:aCurrentNav superVc:aCurrentVc deleteNum:aDeleteNum animated:YES];
        }
    }
    
    //*************hasPrefix 前缀字符串比对,push控制器需要传参*************/
    if ([tempAddress hasPrefix:@"demoTest_"]) {
#pragma mark hasPrefix 未登录状态下跳转登录页
        if (aType == GoIntoEnumTypePompareAddress) {
            return YES;
        }else if (aType == GoIntoEnumTypePompareVC) {
            
        }else if (aType == GoIntoEnumTypePushVC || aType == GoIntoEnumTypeJGPushVC) {
            tempAddress = [tempAddress stringByReplacingOccurrencesOfString:@"weblogin_" withString:@""];
            DPWebViewController *vc = [DPWebViewController webViewUrl:tempAddress withTitle:nil isDocumentTitle:YES];
            if (aBlock) {
                aBlock(vc, nil);
            }
            [UIViewController dp_pushVc:vc superNav:aCurrentNav superVc:aCurrentVc deleteNum:aDeleteNum animated:YES];
        }
    }
    return NO;
}
@end

