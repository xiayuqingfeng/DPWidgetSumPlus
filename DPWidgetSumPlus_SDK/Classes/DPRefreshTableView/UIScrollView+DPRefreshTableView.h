//
//  UIScrollView+DPRefreshTableView.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPRefreshTableHeaderView.h"
#import "DPRefreshTableFooterView.h"

@interface UIScrollView (DPRefreshTableView)
#pragma mark <-------------下拉刷新------------->
@property (nonatomic, strong) DPRefreshTableHeaderView *dpRefreshHeaderView;

///添加下拉刷新block回调
- (void)dpRefreshHeaderAdd:(DPRefreshTableHeaderViewBlock)aRefreshBlock;
///删除下拉刷新
- (void)dpRefreshHeaderRemove;
///手动调用下拉刷新，不触发刷新回调，进行下拉动画
- (void)dpRefreshHeaderBegin;
///手动调用下拉刷新，isDidTrigger 是否触发刷新回调，animated 是否进行下拉动画
- (void)dpRefreshHeaderBeginIsDidTrigger:(BOOL)isDidTrigger Animated:(BOOL)animated;
///结束下拉刷新
- (void)dpRefreshHeaderFinish;
///下拉刷新状态
- (DPRefreshStateHeader)dpRefreshHeaderState;
///下拉刷新是否启用，YES 启用，NO 不启用，默认：YES
- (void)dpRefreshHeaderEnabled:(BOOL)aEnabled;
///下拉刷新停留偏移量基础值为HeaderView高度，设置增加值，默认：0
- (void)dpHeaderMaxStayOffset:(CGFloat)aMaxOffset;

#pragma mark <-------------上拉加载------------->
@property (nonatomic, strong) DPRefreshTableFooterView *dpRefreshFooterView;

///添加上拉加载block回调
- (void)dpRefreshFooterAdd:(DPRefreshTableFooterViewBlock)aRefreshBlock;
///删除上拉加载
- (void)dpRefreshFooterRemove;
///手动调用上拉加载，不触发刷新回调，进行下拉动画
- (void)dpRefreshFooterBegin;
///手动调用上拉加载，isDidTrigger 是否触发刷新回调，animated 是否进行下拉动画
- (void)dpRefreshFooterBeginIsDidTrigger:(BOOL)isDidTrigger Animated:(BOOL)animated;
///结束上拉加载
- (void)dpRefreshFooterFinish;
///禁止上拉加载，没有更多数据了
- (void)dpRefreshFooterIsDataOver:(BOOL)isDataOver;
///上拉加载状态
- (DPRefreshFooterState)dpRefreshFooterState;
///上拉加载是否启用，YES 启用，NO 不启用，默认：YES
- (void)dpRefreshFooterEnabled:(BOOL)aEnabled;
///上拉加载停留偏移量基础值为FooterView高度，设置增加值，默认：0
- (void)dpFooterMaxStayOffset:(CGFloat)aMaxOffset;
@end
