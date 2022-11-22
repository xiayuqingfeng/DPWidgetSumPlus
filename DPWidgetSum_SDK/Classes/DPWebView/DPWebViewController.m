//
//  DPWebViewController.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import "DPWebViewController.h"
#import "DPWidgetSum.h"
#import "DPRefreshTableViewObject.h"
#import "DPDefaultView.h"
//#import "DPShareView.h"

@interface DPWebViewController () {
    
}
///长按屏蔽手势
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
///loading加载框
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
///"关闭"按钮
@property (nonatomic, strong) UIButton *closeBtn;
///"刷新"按钮
@property (nonatomic, strong) UIButton *refreshBtn;
///"分享"按钮
@property (nonatomic, strong) UIButton *shareBtn;
///"文字大小设置、屏幕亮度设置"按钮
@property (nonatomic, strong) UIButton *setBtn;
///"文字大小设置、屏幕亮度设置"弹框
@property (nonatomic, strong) UIView *corverView;
/////"分享"弹框
//@property (nonatomic, strong) DPShareView *shareView;

///初始网址
@property (nonatomic, strong) NSString *originalUrl;
///加载中网址
@property (nonatomic, strong) NSString *currentUrl;
///当前网址加载结束网址
@property (nonatomic, strong) NSString *lastUrlString;

///分享的 title
@property (nonatomic, strong) NSString *shareTitleStr;
///分享的 content
@property (nonatomic, strong) NSString *contentShareStr;

///leftBarTitle: 导航栏"返回"按钮文字
@property (nonatomic, strong) NSString *leftBarTitle;
///"导航栏标题" 全局变量
@property (nonatomic, strong) NSString *navBarTitle;
///refreshImage: "刷新按钮"图片
@property (nonatomic, strong) NSString *refreshImage;

///isNavBar: YES 有上导航栏, NO 没有上导航栏, 默认 YES
@property (nonatomic, assign) BOOL isNavBar;
///isDocumentTitle: YES 使用网页title, NO 使用自定义title, 默认 YES
@property (nonatomic, assign) BOOL isDocumentTitle;
///是否显示 "刷新" 全局变量
@property (nonatomic, assign) BOOL isRefresh;
///是否显示 "设置字体大小"  全局变量
@property (nonatomic, assign) BOOL isSetFont;
///是否显示 "分享" 全局变量
@property (nonatomic, assign) BOOL isShare;
///isAdaptive:YES 支持缩放, NO 不支持缩放, 默认 NO
@property (nonatomic, assign) BOOL isAdaptive;


@end

@implementation DPWebViewController
///根据URL前缀判断是否(显示上导航栏、可缩放、可旋转),默认(不显示上导航栏、不可缩放、不可旋转);
+ (id)webViewUrl:(NSString *)urlAdd{
    if ([urlAdd hasPrefix:shujufenxiHasPrefix]) {
        urlAdd = [urlAdd stringByReplacingOccurrencesOfString:shujufenxiHasPrefix withString:@""];
    }
    if (![urlAdd hasPrefix:url_hasPrefix_webwindow] &&
        ![urlAdd hasPrefix:url_hasPrefix_webwindowRotate] &&
        ![urlAdd hasPrefix:url_hasPrefix_webRotate] &&
        ![urlAdd hasPrefix:url_hasPrefix_web]){
        urlAdd = [NSString stringWithFormat:@"%@%@",url_hasPrefix_webwindow,urlAdd];
    }
    DPWebViewController *vc = [[self alloc] initWithUrl:urlAdd navBarTitle:nil isDocumentTitle:NO leftBarTitle:nil isShare:NO isSetFont:NO refreshImage:@"refresh_ic.png" isRefresh:NO];
    return vc;
}
///根据URL前缀判断是否(显示上导航栏、可缩放、可旋转),默认(显示上导航栏、不可缩放、不可旋转); aTitle 网页标题，isDocumentTitle 是否使用网页标题;
+ (id)webViewUrl:(NSString *)urlAdd withTitle:(NSString *)aTitle isDocumentTitle:(BOOL)isDocumentTitle{
    DPWebViewController *vc = [[self alloc] initWithUrl:urlAdd navBarTitle:aTitle isDocumentTitle:isDocumentTitle leftBarTitle:nil isShare:NO isSetFont:NO refreshImage:@"refresh_ic.png" isRefresh:NO];
    return vc;
}
///根据URL前缀判断是否(显示上导航栏、可缩放、可旋转),默认(显示上导航栏、不可缩放、不可旋转); aTitle 网页标题，isDocumentTitle 是否使用网页标题，aLeftBarTitle 返回按钮文字，isShare 默认显示 "分享"，isSetFont 默认显示 "设置字体大小"  ，isRefresh 默认显示 "刷新" ;
+ (id)webViewUrl:(NSString *)urlAdd withTitle:(NSString *)aTitle isDocumentTitle:(BOOL)isDocumentTitle leftBarTitle:(NSString *)aLeftBarTitle isShare:(BOOL)isShare isSetFont:(BOOL)isSetFont refreshImage:(NSString *)refreshImage isRefresh:(BOOL)isRefresh{
    DPWebViewController *vc = [[self alloc] initWithUrl:urlAdd navBarTitle:aTitle isDocumentTitle:isDocumentTitle leftBarTitle:aLeftBarTitle isShare:isShare isSetFont:isSetFont refreshImage:refreshImage isRefresh:isRefresh];
    return vc;
}

