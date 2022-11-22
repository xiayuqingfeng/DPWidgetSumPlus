//
//  DPBannerAlertView.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 zcw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPCustomBanner.h"

///获取弹框，单例存储，隐藏弹框，不释放，防止多次创建
#define ZCWBannerAlertViewSingle [DPBannerAlertView sharedAlertView].customAlert
///获取弹框，隐藏弹框，释放
#define ZCWBannerAlertViewRelease [[DPBannerAlertView alloc] init]

@interface DPBannerAlertView : UIView
///单例
+ (DPBannerAlertView *)sharedAlertView;
///sharedAlertView 存储对象
@property (nonatomic, strong, readonly) DPBannerAlertView *customAlert;

///DPBannerAlertView 存储对象
@property (nonatomic, strong, readonly) UIWindow *customWindow;
/**
 *  显示消息弹框，block回调；
 *
 *  @param aVC 当前控制器，但是存储，只创建一次
 *  @param aParentView 当前弹框父视图，为空时使用当前加载keyWindow
 *  @param aBlock 回传轮播控件aCustomBanner，加载内容和点击事件都在block回调函数内对aCustomBanner进行处理
 *
 */
- (void)showBannerAlertViewForVC:(UIViewController *)aVC parentView:(UIView *)aParentView loadContentBlock:(void (^)(DPBannerAlertView *aObject, DPCustomBanner *aCustomBanner))aBlock;
@end
