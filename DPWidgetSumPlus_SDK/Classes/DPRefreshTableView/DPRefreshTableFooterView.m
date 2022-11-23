//
//  DPBannerAlertView.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 zcw. All rights reserved.
//

#import "DPRefreshTableFooterView.h"
#import <QuartzCore/QuartzCore.h>
#import "DPWidgetSumPlus.h"
#import "DPRefreshTableViewObject.h"

@interface DPRefreshTableFooterView() {
    
}
@property (nonatomic, strong) DPBallRotationProgress *ballsView;
@property (nonatomic, strong) UILabel *topLabel;

//上拉加载状态 readonly
@property (nonatomic, assign) DPRefreshFooterState refreshState;
@end

@implementation DPRefreshTableFooterView
//添加下拉刷新block回调
+ (instancetype)dpRefreshFooterAddWith:(UIScrollView *)aScrollView refreshBlock:(DPRefreshTableFooterViewBlock)aRefreshBlock {
    DPRefreshTableFooterView *dpFooterView = [[DPRefreshTableFooterView alloc] initWithScrollView:aScrollView];
    dpFooterView.refreshBlock = aRefreshBlock;
    [aScrollView addSubview:dpFooterView];
    return dpFooterView;
}
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    //旧的的父视图ScrollView删除contentSize监听
    if (self.superview && [self.superview isKindOfClass:[UIScrollView class]]) {
        if (newSuperview == nil) {
            //移除圆球动画
            [_ballsView stopAnimator];
        }
        [self removeObservers];
    }
    
    //给新的父视图ScrollView添加contentSize监听
    if (newSuperview && [newSuperview isKindOfClass:[UIScrollView class]]) {
        self.superScrollView = (UIScrollView *)newSuperview;
        if (_superScrollView.contentSize.height <= _superScrollView.dp_height) {
            _superScrollView.contentSize = CGSizeMake(_superScrollView.contentSize.width, _superScrollView.dp_height+1);
        }
        [self addObservers];
    }
}
- (void)dealloc {
    if (self.refreshBlock) {
        self.refreshBlock = nil;
    }
}
- (instancetype)initWithScrollView:(UIScrollView *)aScrollView {
    self = [super initWithFrame:CGRectMake(0, 0, aScrollView.dp_width, 0)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _refreshEnabled = YES;
        
        self.superScrollView = aScrollView;
        
        self.ballsView = [[DPBallRotationProgress alloc] initWithFrame:CGRectMake(0, DP_FrameHeight(8), self.dp_width, DEFAULT_RADIUS*2)];
        _ballsView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_ballsView];
        
        UIFont *topFont = DP_Font(13);
        self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _ballsView.dp_yMax+DP_FrameHeight(4), self.dp_width, topFont.lineHeight)];
        _topLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _topLabel.backgroundColor = [UIColor clearColor];
        _topLabel.adjustsFontSizeToFitWidth = YES;
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.font = topFont;
        _topLabel.textColor = DP_RGBA(87, 108, 137, 1);
        [self addSubview:_topLabel];
        
        self.dp_height = _topLabel.dp_yMax+DP_FrameHeight(6);
        [self uploadLayoutTableFooterView];
        [self uploadEnabledLayout];
        
        //上拉加载过程，未达到临界值
        self.refreshState = DPRefreshFooterStateNormal;
    }
    return self;
}

