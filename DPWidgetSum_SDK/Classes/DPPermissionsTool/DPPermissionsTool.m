//
//  DPPermissionsTool.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/9.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import "DPPermissionsTool.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
#import <Photos/Photos.h>
#else
#import <AssetsLibrary/AssetsLibrary.h>
#endif
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <EventKit/EventKit.h>
#import <CoreTelephony/CTCellularData.h>
#import <HealthKit/HealthKit.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import <PassKit/PassKit.h>
#import <Speech/Speech.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Intents/Intents.h>

@implementation DPPermissionsTool
#pragma mark <--------------plist权限key值-------------->
/*
 <!-- 相册 -->
 <key>NSPhotoLibraryUsageDescription</key>
 <string>App需要您的同意,才能访问相册</string>
 <!-- 相机 -->
 <key>NSCameraUsageDescription</key>
 <string>App需要您的同意,才能访问相机</string>
 <!-- 麦克风 -->
 <key>NSMicrophoneUsageDescription</key>
 <string>App需要您的同意,才能访问麦克风</string>
 <!-- 位置 -->
 <key>NSLocationUsageDescription</key>
 <string>App需要您的同意,才能访问位置</string>
 <!-- 在使用期间访问位置 -->
 <key>NSLocationWhenInUseUsageDescription</key>
 <string>App需要您的同意,才能在使用期间访问位置</string>
 <!-- 始终访问位置 -->
 <key>NSLocationAlwaysUsageDescription</key>
 <string>App需要您的同意,才能始终访问位置</string>
 <!-- 日历 -->
 <key>NSCalendarsUsageDescription</key>
 <string>App需要您的同意,才能访问日历</string>
 <!-- 提醒事项 -->
 <key>NSRemindersUsageDescription</key>
 <string>App需要您的同意,才能访问提醒事项</string>
 <!-- 运动与健身 -->
 <key>NSMotionUsageDescription</key>
 <string>App需要您的同意,才能访问运动与健身</string>
 <!-- 健康更新 -->
 <key>NSHealthUpdateUsageDescription</key>
 <string>App需要您的同意,才能访问健康更新 </string>
 <!-- 健康分享 -->
 <key>NSHealthShareUsageDescription</key>
 <string>App需要您的同意,才能访问健康分享</string>
 <!-- 蓝牙 -->
 <key>NSBluetoothPeripheralUsageDescription</key>
 <string>App需要您的同意,才能访问蓝牙</string>
 <!-- 媒体资料库 -->
 <key>NSAppleMusicUsageDescription</key>
 <string>App需要您的同意,才能访问媒体资料库</string>
 <!-- 语音识别 -->
 <key>NSSpeechRecognitionUsageDescription</key>
 <string>App需要您的同意,才能使用语音识别</string>
 */

#pragma mark <--------------权限判断-------------->
///是否开启定位
+ (void)isOpenLocationServiceWithBlock:(void(^)(BOOL isOpen))callback {
    BOOL isOPen = NO;
    if ([CLLocationManager locationServicesEnabled] &&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        isOPen = YES;
    }
    callback(isOPen);
}

///是否允许消息推送
+ (void)isOpenMessageNotificationServiceWithBlock:(void(^)(BOOL isOpen))callback {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
            callback(settings.authorizationStatus == UNAuthorizationStatusAuthorized);
        }];
    }
#elif __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    callback([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]);
#else
    UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    callback(type != UIRemoteNotificationTypeNone);
#endif
}

///是否开启摄像头
+ (void)isOpenCaptureDeviceServiceWithBlock:(void(^)(BOOL isOpen))callback {
#if TARGET_IPHONE_SIMULATOR
    callback(NO);
#elif TARGET_OS_IPHONE
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(granted);
            });
        }];
    } else if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        callback(NO);
    } else {
        callback(YES);
    }
#endif
    
#endif
}

///是否开启相册
+ (void)isOpenAlbumServiceWithBlock:(void(^)(BOOL isOpen))callback {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    if (@available(iOS 8, *)) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(status == PHAuthorizationStatusAuthorized);
                });
            }];
        }else {
            callback(status == PHAuthorizationStatusAuthorized);
        }
    } else {
        callback(NO);
    }
#else
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status == ALAuthorizationStatusNotDetermined) {
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(status == ALAuthorizationStatusAuthorized);
            });
        } failureBlock:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(status == ALAuthorizationStatusAuthorized);
            });
        }];
    }else {
        callback(status == ALAuthorizationStatusAuthorized);
    }
#endif
}

