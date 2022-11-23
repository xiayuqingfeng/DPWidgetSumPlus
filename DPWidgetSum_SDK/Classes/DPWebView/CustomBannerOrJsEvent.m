//
//  CustomBannerOrJsEvent.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import "CustomBannerOrJsEvent.h"
#import "DPWidgetSum.h"
#import "SBJson5.h"
#import "DPAppEventObject.h"
#import "AFNetworking.h"

#import "DPBaseViewController.h"
#import "DPWebViewController.h"

@interface CustomBannerOrJsEvent (){
    
}
@property (nonatomic, weak) WKWebView *tempWebView;
@property (nonatomic, weak) UINavigationController *tempNav;
@property (nonatomic, weak) UIViewController *tempBaseVc;

@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareContent;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *imageData;
@property (nonatomic, strong) NSString *shareType;
@property (nonatomic, strong) NSString *moreSelectType;
@end
@implementation CustomBannerOrJsEvent
- (void)dealloc {
    if (self.webViewJavascriptBridge) {
        [self.webViewJavascriptBridge removeHandler:@"zhcwclientCallBack"];
    }
    if (self.jsBlock) {
        self.jsBlock = nil;
    }
}

#pragma mark <--------------自定义JS点击事件-------------->
- (void)jsH5:(WKWebView *)webView delegate:(DPWebView *)delegate pushNavigationVC:(UINavigationController *)nav vc:(UIViewController *)vc{
    if (webView == nil) {
        return;
    }
    
    self.tempWebView = webView;
    self.tempNav = nav;
    self.tempBaseVc = vc;
    
#ifdef DEBUG
    [WebViewJavascriptBridge enableLogging];
#endif
    
    self.webViewJavascriptBridge = nil;
    self.webViewJavascriptBridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [_webViewJavascriptBridge setWebViewDelegate:delegate];
    //避免循环引用
    dp_arc_block(self);
    [_webViewJavascriptBridge registerHandler:@"zhcwclientCallBack" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weak_self jsEvenWithData:data responseCallback:responseCallback];
    }];
}
- (void)jsEvenWithData:(id)data responseCallback:(WVJBResponseCallback)aResponseCallback{
    __block NSDictionary *jsondic = nil;
    SBJson5Parser *parser = [SBJson5Parser parserWithBlock:^(id item, BOOL *stop) {
        if ([item isKindOfClass:[NSDictionary class]]) {
            jsondic = (NSDictionary*)item;
        }
    } errorHandler:^(NSError *error) {
        NSLog(@"SBJson5Parser_error:%@", error);
    }];
    NSString *aStr = [NSString stringWithFormat:@"%@",[data objectForKey:@"content"]];
    NSData *parserData = [aStr dataUsingEncoding:NSUTF8StringEncoding];
    [parser parse:parserData];

    NSString *title = [jsondic dp_stringForKey:@"title"];
    NSString *type = [jsondic dp_stringForKey:@"type"];
    NSString *content = [jsondic dp_stringForKey:@"content"];
    
    if (type.length < 1 && content.length < 1) {
        return;
    }
    if (jsondic) {
         NSLog(@"jsEven:%@",jsondic);
    }
   
    //JS点击事件(h5调oc)Block. 返回BOOL值, 为YES则停止基类中的判断逻辑, 为NO则继续使用基类中的判断逻辑.
    if (self.jsBlock) {
        BOOL isReturn = self.jsBlock(_tempWebView, aResponseCallback, type, content, title);
        if (isReturn) {
            return;
        }
    }
    
    //服务器使用,客户端删除
    if ([type hasPrefix:shujufenxiHasPrefix]) {
        type = [type stringByReplacingOccurrencesOfString:shujufenxiHasPrefix withString:@""];
    }
    if ([content hasPrefix:shujufenxiHasPrefix]) {
        content = [content stringByReplacingOccurrencesOfString:shujufenxiHasPrefix withString:@""];
    }
    
    //查询下发参数是否有效, 调用push事件
    BOOL bol = [DPAppEventObject goIntoVCForAddress:type deleteNum:0 nav:_tempNav vc:_tempBaseVc webView:_tempWebView type:GoIntoEnumTypePompareAddress block:nil];
    if (bol == YES) {
        [DPAppEventObject goIntoVCForAddress:type deleteNum:0 nav:_tempNav vc:_tempBaseVc webView:_tempWebView type:GoIntoEnumTypePushVC block:nil];
        return;
    }
    bol = [DPAppEventObject goIntoVCForAddress:content deleteNum:0 nav:_tempNav vc:_tempBaseVc webView:_tempWebView type:GoIntoEnumTypePompareAddress block:nil];
    if (bol == YES) {
        [DPAppEventObject goIntoVCForAddress:content deleteNum:0 nav:_tempNav vc:_tempBaseVc webView:_tempWebView type:GoIntoEnumTypePushVC block:nil];
        return;
    }

    dp_arc_block(self);
    if ([type isEqualToString:@"close"]) {
        //返回当前根控制器
        if ([_tempBaseVc isKindOfClass:[UIViewController class]]){
            [_tempBaseVc.navigationController popToRootViewControllerAnimated:YES];
        }
    } else if ([type isEqualToString:@"token"]) {
        //返回当前根控制器
        __block NSDictionary *jsondicOne = nil;
        SBJson5Parser *parserOne = [SBJson5Parser parserWithBlock:^(id item, BOOL *stop) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                jsondicOne = (NSDictionary*)item;
            }
        } errorHandler:^(NSError *error) {
            NSLog(@"SBJson5Parser_error:%@", error);
        }];
        NSData *parserData = [content dataUsingEncoding:NSUTF8StringEncoding];
        [parserOne parse:parserData];
        
        [_tempBaseVc.navigationController dismissModalViewControllerAnimated:YES];
    }
    return;
    
    if ([type isEqualToString:@"native"]) {
        if ([content isEqualToString:@"webclose"]) {
            //关闭web页面
            if ([_tempBaseVc isKindOfClass:[UIViewController class]]){
                [UIViewController dp_popVc:nil superNav:_tempNav superVc:_tempBaseVc num:1 animated:YES];
            }else if([_tempWebView isKindOfClass:[WKWebView class]]) {
                [(WKWebView *)_tempWebView removeFromSuperview];
            }
        }else if ([content isEqualToString:@"webRootClose"]) {
            //返回当前根控制器
            if ([_tempBaseVc isKindOfClass:[UIViewController class]]){
                [_tempBaseVc.navigationController popToRootViewControllerAnimated:YES];
            }
        }else if ([content isEqualToString:@"webrefresh"]) {
            //页面强制刷新
            if ([_tempBaseVc isKindOfClass:[DPWebViewController class]]) {
                DPWebViewController * my = (DPWebViewController *)_tempBaseVc;
                [my.currentWebView reload];
            }else if([_tempWebView isKindOfClass:[WKWebView class]]) {
                [(WKWebView *)_tempWebView reload];
            }
        }else if ([content isEqualToString:@"refreshDelay"]) {
            //延迟刷新
            dp_arc_block(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([weak_self.tempBaseVc isKindOfClass:[DPWebViewController class]]) {
                    DPWebViewController * my = (DPWebViewController *)weak_self.tempBaseVc;
                    [my.currentWebView reload];
                }else if([weak_self.tempWebView isKindOfClass:[WKWebView class]]) {
                    [(WKWebView *)weak_self.tempWebView reload];
                }
            });
        }else if ([content isEqualToString:@"clearCache"]) {
            //清理webview缓存
            [DPWebView clearCacheForType:0 hostArray:nil successBlock:nil];
        }else if ([content isEqualToString:@"webloadfinish"]) {
            //页面资源加载完成
            if ([_tempWebView isKindOfClass:[DPWebView class]]) {
                ((DPWebView *)_tempWebView).webloadfinish = YES;
            }
        }else if ([content isEqualToString:@"webgoback"]) {
            //返回上级
            if ([_tempBaseVc isKindOfClass:[DPWebViewController class]]) {
                DPWebViewController * my = (DPWebViewController *)_tempBaseVc;
                [my leftBackBtnAction:nil];
            }else if([_tempWebView isKindOfClass:[WKWebView class]]) {
                [(WKWebView *)_tempWebView goBack];
            }
        }else if ([content isEqualToString:@"longPressOpen"]){
            //长按打开
            if ([_tempBaseVc isKindOfClass:[DPWebViewController class]]) {
                DPWebViewController * my = (DPWebViewController * )_tempBaseVc;
                [my longPressSwitch:NO];
            }
        }else if ([content isEqualToString:@"longPressBan"]){
            //长按禁止
            if ([_tempBaseVc isKindOfClass:[DPWebViewController class]]) {
                DPWebViewController * my = (DPWebViewController * )_tempBaseVc;
                [my longPressSwitch:YES];
            }
        }else if ([content isEqualToString:@"screenRotate"]) {
            //强制旋转屏幕
            if ([_tempBaseVc isKindOfClass:[DPBaseViewController class]]) {
                NSArray *array = [content componentsSeparatedByString:@"$"];
                NSString *type = dp_notEmptyStr([array dp_objectAtIndex:1]);
                if ([type isEqualToString:@"0"]) {
                    [(DPBaseViewController *)_tempBaseVc mandatoryRotationWithIsAutorotateBase:YES supportedInterfaceOrientationsBase:UIInterfaceOrientationMaskPortraitUpsideDown orientation:UIInterfaceOrientationPortrait];
                }else if ([type isEqualToString:@"1"]){
                    [(DPBaseViewController *)_tempBaseVc mandatoryRotationWithIsAutorotateBase:YES supportedInterfaceOrientationsBase:UIInterfaceOrientationMaskPortraitUpsideDown orientation:UIInterfaceOrientationLandscapeRight];
                }
            }
        }else if ([content isEqualToString:@"get_version"]) {
            //获取客户端版本
            NSString* javascriptCommand = [NSString stringWithFormat:@"zhcw_get_version('%@')",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
            [_tempWebView evaluateJavaScript:javascriptCommand completionHandler:nil];
        }else {
            [self jsEvenWithDataExtensionFunctionWithType:type content:content];
        }
    }else if ([type isEqualToString:@"zcwOpenURLScheme"]) {
        //URLScheme唤起APP
        if([[UIApplication sharedApplication] canOpenURL:[NSURL dp_urlEncodedString:content]]) {
            [UIApplication dp_openURL:[NSURL dp_urlEncodedString:content] options:@{} completionHandler:nil];
        }
    }else if ([type isEqualToString:@"share"]) {
        //分享
        NSArray *array = [content componentsSeparatedByString:@"$"];
        self.shareTitle = dp_notEmptyStr([array dp_objectAtIndex:0]);
        self.shareContent = dp_notEmptyStr([array dp_objectAtIndex:1]);
        self.shareUrl = dp_notEmptyStr([array dp_objectAtIndex:2]);
        self.imageUrl = dp_notEmptyStr([array dp_objectAtIndex:3]);
        self.shareType = dp_notEmptyStr([array dp_objectAtIndex:4]);
        self.moreSelectType = dp_notEmptyStr([array dp_objectAtIndex:5]);
        self.imageData = dp_notEmptyStr([array dp_objectAtIndex:6]);
    }else if ([type isEqualToString:@"getNetwork"]) {
        //获取手机网络环境
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSString *statusStr = @"3";
            if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
                statusStr = @"0";
            }else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
                statusStr = @"1";
            }else if (status == AFNetworkReachabilityStatusNotReachable) {
                statusStr = @"2";
            }else if (status == AFNetworkReachabilityStatusUnknown) {
                statusStr = @"3";
            }
            NSString *javascriptCommand = [NSString stringWithFormat:@"zhcw_get_network('%@')",statusStr];
            [weak_self.tempWebView evaluateJavaScript:javascriptCommand completionHandler:nil];
        }];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }else if ([type isEqualToString:@"web"] || [type isEqualToString:@"webwindow"] || [type isEqualToString:@"webRotate"] || [type isEqualToString:@"webwindowRotate"]){
        content = [NSString stringWithFormat:@"%@_%@",type,content];
        DPWebViewController *vc = [DPWebViewController webViewUrl:content withTitle:dp_notEmptyStr(title) isDocumentTitle:YES];
        [UIViewController dp_pushVc:vc superNav:_tempNav superVc:_tempBaseVc deleteNum:0 animated:YES];
    }else {
        [self jsEvenWithDataExtensionFunctionWithType:type content:content];
    }
}

///刷新当前桥接文件拥有的控制器，重定向push根控制器
- (void)updateCurrentViewController:(UIViewController *)aViewController navigationVC:(UINavigationController *)aNavigationVC{
    if (aViewController) {
        self.tempBaseVc = (DPBaseViewController *)aViewController;
    }
    if (aNavigationVC) {
        self.tempNav = aNavigationVC;
    }
}

- (void)shareTypeExtensionFunction {
    
}

- (void)jsEvenWithDataExtensionFunctionWithType:(NSString *)aType content:(NSString *)aContent {
    
}
@end
