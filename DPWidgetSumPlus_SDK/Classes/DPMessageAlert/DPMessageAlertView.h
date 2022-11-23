//
//  DPMessageAlertView.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 zcw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class DPMessageAlertView;

///消息弹框单例获取
#define DPAlertView [DPMessageAlertView sharedAlertView].customAlert

typedef NS_ENUM(NSUInteger, DPMessageAlertStyle) {
    ///底部按钮样式
    DPMessageAlertStyleDefault,
    ///圆角按钮按钮样式
    DPMessageAlertStyleOne
};

@protocol DPMessageAlertViewDelegate <NSObject>
@optional
- (BOOL)CustomAlert:(UIView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex __deprecated_msg("当前类已经弃用,请使用 -messageAlertView: tapIndex:");
- (BOOL)messageDpAlertView:(DPMessageAlertView *)alertView tapIndex:(NSUInteger)aTapIndex;
@end

typedef BOOL(^ButtonActionBlock)(DPMessageAlertView *aObject, NSInteger tapIndex);

@interface DPMessageAlertView : UIView
@property (nonatomic, strong, readonly) UIWindow *customWindow;
@property (nonatomic, strong, readonly) DPMessageAlertView *customAlert;

///单例
+ (DPMessageAlertView *)sharedAlertView;

///显示消息弹框，block回调
- (void)showAlterWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)firstObject callBackBlock:(void(^)(NSInteger index, NSString *title))callBackBlock __deprecated_msg("当前类已经弃用,请使用 -showDPMessageAlertViewForTitle: buttonTitles: buttonBlock:");

///显示消息弹框，代理回调
- (void)showAlterWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles __deprecated_msg("当前类已经弃用,请使用 -showDPMessageAlertViewForTitle: buttonTitles: buttonBlock:");

/**
 *  显示消息弹框，block回调；默认父视 keyWindow；默认样式 DPMessageAlertStyleDefault；
 *
 *  @param aTitle 当前弹框标题，默认：nil
 *  @param aContent 当前弹框消息内容，默认：nil
 *  @param buttonTitles 当前按钮标题数组，默认：nil，没有按钮
 *  @param aButtonBlock 当前按钮点击回调事件
 *
 */
- (void)showDPMessageAlertViewForTitle:(id)aTitle content:(id)aContent buttonTitles:(NSArray <id>*)buttonTitles buttonBlock:(ButtonActionBlock)aButtonBlock;

/**
 *  显示消息弹框，delegate回调；
 *
 *  @param aVC 当前控制器，但是存储，只创建一次
 *  @param aParentView 当前弹框父视图，为空时使用当前加载keyWindow
 *  @param aParentColor 当前弹框父视图背景颜色，默认DP_RGBA(0, 0, 0, 0.7)
 *  @param aTitle 当前弹框标题，默认：nil
 *  @param aContent 当前弹框消息内容，默认：nil
 *  @param aAlertStyle 当前弹框样式，默认：DPMessageAlertStyleDefault
 *  @param buttonTitles 当前按钮标题数组，默认：nil，没有按钮
 *
 */
- (void)showDPMessageAlertViewForVC:(UIViewController *)aVC parentView:(UIView *)aParentView delegate:(id)aDelegate title:(id)aTitle content:(id)aContent alertStyle:(DPMessageAlertStyle)aAlertStyle buttonTitles:(NSArray <id>*)buttonTitles;

/**
 *  显示消息弹框，block回调；
 *
 *  @param aVC 当前控制器，但是存储，只创建一次
 *  @param aParentView 当前弹框父视图，为空时使用当前加载keyWindow
 *  @param aParentColor 当前弹框父视图背景颜色，默认DP_RGBA(0, 0, 0, 0.7)
 *  @param aTitle 当前弹框标题，默认：nil
 *  @param aContent 当前弹框消息内容，默认：nil
 *  @param aAlertStyle 当前弹框样式，默认：DPMessageAlertStyleDefault
 *  @param buttonTitles 当前按钮标题数组，默认：nil，没有按钮
 *  @param aButtonBlock 当前按钮点击回调事件
 *
 */
- (void)showDPMessageAlertViewForVC:(UIViewController *)aVC parentView:(UIView *)aParentView title:(id)aTitle content:(id)aContent alertStyle:(DPMessageAlertStyle)aAlertStyle buttonTitles:(NSArray <id>*)buttonTitles buttonBlock:(ButtonActionBlock)aButtonBlock;

/**
 *  隐藏消息弹框，block回调；
 *
 *  @param finishBlock 动画结束回调事件
 *
 */
- (void)hiddenViewFinishBlock:(void (^)(DPMessageAlertView *aObject))finishBlock;

/**
 *  消息弹框，内容添加文字点击事件
 *
 *  @param aText 点击文字
 *  @param aUrl 点击文字响应参数
 *  @param aAttributes 点击文字富文本参数
 *  @param aAddIndex 多个相同对象，指定响应位置：0、1、2、3……，默认 0，-1 响应全部对象，越界响应最后一个
 *  @param aBlock 文字点击回调，为nil，使用aUrl跳转 DPWebViewController；返回BOOL值：YES 继续隐藏动画，NO 停止隐藏动画；
 *
 */
- (void)addTapContentForText:(NSString *)aText url:(NSString *)aUrl attributes:(NSDictionary *)aAttributes addIndex:(NSInteger)aAddIndex block:(BOOL (^)(DPMessageAlertView *aObject, NSString *aText, NSString *aUrlStr))aBlock;
@end