///是否开启麦克风
+ (void)isOpenRecordServiceWithBlock:(void(^)(BOOL isOpen))callback {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    if (@available(iOS 8.0, *)) {
        AVAudioSessionRecordPermission permissionStatus = [[AVAudioSession sharedInstance] recordPermission];
        if (permissionStatus == AVAudioSessionRecordPermissionUndetermined) {
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                callback(granted);
            }];
        } else if (permissionStatus == AVAudioSessionRecordPermissionDenied) {
            callback(NO);
        } else {
            callback(YES);
        }
    } else {
        callback(NO);
    }
#endif
}

///是否开启通讯录
+ (void)isOpenContactsServiceWithBolck:(void(^)(BOOL isOpen))callback {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    if (@available(iOS 9.0, *)) {
        CNAuthorizationStatus cnAuthStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (cnAuthStatus == CNAuthorizationStatusNotDetermined) {
            CNContactStore *store = [[CNContactStore alloc] init];
            [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError *error) {
                callback(granted);
            }];
        } else if (cnAuthStatus == CNAuthorizationStatusRestricted || cnAuthStatus == CNAuthorizationStatusDenied) {
            callback(NO);
        } else {
            callback(YES);
        }
    } else {
        callback(NO);
    }
#else
    //ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRef addressBook = ABAddressBookCreate();
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    if (authStatus != kABAuthorizationStatusAuthorized) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"Error: %@", (__bridge NSError *)error);
                    if (returnBolck) {
                        callback(NO);
                    }
                } else {
                    callback(YES);
                }
            });
        });
    } else {
        callback(YES);
    }
#endif
}

///是否开启蓝牙
+ (void)isOpenPeripheralServiceWithBolck:(void(^)(BOOL isOpen))callback {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    CBPeripheralManagerAuthorizationStatus cbAuthStatus = [CBPeripheralManager authorizationStatus];
    if (cbAuthStatus == CBPeripheralManagerAuthorizationStatusNotDetermined) {
        callback(NO);
    } else if (cbAuthStatus == CBPeripheralManagerAuthorizationStatusRestricted || cbAuthStatus == CBPeripheralManagerAuthorizationStatusDenied) {
        callback(NO);
    } else {
        callback(YES);
    }
#endif
}

///是否开启日历/备忘录
+ (void)isOpenEventServiceWithBolck:(void(^)(BOOL isOpen))callback withType:(NSInteger)entityType {
    // EKEntityTypeEvent  代表日历
    // EKEntityTypeReminder 代表备忘
    EKAuthorizationStatus ekAuthStatus = [EKEventStore authorizationStatusForEntityType:(EKEntityType)entityType];
    if (ekAuthStatus == EKAuthorizationStatusNotDetermined) {
        EKEventStore *store = [[EKEventStore alloc] init];
        [store requestAccessToEntityType:(EKEntityType)entityType completion:^(BOOL granted, NSError *error) {
            callback(granted);
        }];
    } else if (ekAuthStatus == EKAuthorizationStatusRestricted || ekAuthStatus == EKAuthorizationStatusDenied) {
        callback(NO);
    } else {
        callback(YES);
    }
}

///是否开启联网
+ (void)isOpenNetworkServiceWithBolck:(void(^)(BOOL isOpen))callback {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    if (@available(iOS 9.0, *)) {
        CTCellularData *cellularData = [[CTCellularData alloc] init];
        cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state){
            if (state == kCTCellularDataRestrictedStateUnknown || state == kCTCellularDataNotRestricted) {
                callback(NO);
            } else {
                callback(YES);
            }
        };
        CTCellularDataRestrictedState state = cellularData.restrictedState;
        if (state == kCTCellularDataRestrictedStateUnknown || state == kCTCellularDataNotRestricted) {
            callback(NO);
        } else {
            callback(YES);
        }
    } else {
        callback(NO);
    }
#endif
}

///是否开启健康
+ (void)isOpenHealthServiceWithBolck:(void(^)(BOOL isOpen))callback {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    if (@available(iOS 8.0, *)) {
        if (![HKHealthStore isHealthDataAvailable]) {
            callback(NO);
        } else {
            HKHealthStore *healthStore = [[HKHealthStore alloc] init];
            HKObjectType *hkObjectType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
            HKAuthorizationStatus hkAuthStatus = [healthStore authorizationStatusForType:hkObjectType];
            if (hkAuthStatus == HKAuthorizationStatusNotDetermined) {
                // 1. 你创建了一个NSSet对象，里面存有本篇教程中你将需要用到的从Health Stroe中读取的所有的类型：个人特征（血液类型、性别、出生日期）、数据采样信息（身体质量、身高）以及锻炼与健身的信息。
                NSSet <HKObjectType *> * healthKitTypesToRead = [[NSSet alloc] initWithArray:@[[HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth],[HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBloodType],[HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex],[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],[HKObjectType workoutType]]];
                // 2. 你创建了另一个NSSet对象，里面有你需要向Store写入的信息的所有类型（锻炼与健身的信息、BMI、能量消耗、运动距离）
                NSSet <HKSampleType *> * healthKitTypesToWrite = [[NSSet alloc] initWithArray:@[[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex],[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned],[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning],[HKObjectType workoutType]]];
                [healthStore requestAuthorizationToShareTypes:healthKitTypesToWrite readTypes:healthKitTypesToRead completion:^(BOOL success, NSError *error) {
                    callback(success);
                }];
            } else if (hkAuthStatus == HKAuthorizationStatusSharingDenied) {
                callback(NO);
            } else {
                callback(YES);
            }
        }
    } else {
        callback(NO);
    }
#endif
}

