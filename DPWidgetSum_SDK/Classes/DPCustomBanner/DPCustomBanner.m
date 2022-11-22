//
//  DPCustomBanner.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import "DPCustomBanner.h"
#import "DPWidgetSum.h"
#import <ReactiveObjC/ReactiveObjC.h>

//循环页面tag基数
#define PageTagInitial 10000
//循环页面数量
#define CyclicPageCount 3

@interface DPCustomBanner ()<UIScrollViewDelegate> {
    
}
//当前背景视图
@property (nonatomic, strong) UIImageView *bgImageView;
//当前轮播控件
@property (nonatomic, strong) UIScrollView *bgScrollView;
//当前页码指示器
@property (nonatomic, strong) UIPageControl *pageControl;
//当前定时器
@property (nonatomic, strong) NSTimer *currentTimer;
//当前循环载体页面数组
@property (nonatomic, strong) NSMutableArray <DPCBContentView *>*pageArray;
//当前显示页的位置
@property (nonatomic, assign) NSInteger showPageIndex;
//当前加载数据
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation DPCustomBanner
- (void)dealloc {
    [self racRelease];
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSetting];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSetting];
    }
    return self;
}
- (void)initSetting {
    self.backgroundColor = [UIColor clearColor];
    _layoutStyle = DPCustomBannerHorizontal;
    [self loadViewLayout];
    
    //监听size变化，刷新布局
    dp_arc_block(self);
    [RACObserve(self, frame) subscribeNext:^(id x) {
        if (!CGSizeEqualToSize(weak_self.dp_size, CGSizeZero)) {
            [weak_self loadViewLayout];
            [weak_self stopTimer];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weak_self loadViewLayout];
                [weak_self cyclicRelocationMoveForType:0];
                [weak_self startTimer];
            });
        }
    }];
    [RACObserve(self, bounds) subscribeNext:^(id x) {
        if (!CGSizeEqualToSize(weak_self.dp_size, CGSizeZero)) {
            [weak_self loadViewLayout];
            [weak_self stopTimer];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weak_self loadViewLayout];
                [weak_self cyclicRelocationMoveForType:0];
                [weak_self startTimer];
            });
        }
    }];
}

#pragma mark <--------------UIScrollViewDelegate-------------->
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_dataArray.count > 1 && _timeInterval > 0) {
        [self startTimer];
    }else {
        [self stopTimer];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentX = (NSInteger)_bgScrollView.contentOffset.x;
    NSInteger currentY = (NSInteger)_bgScrollView.contentOffset.y;
    NSInteger towWidth = (NSInteger)(2*_bgScrollView.dp_width);
    NSInteger towHeight = (NSInteger)(2*_bgScrollView.dp_height);

    if ((_layoutStyle == DPCustomBannerHorizontal && currentX >= towWidth) ||
        (_layoutStyle == DPCustomBannerPortrait && currentY >= towHeight)) {
        [self cyclicRelocationMoveForType:1];
    }else if ((_layoutStyle == DPCustomBannerHorizontal && currentX <= 0) ||
              (_layoutStyle == DPCustomBannerPortrait && currentY <= 0)) {
        [self cyclicRelocationMoveForType:2];
    }
}

