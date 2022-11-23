//
//  DPBaseViewController.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright (c) 2021年 xiayupeng. All rights reserved.
//

#import "DPBaseViewController.h"
#import "DPWidgetSumPlus.h"

@interface DPBaseViewController () {
    
}
@end

@implementation DPBaseViewController
#pragma mark <--------------View lifecycle-------------->
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.viewWillAppearBlock) {
        //返回BOOL值, 为YES则停止基类中的判断逻辑, 为NO则继续使用基类中的判断逻辑.
        BOOL isReturn = self.viewWillAppearBlock(self, animated);
        if (isReturn) {
            return;
        }
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.viewDidAppearBlock) {
        //返回BOOL值, 为YES则停止基类中的判断逻辑, 为NO则继续使用基类中的判断逻辑.
        BOOL isReturn = self.viewDidAppearBlock(self, animated);
        if (isReturn) {
            return;
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.viewWillDisappearBlock) {
        //返回BOOL值, 为YES则停止基类中的判断逻辑, 为NO则继续使用基类中的判断逻辑.
        BOOL isReturn = self.viewWillDisappearBlock(self, animated);
        if (isReturn) {
            return;
        }
    }
    //关闭键盘
    [self.view endEditing:YES];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.viewDidDisappearBlock) {
        //返回BOOL值, 为YES则停止基类中的判断逻辑, 为NO则继续使用基类中的判断逻辑.
        BOOL isReturn = self.viewDidDisappearBlock(self, animated);
        if (isReturn) {
            return;
        }
    }
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self layoutSubviewsCustom];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.viewWillAppearBlock) {
        self.viewWillAppearBlock = nil;
    }
    if (self.viewDidAppearBlock) {
        self.viewDidAppearBlock = nil;
    }
    if (self.viewWillDisappearBlock) {
        self.viewWillDisappearBlock = nil;
    }
    if (self.viewDidDisappearBlock) {
        self.viewDidDisappearBlock = nil;
    }
    if (self.viewDidLoadBlock) {
        self.viewDidLoadBlock = nil;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.viewDidLoadBlock) {
        //返回BOOL值, 为YES则停止基类中的判断逻辑, 为NO则继续使用基类中的判断逻辑.
        BOOL isReturn = self.viewDidLoadBlock(self, NO);
        if (isReturn) {
            return;
        }
    }

    self.view.backgroundColor = DPSMDate.baseContent_viewStyle[@"bgColor"];
    _isHiddenNavBarView = NO;
    _isHiddenBackBtn = NO;
    
    [self createNavigationBarView];
}

#pragma mark <-----自定义Navigation导航栏----->
/**
 *  自定义Navigation导航栏
 */
- (void)createNavigationBarView {
    if (_isHiddenNavBarView) {
        return;
    }
    
    self.navBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, DP_NavibarHeight)];
    _navBarView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    _navBarView.userInteractionEnabled = YES;
    UIColor *startColor = DPSMDate.navBarGB_viewStyle[@"startColor"];
    UIColor *endColor = DPSMDate.navBarGB_viewStyle[@"endColor"];
    if (startColor != nil && endColor != nil) {
        if (CGColorEqualToColor(startColor.CGColor, endColor.CGColor)) {
            _navBarView.backgroundColor = startColor;
        }else {
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
            gradientLayer.locations = @[@0,@1.0];
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(0, 1.0);
            gradientLayer.frame = _navBarView.bounds;
            
            UIGraphicsBeginImageContextWithOptions(gradientLayer.frame.size, NO, 0);
            [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *backImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            _navBarView.backgroundColor = [UIColor colorWithPatternImage:backImage];
        }
    }else if (startColor != nil) {
        _navBarView.backgroundColor = startColor;
    }else if (endColor != nil) {
        _navBarView.backgroundColor = endColor;
    }
    [self.view addSubview:_navBarView];    
    
    CGFloat titleLabelW = _navBarView.dp_width-DP_FrameWidth(70)*2;
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((_navBarView.dp_width-titleLabelW)/2, DP_StatusbarHeight, titleLabelW, _navBarView.dp_height-DP_StatusbarHeight)];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    _titleLabel.font = DPSMDate.navBarTitle_labStyle[@"font"];
    _titleLabel.textColor = DPSMDate.navBarTitle_labStyle[@"titleColor"];
    [_navBarView addSubview:_titleLabel];
    
    self.leftBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBackBtn setFrame:CGRectMake(0, DP_StatusbarHeight, 40, self.titleLabel.dp_height)];
    _leftBackBtn.hidden = _isHiddenBackBtn;
    [_leftBackBtn setContentMode:UIViewContentModeCenter];
    _leftBackBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    UIImage *leftBackBtnImage = DPSMDate.navBarBack_btnStyle[@"image"];
    if (leftBackBtnImage && [leftBackBtnImage isKindOfClass:[UIImage class]]) {
        _leftBackBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [_leftBackBtn setImage:leftBackBtnImage forState:UIControlStateNormal];
        [_leftBackBtn setImage:leftBackBtnImage forState:UIControlStateHighlighted];
    }else {
        _leftBackBtn.titleLabel.font = DPSMDate.navBarBack_btnStyle[@"font"];
        [_leftBackBtn setTitleColor:DPSMDate.navBarBack_btnStyle[@"titleColor"] forState:UIControlStateNormal];
        [_leftBackBtn setTitleColor:DPSMDate.navBarBack_btnStyle[@"titleColor"] forState:UIControlStateHighlighted];
    }
    [_leftBackBtn addTarget:self action:@selector(leftBackBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_navBarView addSubview:_leftBackBtn];
}
//导航栏左侧返回按钮点击事件
- (void)leftBackBtnAction:(id)sender {
    [self dp_popVcWithAnimated:YES];
    
    if (self.leftBackBtnActionBlock) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
            self.leftBackBtnActionBlock(self);
        });
    }
}