- (id)initWithUrl:(NSString *)urlAdd navBarTitle:(NSString *)aNavBarTitle isDocumentTitle:(BOOL)isDocumentTitle leftBarTitle:(NSString *)aLeftBarTitle isShare:(BOOL)isShare isSetFont:(BOOL)isSetFont refreshImage:(NSString *)refreshImage isRefresh:(BOOL)isRefresh{
    if (self = [super init]) {
        if ([urlAdd hasPrefix:shujufenxiHasPrefix]) {
            urlAdd = [urlAdd stringByReplacingOccurrencesOfString:shujufenxiHasPrefix withString:@""];
        }
        urlAdd = [self urlCustomFunction:urlAdd];
        
        self.originalUrl = urlAdd;
        self.navBarTitle = aNavBarTitle;
        self.isDocumentTitle = isDocumentTitle;
        self.leftBarTitle = aLeftBarTitle;
        self.refreshImage = refreshImage;
        self.isRefresh = isRefresh;
        self.isShare = isShare;
        self.isSetFont = isSetFont;
        self.isNeedSession = YES;
        self.isCustomViewport = YES;
        
        UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithTitle:aLeftBarTitle style:UIBarButtonItemStylePlain target:self action:@selector(leftBackBtnAction:)];
        if (leftBar && [leftBar respondsToSelector:@selector(setTintColor:)]) {
            [leftBar setTintColor:[UIColor clearColor]];
        }
        if (_leftBarTitle.length > 0) {
            [self.leftBackBtn setTitle:_leftBarTitle forState:UIControlStateNormal];
        }
    }
    return self;
}

#pragma mark <--------------View lifecycle-------------->
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    if (dp_isNotNil(_currentWebView)) {
        [self deleteWebView];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
#ifdef AppLoginSuccess
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:AppLoginSuccess object:nil];
#endif
#ifdef AppLogOutSuccess
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutSuccess:) name:AppLogOutSuccess object:nil];
#endif
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
//    if (_isNavBar) {
//        self.navBarView.hidden = NO;
//        self.titleLabel.numberOfLines = 1;
//        self.titleLabel.adjustsFontSizeToFitWidth = NO;
//        self.titleLabel.text = _navBarTitle;
//    }else{
        self.navBarView.hidden = YES;
//    }
    
    self.contentView.shouldResignOnTouchOutside = NO;

    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setFrame:CGRectMake(self.leftBackBtn.dp_xMax, DP_StatusbarHeight, 45, self.navBarView.dp_height-DP_StatusbarHeight)];
    _closeBtn.hidden = YES;
    _closeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    [_closeBtn setImage:[UIImage imageNamed:@"close_normal.png"] forState:UIControlStateNormal];
    _closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_closeBtn addTarget:self action:@selector(leftBackBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:_closeBtn];
    
    self.refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _refreshBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    _refreshBtn.tag = 102;
    _refreshBtn.hidden = !_isRefresh;
    if (_refreshImage != nil) {
        [_refreshBtn setFrame:CGRectMake(DP_ScreenWidth-DP_FrameWidth(10)-DP_FrameWidth(20), DP_StatusbarHeight, DP_FrameWidth(20), self.navBarView.dp_height-DP_StatusbarHeight)];
        [_refreshBtn setImage:[UIImage imageNamed:_refreshImage] forState:UIControlStateNormal];
    }else {
        [_refreshBtn setFrame:CGRectMake(DP_ScreenWidth-DP_FrameWidth(10)-DP_FrameWidth(35), DP_StatusbarHeight, DP_FrameWidth(35), self.navBarView.dp_height-DP_StatusbarHeight)];
        _refreshBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _refreshBtn.titleLabel.font = DP_Font(14);
        [_refreshBtn setTitleColor:DP_RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
        [_refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
    }
    [_refreshBtn addTarget:self action:@selector(rigthBtns:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:_refreshBtn];
    
    self.setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _setBtn.frame = CGRectMake(DP_ScreenWidth-DP_FrameWidth(22), DP_StatusbarHeight, DP_FrameWidth(22), self.navBarView.dp_height-DP_StatusbarHeight);
    _setBtn.tag = 100;
    _setBtn.hidden = !_isSetFont;
    _setBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    _setBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_setBtn setImage:[UIImage imageNamed:@"set_ic.png"] forState:UIControlStateNormal];
    [_setBtn addTarget:self action:@selector(rigthBtns:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:_setBtn];

    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareBtn setFrame:CGRectMake(DP_ScreenWidth-DP_FrameWidth(20)*2, DP_StatusbarHeight, DP_FrameWidth(20), self.navBarView.dp_height-DP_StatusbarHeight)];
    _shareBtn.tag = 101;
    _shareBtn.hidden = !_isShare;
    _shareBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    _shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_shareBtn setImage:[UIImage imageNamed:@"share_ic"] forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(rigthBtns:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:_shareBtn];

    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorView.center = CGPointMake(self.contentView.dp_width/2, self.contentView.dp_height/2);
    _activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _activityIndicatorView.color = [UIColor darkGrayColor];
    _activityIndicatorView.hidden = YES;
    [self.contentView addSubview:_activityIndicatorView];
    
    [self createWebView];
}
- (void)rigthBtns:(UIButton*)btn{
//    if (btn.tag == 100) {
//        if (_corverView.superview == nil) {
//            [_shareView removeFromSuperview];
//            _corverView = [self createBrightnessView];
//        }else{
//            [_corverView removeFromSuperview];
//        }
//    }else if (btn.tag == 101) {
//        if (_shareView.superview == nil) {
//            [_corverView removeFromSuperview];
//            [self umShareViewSelecter];
//        }else{
//            [_shareView removeFromSuperview];
//        }
//    }else if (btn.tag == 102) {
//        [_corverView removeFromSuperview];
//        [_shareView removeFromSuperview];
//        [_currentWebView reload];
//    }
}

#pragma mark <--------------基类函数-------------->
- (void)leftBackBtnAction:(id)sender{
    if (_currentWebView.canGoBack) {
        [_currentWebView goBack];
        if (!self.isHiddenBackBtn) {
            self.closeBtn.hidden = NO;
        }
        
        dp_arc_block(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //不增加延迟调用无效
            NSString *javascriptCommand = [NSString stringWithFormat:@"zhcw_change_webview_status()"];
            [weak_self.currentWebView evaluateJavaScript:javascriptCommand completionHandler:^(id _Nullable data, NSError *_Nullable error) {
                if (error) {
                    NSLog(@"错误:%@", error.localizedDescription);
                }
            }];
        });
    }else {
        [self deleteWebView];
        [super leftBackBtnAction:sender];
    }
    
    //页面中心和时间状态栏的loading框显示状态
    [self setLoadingState:NO];
}

