//
//  DPTool.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright (c) 2021年 xiayupeng. All rights reserved.
//

#import "DPTool.h"
#import "DPWidgetSum.h"
#import <CommonCrypto/CommonDigest.h>
#import <MBProgressHUD/MBProgressHUD.h>

@implementation DPTool
+ (void)showToastMsg:(NSString *)toastStr {
    [self showToastMsg:toastStr style:DPShowToastMsgStyleCenter delay:Animation_Time];
}
+ (void)showToastMsg:(NSString *)toastStr style:(DPShowToastMsgStyle)aStyle {
    [self showToastMsg:toastStr style:aStyle delay:Animation_Time];
}
+ (void)showToastMsg:(NSString *)toastStr style:(DPShowToastMsgStyle)aStyle delay:(int)delay {
    [self showToastMsg:toastStr style:aStyle forView:[UIApplication sharedApplication].dp_keyWindow delay:delay];
}
+ (void)showToastMsg:(NSString *)toastStr style:(DPShowToastMsgStyle)aStyle forVc:(UIViewController *)vc {
    [self showToastMsg:toastStr style:aStyle forVc:vc delay:Animation_Time];
}
+ (void)showToastMsg:(NSString *)toastStr style:(DPShowToastMsgStyle)aStyle forVc:(UIViewController *)vc delay:(int)delay {
    if(dp_isNotNullString(toastStr) && vc && [vc isKindOfClass:[UIViewController class]]) {
        [self showToastMsg:toastStr style:aStyle forView:vc.view delay:delay];
    }
}
+ (void)showToastMsg:(NSString *)toastStr style:(DPShowToastMsgStyle)aStyle forView:(UIView *)aView {
    [self showToastMsg:toastStr style:aStyle forView:aView delay:Animation_Time];
}
+ (void)showToastMsg:(NSString *)toastStr style:(DPShowToastMsgStyle)aStyle forView:(UIView *)aView delay:(int)delay {
    UIView *toastView = [aView viewWithTag:ToastView_Tag];
    if(nil != toastView) {
        [toastView removeFromSuperview];
    }
    
    if(nil != toastStr && toastStr.length>0 && aView) {
        if (toastStr.length<10) {
            toastStr = [NSString stringWithFormat:@"%@",toastStr];
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
        hud.tag = ToastView_Tag;
        hud.userInteractionEnabled = NO;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = toastStr;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = DP_RGBACOLOR(0x00, 0x00, 0x00, .75);
        hud.label.textColor = DP_RGB(255, 255, 255);
        hud.label.numberOfLines = 0;
        CGFloat offSetY = 0;
        if (aStyle == DPShowToastMsgStyleTop) {
            offSetY = 0-aView.dp_height/4;
        }else if (aStyle == DPShowToastMsgStyleBottom) {
            offSetY = aView.dp_height/4;
        }
        hud.offset = CGPointMake(0, offSetY);
        hud.margin = 8;
        [hud hideAnimated:YES afterDelay:delay];
    }
}
@end
