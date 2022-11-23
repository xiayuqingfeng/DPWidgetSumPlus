//
//  DPSharedManager.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 zcw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DPWebView.h"

@class DPSharedManager;
@class DPMessageAlertViewStyle;
@class DPDefaultViewStyle;
@class DPBaseViewControllerStyle;

///消息弹框 “单例获取
#define DPSMDate [DPSharedManager sharedManager]

@interface DPSharedManager : NSObject
///单例获取
+ (DPSharedManager *)sharedManager;

#pragma mark - DPWebView 非法Url，禁止访问
@property (nonatomic, copy) WebViewUrlIllegalBlock urlIllegalBlock;

#pragma mark - DPWebView 重定向Url，修改当前访问地址，再次访问
@property (nonatomic, copy) WebViewUrlRedirectBlock urlRedirectBlock;

#pragma mark - 单例存储"样式"数据格式解读
/*
 _viewStyle 字典类型：@{
    @"bgColor":DP_RGBA(0, 0, 0, 0),
    @"radius":"10"
 }
 _labStyle 字典类型：@{
    @"font":DP_FontBold(18),
    @"textColor":DP_RGBA(0, 0, 0, 1)
 }
 _btnStyle 字典类型：@{
    @"font":DP_FontBold(18),
    @"textColor":DP_RGBA(0, 0, 0, 1)
 }
 _borderLineStyle 字典类型：@{
    @"borderWidth":@"0.5",
    @"bgColor":DP_RGBA(51, 105, 227, 1)
 }
 _lineStyle 字典类型：@{
    @"borderWidth":@"0.5",
    @"bgColor":DP_RGBA(51, 105, 227, 1)
 }
 _imageValus 字典类型：@{
    @"imageOne":[UIImage imageNamed:@"dp_no_failed.png"],
    @"imageTow":[UIImage imageNamed:@"dp_no_failed.png"],
    ……
 }
 _textValus 字典类型：@{
    @"textOne":@"获取数据为空！",
    @"textTow":@"168",
    ……
 }
 */

#pragma mark - DPBaseViewController 基类样式自定义
///可重定义，上导航栏“背景” 样式，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *navBarGB_viewStyle;
///可重定义，上导航栏“标题” 样式，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *navBarTitle_labStyle;
///可重定义，上导航栏“按钮” 样式，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *navBarBack_btnStyle;
///可重定义，基类“主视图” 样式，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *baseContent_viewStyle;
///可重定义，基类“默认显示视图图片” 参数，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *baseContent_imageValus;
///可重定义，基类“默认显示视图文字” 参数，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *baseContent_textValus;

#pragma mark - DPDefaultView 默认视图样式自定义
///可重定义，默认视图“背景” 样式，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *defaultViewBG_viewStyle;
///可重定义，默认视图“标题” 样式，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *defaultViewTitle_labStyle;
///可重定义，默认视图“按钮” 样式，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *defaultView_btnStyle;

#pragma mark - DPMessageAlertView 消息弹框样式自定义
///可重定义，消息弹框 “背景” 样式，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *alertMsgGB_viewStyle;
///可重定义，消息弹框 “中间父视图背景” 样式，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *alertMsgCenter_viewStyle;
///可重定义，消息弹框 “标题” 样式，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *alertMsgTitle_labStyle;
///可重定义，消息弹框 “详细内容” 样式，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *alertMsgContent_labStyle;
///可重定义，消息弹框 “按钮边框线” 样式，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *alertMsgBtn_borderLineStyle;
///可重定义，消息弹框 “第一个按钮” 样式，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *alertMsg_btnStyle;
///可重定义，消息弹框 “第n个按钮” 样式，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *alertMsgOther_btnStyle;

#pragma mark - DPInputBox 输入框样式自定义
///可重定义，输入框 “提示语、数字” 参数，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *inputBox_textValus;

#pragma mark - DPWebLoadFailView 默认视图样式自定义
///可重定义，基类“默认显示视图图片” 参数，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *webLoadFail_imageValus;
///可重定义，基类“默认显示视图标题” 样式，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *webLoadFailTitle_labStyle;
///可重定义，基类“默认显示视图详情” 样式，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *webLoadFailDetails_labStyle;
///可重定义，基类“默认显示视图关闭按钮” 样式，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *webLoadFailClose_labStyle;
///可重定义，基类“默认显示视图刷新按钮” 样式，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *webLoadFailRefresh_labStyle;

#pragma mark - DPShareView 基类样式自定义
///可重定义，分享弹框“背景” 样式，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *shareViewGB_viewStyle;
///可重定义，分享弹框“弹框父视图” 样式，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *shareViewCenter_viewStyle;
///可重定义，分享弹框“标题” 样式，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *shareViewTitle_labStyle;
///可重定义，分享弹框 “顶部分割线” 样式，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *shareViewTop_borderLineStyle;
///可重定义，基类“分享平台图片” 参数，默认值：getter逻辑获取
@property (nonatomic, strong) NSDictionary *shareView_imageValus;
@end