#pragma mark <--------------本类公共函数-------------->
//页面中心和时间状态栏的loading框显示状态
- (void)setLoadingState:(BOOL)isLoading{
    if (self.contentView == nil || _activityIndicatorView == nil) {
        return;
    }
    
    if(isLoading){
        //状态栏的网络活动标志
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        //页面中心loading
        _activityIndicatorView.hidden = NO;
        [_activityIndicatorView startAnimating];
        [self.contentView bringSubviewToFront:_activityIndicatorView];
    }else{
        //状态栏的网络活动标志
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        //页面中心loading
        _activityIndicatorView.hidden = YES;
        [_activityIndicatorView stopAnimating];
    }
}
- (NSString *)getURLAppendSessionId{
    if (dp_isNullString(_originalUrl)) {
        return @"";
    }
    NSMutableString *tmpUrlAddress = [NSMutableString stringWithString:_originalUrl];
    if([tmpUrlAddress hasPrefix:@"www."]){
        [tmpUrlAddress insertString:@"http://" atIndex:0];
    }

    return tmpUrlAddress;
}
//url前缀参数识别、截取
- (NSString *)urlCustomFunction:(NSString *)urlAdd{
    if ([urlAdd hasPrefix:shujufenxiHasPrefix]) {
        //跳转事件、URL前缀,服务器使用,客户端删除
        urlAdd = [urlAdd stringByReplacingOccurrencesOfString:shujufenxiHasPrefix withString:@""];
    }
    if ([urlAdd hasPrefix:url_hasPrefix_webwindow]){
        //URL前缀_打开新的浏览器(不显示上导航栏、不可旋转、不可缩放)
        urlAdd = [urlAdd stringByReplacingOccurrencesOfString:url_hasPrefix_webwindow withString:@""];
        self.isNavBar = NO;
        self.isAdaptive = NO;
        self.isAutorotateBase = NO;
    }else if ([urlAdd hasPrefix:url_hasPrefix_webwindowRotate]){
        //URL前缀_打开新的浏览器(不显示上导航栏、可旋转、可缩放)
        urlAdd = [urlAdd stringByReplacingOccurrencesOfString:url_hasPrefix_webwindowRotate withString:@""];
        self.isNavBar = NO;
        self.isAdaptive = YES;
        self.isAutorotateBase = YES;
    }else if ([urlAdd hasPrefix:url_hasPrefix_webRotate]){
        //URL前缀_打开新的浏览器(显示上导航栏、可旋转、可缩放)
        urlAdd = [urlAdd stringByReplacingOccurrencesOfString:url_hasPrefix_webRotate withString:@""];
        self.isNavBar = YES;
        self.isAdaptive = YES;
        self.isAutorotateBase = YES;
    }else if ([urlAdd hasPrefix:url_hasPrefix_web]){
        //URL前缀_打开新的浏览器(显示上导航栏、不可旋转、不可缩放)
        urlAdd = [urlAdd stringByReplacingOccurrencesOfString:url_hasPrefix_web withString:@""];
        self.isNavBar = YES;
        self.isAdaptive = NO;
        self.isAutorotateBase = NO;
    }else{
        //URL无前缀_打开新的浏览器(显示上导航栏、不可旋转、不可缩放)
        self.isNavBar = YES;
        self.isAdaptive = NO;
        self.isAutorotateBase = NO;
    }
    return urlAdd;
}

#pragma mark <--------------Notification-------------->
- (void)loginSuccess:(NSNotification *)notification {
    //登录成功,清除全部缓存(防止webview缓存登录状态被使用)
    [DPWebView clearCacheForType:1 hostArray:nil successBlock:nil];
    [self recoverWebViewUrl:nil];
}
- (void)logOutSuccess:(NSNotification *)notification {
    //退出登录,清除全部缓存(防止webview缓存登录状态被使用)
    [DPWebView clearCacheForType:1 hostArray:nil successBlock:nil];
    [self recoverWebViewUrl:nil];
}
- (void)keyboardWillShow:(NSNotification *)notification {
    //键盘出现，控制视图上移
    if (_currentWebView) {
        NSDictionary *userInfo = [notification userInfo];
        NSValue* value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [value CGRectValue];
        _currentWebView.dp_height = self.contentView.dp_height - keyboardRect.size.height;
    }
}
- (void)keyboardWillHide:(NSNotification *)notification {
    //键盘移除，控制视图还原
    if (_currentWebView) {
        _currentWebView.dp_height = self.contentView.dp_height;
    }
}