///是否开启Touch ID
+ (void)isOpenTouchIDServiceWithBlock:(void(^)(BOOL isOpen))callback {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    if (@available(iOS 8.0, *)) {
        LAContext *laContext = [[LAContext alloc] init];
        laContext.localizedFallbackTitle = @"输入密码";
        NSError *error;
        if ([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            NSLog(@"恭喜,Touch ID可以使用!");
            [laContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"需要验证您的指纹来确认您的身份信息" reply:^(BOOL success, NSError *error) {
                if (success) {
                    // 识别成功
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        callback(YES);
                    }];
                } else if (error) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        callback(NO);
                    }];
                    if (error.code == LAErrorAuthenticationFailed) {
                        // 验证失败
                    }
                    if (error.code == LAErrorUserCancel) {
                        // 用户取消
                    }
                    if (error.code == LAErrorUserFallback) {
                        // 用户选择输入密码
                    }
                    if (error.code == LAErrorSystemCancel) {
                        // 系统取消
                    }
                    if (error.code == LAErrorPasscodeNotSet) {
                        // 密码没有设置
                    }
                }
            }];
        } else {
            NSLog(@"设备不支持Touch ID功能,原因:%@",error);
            callback(NO);
        }
    } else {
        callback(NO);
    }
#endif
}

///是否开启Apple Pay
+ (void)isOpenApplePayServiceWithBlock:(void(^)(BOOL isOpen))callback {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    if (@available(iOS 9.0, *)) {
        NSArray<PKPaymentNetwork> *supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa, PKPaymentNetworkDiscover];
        if ([PKPaymentAuthorizationViewController canMakePayments] && [PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:supportedNetworks]) {
            callback(YES);
        } else {
            callback(NO);
        }
    } else {
        callback(NO);
    }
#endif
}

///是否开启语音识别
+ (void)isOpenSpeechServiceWithBlock:(void(^)(BOOL isOpen))callback {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    if (@available(iOS 10.0, *)) {
        SFSpeechRecognizerAuthorizationStatus speechAuthStatus = [SFSpeechRecognizer authorizationStatus];
        if (speechAuthStatus == SFSpeechRecognizerAuthorizationStatusNotDetermined) {
            [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
                if (status == SFSpeechRecognizerAuthorizationStatusAuthorized) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callback(YES);
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callback(NO);
                    });
                }
            }];
        } else if (speechAuthStatus == SFSpeechRecognizerAuthorizationStatusAuthorized) {
            callback(YES);
        } else{
            callback(NO);
        }
    } else {
        callback(NO);
    }
#endif
}

///是否开启媒体资料库/Apple Music
+ (void)isOpenMediaPlayerServiceWithBlock:(void(^)(BOOL isOpen))callback {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_3
    if (@available(iOS 9.3, *)) {
        MPMediaLibraryAuthorizationStatus authStatus = [MPMediaLibrary authorizationStatus];
        if (authStatus == MPMediaLibraryAuthorizationStatusNotDetermined) {
            [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
                if (status == MPMediaLibraryAuthorizationStatusAuthorized) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callback(YES);
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callback(NO);
                    });
                }
            }];
        }else if (authStatus == MPMediaLibraryAuthorizationStatusAuthorized){
            callback(YES);
        }else{
            callback(NO);
        }
    } else {
        callback(NO);
    }
#endif
}

///是否开启Siri
+ (void)isOpenSiriServiceWithBlock:(void(^)(BOOL isOpen))callback {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    if (@available(iOS 10.0, *)) {
        INSiriAuthorizationStatus siriAutoStatus = [INPreferences siriAuthorizationStatus];
        if (siriAutoStatus == INSiriAuthorizationStatusNotDetermined) {
            [INPreferences requestSiriAuthorization:^(INSiriAuthorizationStatus status) {
                if (status == INSiriAuthorizationStatusAuthorized) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callback(YES);
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callback(NO);
                    });
                }
            }];
        } else if (siriAutoStatus == INSiriAuthorizationStatusAuthorized) {
            callback(YES);
        } else{
            callback(NO);
        }
    } else {
        callback(NO);
    }
