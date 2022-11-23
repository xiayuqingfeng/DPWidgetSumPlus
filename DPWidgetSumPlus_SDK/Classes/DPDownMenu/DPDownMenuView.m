//
//  DPDownMenuView.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 zcw. All rights reserved.
//

#import "DPDownMenuView.h"
#import "DPWidgetSumPlus.h"
#import <ReactiveObjC/ReactiveObjC.h>

#define listBGViewMaxHeight DP_FrameHeight(250)

@interface DPDownMenuView (){
    
}
//菜单弹框弹出，需要置顶的父视图
@property (nonatomic, weak) UIView *aRootView;
//背景视图
@property (nonatomic, strong) UIView *listBGView;
//左边文字 Label
@property (nonatomic, strong) UILabel *leftLabel;
//右边图片 Button
@property (nonatomic, strong) UIButton *rigthButton;
//菜单按钮父视图
@property (nonatomic, strong) UIScrollView *btnBgView;

@property (nonatomic, weak) UIView *currentSuperView;
@property (nonatomic, assign) CGRect currentFrame;
@property (nonatomic, strong) NSMutableArray *listBtnArray;
@end

@implementation DPDownMenuView
- (void)dealloc {
    if (self.aTapBlock) {
        self.aTapBlock = nil;
    }
    if (self.aTapEnabledBlock) {
        self.aTapEnabledBlock = nil;
    }
}
//aSuperView: 不可为空，当前控件父视图；aRootView:  可为空，当前控件“弹出按钮菜单”父视图；aSelectBlock: 可为空，当前控件“菜单按钮”点击事件回调；
+ (id)initWithSuperView:(UIView *)aSuperView rootView:(UIView *)aRootView selectBlock:(DPDownMenuViewButtonBlock)aSelectBlock {
    DPDownMenuView *downMenuView = [[DPDownMenuView alloc] initWithSuperView:aSuperView rootView:aRootView selectBlock:aSelectBlock];
    return downMenuView;
}
- (id)initWithSuperView:(UIView *)aSuperView rootView:(UIView *)aRootView selectBlock:(DPDownMenuViewButtonBlock)aSelectBlock {
    self = [super init];
    if (self) {
        self.clipsToBounds = NO;
        dp_arc_block(self);
        [RACObserve(self, frame) subscribeNext:^(id  _Nullable x) {
            if (weak_self.menuHidden && !CGRectEqualToRect(weak_self.currentFrame, weak_self.frame)) {
                weak_self.currentFrame = weak_self.frame;
                [weak_self uploadViewLoad];
            }
        }];
        [RACObserve(self, center) subscribeNext:^(id  _Nullable x) {
            if (weak_self.menuHidden && !CGRectEqualToRect(weak_self.currentFrame, weak_self.frame)) {
                weak_self.currentFrame = weak_self.frame;
                [weak_self uploadViewLoad];
            }
        }];
        
        _currentSuperView = aSuperView;
        _aRootView = aRootView;
        self.aTapBlock = aSelectBlock;

        _arrowNImage = dp_BundleImageNamed(@"dp_down_arrow.png");
        _arrowSImage = dp_BundleImageNamed(@"dp_up_arrow.png");
        _lrGap = DP_FrameWidth(12);
        _textFont = DP_Font(15);

        UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction:)];
        [self addGestureRecognizer:viewTap];

        //背景视图
        self.listBGView = [[UIView alloc] init];
        _listBGView.layer.cornerRadius = 3;
        _listBGView.layer.borderWidth = 0.5;
        _listBGView.layer.borderColor = DP_RGBA(230, 233, 240, 1).CGColor;
        _listBGView.layer.shadowColor = UIColor.clearColor.CGColor;
        _listBGView.layer.shadowOffset = CGSizeMake(0, 0);
        _listBGView.layer.shadowOpacity = 0.2;
        _listBGView.layer.shadowRadius = 0;
        _listBGView.clipsToBounds = NO;
        [self addSubview:_listBGView];

        //右边图片 Button
        self.rigthButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rigthButton.contentMode = UIViewContentModeScaleAspectFit;
        [_rigthButton setImage:_arrowNImage forState:UIControlStateNormal];
        [_rigthButton setImage:_arrowSImage forState:UIControlStateSelected];
        [[_rigthButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weak_self viewTapAction:x];
        }];
        [_listBGView addSubview:_rigthButton];

        //左边文字 Label
        self.leftLabel = [[UILabel alloc] init];
        _leftLabel.adjustsFontSizeToFitWidth = YES;
        _leftLabel.numberOfLines = 1;
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.font = _textFont;
        _leftLabel.textColor = DP_RGBA(43, 56, 120, 1);
        [_listBGView addSubview:_leftLabel];

        //菜单按钮父视图
        self.btnBgView = [[UIScrollView alloc] init];
        _btnBgView.clipsToBounds = YES;
        [_listBGView addSubview:_btnBgView];

        //列表按钮数组
        self.dataArray = @[];
        
        [self uploadViewLoad];
    }
    return self;
}
- (void)viewTapAction:(id)sender {
    UIView *firstResponder = [[UIApplication sharedApplication].dp_keyWindow dp_findFirstResponder];
    [firstResponder resignFirstResponder];
    
    if (_menuHidden) {
        if (self.aTapEnabledBlock) {
            BOOL tapBool = self.aTapEnabledBlock(self);
            if (!tapBool) {
                return;
            }
        }
    }
    
    self.menuHidden = !_menuHidden;
}

