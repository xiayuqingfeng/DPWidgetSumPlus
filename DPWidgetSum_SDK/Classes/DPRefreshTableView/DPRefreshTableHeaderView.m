//
//  DPBannerAlertView.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 zcw. All rights reserved.
//

#import "DPRefreshTableHeaderView.h"
#import <QuartzCore/QuartzCore.h>
#import "DPWidgetSum.h"
#import "DPRefreshTableViewObject.h"

@interface DPRefreshTableHeaderView() {
    
}
@property (nonatomic, strong) DPBallRotationProgress *ballsView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;

//下拉刷新状态 readonly
@property (nonatomic, assign) DPRefreshStateHeader refreshState;
@end

@implementation DPRefreshTableHeaderView
//添加下拉刷新block回调
+ (instancetype)dpRefreshHeaderAddWith:(UIScrollView *)aScrollView refreshBlock:(DPRefreshTableHeaderViewBlock)aRefreshBlock {
    DPRefreshTableHeaderView *dpHeaderView = [[DPRefreshTableHeaderView alloc] initWithScrollView:aScrollView];
    dpHeaderView.refreshBlock = aRefreshBlock;
    [aScrollView addSubview:dpHeaderView];
    return dpHeaderView;
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
        _headerMaxStayOffset = 0;
        
        self.superScrollView = aScrollView;
        
        self.ballsView = [[DPBallRotationProgress alloc] initWithFrame:CGRectMake(0, 0, self.dp_width, DEFAULT_RADIUS*2)];
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
        
        UIFont *bottomFont = DP_Font(12);
		self.bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _topLabel.dp_yMax, self.dp_width, bottomFont.lineHeight)];
        _bottomLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _bottomLabel.backgroundColor = [UIColor clearColor];
        _bottomLabel.adjustsFontSizeToFitWidth = YES;
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
		_bottomLabel.font = bottomFont;
        _bottomLabel.textColor = DP_RGBA(0, 0, 0, 0.4);
		[self addSubview:_bottomLabel];
        
        self.dp_height = _bottomLabel.dp_yMax+DP_FrameHeight(6);
        [self uploadLayoutTableHeaderView];
        [self uploadEnabledLayout];
        
        //下拉刷新过程，未达到临界值
        self.refreshState = DPRefreshStateHeaderNormal;
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
                [self uploadLayoutTableHeaderView];
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
    if (scrollView.isDragging == YES) {
        if (scrollView.contentOffset.y < 0) {
            if (_refreshState != DPRefreshStateHeaderLoading) {
                if (scrollView.contentOffset.y > -[self getRefreshStayOffset]) {
                    //下拉刷新过程，未达到临界值
                    self.refreshState = DPRefreshStateHeaderNormal;
                } else if (scrollView.contentOffset.y <= -[self getRefreshStayOffset]) {
                    //已达到或超过下拉临界值
                    self.refreshState = DPRefreshStateHeaderPulling;
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
    CGFloat asd = [self getRefreshStayOffset];
    if (scrollView.contentOffset.y < -asd &&
        _refreshState != DPRefreshStateHeaderLoading) {
        //下拉刷新结束，停止到临界值，网络请求中
        self.refreshState = DPRefreshStateHeaderLoading;
        [UIView animateWithDuration:DPTHVRefreshAnimateTime animations:^{
            scrollView.contentInset = UIEdgeInsetsMake([self getRefreshStayOffset], 0, 0, 0);
        }];
        
        //延迟调用，等待队列动画执行完成（防止：动画 和 网络请求，线程冲突导致动画小卡顿）
        dp_arc_block(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((DPTHVRefreshAnimateTime*2) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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

#pragma mark <-------------公共函数------------->
- (void)uploadLayoutTableHeaderView {
    if (_superScrollView) {
        self.dp_y = 0-self.dp_height;
        if (_superScrollView.contentSize.height <= _superScrollView.dp_height) {
            _superScrollView.contentSize = CGSizeMake(_superScrollView.contentSize.width, _superScrollView.dp_height+1);
        }
    }
}
//记录上次刷新时间
- (void)saveLastUpdatedDate {
    NSString *lastDateStr = [NSString stringWithFormat:@"上次刷新时间: %@",[NSDate dp_getLocalStrForDateOrStr:[NSDate date] formatter:@"yyyy-MM-dd HH:mm:ss" isIntercept:NO]];
    [[NSUserDefaults standardUserDefaults] setObject:lastDateStr forKey:@"EGORefreshTableView_LastRefresh"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//提取上次刷新时间 lable赋值
- (void)getLastUpdatedDate {
    NSString *lastDateStr = [NSUserDefaults dp_stringForKey:@"EGORefreshTableView_LastRefresh"];
    if (lastDateStr.length < 1) {
        [self saveLastUpdatedDate];
    }
    lastDateStr = [NSUserDefaults dp_stringForKey:@"EGORefreshTableView_LastRefresh"];
    _bottomLabel.text = lastDateStr;
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
    return self.dp_height+_headerMaxStayOffset;
}

#pragma mark <-------------Setter_methods------------->
//下拉刷新是否启用，默认：YES 启用，NO 不启用
- (void)setRefreshEnabled:(BOOL)refreshEnabled {
    _refreshEnabled = refreshEnabled;
    [self uploadEnabledLayout];
}
//下拉刷新状态
- (void)setRefreshState:(DPRefreshStateHeader)aState {
    switch (aState) {
        case DPRefreshStateHeaderNormal: {
            if (_refreshState != aState) {
                _topLabel.text = @"下拉即可刷新";
                [self getLastUpdatedDate];
            }
            if (_bottomLabel.text.length < 1) {
                [self getLastUpdatedDate];
            }
            //停止加载动画
            [_ballsView stopAnimator];
        }
            break;
        case DPRefreshStateHeaderPulling: {
            if (_refreshState != aState) {
                _topLabel.text = @"松开立即刷新";
            }
            //停止加载动画
            [_ballsView stopAnimator];
        }
            break;
        case DPRefreshStateHeaderLoading: {
            if (_refreshState != aState) {
                _topLabel.text = @"刷新中，请稍候";
                [self saveLastUpdatedDate];
            }
            //开始加载动画
            [_ballsView startAnimator];
        }
            break;
        case DPRefreshStateHeaderEnd: {
            //停止加载动画
            [_ballsView stopAnimator];
        }
            break;
        default:
            break;
    }
    _refreshState = aState;
}

#pragma mark <-------------外部调用函数------------->
//手动调用下拉刷新，isDidTrigger 是否触发刷新回调，animated 是否进行下拉动画
- (void)dpRefreshBeginIsDidTrigger:(BOOL)isDidTrigger Animated:(BOOL)animated {
    [self uploadEnabledLayout];
    //下拉刷新是否启用，默认：YES 启用，NO 不启用
    if (_refreshEnabled == NO) {
        return;
    }
    
    //上拉刷暂停，停止到临界值，网络请求中
    if (_refreshState == DPRefreshStateHeaderLoading) {
        return;
    }
    
    //下拉刷新停留在临界值
    _superScrollView.contentOffset = CGPointZero;
    if (animated) {
        //下拉刷新结束，停止到临界值，网络请求中
        self.refreshState = DPRefreshStateHeaderLoading;
        //动画scrollView偏移到临界值
        dp_arc_block(self);
        [UIView animateWithDuration:DPTHVRefreshAnimateTime animations:^{
            weak_self.superScrollView.contentInset = UIEdgeInsetsMake([self getRefreshStayOffset], 0, 0, 0);
            weak_self.superScrollView.contentOffset = CGPointMake(0, 0-[self getRefreshStayOffset]);
        }];
    }else {
        _superScrollView.contentInset = UIEdgeInsetsMake([self getRefreshStayOffset], 0, 0, 0);
        _superScrollView.contentOffset = CGPointMake(0, 0-[self getRefreshStayOffset]);
    }
    
    if (isDidTrigger) {
        //延迟调用，等待队列动画执行完成（防止：动画 和 网络请求，线程冲突导致动画小卡顿）
        dp_arc_block(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DPTHVRefreshAnimateTime*2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
//结束下拉刷新
- (void)dpRefreshFinish {
    if (_refreshState == DPRefreshStateHeaderLoading) {
        if (_superScrollView && !UIEdgeInsetsEqualToEdgeInsets(_superScrollView.contentInset, UIEdgeInsetsZero)) {
            //延迟调用，让loading显示一会儿
            dp_arc_block(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DPTHVRefreshStayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (weak_self.superScrollView && !UIEdgeInsetsEqualToEdgeInsets(weak_self.superScrollView.contentInset, UIEdgeInsetsZero)) {
                    //下拉刷新结束，不作任何处理
                    weak_self.refreshState = DPRefreshStateHeaderEnd;
                    //动画scrollView偏移量还原
                    [UIView animateWithDuration:DPTHVRefreshAnimateTime animations:^{
                        weak_self.superScrollView.contentInset = UIEdgeInsetsZero;
                    }];
                }else {
                    //下拉刷新结束，不作任何处理
                    weak_self.refreshState = DPRefreshStateHeaderEnd;
                }
            });
        }else {
            //下拉刷新结束，不作任何处理
            self.refreshState = DPRefreshStateHeaderEnd;
        }
    }
}
@end
