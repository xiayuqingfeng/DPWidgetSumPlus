//
//  DPBannerAlertView.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 zcw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DPRefreshTableHeaderView;

///下拉刷新停留时间，让loading显示一会儿
#define DPTHVRefreshStayTime 0.3
///通用动画时间
#define DPTHVRefreshAnimateTime 0.3

typedef NS_ENUM(NSUInteger, DPRefreshStateHeader) {
    ///下拉刷新过程，未达到临界值
    DPRefreshStateHeaderNormal = 0,
    ///下拉刷新过程，达到或超过临界值
    DPRefreshStateHeaderPulling,
    ///下拉刷暂停，停止到临界值，网络请求中
    DPRefreshStateHeaderLoading,
    ///下拉刷新结束，不作任何处理
    DPRefreshStateHeaderEnd
};

typedef void (^DPRefreshTableHeaderViewBlock)(DPRefreshTableHeaderView *aObject);

@interface DPRefreshTableHeaderView : UIView
///刷新回调block
@property (nonatomic, copy) DPRefreshTableHeaderViewBlock refreshBlock;
///ScrollView父视图
@property (nonatomic, weak) UIScrollView *superScrollView;
///下拉刷新是否启用，默认：YES 启用，NO 不启用
@property (nonatomic, assign) BOOL refreshEnabled;
///下拉刷新停留偏移量基础值为HeaderView高度，设置增加值，默认：0
@property (nonatomic, assign) CGFloat headerMaxStayOffset;
///下拉刷新状态
@property (nonatomic, assign, readonly) DPRefreshStateHeader refreshState;

///添加下拉刷新block回调
+ (instancetype)dpRefreshHeaderAddWith:(UIScrollView *)aScrollView refreshBlock:(DPRefreshTableHeaderViewBlock)aRefreshBlock;

///手动调用下拉刷新，isDidTrigger 是否触发刷新回调，animated 是否进行下拉动画
- (void)dpRefreshBeginIsDidTrigger:(BOOL)isDidTrigger Animated:(BOOL)animated;
///结束下拉刷新
- (void)dpRefreshFinish;
@end
