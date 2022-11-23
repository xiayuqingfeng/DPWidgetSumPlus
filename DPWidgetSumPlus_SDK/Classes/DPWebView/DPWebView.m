//
//  DPWebView.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import "DPWebView.h"
#import "DPWidgetSumPlus.h"
#import "CustomBannerOrJsEvent.h"

//请求超时时间
#define TimeoutInterval 20.0f

@interface DPWebView()<WKUIDelegate,WKNavigationDelegate> {
    
}
@property (nonatomic, strong) CustomBannerOrJsEvent *jsEvent;
@property (nonatomic, weak) UINavigationController *nav;
@property (nonatomic, weak) UIViewController *vc;
@end
@implementation DPWebView
- (void)dealloc {
    if (self.aRemoveFromSuperviewBlock) {
        self.aRemoveFromSuperviewBlock = nil;
    }
    if (self.scrollView) {
        self.scrollView.delegate = nil;
    }
    if (self.UIDelegate) {
        self.UIDelegate = nil;
    }
    if (self.navigationDelegate) {
        self.navigationDelegate = nil;
    }
    
    if (self.startProvisionalNavigationBlock) {
        self.startProvisionalNavigationBlock = nil;
    }
    if (self.didFinishNavigationBlock) {
        self.didFinishNavigationBlock = nil;
    }
    if (self.failNavigationBlock) {
        self.failNavigationBlock = nil;
    }
    if (self.failProvisionalNavigationBlock) {
        self.failProvisionalNavigationBlock = nil;
    }
    if (self.decidePolicyForNavigationActionBlock) {
        self.decidePolicyForNavigationActionBlock = nil;
    }
    if (self.urlIllegalBlock) {
        self.urlIllegalBlock = nil;
    }
    if (self.urlRedirectBlock) {
        self.urlRedirectBlock = nil;
    }
}
- (instancetype)initWithFrame:(CGRect)frame pushNavigationVC:(UINavigationController *)nav vc:(UIViewController *)vc {
    //WKWebView注入默认Script, 屏幕禁止缩放、滑动手势, 网页宽度固定位屏幕宽度; 需要修改当前设置项, 需要删除在[WKWebView loadRequest]前调用[WKUserContentController removeAllUserScripts];
    NSString *jScript;
    if ([[UIDevice currentDevice] systemVersion].doubleValue < 9.0) {
        jScript = @"var script = document.createElement('meta');"
        "script.name = 'viewport';"
        "script.content=\"width=100%, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, viewport-fit=cover\";"
        "document.getElementsByTagName('head')[0].appendChild(script);";
    }else{
        jScript = @"var script = document.createElement('meta');"
        "script.name = 'viewport';"
        "script.content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, viewport-fit=cover\";"
        "document.getElementsByTagName('head')[0].appendChild(script);";
    }
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.allowsInlineMediaPlayback = YES;
    wkWebConfig.userContentController = wkUController;
    
    self = [super initWithFrame:frame configuration:wkWebConfig];
    if (self) {
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.UIDelegate = self;
        self.navigationDelegate = self;
        
        self.nav = nav;
        self.vc = vc;
        self.isUrlIllegal = YES;
        self.isUrlRedirect = YES;
        
        //监控JS事件
        self.jsEvent = [[CustomBannerOrJsEvent alloc]init];
        [self.jsEvent jsH5:self delegate:self pushNavigationVC:self.nav vc:self.vc];
    }
    return self;
}

