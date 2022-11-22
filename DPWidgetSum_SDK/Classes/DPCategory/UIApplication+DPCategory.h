//
//  UIApplication+DPCategory.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIApplication (DPCategory)
///获取keyWindow，iOS13废弃 [UIApplication sharedApplication].keyWindow
@property(nonatomic, readonly) UIWindow *dp_keyWindow;

///获取LaunchImage启动图片
+ (NSString *)dp_getLaunchImageName;

///地址唤醒
+ (void)dp_openURL:(id)aUrl options:(NSDictionary<UIApplicationOpenExternalURLOptionsKey, id> *)options completionHandler:(void (^)(NSError *aError))aCompletion;
@end

