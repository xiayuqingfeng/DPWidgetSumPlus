//
//  UIApplication+DPCategory.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import "UIApplication+DPCategory.h"
#import "DPWidgetSumPlus.h"

@implementation UIApplication (DPCategory)
///获取keyWindow，iOS13废弃 [UIApplication sharedApplication].keyWindow
- (UIWindow *)dp_keyWindow {
    UIWindow *aWindow = nil;
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *windowScene in self.connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        aWindow = window;
                        break;
                    }
                }
            }
        }
    }else {
        aWindow = [UIApplication sharedApplication].keyWindow;
    }
    if (aWindow == nil || !aWindow.isKeyWindow) {
        aWindow = [[UIApplication sharedApplication] delegate].window;
    }
    return aWindow;
}

///获取LaunchImage启动图片
+ (NSString *)dp_getLaunchImageName {
    NSArray *imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    CGSize viewSize = [UIApplication sharedApplication].keyWindow.bounds.size;
    //横屏请设置成 @"Landscape"
    NSString *viewOrientation = @"Portrait";
    NSString *launchImage = nil;
    for (NSDictionary* dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    return launchImage;
}

///地址唤醒
+ (void)dp_openURL:(id)aUrl options:(NSDictionary<UIApplicationOpenExternalURLOptionsKey, id> *)options completionHandler:(void (^)(NSError *aError))aCompletion {
    NSError *error = nil;
    if (aUrl == nil) {
        error = [NSError errorWithDomain:@"跳转地址为空！" code:400 userInfo:nil];
        if (aCompletion) {
            aCompletion(error);
        }
        return;
    }
    NSURL *currentUrl = nil;
    if ([aUrl isKindOfClass:[NSString class]]) {
        if (((NSString *)aUrl).length < 1) {
            error = [NSError errorWithDomain:@"跳转地址为空！" code:400 userInfo:nil];
            if (aCompletion) {
                aCompletion(error);
            }
            return;
        }
        currentUrl = [NSURL URLWithString:aUrl];
    }else if ([aUrl isKindOfClass:[NSURL class]]) {
        currentUrl = (NSURL *)aUrl;
    }
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    [[UIApplication sharedApplication] openURL:currentUrl options:options completionHandler:^(BOOL success) {
        NSError *newError = nil;
        if (success) {
            newError = [NSError errorWithDomain:@"跳转失败！" code:401 userInfo:nil];
        }
        if (aCompletion) {
            aCompletion(newError);
        }
    }];
#else
    BOOL success = [[UIApplication sharedApplication] openURL:currentUrl];
    NSError *newError = nil;
    if (success) {
        newError = [NSError errorWithDomain:@"跳转失败！" code:401 userInfo:nil];
    }
    if (aCompletion) {
        aCompletion(newError);
    }
#endif
}
@end
