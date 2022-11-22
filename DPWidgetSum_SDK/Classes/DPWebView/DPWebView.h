//
//  DPWebView.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@class DPWebView;

///访问地址为空
#define DPWebViewErrorNilUrl -110110
///访问地址非法
#define DPWebViewErrorIllegalUrl -110111

typedef NS_ENUM(NSUInteger, DPWebViewLoadType) {
    DPLoadRequestURL,
    DPLoadHTMLString
};

///当前webview被删除
typedef void(^RemoveFromSuperviewBlock) (DPWebView *webView);
///页面加载完成之后调用
typedef void(^WebViewFinishBlock) (DPWebView *webView);
///页面加载失败时调用
typedef void(^WebViewFailProvisionalNavigationBlock) (DPWebView *webView, WKNavigation *navigation, NSError *error);
///提交发生错误时调用
typedef void(^WebViewFailNavigationBlock) (DPWebView *webView, WKNavigation *navigation, NSError *error);
///页面开始加载时调用
typedef void(^WebViewStartProvisionalNavigationBlock) (DPWebView *webView, WKNavigation *navigation);
///页面准备跳转
typedef WKNavigationActionPolicy(^WebViewdecidePolicyForNavigationActionBlock) (DPWebView *webView, WKNavigationAction *navigation);
///非法Url，禁止访问
typedef BOOL(^WebViewUrlIllegalBlock) (DPWebView *webView, WKNavigationAction *navigation, NSString *aUrlStr);
///重定向Url，修改当前访问地址，再次访问
typedef NSString *(^WebViewUrlRedirectBlock) (DPWebView *webView, WKNavigationAction *navigation, NSString *aUrlStr);

@interface DPWebView : WKWebView
///当前webview被删除
@property (nonatomic, copy) RemoveFromSuperviewBlock aRemoveFromSuperviewBlock;
///页面开始加载时调用
@property (nonatomic, copy) WebViewStartProvisionalNavigationBlock startProvisionalNavigationBlock;
///页面加载完成之后调用
@property (nonatomic, copy) WebViewFinishBlock didFinishNavigationBlock;
///提交发生错误时调用
@property (nonatomic, copy) WebViewFailNavigationBlock failNavigationBlock;
///页面加载失败时调用
@property (nonatomic, copy) WebViewFailProvisionalNavigationBlock failProvisionalNavigationBlock;
///在发送请求之前，决定是否跳转 (用户点击网页上的链接，需要打开新页面时，将先调用这个方法。)
@property (nonatomic, copy) WebViewdecidePolicyForNavigationActionBlock decidePolicyForNavigationActionBlock;
///非法Url，禁止访问
@property (nonatomic, copy) WebViewUrlIllegalBlock urlIllegalBlock;
///重定向Url，修改当前访问地址，再次访问
@property (nonatomic, copy) WebViewUrlRedirectBlock urlRedirectBlock;

///非法Url是否进行判断，默认：YES 进行非法Url限制;
@property (nonatomic, assign) BOOL isUrlIllegal;
///访问地址是否进行重定向处理，修改当前访问地址，默认：YES 进行重定向;
@property (nonatomic, assign) BOOL isUrlRedirect;
///标记页面资源加载完成。每次网页加载新地址时,当前值修改为NO(未加载完成),JS事件通知次改为YES(加载完成);
@property (nonatomic, assign) BOOL webloadfinish;
///当前网页是否二级页面
@property (nonatomic, assign) BOOL isGoBack;
///当前浏览器是否曾经加载成功，当前标记用于网页加载失败显示默认背景使用，默认 YES
@property (nonatomic, assign) BOOL isHaveDidFinish;

- (instancetype)initWithFrame:(CGRect)frame pushNavigationVC:(UINavigationController *)nav vc:(UIViewController *)vc;
///加载地址，默认：网络地址
- (void)loadRequestURLStr:(NSString *)str;
///加载地址，type：加载类型DPWebViewLoadType
- (void)loadRequestURLStr:(NSString *)str type:(DPWebViewLoadType)type;
///加载本地bundle中的html，处理iOS8图片资源不加载问题
- (void)loadLocalHtmlWithFolderName:(NSString *)folderName htmlName:(NSString *)htmlName;
///刷新当前WebView拥有的控制器，重定向push根控制器
- (void)updateCurrentViewController:(UIViewController *)aViewController navigationVC:(UINavigationController *)aNavigationVC;
///App浏览器缓存清理；type：0 清理h5不能操作的缓存数据，1 清理(除WKWebsiteDataTypeLocalStorage_h5数据持久化方式)意外所有的缓存数据，aHostArray：指定域名，为空清除所有缓存；
+ (void)clearCacheForType:(NSInteger)type hostArray:(NSArray <NSString *>*)aHostArray successBlock:(void (^)(id aData))successBlock;
@end