#endif
}

#pragma mark <--------------跳转权限设置页-------------->
///跳转系统"app"权限设置页
+ (void)openApplicationSettingsWithBlock:(void(^)(BOOL isOpen))callback {
    if (@available(iOS 8.0, *)) {
        [DPPermissionsTool customOpenURL:UIApplicationOpenSettingsURLString block:callback];
    } else {
        callback(NO);
    }
}

///跳转系统"定位"权限设置页
+ (void)openLocationServiceWithBlock:(void(^)(BOOL isOpen))callback {
    [DPPermissionsTool customOpenURL:@"prefs:root=LOCATION_SERVICES" block:callback];
}

///跳转系统"消息推送"权限设置页
+ (void)openMessageNotificationServiceWithBlock:(void(^)(BOOL isOpen))callback {
    [DPPermissionsTool customOpenURL:@"prefs:root=NOTIFICATIONS_ID" block:callback];
}

///跳转系统"摄像头"权限设置页
+ (void)openCaptureDeviceServiceWithBlock:(void(^)(BOOL isOpen))callback {
    [DPPermissionsTool customOpenURL:@"prefs:root=Photos" block:callback];
}

///跳转系统"相册"权限设置页
+ (void)openAlbumServiceWithBlock:(void(^)(BOOL isOpen))callback {
    [DPPermissionsTool customOpenURL:@"prefs:root=Photos" block:callback];
}

///跳转系统"麦克风"权限设置页
+ (void)openRecordServiceWithBlock:(void(^)(BOOL isOpen))callback {
    [DPPermissionsTool customOpenURL:@"" block:callback];
}

///跳转系统"通讯录"权限设置页
+ (void)openContactsServiceWithBlock:(void(^)(BOOL isOpen))callback {
    [DPPermissionsTool customOpenURL:@"" block:callback];
}

/////跳转系统"蓝牙"权限设置页
+ (void)openPeripheralServiceWithBlock:(void(^)(BOOL isOpen))callback {
    [DPPermissionsTool customOpenURL:@"prefs:root=Bluetooth" block:callback];
}

///跳转系统"日历/备忘录"权限设置页
+ (void)openEventServiceWithBlock:(void(^)(BOOL isOpen))callback {
    [DPPermissionsTool customOpenURL:@"prefs:root=NOTES" block:callback];
}

///跳转系统"联网"权限设置页
+ (void)openNetworkServiceWithBlock:(void(^)(BOOL isOpen))callback {
    [DPPermissionsTool customOpenURL:@"prefs:root=General&path=Network" block:callback];
}

///跳转系统"健康"权限设置页
+ (void)openHealthServiceWithBlock:(void(^)(BOOL isOpen))callback {
    [DPPermissionsTool customOpenURL:@"" block:callback];
}

///跳转系统"Touch ID"权限设置页
+ (void)openTouchIDServiceWithBlock:(void(^)(BOOL isOpen))callback {
    [DPPermissionsTool customOpenURL:@"" block:callback];
}

///跳转系统"Apple Pay"权限设置页
+ (void)openApplePayServiceWithBlock:(void(^)(BOOL isOpen))callback {
    [DPPermissionsTool customOpenURL:@"" block:callback];
}

///跳转系统"语音识别"权限设置页
+ (void)openSpeechServiceWithBlock:(void(^)(BOOL isOpen))callback {
    [DPPermissionsTool customOpenURL:@"" block:callback];
}

///跳转系统"媒体资料库/Apple Music"权限设置页
+ (void)openMediaPlayerServiceWithBlock:(void(^)(BOOL isOpen))callback {
    [DPPermissionsTool customOpenURL:@"prefs:root=MUSIC" block:callback];
}

///是否开启Siri"权限设置页
+ (void)openSiriServiceWithBlock:(void(^)(BOOL isOpen))callback {
    [DPPermissionsTool customOpenURL:@"App-Prefs:root=Siri" block:callback];
}

+ (void)customOpenURL:(id)aUrl block:(void(^)(BOOL isOpen))callback {
    NSURL *url = nil;
    if ([aUrl isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:aUrl];
    }else if ([aUrl isKindOfClass:[NSURL class]]) {
        url = (NSURL *)aUrl;
    }
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            if (callback) {
                callback(success);
            }
        }];
    } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_10_0
            [[UIApplication sharedApplication] openURL:url];
#endif
        if (callback) {
            callback(YES);
        }
    }
}
@end