#pragma mark <-------------KVO------------->
- (void)addObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    if (_superScrollView && [_superScrollView isKindOfClass:[UIScrollView class]]) {
        [_superScrollView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
        [_superScrollView addObserver:self forKeyPath:@"contentSize" options:options context:nil];
        [_superScrollView.panGestureRecognizer addObserver:self forKeyPath:@"state" options:options context:nil];
    }
}
- (void)removeObservers {
    if (_superScrollView && [_superScrollView isKindOfClass:[UIScrollView class]]) {
        @try {
            [_superScrollView removeObserver:self forKeyPath:@"contentOffset"];
            [_superScrollView removeObserver:self forKeyPath:@"contentSize"];
            [_superScrollView.panGestureRecognizer removeObserver:self forKeyPath:@"state"];
        }
        @catch (NSException *exception) {
            NSLog(@"多次删除KVO");
        }
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (_superScrollView) {
        if ([object isEqual:_superScrollView]) {
            if ([keyPath isEqualToString:@"contentOffset"]) {
                [self dpRefreshScrollViewDidScroll:_superScrollView];
            }else if ([keyPath isEqualToString:@"contentSize"]) {
                [self uploadLayoutTableFooterView];
            }
        }else if ([object isEqual:_superScrollView.panGestureRecognizer]) {
            if ([keyPath isEqualToString:@"state"] && _superScrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
                [self dpRefreshScrollViewDidEndDragging:_superScrollView];
            }
        }
    }
}

#pragma mark <-------------KVO_UIScrollViewDelegate------------->
//ScrollView运动中遵守函数（必须调用遵守）
- (void)dpRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
    [self uploadEnabledLayout];
    //下拉刷新是否启用，默认：YES 启用，NO 不启用
    if (_refreshEnabled == NO) {
        return;
    }
    
    //下拉处理
    if (scrollView.isDragging == YES && _dataLoadOver == NO) {
        CGFloat contentOffsetY = scrollView.contentOffset.y+scrollView.dp_height;
        CGFloat maxContentH = MAX(scrollView.dp_height, scrollView.contentSize.height);
        
        if (contentOffsetY >= maxContentH) {
            if (_refreshState != DPRefreshFooterStateLoading) {
                CGFloat maxOffsetY = maxContentH+[self getRefreshStayOffset];
                
                if (contentOffsetY < maxOffsetY) {
                    //上拉加载过程，未达到临界值
                    self.refreshState = DPRefreshFooterStateNormal;
                } else if (contentOffsetY >= maxOffsetY) {
                    //已达到或超过上拉临界值
                    self.refreshState = DPRefreshFooterStatePulling;
                }
            }
        }
    }
}
//ScrollView拖动结束遵守函数（必须调用遵守）
- (void)dpRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    [self uploadEnabledLayout];
    //下拉刷新是否启用，默认：YES 启用，NO 不启用
    if (_refreshEnabled == NO) {
        return;
    }
    
    //下拉处理
    if (_dataLoadOver == NO) {
        CGFloat contentOffsetY = scrollView.contentOffset.y+scrollView.dp_height;
        CGFloat maxContentH = MAX(scrollView.dp_height, scrollView.contentSize.height);
        CGFloat maxOffsetY = maxContentH+[self getRefreshStayOffset];
        
        if (contentOffsetY >= maxOffsetY && _refreshState != DPRefreshFooterStateLoading) {
            //上拉加载结束，停止到临界值，网络请求中
            self.refreshState = DPRefreshFooterStateLoading;
            [UIView animateWithDuration:DPTHVRefreshAnimateTime animations:^{
                scrollView.contentInset = UIEdgeInsetsMake(0, 0, [self getRefreshStayOffset], 0);
            }];

            //延迟调用，让loading显示一会儿，等待队列动画执行完成（防止：动画 和 网络请求，线程冲突导致动画小卡顿）
            dp_arc_block(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((DPTHVRefreshAnimateTime+DPTHVRefreshStayTime*2) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (weak_self.refreshBlock) {
                    //block回调，临界值移动 到 初始位置，动画开始
                    weak_self.refreshBlock(weak_self);
                }else {
                    //没有外部代理函数，临界值移动 到 初始位置，动画开始
                    [weak_self dpRefreshFinish];
                }
            });
        }
    }
}

#pragma mark <-------------公共函数------------->
- (void)uploadLayoutTableFooterView {
    if (_superScrollView) {
        if (_superScrollView.dp_height < _superScrollView.contentSize.height) {
            self.dp_y = _superScrollView.contentSize.height;
        }else{
            self.dp_y = _superScrollView.dp_height;
        }
    }
}
//根据Enabled刷新显示状态
- (void)uploadEnabledLayout {
    if (_refreshEnabled == YES) {
        if (self.hidden == YES) {
            self.hidden = NO;
        }
    }else {
        if (self.hidden == NO) {
            self.hidden = YES;
            [_ballsView stopAnimator];
        }
    }
}
//获取下拉刷新停留偏移量
- (CGFloat)getRefreshStayOffset {
    return self.dp_height+_footerMaxStayOffset;
}

