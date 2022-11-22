//
//  DPTool.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright (c) 2021年 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ToastView_Tag 201503312
#define Animation_Time 2

@interface DPTool : NSObject

typedef NS_ENUM(NSUInteger, DPShowToastMsgStyle) {
    ///Toast提示框居上
    DPShowToastMsgStyleTop,
    ///Toast提示框居中
    DPShowToastMsgStyleCenter,
    ///Toast提示框居下
    DPShowToastMsgStyleBottom
};
///Toast提示框；默认时间 Animation_Time；delay 自定义时间；aView 父视图；vc 根控制器；
+ (void)showToastMsg:(NSString *)toastStr;
+ (void)showToastMsg:(NSString *)toastStr style:(DPShowToastMsgStyle)aStyle;
+ (void)showToastMsg:(NSString *)toastStr style:(DPShowToastMsgStyle)aStyle delay:(int)delay;
+ (void)showToastMsg:(NSString *)toastStr style:(DPShowToastMsgStyle)aStyle forVc:(UIViewController *)vc;
+ (void)showToastMsg:(NSString *)toastStr style:(DPShowToastMsgStyle)aStyle forVc:(UIViewController *)vc delay:(int)delay;
+ (void)showToastMsg:(NSString *)toastStr style:(DPShowToastMsgStyle)aStyle forView:(UIView *)aView;
+ (void)showToastMsg:(NSString *)toastStr style:(DPShowToastMsgStyle)aStyle forView:(UIView *)aView delay:(int)delay;
@end