#pragma mark <--------------CreateWebView-------------->
- (void)createWebView{
    if (dp_isNotNil(_currentWebView)) {
        [self deleteWebView];
    }
    if(dp_isNil(self.contentView)){
        return;
    }

    dp_arc_block(self);
    self.currentWebView = [[DPWebView alloc] initWithFrame:self.contentView.bounds pushNavigationVC:self.navigationController vc:self];
    if (self.currentWebViewSize.width>0 && self.currentWebViewSize.height>0) {
        self.currentWebView.dp_size = self.currentWebViewSize;
    }
    _currentWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    //WKWebView注入默认Script, 屏幕禁止缩放、滑动手势, 网页宽度固定位屏幕宽度; 需要修改当前设置项, 需要删除在[WKWebView loadRequest]前调用[WKUserContentController removeAllUserScripts];
    [_currentWebView.configuration.userContentController removeAllUserScripts];
    _currentWebView.isUrlIllegal = _isUrlIllegal;
    _currentWebView.isUrlRedirect = _isUrlRedirect;
    _currentWebView.didFinishNavigationBlock = ^(WKWebView * _Nonnull webView) {
        //结束下拉刷新
        [weak_self.currentWebView.scrollView dpRefreshHeaderFinish];
        
        //页面加载完成之后调用
        [weak_self webViewFinishLoad:webView];
    };
    _currentWebView.failNavigationBlock = ^(DPWebView *webView, WKNavigation *_Nonnull navigation, NSError *_Nonnull error) {
        //结束下拉刷新
        [weak_self.currentWebView.scrollView dpRefreshHeaderFinish];
        
        //提交发生错误时调用
        [weak_self webView:weak_self.currentWebView FailLoadWithError:error];
    };
    _currentWebView.failProvisionalNavigationBlock = ^(DPWebView *webView, WKNavigation *_Nonnull navigation, NSError *_Nonnull error) {
        //结束下拉刷新
        [weak_self.currentWebView.scrollView dpRefreshHeaderFinish];
        
        //页面加载失败时调用
        [weak_self webView:weak_self.currentWebView FailLoadWithError:error];
    };
    _currentWebView.decidePolicyForNavigationActionBlock = ^(DPWebView *webView, WKNavigationAction *_Nonnull navigation) {
        //结束下拉刷新
        [weak_self.currentWebView.scrollView dpRefreshHeaderFinish];
        
        //在发送请求之前，决定是否跳转 (用户点击网页上的链接，需要打开新页面时，将先调用这个方法。)
        return [weak_self decidePolicyForNavigationAction:navigation];
    };
    if (@available(iOS 11.0, *)) {
        _currentWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _currentWebView.scrollView.scrollsToTop = YES;
    [self.contentView addSubview:_currentWebView];
    
    //添加下拉刷新 默认不启用
    [self.currentWebView.scrollView dpRefreshHeaderAdd:^(DPRefreshTableHeaderView *aObject) {
        [weak_self.currentWebView reload];
    }];
    [self.currentWebView.scrollView dpRefreshHeaderEnabled:NO];
    
    //页面中心和时间状态栏的loading框显示状态
    [self setLoadingState:YES];

    //webvie发起请求
    [_currentWebView loadRequestURLStr:[self getURLAppendSessionId]];
}

#pragma mark <--------------WKWebViewDelegate-------------->
///页面加载完成之后调用
- (void)webViewFinishLoad:(WKWebView *)webView{
    //浏览器加载完成，隐藏"加载失败默认背景(浏览器显示为空白页时)"
    [self showDefaulWithSuperView:nil useType:1 dataCount:1 btnBlock:nil];
    
    dp_arc_block(self);
    if (self.isHiddenBackBtn == YES) {
        if (_currentWebView.canGoBack == YES) {
            self.leftBackBtn.hidden = NO;
        }else{
            self.leftBackBtn.hidden = YES;
        }
    }
    NSString *path = path = [[NSBundle mainBundle] pathForResource:@"webView" ofType:@"txt"];
    NSString *str = [NSFileManager dp_jsonStringForPath:path];
    if (str) {
        [_currentWebView evaluateJavaScript:str completionHandler:nil];
    }

    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    [webView.scrollView setContentSize:CGSizeMake(actualSize.width, actualSize.height)];
    
    NSString *meta = @"";
    if (_isAdaptive) {
        if (_isCustomViewport) {
            meta = [NSString stringWithFormat:@"var script = document.createElement('meta');"
            "script.name = 'viewport';"
            "script.content = \"minimum-scale = 0.5, maximum-scale = 1.5, initial-scale = 1.0, width = %f, user-scalable = no\";"
            "document.getElementsByTagName('head')[0].appendChild(script);",_currentWebView.dp_width];
        }
    }else {
        if ( [[UIDevice currentDevice] systemVersion].doubleValue < 9.0) {
            meta = @"var script = document.createElement('meta');"
            "script.name = 'viewport';"
            "script.content = \"width = 100%, user-scalable = no\";"
            "document.getElementsByTagName('head')[0].appendChild(script);";
        }else {
            meta = @"var script = document.createElement('meta');"
            "script.name = 'viewport';"
            "script.content = \"width = device-width, user-scalable = no\";"
            "document.getElementsByTagName('head')[0].appendChild(script);";
        }
    }
    [_currentWebView evaluateJavaScript:meta completionHandler:nil];
    
    self.lastUrlString = _currentWebView.URL.absoluteString;
    [_currentWebView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust = '100%'" completionHandler:nil];
    
    [_currentWebView evaluateJavaScript:[NSString stringWithFormat:@"<html><head><style type = \"text/css\">body{font-family:\"%@\";}</style></head></html>", @"Helvetica-Light"] completionHandler:nil];

    //使用网页Title
    if (_isDocumentTitle) {
        [_currentWebView evaluateJavaScript:@"$('show_title').html()" completionHandler:^(id _Nullable data, NSError *_Nullable error) {
            if (error) {
                NSLog(@"使用网页Title_错误:%@", error.localizedDescription);
            }else{
                NSString *show_title = dp_notEmptyStr(data);
                if (![show_title isEqualToString:@"1"]) {
                    [weak_self.currentWebView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable data, NSError *_Nullable error) {
                        if (error) {
                            NSLog(@"错误:%@", error.localizedDescription);
                        }else{
                            weak_self.titleLabel.text = dp_notEmptyStr(data);
                        }
                    }];
                }else{
                    weak_self.titleLabel.text = @"";
                }
            }
        }];
    }
    
    //导航栏右上角"分享按钮"、"设置按钮"显示状态
    _setBtn.hidden = !_isSetFont;
    _shareBtn.hidden = !_isShare;
    _refreshBtn.hidden = !_isRefresh;
    [_currentWebView evaluateJavaScript:@"$('power_num').html()" completionHandler:^(id _Nullable data, NSError *_Nullable error) {
        if (error) {
            NSLog(@"导航栏右上角'分享按钮'、'设置按钮'显示状态_错误:%@", error.localizedDescription);
        }else{
            NSString *isShareAndSetFont = dp_notEmptyStr(data);
            if ([isShareAndSetFont integerValue] == 1) {
                //设置字体
                weak_self.setBtn.dp_x = weak_self.navBarView.dp_width-weak_self.setBtn.dp_width-DP_FrameWidth(10);
                weak_self.setBtn.hidden = NO;
                weak_self.shareBtn.hidden = YES;
                weak_self.refreshBtn.hidden = YES;
            }else if ([isShareAndSetFont integerValue] == 2) {
                //设置分享
                weak_self.setBtn.hidden = YES;
                weak_self.shareBtn.dp_x = weak_self.navBarView.dp_width-weak_self.shareBtn.dp_width-DP_FrameWidth(10);
                weak_self.shareBtn.hidden = NO;
                weak_self.refreshBtn.hidden = YES;
            }else if ([isShareAndSetFont integerValue] == 3) {
                //设置字体与分享
                weak_self.setBtn.dp_x = self.navBarView.dp_width-weak_self.setBtn.dp_width-DP_FrameWidth(10);
                weak_self.setBtn.hidden = NO;
                weak_self.shareBtn.dp_x = weak_self.setBtn.dp_x-weak_self.shareBtn.dp_width-DP_FrameWidth(10);
                weak_self.shareBtn.hidden = NO;
                weak_self.refreshBtn.hidden = YES;
            }else if ([isShareAndSetFont integerValue] == 4) {
                //显示刷新按钮
                weak_self.setBtn.hidden = YES;
                weak_self.shareBtn.hidden = YES;
                weak_self.refreshBtn.hidden = NO;
                weak_self.refreshBtn.dp_x = weak_self.navBarView.dp_width-weak_self.refreshBtn.dp_width-DP_FrameWidth(10);
            }
        }
    }];
    
    //"下拉刷新"模块显示状态, 默认不启用
    [self.currentWebView.scrollView dpRefreshHeaderEnabled:YES];
    [_currentWebView evaluateJavaScript:@"$('refresh_type').html()" completionHandler:^(id _Nullable data, NSError *_Nullable error) {
        if (error) {
            NSLog(@"网页下拉刷新功能，启用状态_错误:%@", error.localizedDescription);
        }else{
            NSString *isShareAndSetFont = dp_notEmptyStr(data);
            if ([isShareAndSetFont integerValue] == 1) {
                //启用下拉刷新
                [weak_self.currentWebView.scrollView dpRefreshHeaderEnabled:NO];
            }else if ([isShareAndSetFont integerValue] == 2) {
                //不启用下拉刷新
                [weak_self.currentWebView.scrollView dpRefreshHeaderEnabled:YES];
            }
        }
    }];
    
    //"屏幕旋转"启用状态, 默认不启用(基类UIBaseViewController默认设置不启用屏幕旋转)
    [_currentWebView evaluateJavaScript:@"$('webViewRotate_type').html()" completionHandler:^(id _Nullable data, NSError *_Nullable error) {
        if (error) {
            NSLog(@"屏幕旋转，启用状态_错误:%@", error.localizedDescription);
        }else{
            NSString *isShareAndSetFont = dp_notEmptyStr(data);
            if ([isShareAndSetFont integerValue] == 1) {
                //开启屏幕旋转
                self.isAutorotateBase = YES;
            }else if ([isShareAndSetFont integerValue] == 2) {
                //关闭屏幕旋转
                self.isAutorotateBase = NO;
                [self mandatoryRotationWithIsAutorotateBase:NO supportedInterfaceOrientationsBase:UIInterfaceOrientationMaskPortrait orientation:UIInterfaceOrientationPortrait];
            }
        }
    }];
    
    //获取第三方平台分享标题
    [_currentWebView evaluateJavaScript:@"$('fx_title').html()" completionHandler:^(id _Nullable data, NSError *_Nullable error) {
        if (error) {
            NSLog(@"获取第三方平台分享标题_错误:%@", error.localizedDescription);
        }else{
            weak_self.shareTitleStr = dp_notEmptyStr(data);
            if (weak_self.shareTitleStr == nil || weak_self.shareTitleStr.length == 0) {
                weak_self.shareTitleStr = @"有球有料分享，最新最全的彩票资讯";
            }
        }
    }];
    
    //获取第三方平台分享内容
    NSString *javascriptCommand = @"document.getElementsByName(\"description\")[0].content";
    [_currentWebView evaluateJavaScript:javascriptCommand completionHandler:^(id _Nullable data, NSError *_Nullable error) {
        if (error) {
              weak_self.contentShareStr = weak_self.shareTitleStr;
            NSLog(@"获取第三方平台分享内容_错误:%@", error.localizedDescription);
        }else{
            weak_self.contentShareStr = dp_notEmptyStr(data);
            if (weak_self.contentShareStr.length == 0 || weak_self.contentShareStr == nil) {
                weak_self.contentShareStr = weak_self.shareTitleStr;
            }
        }
    }];

    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([[def objectForKey:@"fontValue"] length]>0) {
        [self sendMessage:[def objectForKey:@"fontValue"]];
    }

    //页面中心和时间状态栏的loading框显示状态
    [self setLoadingState:NO];
}
///在发送请求之前，决定是否跳转 (用户点击网页上的链接，需要打开新页面时，将先调用这个方法。)
- (WKNavigationActionPolicy)decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction{
    //页面中心和时间状态栏的loading框显示状态
    if (navigationAction.navigationType != WKNavigationTypeOther){
        [self setLoadingState:YES];
    }

    NSURL *requestURL = navigationAction.request.URL;
    NSString *urlStr = requestURL.absoluteString;
    if ([requestURL.scheme isEqualToString:@"videohandler"]) {
        if ([[requestURL absoluteString]isEqualToString:@"videohandler://video-beginfullscreen"]) {
            self.statusBarHiddenBase = YES;
            [self mandatoryRotationWithIsAutorotateBase:YES supportedInterfaceOrientationsBase:UIInterfaceOrientationMaskAllButUpsideDown orientation:UIInterfaceOrientationPortrait];
        }else{
            self.statusBarHiddenBase = NO;
            [self mandatoryRotationWithIsAutorotateBase:YES supportedInterfaceOrientationsBase:UIInterfaceOrientationMaskAllButUpsideDown orientation:UIInterfaceOrientationPortrait];
        }
        return WKNavigationActionPolicyCancel;
    }
    
    //清空网页Title
    if (_isDocumentTitle) {
        self.titleLabel.text = @"";
    }
    if (navigationAction.targetFrame.isMainFrame) {
            self.currentUrl = urlStr;
    }

    if([urlStr containsString:@"#"]){
        if(dp_isNotNil(_lastUrlString)){
            NSString *preLastURL = [[_lastUrlString componentsSeparatedByString:@"#"] firstObject];
            if([urlStr hasPrefix:preLastURL]){
                [_currentWebView stopLoading];
                [_currentWebView evaluateJavaScript:[NSString stringWithFormat:@"<a id = '%@'>%@</a>",urlStr,urlStr] completionHandler:nil];
                [_currentWebView evaluateJavaScript:[NSString stringWithFormat:@"document.getElementById('%@').scrollIntoView()",urlStr] completionHandler:nil];
            }
        }
    }
    return WKNavigationActionPolicyAllow;
}
///提交发生错误时调用 || 页面加载失败时调用
- (void)webView:(WKWebView *)webView FailLoadWithError:(NSError *)error{
    if (self.isHiddenBackBtn == YES) {
        if (_currentWebView.canGoBack == YES) {
            self.leftBackBtn.hidden = NO;
        }else{
            self.leftBackBtn.hidden = YES;
        }
    }
    
    //当前浏览器从未加载成功，显示"加载失败默认背景(浏览器显示为空白页时)"
    if (error.code != NSURLErrorCancelled && !_currentWebView.isHaveDidFinish) {
        NSString *aDetails = @"";
        if (error.code == DPWebViewErrorNilUrl) {
            aDetails = @"访问地址为空";
        }else if (error.code == DPWebViewErrorIllegalUrl) {
            aDetails = @"访问地址非法";
        }
        
        NSInteger aType = 0;
        if (self.navBarView.hidden == YES && _isHomePage == NO) {
            aType = 1;
        }
        
        dp_arc_block(self);
        [self showDefaulWithSuperView:nil useType:1 dataCount:0 btnBlock:^(DPDefaultView *aObject, NSInteger selectIndex) {
            if (selectIndex == 0) {
                [weak_self leftBackBtnAction:nil];
            }else if (selectIndex == 1) {
                if (dp_isNullString(weak_self.currentWebView.URL.absoluteString)) {
                    //页面中心和时间状态栏的loading框显示状态
                    [weak_self setLoadingState:YES];

                    [weak_self.currentWebView loadRequestURLStr:[weak_self getURLAppendSessionId]];
                }else {
                    [weak_self.currentWebView reload];
                }
            }
        }];
    }
    
    //页面中心和时间状态栏的loading框显示状态
    [self setLoadingState:NO];
}

#pragma mark <--------------外部调用函数-------------->
///加载网址, aUrl: 为nil 则刷新当前webview, 不为nil 则使用当前地址刷新webview;
- (void)reloadWebViewUrl:(NSString *)aUrl{
    if (aUrl.length) {
        self.originalUrl = [self urlCustomFunction:aUrl];
    }
    
    //页面中心和时间状态栏的loading框显示状态
    [self setLoadingState:YES];
    
    [_currentWebView loadRequestURLStr:[self getURLAppendSessionId]];
}
///还原WebView, aUrl: 为nil 则使用初始地址, 不为nil 则使用当前地址;
- (void)recoverWebViewUrl:(NSString *)aUrl{
    if (aUrl.length) {
        self.originalUrl = [self urlCustomFunction:aUrl];
    }
    
    if ([UIDevice currentDevice].systemVersion.intValue < 9.0) {
        //队列执行KWKWebview的删除、创建动作，防止闪退。
        //dispatch_async是添加异步任务的，添加任务的时候会立即返回，不管block里面的代码是否执行。
        dispatch_queue_t queue = dispatch_queue_create("current queue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queue, ^{
            [self deleteWebView];
        });
        dispatch_async(queue, ^{
            [self createWebView];
        });
    }else{
        [self deleteWebView];
        [self createWebView];
    }
}
///删除内部WebView减少内存消耗
- (void)deleteWebView{
    //页面中心和时间状态栏的loading框显示状态
    [self setLoadingState:NO];
    
    if (_currentWebView) {
        [_currentWebView stopLoading];
        if (_currentWebView.superview) {
            [_currentWebView removeFromSuperview];
        }
    }
}
///禁止webView长按手势 isOpen: YES 禁止, NO 不禁止
- (void)longPressSwitch:(BOOL)isOpen{
    if (!_longPress) {
        //只要大于0.5就无效，大概是因为默认的跳出放大镜的手势的长按时间是0.5秒，如果我们自定义的手势大于或小于0.5秒
        self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:nil];
        _longPress.minimumPressDuration = 0.45f;
    }
    
    if (isOpen) {
        [_currentWebView addGestureRecognizer:_longPress];
    }else{
        [_currentWebView removeGestureRecognizer:_longPress];
    }
}

