//
//  DPSharedManager.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 zcw. All rights reserved.
//

#import "DPSharedManager.h"
#import "DPWidgetSumPlus.h"

@interface DPSharedManager (){
    
}
@property (nonatomic, copy) void(^currentBlock)(DPSharedManager *aObject);
@end

@implementation DPSharedManager
///单例获取
+ (DPSharedManager *)sharedManager {
    static DPSharedManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

#pragma mark - DPBaseViewController 基类样式自定义
///可重定义，上导航栏“背景” 样式
@synthesize navBarGB_viewStyle = _navBarGB_viewStyle;
- (void)setNavBarGB_viewStyle:(NSDictionary *)navBarGB_viewStyle {
    _navBarGB_viewStyle = navBarGB_viewStyle;
}
- (NSDictionary *)navBarGB_viewStyle {
    if (_navBarGB_viewStyle == nil) {
        return @{@"startColor":DP_RGBA(51, 105, 227, 1),
                 @"endColor":DP_RGBA(51, 105, 227, 1)};
    }
    return _navBarGB_viewStyle;
}

///可重定义，上导航栏“标题” 样式
@synthesize navBarTitle_labStyle = _navBarTitle_labStyle;
- (void)setNavBarTitle_labStyle:(NSDictionary *)navBarTitle_labStyle {
    _navBarTitle_labStyle = navBarTitle_labStyle;
}
- (NSDictionary *)navBarTitle_labStyle {
    if (_navBarTitle_labStyle == nil) {
        return @{@"font":DP_FontPFMedium(18),
                 @"titleColor":DP_RGBA(255, 255, 255, 1)};
    }
    return _navBarTitle_labStyle;
}

///可重定义，上导航栏“按钮” 样式
@synthesize navBarBack_btnStyle = _navBarBack_btnStyle;
- (void)setNavBarBack_btnStyle:(NSDictionary *)navBarBack_btnStyle {
    _navBarBack_btnStyle = navBarBack_btnStyle;
}
- (NSDictionary *)navBarBack_btnStyle {
    if (_navBarBack_btnStyle == nil) {
        UIImage *aImage = dp_BundleImageNamed(@"dp_base_back.png");
        return @{@"image":aImage ? aImage : @"",
                 @"bgColor":@"",
                 @"font":@"",
                 @"titleColor":@""};
    }
    return _navBarBack_btnStyle;
}

///可重定义，基类“主视图” 样式
@synthesize baseContent_viewStyle = _baseContent_viewStyle;
- (void)setBaseContent_viewStyle:(NSDictionary *)baseContent_viewStyle {
    _baseContent_viewStyle = baseContent_viewStyle;
}
- (NSDictionary *)baseContent_viewStyle {
    if (_baseContent_viewStyle == nil) {
        return @{@"bgColor":DP_RGBA(233, 233, 233, 1)};
    }
    return _baseContent_viewStyle;
}

///可重定义，基类“默认显示视图图片” 参数
@synthesize baseContent_imageValus = _baseContent_imageValus;
- (void)setBaseContent_imageValus:(NSDictionary *)baseContent_imageValus {
    _baseContent_imageValus = baseContent_imageValus;
}
- (NSDictionary *)baseContent_imageValus {
    if (_baseContent_imageValus == nil) {
        return @{@"imageOne":dp_BundleImageNamed(@"dp_no_failed.png"),
                 @"imageTow":dp_BundleImageNamed(@"dp_no_failed.png")};
    }
    return _baseContent_imageValus;
}

///可重定义，基类“默认显示视图文字” 参数
@synthesize baseContent_textValus = _baseContent_textValus;
- (void)setBaseContent_textValus:(NSDictionary *)baseContent_textValus {
    _baseContent_textValus = baseContent_textValus;
}
- (NSDictionary *)baseContent_textValus {
    if (_baseContent_textValus == nil) {
        return @{@"textOne":@"获取数据为空！",
                 @"textTow":@"网络请求失败啦！",
                 @"textThree":@"重新获取"};
    }
    return _baseContent_textValus;
}

#pragma mark - DPDefaultView 默认视图样式自定义
///可重定义，默认视图 “背景” 样式
@synthesize defaultViewBG_viewStyle = _defaultViewBG_viewStyle;
- (void)setDefaultViewBG_viewStyle:(NSDictionary *)defaultViewBG_viewStyle {
    _defaultViewBG_viewStyle = defaultViewBG_viewStyle;
}
- (NSDictionary *)defaultViewBG_viewStyle {
    if (_defaultViewBG_viewStyle == nil) {
        return @{@"bgColor":DP_RGBA(243, 243, 243, 1)};
    }
    return _defaultViewBG_viewStyle;
}

///可重定义，默认视图 “标题” 样式
@synthesize defaultViewTitle_labStyle = _defaultViewTitle_labStyle;
- (void)setDefaultViewTitle_labStyle:(NSDictionary *)defaultViewTitle_labStyle {
    _defaultViewTitle_labStyle = defaultViewTitle_labStyle;
}
- (NSDictionary *)defaultViewTitle_labStyle {
    if (_defaultViewTitle_labStyle == nil) {
        return @{@"font":DP_FontBold(18),
                 @"textColor":DP_RGBA(156, 156, 156, 1)};
    }
    return _defaultViewTitle_labStyle;
}

///可重定义，默认视图 “按钮” 样式
@synthesize defaultView_btnStyle = _defaultView_btnStyle;
- (void)setDefaultView_btnStyle:(NSDictionary *)defaultView_btnStyle {
    _defaultView_btnStyle = defaultView_btnStyle;
}
- (NSDictionary *)defaultView_btnStyle {
    if (_defaultView_btnStyle == nil) {
        return @{@"bgColor":DP_RGBA(36, 47, 95, 1),
                 @"font":DP_FontBold(16),
                 @"titleColor":DP_RGBA(255, 255, 255, 1),
                 @"borderColor":DP_RGBA(216, 216, 216, 1),
                 @"radius":@"5"};
    }
    return _defaultView_btnStyle;
}

#pragma mark - DPMessageAlertView 消息弹框样式自定义
///可重定义，消息弹框 “背景” 样式
@synthesize alertMsgGB_viewStyle = _alertMsgGB_viewStyle;
- (void)setAlertMsgGB_viewStyle:(NSDictionary *)alertMsgGB_viewStyle {
    _alertMsgGB_viewStyle = alertMsgGB_viewStyle;
}
- (NSDictionary *)alertMsgGB_viewStyle {
    if (_alertMsgGB_viewStyle == nil) {
        return @{@"bgColor":DP_RGBA(0, 0, 0, 0.5)};
    }
    return _alertMsgGB_viewStyle;
}

///可重定义，消息弹框 “中间父视图背景” 样式
@synthesize alertMsgCenter_viewStyle = _alertMsgCenter_viewStyle;
- (void)setAlertMsgCenter_viewStyle:(NSDictionary *)alertMsgCenter_viewStyle {
    _alertMsgCenter_viewStyle = alertMsgCenter_viewStyle;
}
- (NSDictionary *)alertMsgCenter_viewStyle {
    if (_alertMsgCenter_viewStyle == nil) {
        return @{@"bgColor":DP_RGBA(255, 255, 255, 1),
                 @"radius":@"10"};
    }
    return _alertMsgCenter_viewStyle;
}

///可重定义，消息弹框 “标题” 样式
@synthesize alertMsgTitle_labStyle = _alertMsgTitle_labStyle;
- (void)setAlertMsgTitle_labStyle:(NSDictionary *)alertMsgTitle_labStyle {
    _alertMsgTitle_labStyle = alertMsgTitle_labStyle;
}
- (NSDictionary *)alertMsgTitle_labStyle {
    if (_alertMsgTitle_labStyle == nil) {
        return @{@"font":DP_FontBold(18),
                 @"textColor":DP_RGBA(0, 0, 0, 1)};
    }
    return _alertMsgTitle_labStyle;
}

///可重定义，消息弹框 “详细内容” 样式
@synthesize alertMsgContent_labStyle = _alertMsgContent_labStyle;
- (void)setAlertMsgContent_labStyle:(NSDictionary *)alertMsgContent_labStyle {
    _alertMsgContent_labStyle = alertMsgContent_labStyle;
}
- (NSDictionary *)alertMsgContent_labStyle {
    if (_alertMsgContent_labStyle == nil) {
        return @{@"font":DP_Font(16),
                 @"textColor":DP_RGBA(0, 0, 0, 1)};
    }
    return _alertMsgContent_labStyle;
}

///可重定义，消息弹框 “按钮边框线” 样式
@synthesize alertMsgBtn_borderLineStyle = _alertMsgBtn_borderLineStyle;
- (void)setAlertMsgBtn_borderLineStyle:(NSDictionary *)alertMsgBtn_borderLineStyle {
    _alertMsgBtn_borderLineStyle = alertMsgBtn_borderLineStyle;
}
- (NSDictionary *)alertMsgBtn_borderLineStyle {
    if (_alertMsgBtn_borderLineStyle == nil) {
        return @{@"borderWidth":@"0.5",
                 @"bgColor":DP_RGBA(51, 105, 227, 1)};
    }
    return _alertMsgBtn_borderLineStyle;
}

///可重定义，消息弹框 “忽略按钮” 样式
@synthesize alertMsg_btnStyle = _alertMsg_btnStyle;
- (void)setAlertMsg_btnStyle:(NSDictionary *)alertMsg_btnStyle {
    _alertMsg_btnStyle = alertMsg_btnStyle;
}
- (NSDictionary *)alertMsg_btnStyle {
    if (_alertMsg_btnStyle == nil) {
        return @{@"bgColor":DP_RGBA(255, 255, 255, 1),
                 @"font":DP_FontBold(16),
                 @"titleColor":DP_RGBA(51, 105, 227, 1)};
    }
    return _alertMsg_btnStyle;
}

///可重定义，消息弹框 “引导按钮” 样式
@synthesize alertMsgOther_btnStyle = _alertMsgOther_btnStyle;
- (void)setAlertMsgOther_btnStyle:(NSDictionary *)alertMsgOther_btnStyle {
    _alertMsgOther_btnStyle = alertMsgOther_btnStyle;
}
- (NSDictionary *)alertMsgOther_btnStyle {
    if (_alertMsgOther_btnStyle == nil) {
        return @{@"bgColor":DP_RGBA(51, 105, 227, 1),
                 @"font":DP_FontBold(16),
                 @"titleColor":DP_RGBA(255, 255, 255, 1)};
    }
    return _alertMsgOther_btnStyle;
}

#pragma mark - DPInputBox 输入框样式自定义
///可重定义，输入框 “提示语、数字” 参数
@synthesize inputBox_textValus = _inputBox_textValus;
- (void)setInputBox_textValus:(NSDictionary *)inputBox_textValus {
    _inputBox_textValus = inputBox_textValus;
}
- (NSDictionary *)inputBox_textValus {
    if (_inputBox_textValus == nil) {
        return @{@"textOne":@"60",
                 @"textTow":@"最多输入?个字符$最多输入?个字",
                 @"textThree":@"输入字符不合法",
                 @"textFour":@"输入字符不合法",
                 @"textFive":@"输入字符串格式不合法",
                 @"textSix":@"60"};
    }
    return _inputBox_textValus;
}

#pragma mark - DPWebLoadFailView 默认视图样式自定义
///可重定义，基类“默认显示视图图片” 参数，默认值：getter逻辑获取
@synthesize webLoadFail_imageValus = _webLoadFail_imageValus;
- (void)setWebLoadFail_imageValus:(NSDictionary *)webLoadFail_imageValus {
    _webLoadFail_imageValus = webLoadFail_imageValus;
}
- (NSDictionary *)webLoadFail_imageValus {
    if (_webLoadFail_imageValus == nil) {
        return @{@"imageOne":dp_BundleImageNamed(@"dp_no_failed.png")};
    }
    return _webLoadFail_imageValus;
}

///可重定义，基类“默认显示视图标题” 样式，默认值：getter逻辑获取
@synthesize webLoadFailTitle_labStyle = _webLoadFailTitle_labStyle;
- (void)setWebLoadFailTitle_labStyle:(NSDictionary *)webLoadFailTitle_labStyle {
    _webLoadFailTitle_labStyle = webLoadFailTitle_labStyle;
}
- (NSDictionary *)webLoadFailTitle_labStyle {
    if (_webLoadFailTitle_labStyle == nil) {
        return @{@"font":DP_Font(16),
                 @"titleColor":[UIColor grayColor],
                 @"text":@"加载失败"};
    }
    return _webLoadFailTitle_labStyle;
}

///可重定义，基类“默认显示视图详情” 样式，默认值：getter逻辑获取
@synthesize webLoadFailDetails_labStyle = _webLoadFailDetails_labStyle;
- (void)setWebLoadFailDetails_labStyle:(NSDictionary *)webLoadFailDetails_labStyle {
    _webLoadFailDetails_labStyle = webLoadFailDetails_labStyle;
}
- (NSDictionary *)webLoadFailDetails_labStyle {
    if (_webLoadFailDetails_labStyle == nil) {
        return @{@"font":DP_Font(16),
                 @"titleColor":[UIColor grayColor],
                 @"text":@"请确定网络是否正常"};
    }
    return _webLoadFailDetails_labStyle;
}

///可重定义，基类“默认显示视图关闭按钮” 样式，默认值：getter逻辑获取
@synthesize webLoadFailClose_labStyle = _webLoadFailClose_labStyle;
- (void)setWebLoadFailClose_labStyle:(NSDictionary *)webLoadFailClose_labStyle {
    _webLoadFailClose_labStyle = webLoadFailClose_labStyle;
}
- (NSDictionary *)webLoadFailClose_labStyle {
    if (_webLoadFailClose_labStyle == nil) {
        return @{@"font":DP_Font(16),
                 @"titleColor":[UIColor blueColor],
                 @"text":@"  返回"};
    }
    return _webLoadFailClose_labStyle;
}

///可重定义，基类“默认显示视图刷新按钮” 样式，默认值：getter逻辑获取
@synthesize webLoadFailRefresh_labStyle = _webLoadFailRefresh_labStyle;
- (void)setWebLoadFailRefresh_labStyle:(NSDictionary *)webLoadFailRefresh_labStyle {
    _webLoadFailRefresh_labStyle = webLoadFailRefresh_labStyle;
}
- (NSDictionary *)webLoadFailRefresh_labStyle {
    if (_webLoadFailRefresh_labStyle == nil) {
        return @{@"font":DP_Font(16),
                 @"titleColor":[UIColor blueColor],
                 @"text":@"  刷新"};
    }
    return _webLoadFailRefresh_labStyle;
}

#pragma mark - DPShareView 基类样式自定义
///可重定义，分享弹框“背景” 样式，默认值：getter逻辑获取
@synthesize shareViewGB_viewStyle = _shareViewGB_viewStyle;
- (void)setShareViewGB_viewStyle:(NSDictionary *)shareViewGB_viewStyle {
    _shareViewGB_viewStyle = shareViewGB_viewStyle;
}
- (NSDictionary *)shareViewGB_viewStyle {
    if (_shareViewGB_viewStyle == nil) {
        return @{@"bgColor":DP_RGBA(0, 0, 0, 0.5)};
    }
    return _shareViewGB_viewStyle;
}

///可重定义，分享弹框“弹框父视图” 样式，默认值：getter逻辑获取
@synthesize shareViewCenter_viewStyle = _shareViewCenter_viewStyle;
- (void)setShareViewCenter_viewStyle:(NSDictionary *)shareViewCenter_viewStyle {
    _shareViewCenter_viewStyle = shareViewCenter_viewStyle;
}
- (NSDictionary *)shareViewCenter_viewStyle {
    if (_shareViewCenter_viewStyle == nil) {
        return @{@"bgColor":DP_RGBA(255, 255, 255, 1)};
    }
    return _shareViewCenter_viewStyle;
}

///可重定义，分享弹框“标题” 样式，默认值：getter逻辑获取
@synthesize shareViewTitle_labStyle = _shareViewTitle_labStyle;
- (void)setShareViewTitle_labStyle:(NSDictionary *)shareViewTitle_labStyle {
    _shareViewTitle_labStyle = shareViewTitle_labStyle;
}
- (NSDictionary *)shareViewTitle_labStyle {
    if (_shareViewTitle_labStyle == nil) {
        return @{@"font":DP_Font(16),
                 @"textColor":DP_RGBA(0, 0, 51, 1),
                 @"text":@"分享到"};
    }
    return _shareViewTitle_labStyle;
}

///可重定义，分享弹框 “顶部分割线” 样式，默认值：getter逻辑获取
@synthesize shareViewTop_borderLineStyle = _shareViewTop_borderLineStyle;
- (void)setShareViewTop_borderLineStyle:(NSDictionary *)shareViewTop_borderLineStyle {
    _shareViewTop_borderLineStyle = shareViewTop_borderLineStyle;
}
- (NSDictionary *)shareViewTop_borderLineStyle {
    if (_shareViewTop_borderLineStyle == nil) {
        return @{@"borderWidth":@"0.5",
                 @"bgColor":DP_RGBA(0, 0, 51, 1)};
    }
    return _shareViewTop_borderLineStyle;
}

///可重定义，基类“分享平台图片” 参数，默认值：getter逻辑获取
@synthesize shareView_imageValus = _shareView_imageValus;
- (void)setShareView_imageValus:(NSDictionary *)shareView_imageValus {
    _shareView_imageValus = shareView_imageValus;
}
- (NSDictionary *)shareView_imageValus {
    if (_shareView_imageValus == nil) {
        return @{@"imageOne":dp_BundleImageNamed(@"dp_friend_share.png"),
                 @"imageTow":dp_BundleImageNamed(@"dp_weixin_share.png"),
                 @"imageThree":dp_BundleImageNamed(@"dp_qqkj_share.png"),
                 @"imageFour":dp_BundleImageNamed(@"dp_qq_share.png"),
                 @"imageFive":dp_BundleImageNamed(@"dp_save_share.png"),
                 @"imageSix":dp_BundleImageNamed(@"dp_sinabolg_share.png")};
    }
    return _shareView_imageValus;
}
@end
