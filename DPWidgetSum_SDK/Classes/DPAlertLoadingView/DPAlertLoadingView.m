//
//  DPAlertLoadingView.m
//  DPWidgetSumDemo
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import "DPAlertLoadingView.h"
#import <objc/runtime.h>
#import "DPWidgetSum.h"
#import "DPBallRotationProgress.h"

static const char *RY_CLICKKEY = "DPAlertLoadingViewCLICKKEY";

@interface DPAlertLoadingView() {
    
}
@property (nonatomic, strong) DPBallRotationProgress *ballsView;
///计数
@property (nonatomic, assign) NSInteger count;
@end

@implementation DPAlertLoadingView
+ (void)showAlertLoadingViewToView:(UIView *)view {
    [self setLoadingView:view rect:view.bounds message:nil];
}
+ (void)showAlertLoadingViewToView:(UIView *)view rect:(CGRect)rect {
    [self setLoadingView:view rect:rect message:nil];
}
+ (void)showAlertLoadingViewToView:(UIView *)view message:(NSString *)message {
    [self setLoadingView:view rect:view.bounds message:message];
}
+ (void)showAlertLoadingViewToView:(UIView *)view rect:(CGRect)rect message:(NSString *)message {
    if (CGRectEqualToRect(rect,CGRectZero)) {
        [self setLoadingView:view rect:view.bounds message:message];
    }else {
        [self setLoadingView:view rect:rect message:message];
    }
}

+ (void)setLoadingView:(UIView *)view rect:(CGRect)rect message:(NSString *)message {
    if (view == nil) {
        return;
    }
    
    //已存在    
    DPAlertLoadingView *loadingView = objc_getAssociatedObject(view, RY_CLICKKEY);
    if (loadingView) {
        loadingView.count++;
        UILabel *label = [loadingView viewWithTag:12432];
        if (message.length == 0) {
            label.text = @"加载中，请稍候...";
        }else {
            label.text = message;
        }
        loadingView.frame = rect;
        return;
    }
    
    loadingView = [[DPAlertLoadingView alloc]initWithFrame:rect];
    loadingView.count++;
    loadingView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    loadingView.opaque = 0;
    [view addSubview:loadingView];
    
    CGFloat w = MIN(DP_ScreenWidth, DP_ScreenHeight)/1.8;
    CGFloat h = w/17 *10;
    UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, w, h)];
    alertView.center = CGPointMake(loadingView.dp_width/2, loadingView.dp_height/2);
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = 7;
    alertView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [loadingView addSubview:alertView];

    loadingView.ballsView = [[DPBallRotationProgress alloc] initWithFrame:CGRectMake(0, 35, alertView.dp_width, 20)];
    loadingView.ballsView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [loadingView.ballsView startAnimator];
    [alertView addSubview:loadingView.ballsView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, loadingView.ballsView.dp_yMax+10, alertView.dp_width, 30)];
    label.tag = 12432;
    [alertView addSubview:label];
    if (message.length == 0) {
        label.text = @"加载中，请稍候...";
    }else {
        label.text = message;
    }
    label.textColor = DP_RGBA(0, 0, 51, 1);
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    
    objc_setAssociatedObject(view, RY_CLICKKEY, loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+ (void)hideAllAlertLoadingViewAtView:(UIView *)view {
    if (view) {
        DPAlertLoadingView *alertView = objc_getAssociatedObject(view, RY_CLICKKEY);
        if (alertView) {
            alertView.count--;
            if (alertView.count <=  0) {
                //释放
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DPAlertLoadingViewStayTime *NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
                    if (alertView) {
                        if (alertView.ballsView) {
                            [alertView.ballsView stopAnimator];
                        }
                        if (alertView.superview) {
                            [alertView removeFromSuperview];
                        }
                        objc_setAssociatedObject(view, RY_CLICKKEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    }
                });
            }
        }
    }
}
+ (void)hideAllDPAlertLoadingViewImmediatelyAtView:(UIView *)view {
    if (view) {
        DPAlertLoadingView *alertView = objc_getAssociatedObject(view, RY_CLICKKEY);
        if (alertView) {
            alertView.count = 0;
            [self hideAllAlertLoadingViewAtView:view];
        }
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    size_t locationsCount = 2;
    CGFloat locations[2] = {0.0f, 1.0f};
    CGFloat colors[8] = {0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.75f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
    CGColorSpaceRelease(colorSpace);
    
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) ;
    CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
}

- (void)dealloc {
    if (_ballsView) {
        [_ballsView stopAnimator];
    }
}
@end
