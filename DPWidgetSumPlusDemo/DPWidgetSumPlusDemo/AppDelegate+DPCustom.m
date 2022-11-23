//
//  AppDelegate+DPCustom.m
//  QMFQ
//
//  Created by yupeng xia on 2017/2/16.
//  Copyright © 2017年 zcw. All rights reserved.
//

#import "AppDelegate+DPCustom.h"
#import "DPWidgetSumPlus.h"

@implementation AppDelegate (DPCustom)
//初始化DP积木模块
- (void)initUmengShare {
    ///DPMessageAlertView 消息弹框样式自定义
    DPSMDate.alertMsg_btnStyle = @{@"bgColor":DP_RGBA(255, 0, 0, 0.5),
                                   @"font":DP_FontBold(19),
                                   @"titleColor":DP_RGBA(0, 0, 0, 1)};
    //DPBaseViewController 基类样式自定义
    DPSMDate.navBarGB_viewStyle = @{@"startColor":DP_RGBA(200, 0, 0, 1),
                                    @"endColor":DP_RGBA(255, 0, 0, 1)};
    //DPWebView 重定向Url，修改当前访问地址，再次访问
    DPSMDate.urlRedirectBlock = ^NSString *(DPWebView *webView, WKNavigationAction *navigation, NSString *aUrlStr) {
        NSMutableString *tmpUrlAddress = [NSMutableString stringWithString:aUrlStr];
        
        //拼接渠道信息
        if (![tmpUrlAddress containsString:@"from=client"]) {
            NSString * str = @"";
            if([tmpUrlAddress containsString:@"?"]) {
                str = [str stringByAppendingString:@"&"];
            }else{
                str = [str stringByAppendingString:@"?"];
            }
            str = [str stringByAppendingString:@"from=client"];
            //有#号参数加在#号前面
            if ([tmpUrlAddress containsString:@"#"]) {
                NSRange range = [tmpUrlAddress rangeOfString:@"#"];
                [tmpUrlAddress insertString:str atIndex:range.location];
            }else{
                [tmpUrlAddress appendFormat:@"%@",str];
            }
        }
        
        if ([tmpUrlAddress isEqualToString:aUrlStr]) {
            return nil;
        }else{
            return tmpUrlAddress;
        }
    };
    
    //DPWebView 非法Url，禁止访问
    DPSMDate.urlIllegalBlock = ^BOOL(DPWebView *webView, WKNavigationAction *navigation, NSString *aUrlStr) {
        NSArray *array = @[@"csgoodsh5.caiminbang1"];
        for (NSString *aStr in array) {
            if ([aUrlStr containsString:aStr]) {
                return YES;
            }
        }
        return NO;
    };
}
@end