#pragma mark <-------------Setter_methods------------->
//上拉加载刷新是否启用，默认：YES 启用，NO 不启用
- (void)setRefreshEnabled:(BOOL)refreshEnabled {
    _refreshEnabled = refreshEnabled;
    [self uploadEnabledLayout];
}
- (void)setRefreshState:(DPRefreshFooterState)aState {
    switch (aState) {
        case DPRefreshFooterStateNormal: {
            if (_refreshState != aState) {
                _topLabel.text = @"上拉显示更多";
            }
            //停止加载动画
            [_ballsView stopAnimator];
        }
            break;
        case DPRefreshFooterStatePulling: {
            if (_refreshState != aState) {
                _topLabel.text = @"松开立即显示";
            }
            //停止加载动画
            [_ballsView stopAnimator];
        }
            break;
        case DPRefreshFooterStateLoading: {
            if (_refreshState != aState) {
                _topLabel.text = @"加载中，请稍候";
            }
            //开始加载动画
            [_ballsView startAnimator];
        }
            break;
        case DPRefreshFooterStateEnd: {
            //停止加载动画
            [_ballsView stopAnimator];
        }
            break;
        default:
            break;
    }
    _refreshState = aState;
}
- (void)setDataLoadOver:(BOOL)dataLoadOver {
    _dataLoadOver = dataLoadOver;
    if (_dataLoadOver == YES) {
        //停止加载动画
        [_ballsView stopAnimator];
        
        if (_ballsView.hidden == NO) {
            _ballsView.hidden = YES;
            _topLabel.dp_y = DP_FrameHeight(4);
        }
        _topLabel.text = @"没有更多了";
    }else {
        if (_ballsView.hidden == YES) {
            _ballsView.hidden = NO;
            _topLabel.dp_y = _ballsView.dp_yMax+DP_FrameHeight(4);
        }
    }
}

#pragma mark <-------------外部调用函数------------->
//手动调用上拉加载，isDidTrigger 是否触发刷新回调，animated 是否进行下拉动画
- (void)dpRefreshFooterBeginIsDidTrigger:(BOOL)isDidTrigger Animated:(BOOL)animated {
    [self uploadEnabledLayout];
    //下拉刷新是否启用，默认：YES 启用，NO 不启用
    if (_refreshEnabled == NO) {
        return;
    }
    
    //上拉刷暂停，停止到临界值，网络请求中
    if (_refreshState == DPRefreshFooterStateLoading) {
        return;
    }
    
    //上拉加载停留在临界值
    _superScrollView.contentOffset = CGPointZero;
    CGFloat contentOffsetY = 0;
    if (_superScrollView.contentSize.height > _superScrollView.dp_height) {
        contentOffsetY = _superScrollView.contentSize.height - _superScrollView.dp_height;
    }
    if (animated) {
        //上拉加载结束，停止到临界值，网络请求中
        self.refreshState = DPRefreshFooterStateLoading;
        //动画scrollView偏移到临界值
        dp_arc_block(self);
        [UIView animateWithDuration:DPTFVRefreshAnimateTime animations:^{
            weak_self.superScrollView.contentInset = UIEdgeInsetsMake(0, 0, [self getRefreshStayOffset], 0);
            weak_self.superScrollView.contentOffset = CGPointMake(0, contentOffsetY);
        }];
    }else {
        _superScrollView.contentInset = UIEdgeInsetsMake(0, 0, [self getRefreshStayOffset], 0);
        _superScrollView.contentOffset = CGPointMake(0, contentOffsetY);
    }
    
    if (isDidTrigger) {
        //延迟调用，让loading显示一会儿，等待队列动画执行完成（防止：动画 和 网络请求，线程冲突导致动画小卡顿）
        dp_arc_block(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DPTHVRefreshAnimateTime+DPTHVRefreshStayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (weak_self.refreshBlock) {
                //block回调，临界值移动 到 初始位置，动画开始
                weak_self.refreshBlock(weak_self);
            }else {
                //没有外部代理函数，临界值移动 到 初始位置，动画开始
                [weak_self dpRefreshFinish];
            }
        });
    }
}
//结束上拉加载
- (void)dpRefreshFinish {
    if (_refreshState == DPRefreshFooterStateLoading) {
        if (_superScrollView && !UIEdgeInsetsEqualToEdgeInsets(_superScrollView.contentInset, UIEdgeInsetsZero)) {
            if (_superScrollView && !UIEdgeInsetsEqualToEdgeInsets(_superScrollView.contentInset, UIEdgeInsetsZero)) {
                //上拉加载结束，不作任何处理
                self.refreshState = DPRefreshFooterStateEnd;
                //动画scrollView偏移量还原
                dp_arc_block(self);
                [UIView animateWithDuration:DPTFVRefreshAnimateTime animations:^{
                    weak_self.superScrollView.contentInset = UIEdgeInsetsZero;
                }];
            }else {
                //上拉加载结束，不作任何处理
                self.refreshState = DPRefreshFooterStateEnd;
            }
        }else {
            //上拉加载结束，不作任何处理
            self.refreshState = DPRefreshFooterStateEnd;
        }
    }
}
@end