#pragma mark <-----自定义ContentView父视图----->
/**
 *  基类扩展父视图
 *
 *  @return UIScrollView 属性的父视图
 */
- (DPBaseContentView *)contentView {
    if (_contentView == nil) {
        _contentView = [DPBaseContentView initWithSuperView:self.view];
        //ScrollView显示区域扩展
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_11_0
        self.automaticallyAdjustsScrollViewInsets = NO;
#endif
        _contentView.backgroundColor = DPSMDate.baseContent_viewStyle[@"bgColor"];
        _contentView.frame = [self getContentFrame];
        _contentView.contentSize = CGSizeMake(_contentView.dp_width, _contentView.dp_height);
        [self.view addSubview:_contentView];
        
        //"navigationBarView"层级高于"contentView"
        if (_navBarView != nil && [_navBarView.superview isEqual:self.view]) {
            [self.view insertSubview:_navBarView aboveSubview:_contentView];
        }
    }
    return _contentView;
}

#pragma mark <-------------Setter_methods------------->
- (void)setContentLayoutType:(NSInteger)contentLayoutType {
    _contentLayoutType = contentLayoutType;
    [self layoutSubviewsCustom];
}
- (void)setIsHiddenNavBarView:(BOOL)isHiddenNavBarView {
    _isHiddenNavBarView = isHiddenNavBarView;
    if (_isHiddenNavBarView) {
        if (_navBarView != nil) {
            _navBarView.hidden = _isHiddenNavBarView;
        }
    }else {
        if (_navBarView == nil) {
            [self createNavigationBarView];
        }
        _navBarView.hidden = _isHiddenNavBarView;
    }
    [self layoutSubviewsCustom];
}
- (void)setIsHiddenBackBtn:(BOOL)isHiddenLeftBackBtn {
    _isHiddenBackBtn = isHiddenLeftBackBtn;
    _leftBackBtn.hidden = _isHiddenBackBtn;
}

