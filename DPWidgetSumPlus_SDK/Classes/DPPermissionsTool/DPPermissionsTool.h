//
//  DPPermissionsTool.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/9.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DPPermissionsTool : NSObject
#pragma mark <--------------权限判断-------------->
///是否开启定位
+ (void)isOpenLocationServiceWithBlock:(void(^)(BOOL isOpen))callback;

///是否允许消息推送
+ (void)isOpenMessageNotificationServiceWithBlock:(void(^)(BOOL isOpen))callback;

///是否开启摄像头
+ (void)isOpenCaptureDeviceServiceWithBlock:(void(^)(BOOL isOpen))callback;

///是否开启相册
+ (void)isOpenAlbumServiceWithBlock:(void(^)(BOOL isOpen))callback;

///是否开启麦克风
+ (void)isOpenRecordServiceWithBlock:(void(^)(BOOL isOpen))callback;

///是否开启通讯录
+ (void)isOpenContactsServiceWithBolck:(void(^)(BOOL isOpen))callback;

/////是否开启蓝牙
+ (void)isOpenPeripheralServiceWithBolck:(void(^)(BOOL isOpen))callback;

///是否开启日历/备忘录，entityType 类型 EKEntityType
+ (void)isOpenEventServiceWithBolck:(void(^)(BOOL isOpen))callback withType:(NSInteger)entityType;

///是否开启联网
+ (void)isOpenNetworkServiceWithBolck:(void(^)(BOOL isOpen))callback;

///是否开启健康
+ (void)isOpenHealthServiceWithBolck:(void(^)(BOOL isOpen))callback;

///是否开启Touch ID
+ (void)isOpenTouchIDServiceWithBlock:(void(^)(BOOL isOpen))callback;

/////是否开启Apple Pay
+ (void)isOpenApplePayServiceWithBlock:(void(^)(BOOL isOpen))callback;

///是否开启语音识别
+ (void)isOpenSpeechServiceWithBlock:(void(^)(BOOL isOpen))callback;

///是否开启媒体资料库/Apple Music
+ (void)isOpenMediaPlayerServiceWithBlock:(void(^)(BOOL isOpen))callback;

///是否开启Siri
+ (void)isOpenSiriServiceWithBlock:(void(^)(BOOL isOpen))callback;

#pragma mark <--------------跳转权限设置页-------------->
///跳转系统"app"权限设置页
+ (void)openApplicationSettingsWithBlock:(void(^)(BOOL isOpen))callback;

///跳转系统"定位"权限设置页
+ (void)openLocationServiceWithBlock:(void(^)(BOOL isOpen))callback;

///跳转系统"消息推送"权限设置页
+ (void)openMessageNotificationServiceWithBlock:(void(^)(BOOL isOpen))callback;

///跳转系统"摄像头"权限设置页
+ (void)openCaptureDeviceServiceWithBlock:(void(^)(BOOL isOpen))callback;

///跳转系统"相册"权限设置页
+ (void)openAlbumServiceWithBlock:(void(^)(BOOL isOpen))callback;

///跳转系统"麦克风"权限设置页
+ (void)openRecordServiceWithBlock:(void(^)(BOOL isOpen))callback;

///跳转系统"通讯录"权限设置页
+ (void)openContactsServiceWithBlock:(void(^)(BOOL isOpen))callback;

/////跳转系统"蓝牙"权限设置页
+ (void)openPeripheralServiceWithBlock:(void(^)(BOOL isOpen))callback;

///跳转系统"日历/备忘录"权限设置页
+ (void)openEventServiceWithBlock:(void(^)(BOOL isOpen))callback;

///跳转系统"联网"权限设置页
+ (void)openNetworkServiceWithBlock:(void(^)(BOOL isOpen))callback;

///跳转系统"健康"权限设置页
+ (void)openHealthServiceWithBlock:(void(^)(BOOL isOpen))callback;

///跳转系统"Touch ID"权限设置页
+ (void)openTouchIDServiceWithBlock:(void(^)(BOOL isOpen))callback;

///跳转系统"Apple Pay"权限设置页
+ (void)openApplePayServiceWithBlock:(void(^)(BOOL isOpen))callback;

///跳转系统"语音识别"权限设置页
+ (void)openSpeechServiceWithBlock:(void(^)(BOOL isOpen))callback;

///跳转系统"媒体资料库/Apple Music"权限设置页
+ (void)openMediaPlayerServiceWithBlock:(void(^)(BOOL isOpen))callback;

///是否开启Siri"权限设置页
+ (void)openSiriServiceWithBlock:(void(^)(BOOL isOpen))callback;
@end
