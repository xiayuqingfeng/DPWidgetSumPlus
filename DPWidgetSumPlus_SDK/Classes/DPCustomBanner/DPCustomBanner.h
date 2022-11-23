//
//  DPCustomBanner.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DPCustomBanner;
@class DPCBContentView;

typedef NS_ENUM(NSUInteger, DPCustomBannerStyle) {
    ///水平排列，页码指示器底部居中
    DPCustomBannerHorizontal,
    ///水平排列，页码指示器底部靠右
    DPCustomBannerHorizontalTagRight,
    ///垂直排列，无页码指示器
    DPCustomBannerPortrait,
};

@protocol DPCustomBannerDelegate <NSObject>
@required
///轮播页面获取；aObject 当前控件；aBounds 当前page显示区域；aIndex 当前点击page位置；aData 当前page加载数据；aCyclicView 循环引用page；
- (UIView *)dpCustomBannerLoadViewWithObject:(DPCustomBanner *)aObject bounds:(CGRect)aBounds index:(NSInteger)aIndex data:(id)aData cyclicView:(UIView *)aCyclicView;
@optional
///轮播页面点击事件；aObject 当前控件；aIndex 当前点击page位置；aData 当前page加载数据；aCyclicView 循环引用page；
- (void)dpCustomBannerTapWithObject:(DPCustomBanner *)aObject index:(NSInteger)aIndex data:(id)aData cyclicView:(UIView *)aCyclicView;
///轮播控件布局重定义；aObject 当前控件；aBgScrollView 轮播控件；
- (UIScrollView *)dpCustomBannerScrollViewLayout:(DPCustomBanner *)aObject bgScrollView:(UIScrollView *)aBgScrollView;
///页码指示器布局重定义；aObject 当前控件；aPageControl 当前页码指示器；
- (UIPageControl *)dpCustomBannerPageControlLayout:(DPCustomBanner *)aObject pageControl:(UIPageControl *)aPageControl;
@end

@interface DPCustomBanner : UIView
///代理综合函数
@property (nonatomic, weak) id<DPCustomBannerDelegate>delegate;

///轮播页面获取block；aObject 当前控件；aIndex 当前点击page位置；aData 当前page加载数据；aCyclicView 循环引用page；
@property (nonatomic, copy) UIView *(^loadViewBlock)(DPCustomBanner *aObject, CGRect aBounds, NSInteger aIndex, id aData, UIView *aCyclicView);
///轮播页面点击事件block；aObject 当前控件；aIndex 当前点击page位置；aCyclicView 循环引用page；
@property (nonatomic, copy) void(^tapBlock)(DPCustomBanner *aObject, NSInteger aIndex, id aData, UIView *aCyclicView);
///轮播控件布局重定义block；aObject 当前控件；aBgScrollView 轮播控件；
@property (nonatomic, copy) UIScrollView *(^scrollViewLayoutBlock)(DPCustomBanner *aObject, UIScrollView *aBgScrollView);
///页码指示器布局重定义block；aObject 当前控件；aPageControl 当前页码指示器；
@property (nonatomic, copy) UIPageControl *(^pageControlLayoutBlock)(DPCustomBanner *aObject, UIPageControl *aPageControl);

///布局样式，默认值：DPCustomBannerHorizontal 水平排列，页码指示器底部靠右
@property (nonatomic, assign) DPCustomBannerStyle layoutStyle;
///默认背景图，默认值：nil
@property (nonatomic, strong) UIImage *bgImage;
///时间间隔，默认值：0 没有定时轮播
@property (nonatomic, assign) NSTimeInterval timeInterval;
///当前加载数据，默认值：nil
@property (nonatomic, strong, readonly) NSArray *dataArray;

///刷新数据
- (void)loadDataArray:(NSArray *)dataArray;
///定时器 开始
- (void)startTimer;
///定时器 暂停
- (void)stopTimer;
///释放当前对象
- (void)racRelease;
@end

@interface DPCBContentView : UIView
@property (nonatomic, strong) id currentData;
@property (nonatomic, assign) NSUInteger dataIndex;
@end