#pragma mark <--------------本类公共函数-------------->
//自适应调整当前类显示区域内容排版布局
- (void)layoutSubviewsCustom {
    //页面内容显示区域(自动延伸显示区域，兼容小屏幕),根据控制器rootView自适应修改frame.
    if (_contentView != nil && [[_contentView superview] isEqual:self.view]) {
        if (!CGRectEqualToRect(_contentView.frame, [self getContentFrame])) {
            _contentView.frame = [self getContentFrame];
        }
        if (!CGSizeEqualToSize(_contentView.contentSize, _contentView.dp_size)) {
            _contentView.contentSize = _contentView.dp_size;
        }
    }
}
//根据上、下导航栏显示状态，获取主视图frame
- (CGRect)getContentFrame {
    CGFloat minY = 0;
    CGFloat height = 0;
    
    if (self.parentViewController != nil &&
        [self.parentViewController.childViewControllers containsObject:self] &&
        (self.navigationController != nil &&
         ![self.navigationController.viewControllers containsObject:self])) {
        //当前控制器为childViewController，contentview高度计算，使用控制器根视图的frame，layout自动适配
        if (_contentLayoutType == 0) {
            //contentView的frame为屏幕中除去上下导航栏以外的区域(上导航栏不能与contentView重叠)
            if (_navBarView && _navBarView.hidden == NO && [_navBarView superview]) {
                //navigationBar导航栏显示
                minY = DP_NavibarHeight;
                height = self.view.dp_height-DP_NavibarHeight;
            }else {
                //navigationBar导航栏 nil 或 不显示
                minY = 0;
                height = self.view.dp_height;
            }
        }else {
            //contentView的frame为屏幕中除去下导航栏以外的区域(上导航栏可以与contentView重叠)
            minY = 0;
            height = self.view.dp_height;
        }
    }else {
        //当前控制器非childViewController，contentview高度计算，使用widow的frame减去上、下导航栏的高度，手动计算
        if (_contentLayoutType == 0) {
            //contentView的frame为屏幕中除去上下导航栏以外的区域(上导航栏不能与contentView重叠)
            if (self.tabBarController.tabBar.hidden == YES || self.hidesBottomBarWhenPushed == YES || self.tabBarController.tabBar == nil) {
                //tabBar导航栏为 nil 或 不显示
                if (_navBarView && _navBarView.hidden == NO && [_navBarView superview]) {
                    //navigationBar导航栏显示
                    minY = DP_NavibarHeight;
                    height = self.view.dp_height-DP_NavibarHeight;
                }else {
                    //navigationBar导航栏 nil 或 不显示
                    minY = 0;
                    height = self.view.dp_height;
                }
            }else {
                //tabBar导航显示
                if (_navBarView && _navBarView.hidden == NO && [_navBarView superview]) {
                    //navigationBar导航栏显示
                    minY = DP_NavibarHeight;
                    height = self.view.dp_height-DP_NavibarHeight-DP_TabbarHeight;
                }else {
                    //navigationBar导航栏 nil 或 不显示
                    minY = 0;
                    height = self.view.dp_height-DP_TabbarHeight;
                }
            }
        }else {
            //contentView的frame为屏幕中除去下导航栏以外的区域(上导航栏可以与contentView重叠)
            if (self.tabBarController.tabBar.hidden == YES || self.hidesBottomBarWhenPushed == YES || self.tabBarController.tabBar == nil) {
                //tabBar导航栏为 nil 或 不显示
                minY = 0;
                height = self.view.dp_height;
            }else {
                //tabBar导航显示
                minY = 0;
                height = self.view.dp_height-DP_TabbarHeight;
            }
        }
    }
    return CGRectMake(0, minY, self.view.dp_width, height);
}

#pragma mark <--------------外部调用函数-------------->
//显示|隐藏默认视图
- (void)showDefaulWithSuperView:(UIView *)aSuperView useType:(NSInteger)aUseType dataCount:(NSInteger)aDataCount btnBlock:(DPDefaultViewButtonBlock)aBtnBlock {
    [self showDefaulWithSuperView:nil useType:aUseType title:nil btnTitles:nil showType:3 layoutType:2 dataCount:aDataCount btnBlock:aBtnBlock];
}
//显示|隐藏默认视图
- (void)showDefaulWithSuperView:(UIView *)aSuperView useType:(NSInteger)aUseType title:(NSString *)aTitle btnTitles:(NSArray <NSString *>*)aBtnTitles showType:(int)aShowType layoutType:(int)aLayoutType dataCount:(NSInteger)aDataCount btnBlock:(DPDefaultViewButtonBlock)aBtnBlock {
    aSuperView = aSuperView != nil ? aSuperView : _contentView;
    aSuperView = aSuperView != nil ? aSuperView : self.view;
    UIImage *aImage = nil;
    if (aUseType == 0) {
        aImage = DPSMDate.baseContent_imageValus[@"imageOne"];
        aTitle = aTitle.length > 0 ? aTitle : DPSMDate.baseContent_textValus[@"textOne"];;
    }else if (aUseType == 1) {
        aImage = DPSMDate.baseContent_imageValus[@"imageTow"];
        aTitle = aTitle.length > 0 ? aTitle : DPSMDate.baseContent_textValus[@"textTow"];
    }
    aBtnTitles = aBtnTitles.count > 0 ? aBtnTitles : @[DPSMDate.baseContent_textValus[@"textThree"]];
    if (aDataCount < 1) {
        [DPDefaultView showDefaulWithSuperView:aSuperView topImage:aImage title:aTitle btnTitles:aBtnTitles showType:aShowType layoutType:aLayoutType btnBlock:aBtnBlock];
    }else {
        [DPDefaultView hiddenDefaulTSuperView:aSuperView];
    }
}
@end
