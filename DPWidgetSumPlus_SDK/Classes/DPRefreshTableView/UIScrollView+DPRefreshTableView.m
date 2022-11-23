//
//  UIScrollView+DPRefreshTableView.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import "UIScrollView+DPRefreshTableView.h"
#import <objc/runtime.h>

@implementation UIScrollView (DPRefreshTableView)
#pragma mark <-------------下拉刷新------------->
static void *dpStaticRefreshHeaderView;
- (void)setDpRefreshHeaderView:(DPRefreshTableHeaderView *)dpRefreshHeaderView {
    objc_setAssociatedObject(self, &dpStaticRefreshHeaderView, dpRefreshHeaderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (DPRefreshTableHeaderView *)dpRefreshHeaderView{
    return objc_getAssociatedObject(self, &dpStaticRefreshHeaderView);
}

//添加下拉刷新block回调
- (void)dpRefreshHeaderAdd:(DPRefreshTableHeaderViewBlock)aRefreshBlock {
    if (self.dpRefreshHeaderView == nil) {
        self.dpRefreshHeaderView = [DPRefreshTableHeaderView dpRefreshHeaderAddWith:self refreshBlock:aRefreshBlock];
    }
}
//删除下拉刷新
- (void)dpRefreshHeaderRemove {
    if (self.dpRefreshHeaderView) {
        if (self.dpRefreshHeaderView.superview) {
            [self.dpRefreshHeaderView removeFromSuperview];
        }
        self.dpRefreshHeaderView = nil;
    }
}
//手动调用下拉刷新，不触发刷新回调，进行下拉动画
- (void)dpRefreshHeaderBegin {
    if (self.dpRefreshHeaderView) {
        [self.dpRefreshHeaderView dpRefreshBeginIsDidTrigger:NO Animated:YES];
    }
}
//手动调用下拉刷新，isDidTrigger 是否触发刷新回调，animated 是否进行下拉动画
- (void)dpRefreshHeaderBeginIsDidTrigger:(BOOL)isDidTrigger Animated:(BOOL)animated {
    if (self.dpRefreshHeaderView) {
        [self.dpRefreshHeaderView dpRefreshBeginIsDidTrigger:isDidTrigger Animated:animated];
    }
}
//结束下拉刷新
- (void)dpRefreshHeaderFinish {
    if (self.dpRefreshHeaderView) {
        [self.dpRefreshHeaderView dpRefreshFinish];
    }
}
//下拉刷新状态
- (DPRefreshStateHeader)dpRefreshHeaderState {
    if (self.dpRefreshHeaderView) {
        return self.dpRefreshHeaderView.refreshState;
    }else {
        return DPRefreshStateHeaderEnd;
    }
}
//下拉刷新是否启用，默认：YES 启用，NO 不启用
- (void)dpRefreshHeaderEnabled:(BOOL)aEnabled {
    if (self.dpRefreshHeaderView) {
        self.dpRefreshHeaderView.refreshEnabled = aEnabled;
    }
}
//下拉刷新停留偏移量基础值为HeaderView高度，设置增加值，默认：0
- (void)dpHeaderMaxStayOffset:(CGFloat)aMaxOffset {
    if (self.dpRefreshHeaderView) {
        self.dpRefreshHeaderView.headerMaxStayOffset = aMaxOffset;
    }
}

#pragma mark <-------------上拉加载------------->
static void *dpStaticRefreshFooterView;
- (void)setDpRefreshFooterView:(DPRefreshTableFooterView *)dpRefreshFooterView {
    objc_setAssociatedObject(self, &dpStaticRefreshFooterView, dpRefreshFooterView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (DPRefreshTableFooterView *)dpRefreshFooterView{
    return objc_getAssociatedObject(self, &dpStaticRefreshFooterView);
}

//添加上拉加载block回调
- (void)dpRefreshFooterAdd:(DPRefreshTableFooterViewBlock)aRefreshBlock {
    if (self.dpRefreshFooterView == nil) {
        self.dpRefreshFooterView = [DPRefreshTableFooterView dpRefreshFooterAddWith:self refreshBlock:aRefreshBlock];
    }
}
//删除上拉加载
- (void)dpRefreshFooterRemove {
    if (self.dpRefreshFooterView) {
        if (self.dpRefreshFooterView.superview) {
            [self.dpRefreshFooterView removeFromSuperview];
        }
        self.dpRefreshFooterView = nil;
    }
}
//手动调用上拉加载，不触发刷新回调，进行下拉动画
- (void)dpRefreshFooterBegin {
    if (self.dpRefreshFooterView) {
        [self.dpRefreshFooterView dpRefreshFooterBeginIsDidTrigger:NO Animated:YES];
    }
}
//手动调用上拉加载，isDidTrigger 是否触发刷新回调，animated 是否进行下拉动画
- (void)dpRefreshFooterBeginIsDidTrigger:(BOOL)isDidTrigger Animated:(BOOL)animated {
    if (self.dpRefreshFooterView) {
        [self.dpRefreshFooterView dpRefreshFooterBeginIsDidTrigger:isDidTrigger Animated:isDidTrigger];
    }
}
//结束上拉加载
- (void)dpRefreshFooterFinish {
    if (self.dpRefreshFooterView) {
        [self.dpRefreshFooterView dpRefreshFinish];
    }
}
//禁止上拉加载，没有更多数据了
- (void)dpRefreshFooterIsDataOver:(BOOL)isDataOver {
    if (self.dpRefreshFooterView) {
        self.dpRefreshFooterView.dataLoadOver = isDataOver;
    }
}
//上拉加载状态
- (DPRefreshFooterState)dpRefreshFooterState {
    if (self.dpRefreshFooterView) {
        return self.dpRefreshFooterView.refreshState;
    }else {
        return DPRefreshFooterStateEnd;
    }
}
//上拉加载是否启用，默认：YES 启用，NO 不启用
- (void)dpRefreshFooterEnabled:(BOOL)aEnabled {
    if (self.dpRefreshFooterView) {
        self.dpRefreshFooterView.refreshEnabled = aEnabled;
    }
}
//上拉加载停留偏移量基础值为FooterView高度，设置增加值，默认：0
- (void)dpFooterMaxStayOffset:(CGFloat)aMaxOffset {
    if (self.dpRefreshFooterView) {
        self.dpRefreshFooterView.footerMaxStayOffset = aMaxOffset;
    }
}
@end