#pragma mark <--------------文字大小设置、屏幕亮度设置-------------->
- (UIView*)createBrightnessView{
    UIView* corverView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navBarView.dp_height, self.view.dp_width, self.view.dp_height-self.navBarView.dp_height)];
    corverView.backgroundColor = [[UIColor dp_hexToColor:@"000000"] colorWithAlphaComponent:0.5];
    corverView.alpha = 0;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(corverTapAction)];
    [corverView addGestureRecognizer:tap];
    corverView.tag = 500;
    [self.view addSubview:corverView];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, corverView.dp_width, 110)];
    view.backgroundColor = [UIColor whiteColor];
    [corverView addSubview:view];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(DP_Font(13).lineHeight, 20, 100, 25)];
    label.text = @"正文字号";
    label.textColor = [UIColor dp_hexToColor:@"000033"];
    label.font = DP_Font(15);
    CGSize size = [label sizeThatFits:label.dp_size];
    label.dp_width = size.width;
    [view addSubview:label];
    CGFloat w = (view.dp_width-label.dp_xMax-10-8*2-DP_Font(13).lineHeight)/3;
    for (int i = 0; i<3; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0) {
            [btn setTitle:@"小" forState:UIControlStateNormal];
            btn.titleLabel.font = DP_Font(15);
        }else if (i == 1) {
            [btn setTitle:@"中" forState:UIControlStateNormal];
            btn.titleLabel.font = DP_Font(16);
        }else if (i == 2) {
            [btn setTitle:@"大" forState:UIControlStateNormal];
            btn.titleLabel.font = DP_Font(20);
        }
        [btn setTitleColor:[UIColor dp_hexToColor:@"000033"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor dp_hexToColor:@"000033"] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor dp_hexToColor:@"242F5F"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor dp_hexToColor:@"242F5F"] forState:UIControlStateSelected | UIControlStateHighlighted];
        
        btn.frame = CGRectMake(label.dp_xMax+10+(8+w)*i, 20, w, 25);
        btn.layer.cornerRadius = btn.dp_height/2;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor dp_hexToColor:@"cccccc"].CGColor;
        [view addSubview:btn];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(setFontBtns:) forControlEvents:UIControlEventTouchUpInside];
    }
    UILabel* label2 = [[UILabel alloc]initWithFrame:label.frame];
    label2.text = @"亮度调节";
    label2.textColor = [UIColor dp_hexToColor:@"000033"];
    label2.font = DP_Font(15);
    label2.dp_y = label.dp_yMax+25;
    [view addSubview:label2];
    
    w = (view.dp_width-label2.dp_xMax-10-DP_Font(13).lineHeight);
    UISlider* slider = [[UISlider alloc]initWithFrame:CGRectMake(label2.dp_xMax+10, label2.dp_y, w, label2.dp_height)];
    [slider setMinimumTrackImage:[UIImage imageNamed:@"news_regu_line@2x"] forState:UIControlStateNormal];
    [slider setThumbImage:[UIImage imageNamed:@"news_regu_btn"] forState:UIControlStateNormal];
    slider.minimumValue = 0.f;
    slider.maximumValue = 1.f;
    slider.value = [UIScreen mainScreen].brightness;
    [slider addTarget:self action:@selector(slider:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:slider];

    [UIView beginAnimations:nil context:nil];
    corverView.alpha = 1;
    [UIView commitAnimations];
    
    UIButton *smbtn = (UIButton *)[view viewWithTag:100];
    UIButton *nobtn = (UIButton *)[view viewWithTag:101];
    UIButton *bigbtn = (UIButton *)[view viewWithTag:102];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([[def objectForKey:@"fontValue"] length]>0) {
        if ([[def objectForKey:@"fontValue"] isEqualToString:@"small"]) {
            smbtn.selected = YES;
            smbtn.layer.borderColor = [UIColor dp_hexToColor:@"242F5F"].CGColor;
            nobtn.selected = NO;
            nobtn.layer.borderColor = [UIColor dp_hexToColor:@"cccccc"].CGColor;
            bigbtn.selected = NO;
            bigbtn.layer.borderColor = [UIColor dp_hexToColor:@"cccccc"].CGColor;
        }else if ([[def objectForKey:@"fontValue"] isEqualToString:@"norma"]) {
            smbtn.selected = NO;
            smbtn.layer.borderColor = [UIColor dp_hexToColor:@"cccccc"].CGColor;
            nobtn.selected = YES;
            nobtn.layer.borderColor = [UIColor dp_hexToColor:@"242F5F"].CGColor;
            bigbtn.selected = NO;
            bigbtn.layer.borderColor = [UIColor dp_hexToColor:@"cccccc"].CGColor;
        }else if ([[def objectForKey:@"fontValue"] isEqualToString:@"big"]) {
            smbtn.selected = NO;
            smbtn.layer.borderColor = [UIColor dp_hexToColor:@"cccccc"].CGColor;
            nobtn.selected = NO;
            nobtn.layer.borderColor = [UIColor dp_hexToColor:@"cccccc"].CGColor;
            bigbtn.selected = YES;
            bigbtn.layer.borderColor = [UIColor dp_hexToColor:@"242F5F"].CGColor;
        }
    }else{
        smbtn.selected = NO;
        smbtn.layer.borderColor = [UIColor dp_hexToColor:@"cccccc"].CGColor;
        nobtn.selected = YES;
        nobtn.layer.borderColor = [UIColor dp_hexToColor:@"242F5F"].CGColor;
        bigbtn.selected = NO;
        bigbtn.layer.borderColor = [UIColor dp_hexToColor:@"cccccc"].CGColor;
    }
    return corverView;
}
//关闭当前功能模块
- (void)corverTapAction{
    [_corverView removeFromSuperview];
    _corverView = nil;
}
//设置字体大小
- (void)setFontBtns:(UIButton*)btn{
    UIButton *smbtn = (UIButton *)[btn.superview viewWithTag:100];
    UIButton *nobtn = (UIButton *)[btn.superview viewWithTag:101];
    UIButton *bigbtn = (UIButton *)[btn.superview viewWithTag:102];
    if (btn.tag == 100) {
        nobtn.selected = NO;
        nobtn.layer.borderColor = [UIColor dp_hexToColor:@"cccccc"].CGColor;
        bigbtn.selected = NO;
        bigbtn.layer.borderColor = [UIColor dp_hexToColor:@"cccccc"].CGColor;
        smbtn.selected = YES;
        smbtn.layer.borderColor = [UIColor dp_hexToColor:@"cccccc"].CGColor;
    }else if (btn.tag == 101) {
        smbtn.selected = NO;
        smbtn.layer.borderColor = [UIColor dp_hexToColor:@"cccccc"].CGColor;
        bigbtn.selected = NO;
        bigbtn.layer.borderColor = [UIColor dp_hexToColor:@"cccccc"].CGColor;
        nobtn.selected = YES;
        nobtn.layer.borderColor = [UIColor dp_hexToColor:@"cccccc"].CGColor;
    }else if (btn.tag == 102) {
        smbtn.selected = NO;
        smbtn.layer.borderColor = [UIColor dp_hexToColor:@"cccccc"].CGColor;
        nobtn.selected = NO;
        nobtn.layer.borderColor = [UIColor dp_hexToColor:@"cccccc"].CGColor;
        bigbtn.selected = YES;
        bigbtn.layer.borderColor = [UIColor dp_hexToColor:@"cccccc"].CGColor;
    }
 
    if (btn.tag == 100) {
        [self sendMessage:@"small"];
    }else if (btn.tag == 101) {
        [self sendMessage:@"norma"];
    }else if (btn.tag == 102) {
        [self sendMessage:@"big"];
    }
}
//JS调用修改字体大小
- (void)sendMessage:(NSString *)sender {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setValue:sender forKey:@"fontValue"];
    [def synchronize];
    
    NSString *javascriptCommand = [NSString stringWithFormat:@"zhcw_change_font_size('%@')",sender];
    [_currentWebView evaluateJavaScript:javascriptCommand completionHandler:^(id _Nullable data, NSError *_Nullable error) {
        if (error) {
            NSLog(@"错误:%@", error.localizedDescription);
        }
    }];
}
//设置系统屏幕的亮度值
- (void)slider:(UISlider*)slider{
    [[UIScreen mainScreen] setBrightness:slider.value];
}

#pragma mark <--------------ShareView-------------->
- (void)umShareViewSelecter{
//    DPShareDataObject *shareObject = [[DPShareDataObject alloc]init];
//    shareObject.image = [UIImage imageNamed:@"shareImage.png"];
//    shareObject.title = @"有球有料";
//    shareObject.text = @"赛程赛果实时更新；赛事情报轻松获悉，来这里有球更有料！";
//    shareObject.url = Key(@"YQBC2000094", @"http://yqyl.caiminbang1.com");
//    ShareViewContentType aShareContentType = DPShareContentTypeDefault;
//    _shareView = [DPShareView createShareView:self.view shareDataObject:shareObject contentType:aShareContentType currentVc:nil platformBack:nil callBack:nil];
}
@end

