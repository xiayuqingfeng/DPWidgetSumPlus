//
//  DPUIBaseViewController.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import "DPUIBaseViewController.h"
#import "DPWidgetSum.h"

@interface DPUIBaseViewController (){
    
}
///当前viewcontroller是否支持转屏, 临时变量
@property (nonatomic, assign) BOOL tempIsAutorotateBase;
///当前viewcontroller支持哪些转屏方向, 临时变量
@property (nonatomic, assign) UIInterfaceOrientationMask tempSupportedInterfaceOrientationsBase;
@end

@implementation DPUIBaseViewController
- (id)init{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        _statusBarHiddenBase = NO;
        _superStatusBarStyle = UIStatusBarStyleLightContent;
        _isAutorotateBase = NO;
        _supportedInterfaceOrientationsBase = UIInterfaceOrientationMaskAllButUpsideDown;
        _defaultPresentationBase = UIInterfaceOrientationPortrait;
        _disappearPresentationBase = self.defaultPresentationBase;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark <-------------Setter_methods------------->
- (void)setStatusBarHiddenBase:(BOOL)statusBarHiddenBase {
    _statusBarHiddenBase = statusBarHiddenBase;
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}
- (void)setSuperStatusBarStyle:(UIStatusBarStyle)superStatusBarStyle {
    _superStatusBarStyle = superStatusBarStyle;
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}
- (void)setIsAutorotateBase:(BOOL)isAutorotateBase {
    _isAutorotateBase = isAutorotateBase;
    self.tempIsAutorotateBase = _isAutorotateBase;
}
- (void)setSupportedInterfaceOrientationsBase:(UIInterfaceOrientationMask)supportedInterfaceOrientationsBase {
    _supportedInterfaceOrientationsBase = supportedInterfaceOrientationsBase;
    self.tempSupportedInterfaceOrientationsBase = _supportedInterfaceOrientationsBase;
}

#pragma mark <--------------基类函数-------------->
//是否隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return _statusBarHiddenBase;
}
//状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return _superStatusBarStyle;
}
//当前viewcontroller是否支持转屏
- (BOOL)shouldAutorotate {
    return _tempIsAutorotateBase;
}
//当前viewcontroller支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (_tempIsAutorotateBase == YES) {
        if (_tempSupportedInterfaceOrientationsBase & UIInterfaceOrientationMaskAllButUpsideDown) {
            return _tempSupportedInterfaceOrientationsBase;
        }else{
            return UIInterfaceOrientationMaskAllButUpsideDown;
        }
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}
//当前viewcontroller默认的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if (_tempIsAutorotateBase == YES && (_defaultPresentationBase == UIInterfaceOrientationPortrait || _defaultPresentationBase == UIInterfaceOrientationLandscapeLeft || _defaultPresentationBase == UIInterfaceOrientationLandscapeRight)) {
        return _defaultPresentationBase;
    }else{
        return UIInterfaceOrientationPortrait;
    }
}
//当根视图控制器的窗口旋转或调整大小时调用此方法
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    dp_arc_block(self);
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
        weak_self.tempIsAutorotateBase = weak_self.isAutorotateBase;
        weak_self.tempSupportedInterfaceOrientationsBase = weak_self.supportedInterfaceOrientationsBase;
    }];
}

#pragma mark <--------------旋转屏幕-------------->
///手动旋转屏幕，并设置屏幕旋转权限。(警告：当前App屏幕旋转，只支持向上、向左、向右三个方向)
- (void)mandatoryRotationWithIsAutorotateBase:(BOOL)aIsAutorotateBase supportedInterfaceOrientationsBase:(UIInterfaceOrientationMask)aSupportedInterfaceOrientationsBase orientation:(UIInterfaceOrientation)aOrientation{
    if (aOrientation == UIInterfaceOrientationPortrait || aOrientation == UIInterfaceOrientationLandscapeLeft || aOrientation == UIInterfaceOrientationLandscapeRight){
        self.isAutorotateBase = aIsAutorotateBase;
        self.supportedInterfaceOrientationsBase = aSupportedInterfaceOrientationsBase;
        if (aOrientation != [UIApplication sharedApplication].statusBarOrientation && [[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            UIInterfaceOrientation val = aOrientation;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }
}
///push或pop动作时，屏幕提前旋转为即将进入界面的方向。旋转开始时，屏幕旋转权限设置全开。旋转结束时，屏幕旋转权限设置恢复。（警告：当前App屏幕旋转，只支持向上、向左、向右三个方向）
- (void)tempMandatoryRotationWithOrientation:(UIInterfaceOrientation)aOrientation{
    if (aOrientation == UIInterfaceOrientationPortrait || aOrientation == UIInterfaceOrientationLandscapeLeft || aOrientation == UIInterfaceOrientationLandscapeRight){
        if (aOrientation != [UIApplication sharedApplication].statusBarOrientation && [[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            if (_tempSupportedInterfaceOrientationsBase != UIInterfaceOrientationMaskAllButUpsideDown) {
                self.tempSupportedInterfaceOrientationsBase = UIInterfaceOrientationMaskAllButUpsideDown;
            }
            if (_tempIsAutorotateBase == NO) {
                self.tempIsAutorotateBase = YES;
            }
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            UIInterfaceOrientation val =aOrientation;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }
}
@end
