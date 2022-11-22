//
//  DPBannerAlertView.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 zcw. All rights reserved.
//

#import "DPBannerAlertView.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "DPWidgetSum.h"

//当前对象Tag
#define DPBannerAlertViewTag 16800300
//动画时间
#define DPMAVAnimateDuration 0.2
//弹框显示范围上下间距
#define ContentViewTBMaxGap DP_FrameHeight(50)

@interface DPBannerAlertView (){
    
}
@property (nonatomic, strong) UIWindow *customWindow;
@property (nonatomic, strong) DPBannerAlertView *customAlert;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) DPCustomBanner *bannerView;

//当前键盘响应焦点
@property (nonatomic, weak) id currentResponder;
@property (nonatomic, weak) UIViewController *currentVC;
@property (nonatomic, weak) UIView *currentParent;
@end

@implementation DPBannerAlertView
#pragma mark - 单例
+ (DPBannerAlertView *)sharedAlertView {
    static DPBannerAlertView *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

#pragma mark - 初始化弹框
- (void)dealloc {
    
}
- (DPBannerAlertView *)customAlert {
    if (_customAlert == nil) {
        self.customAlert = [[DPBannerAlertView alloc] init];
    }
    return _customAlert;
}
- (id)init {
    self = [super init];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.tag = DPBannerAlertViewTag;
        
        self.bgView = [[UIView alloc] init];
        _bgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_bgView];
        
        self.bannerView = [[DPCustomBanner alloc] init];
        _bannerView.timeInterval = 3;
        [_bgView addSubview:_bannerView];

        self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setBackgroundImage:dp_BundleImageNamed(@"dp_banner_close.png") forState:UIControlStateNormal];
        dp_arc_block(self);
        [[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weak_self hiddenViewCompletion:nil];
        }];
        [_bgView addSubview:_closeBtn];
    }
    return self;
}

#pragma mark 通知Notification
//屏幕旋转，弹框超出屏幕，刷新UI布局
- (void)orientChange:(NSNotification *)notification {
    if (self.hidden == NO && self.superview && _bgView && !CGRectContainsRect(self.bounds, _bgView.frame)) {
        [self updateView];
    }
}

#pragma mark - 显示消息弹框
- (void)showBannerAlertViewForVC:(UIViewController *)aVC parentView:(UIView *)aParentView loadContentBlock:(void (^)(DPBannerAlertView *aObject, DPCustomBanner *aCustomBanner))aBlock {
    //刷新数据
    self.currentVC = aVC;
    self.currentParent = aParentView;
    
    if (_currentVC == nil) {
        self.currentVC = [UIViewController dp_topVC];
    }
    
    if (_currentParent == nil) {
        if(_customWindow == nil) {
            self.customWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            _customWindow.backgroundColor = [UIColor clearColor];
            _customWindow.windowLevel = UIWindowLevelAlert;
        }
        self.currentParent = _customWindow;
    }
    
    //回传轮播控件
    if (aBlock) {
        aBlock(self, _bannerView);
    }
    //刷新UI布局
    [self updateView];
    //动画显示弹框
    [self showViewCompletion:nil];
}

#pragma mark - 刷新UI布局
- (void)updateView {
    self.frame = _currentParent.bounds;
    self.backgroundColor = DP_RGBA(0, 0, 0, 0.5);
    
    _bgView.backgroundColor = [UIColor clearColor];
    
    _bannerView.dp_size = CGSizeMake(DP_FrameWidth(300), DP_FrameHeight(400));
    _bgView.dp_width = _bannerView.dp_width;
    
    _closeBtn.dp_size = CGSizeMake(DP_FrameWidth(34), DP_FrameHeight(34));
    _closeBtn.dp_x = _bgView.dp_width-DP_FrameWidth(12)-_closeBtn.dp_width;
    _closeBtn.dp_y = DP_FrameHeight(18);
    
    _bannerView.dp_y = _closeBtn.dp_yMax+DP_FrameHeight(18);
    
    _bgView.dp_height = _bannerView.dp_yMax;
    _bgView.center = CGPointMake(self.dp_width/2, self.dp_height/2);
}

#pragma mark - 动画显示、隐藏弹框
//动画显示弹框
- (void)showViewCompletion:(void (^)(void))completion {
    dp_arc_block(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weak_self.currentParent) {
            //弹框添加父视图
            [weak_self.currentParent addSubview:weak_self];
            if (weak_self.currentParent == weak_self.customWindow) {
                weak_self.currentParent.hidden = NO;
            }
            
            //获取当前键盘响应焦点
            UIView *responderView = [weak_self findResponderForView:weak_self.currentParent];
            if (responderView && ([responderView isKindOfClass:[UITextField class]] || [responderView isKindOfClass:[UITextView class]])) {
                weak_self.currentResponder = responderView;
            }
            
            //屏幕旋转监听 添加
            [[NSNotificationCenter defaultCenter] removeObserver:weak_self name:UIDeviceOrientationDidChangeNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:weak_self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
            
            //关闭键盘
            [weak_self.currentParent endEditing:YES];
        }

        if (weak_self.hidden == YES) {
            weak_self.alpha = 0;
            weak_self.hidden = NO;
            dp_arc_block(self);
            [UIView animateWithDuration:DPMAVAnimateDuration animations:^{
                weak_self.alpha = 1;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
        }else {
            weak_self.alpha = 1;
        }
    });
}
//动画隐藏弹框
- (void)hiddenViewCompletion:(void (^)(DPBannerAlertView *aObject))completion {
    dp_arc_block(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        //屏幕旋转监听 删除
        [[NSNotificationCenter defaultCenter] removeObserver:weak_self name:UIDeviceOrientationDidChangeNotification object:nil];
        
        //当前键盘响应焦点，恢复响应状态
        if (weak_self.currentResponder) {
            if ([weak_self.currentResponder isKindOfClass:[UITextField class]]) {
                [((UITextField *)weak_self.currentResponder) becomeFirstResponder];
            }else if ([weak_self.currentResponder isKindOfClass:[UITextView class]]) {
                [((UITextView *)weak_self.currentResponder) becomeFirstResponder];
            }
        }
        
        [UIView animateWithDuration:DPMAVAnimateDuration animations:^{
            weak_self.alpha = 0;
        } completion:^(BOOL finished) {
            weak_self.hidden = YES;
            [weak_self removeFromSuperview];
            if (weak_self.currentParent == weak_self.customWindow) {
                weak_self.currentParent.hidden = YES;
            }

            if (completion) {
                completion(self);
            }
        }];
    });
}

#pragma mark - 本类公共函数
//获取当前响应对象
- (UIView *)findResponderForView:(UIView *)aView {
    if (aView.isFirstResponder) {
        return aView;
    }
    for (UIView *subView in [aView subviews]) {
        UIView *firstResponder = [self findResponderForView:subView];
        if (nil != firstResponder) {
            return firstResponder;
        }
    }
    return nil;
}
@end