#pragma mark <-------------公共函数------------->
//刷新页面布局
- (void)loadViewLayout {
    if (CGSizeEqualToSize(self.dp_size, CGSizeZero)) {
        return;
    }
    
    //默认背景图
    if (_bgImageView == nil) {
        self.bgImageView = [[UIImageView alloc] init];
        [self addSubview:_bgImageView];
    }
    if (!CGRectEqualToRect(_bgImageView.frame, self.bounds)) {
        _bgImageView.frame = self.bounds;
    }
    _bgImageView.image = _bgImage;

    //滑动控件
    if (_bgScrollView == nil) {
        self.bgScrollView = [[UIScrollView alloc] init];
        _bgScrollView.backgroundColor = [UIColor clearColor];
        _bgScrollView.delegate = self;
        _bgScrollView.pagingEnabled = YES;
        _bgScrollView.scrollsToTop = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_bgScrollView];
    }
    if (!CGRectEqualToRect(_bgScrollView.frame, self.bounds)) {
        _bgScrollView.frame = self.bounds;
    }
    if ([self.delegate respondsToSelector:@selector(dpCustomBannerScrollViewLayout:bgScrollView:)]) {
        self.bgScrollView = [self.delegate dpCustomBannerScrollViewLayout:self bgScrollView:_bgScrollView];
    }else if (self.scrollViewLayoutBlock) {
        self.bgScrollView = self.scrollViewLayoutBlock(self, _bgScrollView);
    }
    if (_layoutStyle == DPCustomBannerHorizontal) {
        //水平排列
        _bgScrollView.scrollEnabled = _dataArray.count > 1;
        CGSize aContent = CGSizeMake(_bgScrollView.dp_width*CyclicPageCount, _bgScrollView.dp_height);
        if (!CGSizeEqualToSize(_bgScrollView.contentSize, aContent)) {
            _bgScrollView.contentSize = aContent;
        }
        if (_bgScrollView.contentSize.height > _bgScrollView.dp_height) {
            _bgScrollView.contentSize = CGSizeMake(_bgScrollView.contentSize.width, _bgScrollView.dp_height);
        }
    }else if (_layoutStyle == DPCustomBannerPortrait){
        //垂直排列
        _bgScrollView.scrollEnabled = NO;
        CGSize aContent = CGSizeMake(_bgScrollView.dp_width, _bgScrollView.dp_height*CyclicPageCount);
        if (!CGSizeEqualToSize(_bgScrollView.contentSize, aContent)) {
            _bgScrollView.contentSize = aContent;
        }
        if (_bgScrollView.contentSize.width > _bgScrollView.dp_width) {
            _bgScrollView.contentSize = CGSizeMake(_bgScrollView.dp_width, _bgScrollView.contentSize.height);
        }
    }
    
    //循环载体页面数组
    if (_pageArray.count < 1) {
        self.pageArray = [NSMutableArray arrayWithCapacity:CyclicPageCount];
        for (int i = 0; i < CyclicPageCount; i++) {
            DPCBContentView *aView = [[DPCBContentView alloc] init];
            aView.backgroundColor = [UIColor clearColor];
            aView.tag = PageTagInitial+i;
            aView.userInteractionEnabled = YES;
            [_bgScrollView addSubview:aView];
            
            UITapGestureRecognizer *pageTap = [[UITapGestureRecognizer alloc] init];
            dp_arc_block(self);
            [[pageTap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
                //循环排列 当前CyclicPage页面
                DPCBContentView *contentView = ((DPCBContentView *)x.view);
                //循环排列 当前CyclicPage填充页面
                UIView *subviewView = x.view.subviews.firstObject;
                if ([weak_self.delegate respondsToSelector:@selector(dpCustomBannerTapWithObject:index:data:cyclicView:)]) {
                    [weak_self.delegate dpCustomBannerTapWithObject:weak_self index:contentView.dataIndex data:contentView.currentData cyclicView:subviewView];
                }else if (weak_self.tapBlock) {
                    weak_self.tapBlock(weak_self, contentView.dataIndex, contentView.currentData, subviewView);
                }
            }];
            [aView addGestureRecognizer:pageTap];
            
            [_pageArray addObject:aView];
        }
    }
    for (UIView *pageView in _pageArray) {
        if (_layoutStyle == DPCustomBannerHorizontal) {
            //水平排列
            if (pageView.dp_y != 0) {
                pageView.dp_y = 0;
            }
        }else if (_layoutStyle == DPCustomBannerPortrait){
            //垂直排列
            if (pageView.dp_x != 0) {
                pageView.dp_x = 0;
            }
        }
        if (!CGSizeEqualToSize(pageView.dp_size, _bgScrollView.dp_size)) {
            pageView.dp_size = _bgScrollView.dp_size;
        }
    }

    //页码指示器
    if (_pageControl == nil) {
        self.pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectZero;
        _pageControl.currentPageIndicatorTintColor = DP_RGBA(255, 255, 255, 1);
        _pageControl.pageIndicatorTintColor = DP_RGBA(255, 255, 255, 0.4);
        _pageControl.enabled = NO;
        [self addSubview:_pageControl];
    }
    CGRect aFrame = CGRectZero;
    aFrame.size = [_pageControl sizeForNumberOfPages:_dataArray.count];
    aFrame.origin.x = (self.dp_width-aFrame.size.width)/2;
    aFrame.origin.y = self.dp_height-aFrame.size.height;
    if (!CGRectEqualToRect(_pageControl.frame, aFrame)) {
        _pageControl.frame = aFrame;
    }
    if ([self.delegate respondsToSelector:@selector(dpCustomBannerPageControlLayout:pageControl:)]) {
        self.pageControl = [self.delegate dpCustomBannerPageControlLayout:self pageControl:_pageControl];
    }else if (self.pageControlLayoutBlock) {
        self.pageControl = self.pageControlLayoutBlock(self, _pageControl);
    }
    if (_pageControl.numberOfPages != _dataArray.count) {
        _pageControl.numberOfPages = _dataArray.count;
    }
    if (_pageControl.currentPage != _showPageIndex) {
        _pageControl.currentPage = _showPageIndex;
    }
    //判断是否显示
    if (_layoutStyle == DPCustomBannerHorizontal) {
        //水平排列
        _pageControl.hidden = _dataArray.count < 2;
    }else if (_layoutStyle == DPCustomBannerPortrait){
        //垂直排列
        _pageControl.hidden = YES;
    }
}
//循环布局重定义 aType：0 重置第一页，1 向前一页，2 向后一页
- (void)cyclicRelocationMoveForType:(NSInteger)aType {
    if (CGSizeEqualToSize(self.dp_size, CGSizeZero)) {
        return;
    }

    if (aType == 0 && _dataArray.count > 0) {
        //页码设置 第一页
        self.showPageIndex = 0;
        
        //所有循环载体页面 重新排序
        NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:_pageArray.count];
        for (int i = 0; i < _pageArray.count; i++) {
            for (DPCBContentView *aView in _pageArray) {
                if (aView.tag == PageTagInitial+i) {
                    [newArray addObject:aView];
                }
            }
        }
        self.pageArray = newArray;
        
        //所有循环载体页 数据刷新
        [self refreshDataForPageIndex:0 dataIndex:[self validPageValue:_showPageIndex-1]];
        [self refreshDataForPageIndex:1 dataIndex:_showPageIndex];
        [self refreshDataForPageIndex:2 dataIndex:[self validPageValue:_showPageIndex+1]];
    }else if (aType == 1) {
        //页码设置 增加一页，越界为第一页
        self.showPageIndex = [self validPageValue:_showPageIndex+1];
        
        //第一个循环载体页面 移至据尾部
        NSInteger firstIndex = 0;
        DPCBContentView *aView = [_pageArray dp_objectAtIndex:firstIndex];
        [_pageArray removeObjectAtIndex:firstIndex];
        [_pageArray addObject:aView];;
        
        //最后一个循环载体页面 数据刷新
        [self refreshDataForPageIndex:2 dataIndex:[self validPageValue:_showPageIndex+1]];
    }else if (aType == 2) {
        //页码设置 减少一页，越界为最后一页
        self.showPageIndex = [self validPageValue:_showPageIndex-1];

        //最后一个循环载体页面 移至据头部
        NSInteger lastIndex = _pageArray.count-1;
        DPCBContentView *aView = [_pageArray dp_objectAtIndex:lastIndex];
        [_pageArray removeObjectAtIndex:lastIndex];
        [_pageArray insertObject:aView atIndex:0];;
        
        //第一个循环载体页面 数据刷新
        [self refreshDataForPageIndex:0 dataIndex:[self validPageValue:_showPageIndex-1]];
    }
    
    //循环载体页面数组frame重定位
    for (int i = 0; i < _pageArray.count; i++) {
        UIView *pageView = [_pageArray dp_objectAtIndex:i];
        if (_layoutStyle == DPCustomBannerHorizontal) {
            //水平排列
            CGFloat newX = _bgScrollView.dp_width*i;
            if (pageView.dp_x != newX) {
                pageView.dp_x = _bgScrollView.dp_width*i;
            }
        }else if (_layoutStyle == DPCustomBannerPortrait){
            //垂直排列
            CGFloat newY = _bgScrollView.dp_height*i;
            if (pageView.dp_y != newY) {
                pageView.dp_y = _bgScrollView.dp_height*i;
            }
        }
    }
    
    //当前显示page重定位
    CGPoint newPoint = CGPointZero;
    if (_layoutStyle == DPCustomBannerHorizontal) {
        //水平排列
        newPoint = CGPointMake(_bgScrollView.dp_width, 0);
    }else if (_layoutStyle == DPCustomBannerPortrait){
        //垂直排列
        newPoint = CGPointMake(0, _bgScrollView.dp_height);
    }
    if (!CGPointEqualToPoint(_bgScrollView.contentOffset, newPoint)) {
        [_bgScrollView setContentOffset:newPoint];
    }

    //判断是否显示
    DPCBContentView *centerPage = [_pageArray dp_objectAtIndex:1];
    if (centerPage != nil && centerPage.subviews.count > 0) {
        _bgImageView.hidden = YES;
    }
    //页码指示器 标记位置
    _pageControl.currentPage = _showPageIndex;
}
//刷新指定页面加载的数据
- (void)refreshDataForPageIndex:(NSUInteger)aPageIndex dataIndex:(NSUInteger)aDataIndex {
    //循环排列 当前CyclicPage页面
    DPCBContentView *contentView = [_pageArray dp_objectAtIndex:aPageIndex];
    contentView.dataIndex = aDataIndex;
    contentView.currentData = [_dataArray dp_objectAtIndex:aDataIndex];
    
    //循环排列 旧的CyclicPage填充页面
    UIView *oldSubviewView = contentView.subviews.firstObject;
    for (UIView *aView in contentView.subviews) {
        [aView removeFromSuperview];
    }
    
    //循环排列 旧的CyclicPage填充页面，回调传出，获取新的CyclicPage填充页面
    //警告：可以循环利用CyclicPage填充页面，只改变数据
    if (contentView.currentData) {
        UIView *newSubviewView = nil;
        if ([self.delegate respondsToSelector:@selector(dpCustomBannerLoadViewWithObject:bounds:index:data:cyclicView:)]) {
            newSubviewView = [_delegate dpCustomBannerLoadViewWithObject:self bounds:contentView.bounds index:aDataIndex data:contentView.currentData cyclicView:oldSubviewView];
        }else if (self.loadViewBlock) {
            newSubviewView = self.loadViewBlock(self, contentView.bounds, aDataIndex, contentView.currentData, oldSubviewView);
        }
        if (newSubviewView != nil) {
            [contentView addSubview:newSubviewView];
        }else {
            [contentView addSubview:oldSubviewView];
        }
    }
}
//页码值设置；向左超出范围，重定义最后一个元素；向右超出范围，重定义第一个元素；
- (NSInteger)validPageValue:(NSInteger)value {
    if (value < 0) {
        value = _dataArray.count-1;
    }else if (value >= (NSInteger)_dataArray.count) {
        value = 0;
    }
    if (value < 0) {
        value = 0;
    }
    return value;
}

