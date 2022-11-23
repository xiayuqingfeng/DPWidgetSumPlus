//
//  CustomBannerOrJsEvent.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>

@class DPBaseViewController;
@class DPWebView;

///JS点击事件(h5调oc)Block. 返回BOOL值, 为YES则停止基类中的判断逻辑, 为NO则继续使用基类中的判断逻辑.
typedef BOOL(^CustomBannerOrJsEventBlock)(WKWebView *webView, WVJBResponseCallback responseCallback, NSString *type, NSString *content, NSString *title);

@interface CustomBannerOrJsEvent : NSObject
///JS点击事件(h5调oc)Block
@property (nonatomic, copy) CustomBannerOrJsEventBlock jsBlock;
@property (nonatomic, strong) WebViewJavascriptBridge *webViewJavascriptBridge;

///JS事件
- (void)jsH5:(WKWebView *)webView delegate:(DPWebView *)delegate pushNavigationVC:(UINavigationController *)nav vc:(UIViewController *)vc;
///刷新当前桥接文件拥有的控制器，重定向push根控制器
- (void)updateCurrentViewController:(UIViewController *)aViewController navigationVC:(UINavigationController *)aNavigationVC;
@end
