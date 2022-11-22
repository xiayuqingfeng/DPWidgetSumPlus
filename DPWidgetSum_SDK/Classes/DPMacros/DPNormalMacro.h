//
//  DPNormalMacro.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright (c) 2021年 xiayupeng. All rights reserved.
//

#ifndef DPNormalMacro_h
#define DPNormalMacro_h

#pragma mark <--------------强弱引用处理-------------->
///弱引用类型，ARC模式使用，不可重新赋值，可以修饰对象，不可以修饰基本数据类型。
#ifndef dp_strong_object
#define dp_strong_object(x) __strong typeof(x) strong_##x = x;
#endif
///弱引用类型，ARC模式使用，不可重新赋值，可以修饰对象，不可以修饰基本数据类型。
#ifndef dp_weak_object
#define dp_weak_object(x) __weak typeof(x) weak_##x = x;
#endif
///强引用类型，ARC、MRC模式使用，可以修饰对象、基本数据类型。
#ifndef dp_block_object
#define dp_block_object(x) __block typeof(x) block_##x = x;
#endif
///防止循环引用，ARC、MRC模式使用，可以修饰对象、基本数据类型。
#ifndef dp_arc_block
#define dp_arc_block(x) __block typeof(x) __weak weak_##x = x;
#endif

#pragma mark <--------------快捷函数-------------->
///获取AppDelegate
#ifndef dp_AppDelegate
#define dp_AppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#endif
///获取bundle图片
#ifndef dp_BundleImageNamed
#define dp_BundleImageNamed(a) [UIImage imageNamed:a] != nil ? [UIImage imageNamed:a] : [UIImage dp_imageName:a bundleName:@"DPResources"]
#endif

#pragma mark <--------------layout-------------->
///屏幕高度
#ifndef DP_ScreenHeight
#define DP_ScreenHeight [UIScreen mainScreen].bounds.size.height
#endif
///屏幕宽度
#ifndef DP_ScreenWidth
#define DP_ScreenWidth [UIScreen mainScreen].bounds.size.width
#endif
///UI适配，以iphone6为基准,等比例缩放
#ifndef DP_FrameWidth
#define DP_FrameWidth(a) ((a)*(MIN(DP_ScreenWidth,DP_ScreenHeight)/375))
#endif
///UI适配，以iphone6为基准,等比例缩放
#ifndef DP_FrameHeight
#define DP_FrameHeight(a) DP_FrameWidth(a)
#endif
///边线frame(防止奇数像素点，出现分割线粗细不同)
#ifndef DP_LineScale
#define DP_LineScale(a) (a*[UIScreen mainScreen].scale)
#endif

#pragma mark <--------------font-------------->
///基础字体
#ifndef DP_Font
#define DP_Font(a)      DP_FontPFRegular(a)
#endif
///基础字体，粗体
#ifndef DP_FontBold
#define DP_FontBold(a)  DP_FontPFBold(a)
#endif
///平方字体，指定字体大小
#define DP_FontPFRegular(fontSize)       [UIFont dp_customFontWithName:DP_PingFangSCRegular size:DP_FontScreen(fontSize)]
#define DP_FontPFMedium(fontSize)        [UIFont dp_customFontWithName:DP_PingFangSCMedium size:DP_FontScreen(fontSize)]
#define DP_FontPFBold(fontSize)          [UIFont dp_customFontWithName:DP_PingFangSCBold size:DP_FontScreen(fontSize)]
#define DP_FontPFHeavy(fontSize)         [UIFont dp_customFontWithName:DP_PingFangSCHeavy size:DP_FontScreen(fontSize)]
#define DP_FontPFLight(fontSize)         [UIFont dp_customFontWithName:DP_PingFangSCLight size:DP_FontScreen(fontSize)]
#define DP_FontPFUltralight(fontSize)    [UIFont dp_customFontWithName:DP_PingFangSCUltralight size:DP_FontScreen(fontSize)]
#define DP_FontPFThin(fontSize)          [UIFont dp_customFontWithName:DP_PingFangSCThin size:DP_FontScreen(fontSize)]

///字体大小，屏幕适配
#define DP_FontScreen(a) (DP_IS_IPHONE_360x780_12mini||DP_IS_IPHONE_375x667_6_6s_7_8_SE2)?a:((DP_IS_IPHONE_414x736_6p_7p_8p||DP_IS_iPhoneXAll)?(a+1):(a-1))

///平方字体库
#define DP_PingFangSCRegular    @"PingFangSC-Regular"    //常规
#define DP_PingFangSCMedium     @"PingFangSC-Medium"     //苹方-简 中黑体
#define DP_PingFangSCBold       @"PingFangSC-Semibold"   //中粗体
#define DP_PingFangSCHeavy      @"PingFangSC-Semibold"   //中粗体
#define DP_PingFangSCLight      @"PingFangSC-Light"      //苹方-简 细体
#define DP_PingFangSCUltralight @"PingFangSC-Ultralight" //苹方-简 极细体
#define DP_PingFangSCThin       @"PingFangSC-Thin"       //苹方-简 纤细体