#pragma mark <-------------Setter_methods------------->
- (void)setArrowNImage:(UIImage *)arrowNImage {
    _arrowNImage = arrowNImage;
    [_rigthButton setImage:_arrowNImage forState:UIControlStateNormal];
}
- (void)setArrowSImage:(UIImage *)arrowSImage {
    _arrowSImage = arrowSImage;
    [_rigthButton setImage:_arrowSImage forState:UIControlStateSelected];
}
- (void)setLrGap:(CGFloat)lrGap {
    _lrGap = lrGap;
    
    [self uploadViewLoad];
}
- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    
    [self uploadViewLoad];
}
- (void)setDataArray:(NSArray<NSDictionary *> *)dataDrray {
    _dataArray = dataDrray;
    _dataArray = [@[@{@"":@"请选择"}] arrayByAddingObjectsFromArray:[_dataArray mutableCopy]];

    if (_listBtnArray.count < dataDrray.count) {
        for (UIButton *button in _listBtnArray) {
            if (button.superview) {
                [button removeFromSuperview];
            }
        }
        
        self.listBtnArray = [NSMutableArray array];
        for (int i = 0; i < dataDrray.count; i++) {
            UIButton *listBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            listBtn.hidden = YES;
            listBtn.titleLabel.font = _textFont;
            [listBtn setTitleColor:DP_RGBA(43, 56, 120, 1) forState:UIControlStateNormal];
            [listBtn setTitleColor:DP_RGBA(43, 56, 120, 1) forState:UIControlStateSelected];
            dp_arc_block(self);
            [[listBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                if (!weak_self.menuHidden) {
                    for (UIButton *btn in weak_self.listBtnArray) {
                        btn.selected = NO;
                    }
                    x.selected = YES;

                    weak_self.selectDic = [weak_self.dataArray dp_objectAtIndex:x.tag-101];

                    weak_self.leftLabel.text = dp_notEmptyStr(weak_self.selectDic.allValues.firstObject);
                    if (dp_notEmptyStr(weak_self.selectDic.allKeys.firstObject).length > 0) {
                        weak_self.leftLabel.textColor = DP_RGBA(43, 56, 120, 1);
                    }else {
                        weak_self.leftLabel.textColor = DP_RGBA(115, 127, 174, 1);
                    }

                    weak_self.menuHidden = YES;

                    if (weak_self.aTapBlock) {
                        weak_self.aTapBlock(weak_self, 0);
                    }
                }
            }];
            [_btnBgView addSubview:listBtn];

            [_listBtnArray addObject:listBtn];
        }
    }

    [self uploadViewLoad];
}
- (void)setSelectDic:(NSDictionary *)selectDic {
    _selectDic = selectDic;
    
    if (self.aTapBlock) {
        self.aTapBlock(self, 1);
    }
    
    [self uploadViewLoad];
}
- (void)setMenuHidden:(BOOL)menuHidden {
    _menuHidden = menuHidden;
    
    [self uploadMenuViewShowType];
}
- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    [super setUserInteractionEnabled:userInteractionEnabled];
    [self uploadViewLoad];
}