#pragma mark <-------------Setter_methods------------->
///轮播控件布局重定义block；aObject 当前控件；aBgScrollView 轮播控件；
- (void)setScrollViewLayoutBlock:(UIScrollView *(^)(DPCustomBanner *, UIScrollView *))scrollViewLayoutBlock {
    _scrollViewLayoutBlock = scrollViewLayoutBlock;
    [self loadViewLayout];
}
///页码指示器布局重定义block；aObject 当前控件；aPageControl 当前页码指示器；
- (void)setPageControlLayoutBlock:(UIPageControl *(^)(DPCustomBanner *, UIPageControl *))pageControlLayoutBlock {
    _pageControlLayoutBlock = pageControlLayoutBlock;
    [self loadViewLayout];
}
///轮播页面获取block；aObject 当前控件；aIndex 当前点击page位置；aData 当前page加载数据；aCyclicView 循环引用page；
- (void)setLoadViewBlock:(UIView *(^)(DPCustomBanner *, CGRect, NSInteger, id, UIView *))loadViewBlock {
    _loadViewBlock = loadViewBlock;
    [self loadViewLayout];
}
///布局样式，默认值：DPCustomBannerHorizontal 水平排列，页码指示器底部靠右
- (void)setLayoutStyle:(DPCustomBannerStyle)layoutStyle {
    _layoutStyle = layoutStyle;
    [self loadViewLayout];
}
///默认背景图，默认值：nil
- (void)setBgImage:(UIImage *)bgImage {
    _bgImage = bgImage;
    if (_bgImage && _bgImageView) {
        _bgImageView.image = _bgImage;
    }
}
///时间间隔，默认值：0 没有定时轮播
- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    _timeInterval = timeInterval;
    if (_currentTimer) {
        [_currentTimer invalidate];
        self.currentTimer = nil;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startTimer];
    });
}