#pragma mark <--------------设备信息-------------->
///iPad设备
#ifndef DP_IS_IPAD
#define DP_IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#endif
///iPhone设备
#ifndef DP_IS_IPHONE
#define DP_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#endif
///获取设备屏幕宽度
#ifndef DP_SCREEN_WIDTH
#define DP_SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#endif
///获取设备屏幕高度
#ifndef DP_SCREEN_HEIGHT
#define DP_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#endif
///获取设备屏幕宽、高较大值
#ifndef DP_SCREEN_MAX_LENGTH
#define DP_SCREEN_MAX_LENGTH (MAX(DP_SCREEN_WIDTH, DP_SCREEN_HEIGHT))
#endif
///获取设备屏幕宽、高较小值
#ifndef DP_SCREEN_MIN_LENGTH
#define DP_SCREEN_MIN_LENGTH (MIN(DP_SCREEN_WIDTH, DP_SCREEN_HEIGHT))
#endif
///手机型号IPHONE_480x320_4
#ifndef DP_IS_IPHONE_480x320_4
#define DP_IS_IPHONE_480x320_4 (DP_IS_IPHONE && DP_SCREEN_MIN_LENGTH == 320 && DP_SCREEN_MAX_LENGTH == 480)
#endif
///手机型号IPHONE_568x320_5_S
#ifndef DP_IS_IPHONE_568x320_5_SE
#define DP_IS_IPHONE_568x320_5_SE (DP_IS_IPHONE && DP_SCREEN_MIN_LENGTH == 320 && DP_SCREEN_MAX_LENGTH == 568)
#endif
///手机型号IPHONE_375x667_6_6s_7_8_SE2
#ifndef DP_IS_IPHONE_375x667_6_6s_7_8_SE2
#define DP_IS_IPHONE_375x667_6_6s_7_8_SE2 (DP_IS_IPHONE && DP_SCREEN_MIN_LENGTH == 375 && DP_SCREEN_MAX_LENGTH == 667)
#endif
///手机型号IPHONE_414x736_6p_7p_8p
#ifndef DP_IS_IPHONE_414x736_6p_7p_8p
#define DP_IS_IPHONE_414x736_6p_7p_8p (DP_IS_IPHONE && DP_SCREEN_MIN_LENGTH == 414 && DP_SCREEN_MAX_LENGTH == 736)
#endif
///手机型号IPHONE_414x896_XR_11_XSMax_11ProMax
#ifndef DP_IS_IPHONE_414x896_XR_11_XSMax_11ProMax
#define DP_IS_IPHONE_414x896_XR_11_XSMax_11ProMax (DP_IS_IPHONE && DP_SCREEN_MIN_LENGTH == 414 && DP_SCREEN_MAX_LENGTH == 896)
#endif
///手机型号IPHONE_375x812_X_XS_11Pro
#ifndef DP_IS_IPHONE_375x812_X_XS_11Pro
#define DP_IS_IPHONE_375x812_X_XS_11Pro (DP_IS_IPHONE && DP_SCREEN_MIN_LENGTH == 375 && DP_SCREEN_MAX_LENGTH == 812)
#endif
///手机型号IPHONE_360x780_12mini
#ifndef DP_IS_IPHONE_360x780_12mini
#define DP_IS_IPHONE_360x780_12mini (DP_IS_IPHONE && DP_SCREEN_MIN_LENGTH == 360 && DP_SCREEN_MAX_LENGTH == 780)
#endif
///手机型号IPHONE_390x844_12_12Pro
#ifndef DP_IS_IPHONE_390x844_12_12Pro
#define DP_IS_IPHONE_390x844_12_12Pro (DP_IS_IPHONE && DP_SCREEN_MIN_LENGTH == 390 && DP_SCREEN_MAX_LENGTH == 844)
#endif
///手机型号IPHONE_428x926_12ProMax
#ifndef DP_IS_IPHONE_428x926_12ProMax
#define DP_IS_IPHONE_428x926_12ProMax (DP_IS_IPHONE && DP_SCREEN_MIN_LENGTH == 428 && DP_SCREEN_MAX_LENGTH == 926)
#endif
///手机型号IPHONE_6
#ifndef DP_IS_IPHONE_6
#define DP_IS_IPHONE_6 (DP_IS_IPHONE && DP_SCREEN_MAX_LENGTH == 667.0)
#endif
///手机型号IPHONE_6P
#ifndef DP_IS_IPHONE_6P
#define DP_IS_IPHONE_6P (DP_IS_IPHONE && DP_SCREEN_MAX_LENGTH == 736.0)
#endif
///刘海儿屏判断
#ifndef DP_IS_iPhoneXAll
#define DP_IS_iPhoneXAll (DP_IS_IPHONE_414x896_XR_11_XSMax_11ProMax || DP_IS_IPHONE_375x812_X_XS_11Pro || DP_IS_IPHONE_360x780_12mini || DP_IS_IPHONE_390x844_12_12Pro || DP_IS_IPHONE_428x926_12ProMax)
#endif
///顶部状态栏高度
#ifndef DP_NavibarHeight
#define DP_NavibarHeight (DP_IS_iPhoneXAll ? 88 : 64)
#endif
///底部状态栏高度
#ifndef DP_TabbarHeight49
#define DP_TabbarHeight49 49
#endif
///底部状态栏高度
#ifndef DP_TabbarHeight
#define DP_TabbarHeight (DP_IS_iPhoneXAll ? DP_TabbarHeight49+34 : DP_TabbarHeight49)
#endif
///时间状态栏
#ifndef DP_StatusbarHeight
#define DP_StatusbarHeight (DP_IS_iPhoneXAll ? 44 : 20)
#endif

#pragma mark <--------------颜色值处理-------------->
///DP_RGB颜色数值
#ifndef DP_RGB
#define DP_RGB(r,g,b)          DP_RGBACOLOR(r,g,b,1)
#endif
///DP_RGBA颜色数值
#ifndef DP_RGBA
#define DP_RGBA(r,g,b,a)       DP_RGBACOLOR(r,g,b,a)
#endif
///DP_RGB颜色数值
#ifndef DP_RGBCOLOR
#define DP_RGBCOLOR(r,g,b)     DP_RGBACOLOR(r,g,b,1)
#endif
///DP_RGBA颜色数值
#ifndef DP_RGBACOLOR
#define DP_RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#endif

#endif /* DPNormalMacro_h */
