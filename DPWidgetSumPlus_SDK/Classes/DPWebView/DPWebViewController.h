//
//  DPWebViewController.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPBaseViewController.h"

#import "DPWebView.h"

///跳转事件、URL前缀,服务器使用,客户端删除
#define shujufenxiHasPrefix @"shujufenxi_"
///URL前缀_打开新的浏览器(不显示上导航栏、不可旋转、不可缩放)
#define url_hasPrefix_webwindow @"webwindow_"
///URL前缀_打开新的浏览器(不显示上导航栏、可旋转、可缩放)
#define url_hasPrefix_webwindowRotate @"webwindowRotate_"
///URL前缀_打开新的浏览器(显示上导航栏、可旋转、可缩放)
#define url_hasPrefix_webRotate @"webRotate_"
///URL前缀_打开新的浏览器(显示上导航栏、不可旋转、不可缩放)
#define url_hasPrefix_web @"web_"

@interface DPWebViewController : DPBaseViewController {
}
@property (nonatomic, strong) DPWebView *currentWebView;
///非法Url是否进行判断，默认：YES 进行非法Url限制;
@property (nonatomic, assign) BOOL isUrlIllegal;
///访问地址是否进行重定向处理，修改当前访问地址，默认：YES 进行重定向;
@property (nonatomic, assign) BOOL isUrlRedirect;
///当前控制器是否是根控制器, YES 是 ,NO 不是(没有上导航栏时,加载失败默认显示选项需要返回按钮), 默认 NO
@property (nonatomic, assign) BOOL isHomePage;
///shareImage: 自定义分享icon, 为空使用默认图片
@property (nonatomic, strong) UIImage *shareImage;
///是否给请求连接拼接 Session, 默认YES
@property (nonatomic, assign) BOOL isNeedSession;
///isCustomViewport: YES 使用自定义viewport页面缩放、手势、布局属性, NO  使用浏览器默认缩放、手势、布局属性, 默认 NO
@property (nonatomic, assign) BOOL isCustomViewport;
///webview固定大小
@property (nonatomic, assign) CGSize currentWebViewSize;

///根据URL前缀判断是否(显示上导航栏、可缩放、可旋转),默认(不显示上导航栏、不可缩放、不可旋转);
+ (id)webViewUrl:(NSString *)urlAdd;
///根据URL前缀判断是否(显示上导航栏、可缩放、可旋转),默认(显示上导航栏、不可缩放、不可旋转); aTitle 网页标题，isDocumentTitle 是否使用网页标题;
+ (id)webViewUrl:(NSString *)urlAdd withTitle:(NSString *)aTitle isDocumentTitle:(BOOL)isDocumentTitle;
///根据URL前缀判断是否(显示上导航栏、可缩放、可旋转),默认(显示上导航栏、不可缩放、不可旋转); aTitle 网页标题，isDocumentTitle 是否使用网页标题，aLeftBarTitle 返回按钮文字，isShare 默认显示 "分享"，isSetFont 默认显示 "设置字体大小"，refreshTitle "刷新按钮"文字或图片，isRefresh 默认显示 "刷新" ;
+ (id)webViewUrl:(NSString *)urlAdd withTitle:(NSString *)aTitle isDocumentTitle:(BOOL)isDocumentTitle leftBarTitle:(NSString *)aLeftBarTitle isShare:(BOOL)isShare isSetFont:(BOOL)isSetFont refreshImage:(NSString *)refreshImage isRefresh:(BOOL)isRefresh;

///加载网址, aUrl: 为nil 则刷新当前webview, 不为nil 则使用当前地址刷新webview;
- (void)reloadWebViewUrl:(NSString *)aUrl;
///还原WebView, aUrl: 为nil 则使用初始地址, 不为nil 则使用当前地址;
- (void)recoverWebViewUrl:(NSString *)aUrl;
///删除内部WebView减少内存消耗
- (void)deleteWebView;
///禁止webView长按手势 isOpen: YES 禁止, NO 不禁止
- (void)longPressSwitch:(BOOL)isOpen;
@end
