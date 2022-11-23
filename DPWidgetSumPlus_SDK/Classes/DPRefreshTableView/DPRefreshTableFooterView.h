//
//  DPBannerAlertView.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 zcw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DPRefreshTableFooterView;

///上拉加载停留时间，让loading显示一会儿
#define DPTFVRefreshStayTime 0.5
///通用动画时间
#define DPTFVRefreshAnimateTime 0.3

typedef NS_ENUM(NSUInteger, DPRefreshFooterState) {
    ///上拉加载过程，未达到临界值
    DPRefreshFooterStateNormal = 0,
    ///上拉加载过程，达到或超过临界值
    DPRefreshFooterStatePulling,
    ///上拉刷暂停，停止到临界值，网络请求中
    DPRefreshFooterStateLoading,
    ///上拉加载结束，不作任何处理
    DPRefreshFooterStateEnd
};

typedef void (^DPRefreshTableFooterViewBlock)(DPRefreshTableFooterView *aObject);

@interface DPRefreshTableFooterView : UIView
///刷新回调block
@property (nonatomic, copy) DPRefreshTableFooterViewBlock refreshBlock;
///ScrollView父视图
@property (nonatomic, weak) UIScrollView *superScrollView;
///上拉加载是否启用，默认：YES 启用，NO 不启用
@property (nonatomic, assign) BOOL refreshEnabled;
///上拉加载停留偏移量基础值为FooterView高度，设置增加值，默认：0
@property (nonatomic, assign) CGFloat footerMaxStayOffset;
///上拉加载状态
@property (nonatomic, assign, readonly) DPRefreshFooterState refreshState;
///上拉加载禁止，没有更多数据了
@property (nonatomic, assign) BOOL dataLoadOver;

///添加下拉刷新block回调
+ (instancetype)dpRefreshFooterAddWith:(UIScrollView *)aScrollView refreshBlock:(DPRefreshTableFooterViewBlock)aRefreshBlock;

///手动调用上拉加载，isDidTrigger 是否触发刷新回调，animated 是否进行下拉动画
- (void)dpRefreshFooterBeginIsDidTrigger:(BOOL)isDidTrigger Animated:(BOOL)animated;
///结束上拉加载
- (void)dpRefreshFinish;
@end