#pragma mark <--------------系统函数-------------->
- (void)removeFromSuperview {
    [super removeFromSuperview];
    if (self.aRemoveFromSuperviewBlock) {
        self.aRemoveFromSuperviewBlock(self);
    }
}
#pragma mark <--------------外部调用函数-------------->
//加载地址，默认：网络地址
- (void)loadRequestURLStr:(NSString *)str {
    [self loadRequestURLStr:str type:DPLoadRequestURL];
}
//加载地址，type：加载类型DPWebViewLoadType
- (void)loadRequestURLStr:(NSString *)str type:(DPWebViewLoadType)type {
    //访问地址为空，访问失败
    if (str.length < 1) {
        if (self.failProvisionalNavigationBlock) {
            NSError *error = [NSError errorWithDomain:@"访问地址为空！" code:DPWebViewErrorNilUrl userInfo:nil];
            self.failProvisionalNavigationBlock(self, nil, error);
        }
        return;
    }
    //区分访问类型
    if (type == DPLoadRequestURL) {
        [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"https"];
        NSMutableString *urlStr = [NSMutableString stringWithString:str];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TimeoutInterval];
        [self loadRequest:request];
    }else if (type == DPLoadHTMLString) {
        [self loadHTMLString:str baseURL:nil];
    }
}
//加载本地bundle中的html，处理iOS8图片资源不加载问题
- (void)loadLocalHtmlWithFolderName:(NSString *)folderName htmlName:(NSString *)htmlName {
    NSString *bundlePath = [[NSBundle mainBundle]pathForResource:folderName ofType:nil];
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 9) {
        NSString *path = NSTemporaryDirectory();
        path = [path stringByAppendingPathComponent:folderName];
        NSFileManager *fm = [NSFileManager defaultManager];
        NSError *error = nil;
        BOOL is = YES;
        if (![fm fileExistsAtPath:path]) {
            is = [fm copyItemAtPath:bundlePath toPath:path error:&error];
        }
        if (is) {
            path = [path stringByAppendingPathComponent:htmlName];
            [self loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
        }
    }else{
        NSString *bundlePath = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@/%@",folderName,htmlName] ofType:nil];
        [self loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:bundlePath]]];
    }
}
//刷新当前WebView拥有的控制器，重定向push根控制器
- (void)updateCurrentViewController:(UIViewController *)aViewController navigationVC:(UINavigationController *)aNavigationVC {
    if (aViewController) {
        self.vc = aViewController;
    }
    if (aNavigationVC) {
        self.nav = aNavigationVC;
    }
    [self.jsEvent updateCurrentViewController:self.vc navigationVC:self.nav];
}
//App浏览器缓存清理；type：0 清理h5不能操作的缓存数据，1 清理(除WKWebsiteDataTypeLocalStorage_h5数据持久化方式)意外所有的缓存数据，aHostArray：指定域名，为空清除所有缓存；
+ (void)clearCacheForType:(NSInteger)type hostArray:(NSArray <NSString *>*)aHostArray successBlock:(void (^)(id aData))successBlock {
    if ([UIDevice currentDevice].systemVersion.intValue >= 9.0) {
        NSSet<NSString *> *types = nil;
        if (type == 0) {
            types = [[NSSet alloc] initWithArray:@[
                WKWebsiteDataTypeDiskCache,
                WKWebsiteDataTypeOfflineWebApplicationCache,
                WKWebsiteDataTypeMemoryCache
            ]];
        }else if (type == 1) {
            NSMutableArray *list = [NSMutableArray arrayWithCapacity:10];
            if (@available(iOS 11.3, *)) {
                [list addObjectsFromArray:@[
                    WKWebsiteDataTypeFetchCache,
                    WKWebsiteDataTypeServiceWorkerRegistrations
                ]];
            }
            [list addObjectsFromArray:@[
                WKWebsiteDataTypeDiskCache,
                WKWebsiteDataTypeMemoryCache,
                WKWebsiteDataTypeOfflineWebApplicationCache,
                WKWebsiteDataTypeCookies,
                WKWebsiteDataTypeSessionStorage,
                WKWebsiteDataTypeWebSQLDatabases,
                WKWebsiteDataTypeIndexedDBDatabases
            ]];
            types = [[NSSet alloc] initWithArray:list];
        }
        WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
        [dateStore fetchDataRecordsOfTypes:types completionHandler:^(NSArray<WKWebsiteDataRecord *> * __nonnull records) {
            if (aHostArray.count > 0) {
                //清除指定域名缓存
                for (WKWebsiteDataRecord *record in records) {
                    for (NSString *host in aHostArray) {
                        if ([record.displayName containsString:host]) {
                            [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes forDataRecords:@[record] completionHandler:^{
                                NSLog(@"WebviewClearCacheSuccessfullyForType: %@",record.displayName);
                            }];
                        }
                    }
                }
            }else {
                //清除所有缓存
                for (WKWebsiteDataRecord *record in records) {
                    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes forDataRecords:@[record] completionHandler:^{
                        NSLog(@"WebviewClearCacheSuccessfullyForType: %@",record.displayName);
                    }];
                }
            }
        }];
    }else {
        NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
        NSString *bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        
        NSError *error;
        
        //磁盘缓存
        NSString *webKitDiskCache = [NSString stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryPath,bundleId];
        BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:webKitDiskCache];
        if (result) {
            [[NSFileManager defaultManager] removeItemAtPath:webKitDiskCache error:&error];
        }
        
        //查询数据库
        NSString *webkitWebSQLDatabasesPath = [NSString stringWithFormat:@"%@/WebKit/%@/WebSQL",libraryPath,bundleId];
        result = [[NSFileManager defaultManager] fileExistsAtPath:webkitWebSQLDatabasesPath];
        if (result) {
            [[NSFileManager defaultManager] removeItemAtPath:webkitWebSQLDatabasesPath error:&error];
        }
        
        //IndexedDB数据库
        NSString *webkitIndexedDBDatabasesPath = [NSString stringWithFormat:@"%@/WebKit/%@/IndexedDB",libraryPath,bundleId];
        result = [[NSFileManager defaultManager] fileExistsAtPath:webkitIndexedDBDatabasesPath];
        if (result) {
            [[NSFileManager defaultManager] removeItemAtPath:webkitIndexedDBDatabasesPath error:&error];
        }
        
        //会话存储
        NSString *webkitSessionStoragePath = [NSString stringWithFormat:@"%@/WebKit/%@/SessionStorage",libraryPath,bundleId];
        result = [[NSFileManager defaultManager] fileExistsAtPath:webkitSessionStoragePath];
        if (result) {
            [[NSFileManager defaultManager] removeItemAtPath:webkitSessionStoragePath error:&error];
        }
        
        //Cookies
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        result = [[NSFileManager defaultManager] fileExistsAtPath:cookiesFolderPath];
        if (result) {
            [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&error];
        }
        
        if (!error) {
            if (successBlock) {
                successBlock(nil);
            }
            NSLog(@"WKWebview 清理缓存成功!");
        }
    }
}