#pragma mark <--------------外部调用函数-------------->
///刷新数据
- (void)loadDataArray:(NSArray *)dataArray {
    if (_dataArray.count == 0 && dataArray != 0) {
        [self stopTimer];
        self.dataArray = dataArray;
        [self loadViewLayout];
        [self cyclicRelocationMoveForType:0];
        [self startTimer];
    }else {
        [self stopTimer];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.dataArray = dataArray;
            [self loadViewLayout];
            [self cyclicRelocationMoveForType:0];
            [self startTimer];
        });
    }
}
///定时器 开始
- (void)startTimer {
    if (_timeInterval > 0 && _currentTimer == nil) {
        self.currentTimer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(timerEvent:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_currentTimer forMode:NSRunLoopCommonModes];
    }
}
- (void)timerEvent:(NSTimer *)aTimer {
    if (self.superview != nil && _dataArray.count > 1) {
        if (_layoutStyle == DPCustomBannerHorizontal) {
            //水平排列
            [_bgScrollView setContentOffset:CGPointMake(_bgScrollView.dp_width*2, 0) animated:YES];
        }else if (_layoutStyle == DPCustomBannerPortrait){
            //垂直排列
            [_bgScrollView setContentOffset:CGPointMake(0, _bgScrollView.dp_height*2) animated:YES];
        }
    }
}
///定时器 暂停
- (void)stopTimer {
    if (_currentTimer) {
        [_currentTimer invalidate];
        self.currentTimer = nil;
    }
}
///释放当前对象
- (void)racRelease {
    if (_currentTimer) {
        [_currentTimer invalidate];
        self.currentTimer = nil;
    }
    self.delegate = nil;
    if (self.loadViewBlock) {
        self.loadViewBlock = nil;
    }
    if (self.tapBlock) {
        self.tapBlock = nil;
    }
    if (self.scrollViewLayoutBlock) {
        self.scrollViewLayoutBlock = nil;
    }
    if (self.pageControlLayoutBlock) {
        self.pageControlLayoutBlock = nil;
    }
    self.bgScrollView.delegate = nil;
    self.bgScrollView = nil;
}
@end

@implementation DPCBContentView

@end