#pragma mark <--------------公共函数-------------->
//刷新页面布局
- (void)uploadViewLoad {
    _menuHidden = YES;
    [_currentSuperView addSubview:self];
    
    if (_selectDic && _selectDic.allKeys.firstObject.length) {
        for (NSDictionary *aDic in _dataArray) {
            if ([_selectDic.allKeys.firstObject isEqualToString:aDic.allKeys.firstObject]) {
                _selectDic = aDic;
                if (self.aTapBlock) {
                    self.aTapBlock(self, 1);
                }
            }
        }
    }
    
    //背景视图
    _listBGView.frame = CGRectMake(0, 0, _currentFrame.size.width, _currentFrame.size.height);
    _listBGView.backgroundColor = self.backgroundColor;
    
    //右边图片 Button
    _rigthButton.frame = CGRectMake(_listBGView.dp_width-_lrGap-_arrowNImage.size.width, 0, _arrowNImage.size.width, _listBGView.dp_height);
    _rigthButton.userInteractionEnabled = self.userInteractionEnabled;
    _rigthButton.hidden = !self.userInteractionEnabled;
    
    //左边文字 Label
    _leftLabel.frame = CGRectMake(_lrGap, 0, _rigthButton.dp_x-_lrGap, _listBGView.dp_height);
    _leftLabel.font = _textFont;
    if (_selectDic) {
        _leftLabel.textColor = DP_RGBA(43, 56, 120, 1);
        _leftLabel.text = dp_notEmptyStr(_selectDic.allValues.firstObject);
    }else {
        _leftLabel.textColor = DP_RGBA(115, 127, 174, 1);
        _leftLabel.text = dp_notEmptyStr(_dataArray.firstObject.allValues.firstObject);
    }
    
    //菜单按钮父视图
    _btnBgView.frame = CGRectMake(0, _currentFrame.size.height, _currentFrame.size.width, 0);
    _btnBgView.hidden = YES;
    
    //列表按钮 显示状态还原
    for (int i = 0; i < _listBtnArray.count; i++) {
        UIButton *listBtn = _listBtnArray[i];
        listBtn.frame = CGRectMake(_leftLabel.dp_x, _currentFrame.size.height*i, _btnBgView.dp_width-_leftLabel.dp_x,  _currentFrame.size.height);
        listBtn.tag = 0;
        listBtn.userInteractionEnabled = self.userInteractionEnabled;
        listBtn.hidden = YES;
        listBtn.selected = NO;
        listBtn.titleLabel.font = _textFont;
    }
    
    //列表按钮 根据当前数据更新显示状态
    for (int i = 1; i < _dataArray.count; i++) {
        UIButton *listBtn = [_listBtnArray dp_objectAtIndex:i-1];
        listBtn.userInteractionEnabled = self.userInteractionEnabled;
        if (listBtn) {
            listBtn.tag = 101+i;
            listBtn.hidden = NO;
            if ([_dataArray indexOfObject:_selectDic] == i) {
                listBtn.selected = YES;
            }else {
                listBtn.selected = NO;
            }
            [listBtn setTitle:_dataArray[i].allValues.firstObject forState:UIControlStateNormal];
        }
    }
}
//刷新菜单显示状态
- (void)uploadMenuViewShowType {
    if (_menuHidden) {
        //隐藏菜单回归初始父视图
        self.frame = _currentFrame;
        [_currentSuperView addSubview:self];
    }else {
        //弹出菜单时会改变父视图
        if (_aRootView && _aRootView != self) {
            CGPoint newPoint = [self convertRect:self.bounds toView:_aRootView].origin;
            self.dp_x = newPoint.x;
            self.dp_y = newPoint.y;
            [_aRootView addSubview:self];
        }else {
            self.frame = _currentFrame;
            [_currentSuperView addSubview:self];
        }
        if (self.superview) {
            [self.superview bringSubviewToFront:self];
        }
    }
    
    //右侧图标状态修改
    _rigthButton.selected = !_menuHidden;

    if (_menuHidden) {
        //菜单隐藏
        _btnBgView.dp_height = 0;
        _btnBgView.hidden = YES;
        
        _listBGView.dp_height = _currentFrame.size.height;
        _listBGView.layer.shadowColor = UIColor.clearColor.CGColor;
        _listBGView.layer.shadowRadius = 0;
        
        for (int i = 0; i < _listBtnArray.count; i++) {
            UIButton *listBtn = _listBtnArray[i];
            listBtn.hidden = YES;
        }
    }else {
        //菜单显示
        _btnBgView.hidden = NO;
        
        _listBGView.layer.shadowColor = UIColor.blackColor.CGColor;
        _listBGView.layer.shadowRadius = 4;
        
        dp_arc_block(self);
        [UIView animateWithDuration:0.25 animations:^{
            //计算按钮排列最大高度
            CGFloat btnBgViewHeight = 0;
            for (int i = 0; i < weak_self.listBtnArray.count; i++) {
                UIButton *listBtn = weak_self.listBtnArray[i];
                if (i < weak_self.dataArray.count-1 && !weak_self.menuHidden) {
                    listBtn.hidden = NO;
                    btnBgViewHeight = listBtn.dp_yMax;
                }else {
                    listBtn.hidden = YES;
                }
            }
            
            //按钮列表菜单高度限制
            weak_self.btnBgView.contentSize = CGSizeMake(weak_self.btnBgView.dp_width, btnBgViewHeight);
            weak_self.btnBgView.dp_height = btnBgViewHeight;
            if (weak_self.btnBgView.dp_height > listBGViewMaxHeight) {
                weak_self.btnBgView.dp_height = listBGViewMaxHeight;
            }
            weak_self.listBGView.dp_height = weak_self.btnBgView.dp_yMax;
            
            //按钮列表菜单高度限制，超出父视图显示区域
            UIView *aSuperView = nil;
            if (weak_self.aRootView
                && weak_self.aRootView != self) {
                aSuperView = weak_self.aRootView;
            }else {
                aSuperView = weak_self.currentSuperView;
            }
            if ([aSuperView isKindOfClass:[UIScrollView class]]) {
                UIScrollView *aScrollView = (UIScrollView *)aSuperView;
                if (weak_self.dp_y+weak_self.listBGView.dp_yMax < aScrollView.contentSize.height) {
                    if (weak_self.dp_y+weak_self.listBGView.dp_yMax > aScrollView.dp_height+aScrollView.contentOffset.y) {
                        [aScrollView setContentOffset:CGPointMake(0, weak_self.dp_y+weak_self.listBGView.dp_yMax-aScrollView.dp_height) animated:YES];
                    }
                }else {
                    CGFloat contentMaxHeight = aScrollView.contentOffset.y+aScrollView.dp_height-weak_self.dp_y;
                    if (weak_self.listBGView.dp_yMax > contentMaxHeight) {
                        weak_self.listBGView.dp_height = contentMaxHeight;
                        weak_self.btnBgView.dp_height = weak_self.listBGView.dp_height-weak_self.btnBgView.dp_y;
                    }
                }
            }else {
                CGFloat contentMaxHeight = aSuperView.dp_height-weak_self.dp_y;
                if (weak_self.listBGView.dp_yMax > contentMaxHeight) {
                    weak_self.listBGView.dp_height = contentMaxHeight;
                    weak_self.btnBgView.dp_height = weak_self.listBGView.dp_height-weak_self.btnBgView.dp_y;
                }
            }
        }];
    }
}

#pragma mark <--------------系统函数-------------->
//菜单列表按钮超出父视图手势响应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (_menuHidden == NO) {
        CGPoint btnBGViewPoint = [_btnBgView convertPoint:point fromView:self];
        if ([_btnBgView pointInside:btnBGViewPoint withEvent:event]) {
            
            for (UIButton *btn in _listBtnArray) {
                CGPoint btnPoint = [btn convertPoint:point fromView:self];
                if ([btn pointInside:btnPoint withEvent:event]) {
                    return btn;
                }
            }
            
        }
        
        CGPoint listBGViewPoint = [_listBGView convertPoint:point fromView:self];
        if (![_listBGView pointInside:listBGViewPoint withEvent:event]) {
            self.menuHidden = YES;
        }
    }

    UIView *view = [super hitTest:point withEvent:event];
    return view;
}
@end
