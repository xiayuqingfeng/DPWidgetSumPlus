//
//  DPBaseContentView.m
//  DPWidgetSumDemo
//
//  Created by yupeng xia on 2021/7/26.
//  Copyright © 2021 yupeng xia. All rights reserved.
//

#import "DPBaseContentView.h"
#import "DPWidgetSum.h"

@interface DPBaseContentView () {
    
}
//当前键盘显示状态，默认值：NO 隐藏
@property (nonatomic, assign) BOOL keyboardIsVisible;
@end

@implementation DPBaseContentView
#pragma mark <--------------外部调用函数-------------->
+ (DPBaseContentView *)initWithSuperView:(UIView *)aSuperView {
    DPBaseContentView *aContentView = [[DPBaseContentView alloc] init];
    if (@available(iOS 11.0, *)) {
        aContentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    aContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    aContentView.scrollsToTop = NO;
    aContentView.showsHorizontalScrollIndicator = NO;
    aContentView.showsVerticalScrollIndicator = NO;
    return aContentView;
}

#pragma mark <--------------系统函数-------------->
//参数控制，点击键盘以外区域关闭键盘，点击输入框不关闭键盘
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (_shouldResignOnTouchOutside &&
        _keyboardIsVisible &&
        ![self isHitInputBoxView:view]) {
        [self endEditing:YES];
    }
    return view;
}
//判断当前视图的“更高级”父视图是否是输入框，循环获取父视图
- (BOOL)isHitInputBoxView:(UIView *)aView {
    if (aView) {
        if ([aView isKindOfClass:[UITextField class]]) {
            return YES;
        }else if ([aView isKindOfClass:[UITextView class]]) {
            return YES;
        }else {
            UIView *aSuperview = [aView superview];
            if (aSuperview) {
                return [self isHitInputBoxView:aSuperview];
            }
        }
    }
    return NO;
}
- (void)addSubview:(UIView *)view {
    [super addSubview:view];
    [self rootViewHeightToFit];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self rootViewHeightToFit];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)init {
    self = [super init];
    if (self) {
        _isAutomaticHeight = YES;
        _shouldResignOnTouchOutside = YES;
        _keyboardIsVisible = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

#pragma mark <-------------NSNotificationCenter------------->
- (void)keyboardDidShow {
    self.scrollEnabled = NO;
    self.keyboardIsVisible = YES;
    [self rootViewHeightToFit];
}
- (void)keyboardDidHide {
    self.scrollEnabled = YES;
    self.keyboardIsVisible = NO;
    [self rootViewHeightToFit];
}

#pragma mark <-------------Setter_methods------------->
- (void)setisAutomaticHeight:(BOOL)isAutomaticHeight {
    _isAutomaticHeight = isAutomaticHeight;
    [self rootViewHeightToFit];
}

#pragma mark <-------------公共函数------------->
//参数控制，rootView根据子视图显示范围高度自适应，父视图superScrollView的contentSize保持同步
- (void)rootViewHeightToFit {
    if (_isAutomaticHeight) {
        CGFloat maxContentHeight = self.dp_height;
        for (UIView *aView in self.subviews) {
            if (aView.dp_yMax > maxContentHeight &&
                aView.dp_x >= 0 &&
                aView.dp_xMax <= self.dp_width &&
                aView.dp_y >= 0 &&
                aView.dp_width > 0 &&
                aView.dp_height > 0 &&
                aView.hidden == NO &&
                aView.alpha != 0) {
                maxContentHeight = aView.dp_yMax+DP_FrameHeight(20);
            }
        }
        if (maxContentHeight > self.dp_height) {
            self.contentSize = CGSizeMake(self.contentSize.width, maxContentHeight);
        }
        if (self.contentSize.height < self.dp_height) {
            self.contentSize = CGSizeMake(self.contentSize.width, self.contentSize.height);
        }
    }else {
        CGSize newSize = self.contentSize;
        if (newSize.width < self.dp_width || newSize.height < self.dp_height) {
            if (newSize.width < self.dp_width) {
                newSize.width = self.dp_width;
            }
            if (newSize.height < self.dp_height) {
                newSize.height = self.dp_height;
            }
            self.contentSize = self.dp_size;
        }
    }
}
@end