#pragma mark <--------------WKWebViewDelegate------------->
//页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    if (self.startProvisionalNavigationBlock) {
        self.startProvisionalNavigationBlock(self, navigation);
    }
}
//当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
}
//页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    self.isHaveDidFinish = YES;
    
    if (self.didFinishNavigationBlock) {
        self.didFinishNavigationBlock(self);
    }
}
//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (error.code == 102) {
        return;
    }
    if (self.failProvisionalNavigationBlock) {
        self.failProvisionalNavigationBlock(self, navigation, error);
    }
}
//页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (error.code != 102) {
        if (self.failProvisionalNavigationBlock) {
            self.failProvisionalNavigationBlock(self, navigation, error);
        }
    }
}
//在发送请求之前，决定是否跳转 (用户点击网页上的链接，需要打开新页面时，将先调用这个方法。)
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"\nWebView当前网页加载地址:%@\n",navigationAction.request.URL.absoluteString);
    
    //标记页面资源加载完成。每次网页加载新地址时,当前值修改为NO(未加载完成),JS事件通知次改为YES(加载完成);
    self.webloadfinish = NO;
    
    //webview缓存清理：url下发时间大于app本地存储时间，清理网页缓存，否则不作处理。url下发时间字段为0，强制清理网页缓存。
    NSURL *aUrl = navigationAction.request.URL;
    NSString *aUrlStr = navigationAction.request.URL.absoluteString;
    
    //浏览器URLScheme 打开AppStore商店
    if ([navigationAction.request.URL.absoluteString containsString:@"//itunes.apple.com/"]) {
        if ([[UIApplication sharedApplication] canOpenURL:navigationAction.request.URL]) {
            [UIApplication dp_openURL:navigationAction.request.URL options:@{} completionHandler:nil];
        } else {
            [DPTool showToastMsg:@"未找到AppStore软件！"];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    //浏览器URLScheme 打电话
    if ([[aUrl scheme] isEqualToString:@"tel"]) {
        if ([[UIApplication sharedApplication] canOpenURL:aUrl]) {
            [UIApplication dp_openURL:aUrl options:@{} completionHandler:nil];
        } else {
            [DPTool showToastMsg:@"未找到电话软件！"];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    //浏览器URLScheme 打开qq，用来接收临时消息的客服QQ号码(注意此QQ号需开通QQ推广功能,否则陌生人向他发送消息会失败)
    if ([[aUrl scheme] isEqualToString:@"mqq"]) {
        if([[UIApplication sharedApplication] canOpenURL:aUrl]) {
            [UIApplication dp_openURL:aUrl options:@{} completionHandler:nil];
        } else {
            [DPTool showToastMsg:@"未安装QQ客户端！"];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    //浏览器URLScheme 打开支付宝支付（三方支付，迷惑字符串处理）
    NSString *strategyOne = @"ali$pays";
    strategyOne = [strategyOne stringByReplacingOccurrencesOfString:@"$" withString:@""];
    NSString *strategyTow = @"ali$pay";
    strategyTow = [strategyTow stringByReplacingOccurrencesOfString:@"$" withString:@""];
    NSString *strategyThree = @"ali$pay://ali$payclient/?";
    strategyThree = [strategyThree stringByReplacingOccurrencesOfString:@"$" withString:@""];
    if ([[aUrl scheme] isEqualToString:strategyOne] || [[aUrl scheme] isEqualToString:strategyTow]) {
        NSString *urlString = [aUrlStr dp_urlDecodedString];
        urlString = [urlString stringByReplacingOccurrencesOfString:strategyOne withString:@"yqylqy"];
        urlString = [urlString stringByReplacingOccurrencesOfString:strategyTow withString:@"yqylqy"];
        if ([urlString hasPrefix:strategyThree]) {
            NSRange rang = [urlString rangeOfString:strategyThree];
            NSString *subString = [urlString substringFromIndex:rang.location+rang.length];
            NSString *encodedString = [strategyThree stringByAppendingString:[subString dp_urlEncodedString]];
            aUrl = [NSURL URLWithString:encodedString];
        }
        if ([[UIApplication sharedApplication] canOpenURL:aUrl]) {
            [UIApplication dp_openURL:aUrl options:@{} completionHandler:nil];
        } else {
            [DPTool showToastMsg:@"未安装支付宝客户端！"];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    //浏览器URLScheme 打开微信支付（三方支付，迷惑字符串处理）
    NSString *strategyFive = @"wei$xin";
    strategyFive = [strategyFive stringByReplacingOccurrencesOfString:@"$" withString:@""];
    NSString *strategySix = @"未安装微信客户端！";
    strategySix = [strategySix stringByReplacingOccurrencesOfString:@"$" withString:@""];
    if ([[aUrl scheme] isEqualToString:strategyFive]) {
        if ([[UIApplication sharedApplication] canOpenURL:aUrl]) {
            [UIApplication dp_openURL:aUrl options:@{} completionHandler:nil];
        } else {
            [DPTool showToastMsg:strategySix];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    //浏览器微信支付链接拦截，截取支付链接、重定向链接、微信商户签名，发起环信微信支付处理（三方支付，迷惑字符串处理）
    NSString *strategySeven = @"https://w$x.ten$pay.com";
    strategySeven = [strategySeven stringByReplacingOccurrencesOfString:@"$" withString:@""];
    if ([aUrlStr hasPrefix:strategySeven] && ([aUrlStr containsString:@"?Referer="] || [aUrlStr containsString:@"&Referer="])) {
        //截取微信支付商户签名 Referer= 后缀参数
        NSString *payUrl = [NSString stringWithString:aUrlStr];
        NSRange refererRange = [payUrl rangeOfString:@"?Referer="];
        if (refererRange.length < 1) {
            refererRange = [payUrl rangeOfString:@"&Referer="];
        }
        if (refererRange.length) {
            NSString *refererUrl = [payUrl substringFromIndex:refererRange.location+refererRange.length];
            if ([refererUrl containsString:@"&"]) {
                NSRange strRange = [refererUrl rangeOfString:@"&"];
                refererUrl = [refererUrl substringToIndex:strRange.location];
            }else if ([refererUrl containsString:@"?"]) {
                NSRange strRange = [refererUrl rangeOfString:@"?"];
                refererUrl = [refererUrl substringToIndex:strRange.location];
            }
            payUrl = [payUrl substringToIndex:refererRange.location];
            
            //截取微信支付重定向地址 redirect_url= 后缀参数
            NSRange redirectRange = [payUrl rangeOfString:@"&redirect_url="];
            if (redirectRange.length < 1) {
                redirectRange = [payUrl rangeOfString:@"?redirect_url="];
            }
            NSString *redirectUrl = @"";
            if (redirectRange.length) {
                redirectUrl = [payUrl substringFromIndex:redirectRange.location+redirectRange.length];
                if ([redirectUrl containsString:@"&"]) {
                    NSRange strRange = [redirectUrl rangeOfString:@"&"];
                    redirectUrl = [redirectUrl substringToIndex:strRange.location];
                }else if ([redirectUrl containsString:@"?"]) {
                    NSRange strRange = [redirectUrl rangeOfString:@"?"];
                    redirectUrl = [redirectUrl substringToIndex:strRange.location];
                }
                payUrl = [payUrl substringToIndex:redirectRange.location];
            }
            
            //新建浏览器，隐藏浏览器加载支付链接，唤醒微信客户端
            DPWebView *payWebView = [[DPWebView alloc] initWithFrame:self.bounds pushNavigationVC:nil vc:nil];
            payWebView.hidden = YES;
            payWebView.isUrlIllegal = NO;
            payWebView.isUrlRedirect = NO;
            dp_arc_block(payWebView);
            payWebView.didFinishNavigationBlock = ^(DPWebView *webView) {
                if (weak_payWebView) {
                    weak_payWebView.hidden = YES;
                }
            };
            payWebView.failNavigationBlock = ^(DPWebView *webView, WKNavigation *navigation, NSError *error) {
                if (weak_payWebView) {
                    weak_payWebView.hidden = YES;
                }
                [DPTool showToastMsg:@"唤醒微信客户端失败！"];
            };
            payWebView.failProvisionalNavigationBlock = ^(DPWebView *webView, WKNavigation *navigation, NSError *error) {
                if (weak_payWebView) {
                    weak_payWebView.hidden = YES;
                }
                [DPTool showToastMsg:@"唤醒微信客户端失败！"];
            };
            [self.superview insertSubview:payWebView atIndex:0];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:payUrl]];
            [request setValue:[NSString stringWithFormat:@"%@://",[NSURL URLWithString:refererUrl].host] forHTTPHeaderField:@"Referer"];
            [payWebView loadRequest:request];
            
            //判断重定向地址长度
            if (redirectUrl.length) {
                //原有浏览器，加载重定向地址 redirectUrl
                aUrlStr = redirectUrl;
            }else {
                //原有浏览器，停止加载
                decisionHandler(WKNavigationActionPolicyCancel);
                return;
            }
        }
    }
    
    //清理网页缓存(非JS事件,通过url拼接字段判断)
    NSString *clearCacheWebTimeKey = @"clearCacheWebTime=";
    if ([aUrlStr containsString:clearCacheWebTimeKey] && [aUrlStr containsString:@"?"]) {
        NSRange urlStrRange = [aUrlStr rangeOfString:@"?"];
        aUrlStr = [aUrlStr substringFromIndex:urlStrRange.location+urlStrRange.length];
        NSArray *parameterArray = [aUrlStr componentsSeparatedByString:@"&"];
        NSString *newClearCacheWebTime = @"";
        for (NSString *parameterStr in parameterArray) {
            if ([parameterStr containsString:clearCacheWebTimeKey]) {
                NSRange timeRange = [parameterStr rangeOfString:clearCacheWebTimeKey];
                newClearCacheWebTime = [parameterStr substringFromIndex:timeRange.location+timeRange.length];
                break;
            }
        }
        
        NSString *oldClearCacheWebTime = [NSUserDefaults dp_stringForKey:clearCacheWebTimeKey];
        if (newClearCacheWebTime.length > 0) {
            if ([newClearCacheWebTime isEqualToString:@"0"]) {
                [DPWebView clearCacheForType:0 hostArray:nil successBlock:nil];
            }else {
                if (oldClearCacheWebTime.length < 1) {
                    [NSUserDefaults dp_setObject:newClearCacheWebTime forKey:clearCacheWebTimeKey];
                    [DPWebView clearCacheForType:0 hostArray:nil successBlock:nil];
                }else if (newClearCacheWebTime.integerValue > oldClearCacheWebTime.integerValue) {
                    [NSUserDefaults dp_setObject:newClearCacheWebTime forKey:clearCacheWebTimeKey];
                    [DPWebView clearCacheForType:0 hostArray:nil successBlock:nil];
                }
            }
        }
    }
    
    //非法Url，禁止访问
    if (_isUrlIllegal && (self.urlIllegalBlock || DPSMDate.urlIllegalBlock)) {
        BOOL urlIllegalBool = YES;
        if (self.urlIllegalBlock) {
            urlIllegalBool = self.urlIllegalBlock(self, navigationAction, aUrlStr);
        }else if (DPSMDate.urlIllegalBlock) {
            urlIllegalBool = DPSMDate.urlIllegalBlock(self, navigationAction, aUrlStr);
        }
        if (urlIllegalBool == NO) {
            NSLog(@"\nWebView当前网页加载地址_非法:%@\n",aUrlStr);
            decisionHandler(WKNavigationActionPolicyCancel);
            
            //访问地址地址，访问失败
            if (self.failProvisionalNavigationBlock) {
                NSError *aError = [NSError errorWithDomain:@"访问地址非法！" code:DPWebViewErrorIllegalUrl userInfo:nil];
                self.failProvisionalNavigationBlock(self, nil, aError);
            }
            return;
        }
    }
    
    //重定向Url，修改当前访问地址，再次访问
    //WKNavigationTypeLinkActivated,点击链接
    //WKNavigationTypeFormSubmitted,提交表单
    //WKNavigationTypeBackForward,点击前进或返回按钮
    //WKNavigationTypeReload,点击重新加载按钮
    //WKNavigationTypeFormResubmitted,重新提交表单
    //WKNavigationTypeOther = -1,发生其它行为
    
    //WKNavigationActionPolicyCancel,允许跳转
    //WKNavigationActionPolicyAllow,不允许跳转
    if ((navigationAction.navigationType == WKNavigationTypeLinkActivated ||
         navigationAction.navigationType == WKNavigationTypeReload ||
         navigationAction.navigationType == WKNavigationTypeOther) &&
        navigationAction.targetFrame.isMainFrame) {
        if (_isUrlRedirect && (self.urlRedirectBlock || DPSMDate.urlRedirectBlock)) {
            NSString *newUrl = @"";
            if (self.urlRedirectBlock) {
                newUrl = self.urlRedirectBlock(self, navigationAction, aUrlStr);
            }else if (DPSMDate.urlRedirectBlock) {
                newUrl = DPSMDate.urlRedirectBlock(self, navigationAction, aUrlStr);
            }
            
            if (newUrl != nil && newUrl.length > 0) {
                decisionHandler(WKNavigationActionPolicyCancel);
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:newUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TimeoutInterval];
                [self loadRequest:request];
                return;
            }
        }
    }
    
    //在发送请求之前，决定是否跳转 (用户点击网页上的链接，需要打开新页面时，将先调用这个方法。)
    if (self.decidePolicyForNavigationActionBlock) {
        if (self.decidePolicyForNavigationActionBlock(self, navigationAction)  == WKNavigationActionPolicyCancel) {
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    
    //标记，当前网页是否二级页面
    if (navigationAction.navigationType == WKNavigationTypeBackForward) {
        _isGoBack = YES;
    }else{
        _isGoBack = NO;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
//主机地址被重定向时调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}
//信任https接口
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, card);
    }
}
@end
