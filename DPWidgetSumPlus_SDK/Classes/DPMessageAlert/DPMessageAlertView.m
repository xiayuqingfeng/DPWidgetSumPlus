//
//  DPMessageAlertView.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 zcw. All rights reserved.
//

#import "DPMessageAlertView.h"
#import "DPWidgetSumPlus.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import <ReactiveObjC/ReactiveObjC.h>

//当前对象Tag
#define DPMessageAlertViewTag 16800200
//动画时间
#define DPMAVAnimateDuration 0.2
//弹框显示范围上下间距
#define ContentViewTBMaxGap DP_FrameHeight(50)
//按钮对打个数
#define ButtonMaxCount 4
//按钮Tag基数
#define ButtonInitTag 504

@interface DPMessageAlertView (){
    
}
@property (nonatomic, strong) UIWindow *customWindow;
@property (nonatomic, strong) DPMessageAlertView *customAlert;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) TTTAttributedLabel *titleLab;
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) TTTAttributedLabel *contentLab;
@property (nonatomic, strong) UIView *lineView;

//当前键盘响应焦点
@property (nonatomic, weak) id currentResponder;

@property (nonatomic, weak) UIViewController *currentVC;
@property (nonatomic, weak) UIView *currentParent;
@property (nonatomic, strong) id currentTitle;
@property (nonatomic, strong) id currentContent;
@property (nonatomic, strong) NSArray <id>*buttonTitles;
@property (nonatomic, assign) DPMessageAlertStyle currentStyle;

@property (nonatomic, copy) ButtonActionBlock aButtonBlock;
@property (nonatomic, weak) id <DPMessageAlertViewDelegate> aDelegate;
@end

@implementation DPMessageAlertView
#pragma mark - 单例
+ (DPMessageAlertView *)sharedAlertView {
    static DPMessageAlertView *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

#pragma mark - 初始化弹框
- (void)dealloc {
    if (self.aButtonBlock) {
        self.aButtonBlock = nil;
    }
}
- (DPMessageAlertView *)customAlert {
    if (_customAlert == nil) {
        self.customAlert = [[DPMessageAlertView alloc] init];
    }
    return _customAlert;
}
- (id)init {
    self = [super init];
    if (self) {
        self.tag = DPMessageAlertViewTag;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = DPSMDate.alertMsgGB_viewStyle[@"bgColor"];

        //内容视图
        self.bgView = [[UIView alloc] init];
        _bgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        _bgView.backgroundColor = DPSMDate.alertMsgCenter_viewStyle[@"bgColor"];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = [DPSMDate.alertMsgCenter_viewStyle[@"radius"] floatValue];
        [self addSubview:_bgView];
        
        //标题
        self.titleLab = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _titleLab.numberOfLines = 0;
        _titleLab.adjustsFontSizeToFitWidth = YES;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = DPSMDate.alertMsgTitle_labStyle[@"font"];
        _titleLab.textColor = DPSMDate.alertMsgTitle_labStyle[@"textColor"];
        [_bgView addSubview:_titleLab];
        
        //详细内容，可滑动
        self.contentView = [[UIScrollView alloc] init];
        _contentView.clipsToBounds = YES;
        [_bgView addSubview:_contentView];
        
        self.contentLab = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _contentLab.numberOfLines = 0;
        _contentLab.adjustsFontSizeToFitWidth = YES;
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.font = DPSMDate.alertMsgContent_labStyle[@"font"];
        _contentLab.textColor = DPSMDate.alertMsgContent_labStyle[@"textColor"];
        [_contentView addSubview:_contentLab];
        
        //多个按钮
        for (int i = 0; i < ButtonMaxCount; i++) {
            UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            aBtn.tag = ButtonInitTag+i;
            aBtn.layer.masksToBounds = YES;
            aBtn.backgroundColor = DPSMDate.alertMsgOther_btnStyle[@"bgColor"];
            aBtn.titleLabel.numberOfLines = 0;
            aBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            aBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
            aBtn.titleLabel.font = DPSMDate.alertMsgOther_btnStyle[@"font"];
            [aBtn setTitleColor:DPSMDate.alertMsgOther_btnStyle[@"titleColor"] forState:UIControlStateNormal];
            dp_arc_block(self);
            [[aBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                if (weak_self.aButtonBlock) {
                    BOOL isCanFinish = weak_self.aButtonBlock(weak_self, x.tag-ButtonInitTag);
                    if (isCanFinish) {
                        [weak_self hiddenViewFinishBlock:nil];
                    }
                }else {
                    [weak_self hiddenViewFinishBlock:nil];
                }
            }];
            [_bgView addSubview:aBtn];
            
            if (i != 0) {
                UIView *btnLineView = [[UIView alloc] init];
                btnLineView.frame = CGRectMake(0, 0, [DPSMDate.alertMsgBtn_borderLineStyle[@"borderWidth"] floatValue], 0);
                btnLineView.tag = 1000+aBtn.tag;
                UIColor *btnColor = DPSMDate.alertMsg_btnStyle[@"bgColor"];
                UIColor *btnColorOther = DPSMDate.alertMsgOther_btnStyle[@"bgColor"];
                if (CGColorEqualToColor(btnColor.CGColor, btnColorOther.CGColor)) {
                    btnLineView.backgroundColor = DPSMDate.alertMsgBtn_borderLineStyle[@"bgColor"];
                }else {
                    btnLineView.backgroundColor = [UIColor clearColor];
                }
                [aBtn addSubview:btnLineView];
            }
        }
        
        self.lineView = [[UIView alloc] init];
        _lineView.backgroundColor = DPSMDate.alertMsgBtn_borderLineStyle[@"bgColor"];
        [_bgView addSubview:_lineView];
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
//显示消息弹框，block回调
- (void)showAlterWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)firstObject callBackBlock:(void(^)(NSInteger index, NSString *title))callBackBlock {
    NSArray *btnArray = @[];
    if (cancelButtonTitle.length && firstObject.length) {
        btnArray = @[dp_notEmptyStr(cancelButtonTitle),
                     dp_notEmptyStr(firstObject)];
    }else if (cancelButtonTitle.length && firstObject.length < 1) {
        btnArray = @[dp_notEmptyStr(cancelButtonTitle)];
    }else if (cancelButtonTitle.length < 1 && firstObject.length) {
        btnArray = @[dp_notEmptyStr(firstObject)];
    }
    dp_arc_block(self);
    [self showDPMessageAlertViewForTitle:title content:message buttonTitles:btnArray buttonBlock:^BOOL(DPMessageAlertView *aObject, NSInteger tapIndex) {
        if (callBackBlock) {
            callBackBlock(tapIndex,[weak_self.buttonTitles dp_objectAtIndex:tapIndex]);
        }
        return YES;
    }];
}
//显示消息弹框，代理回调
- (void)showAlterWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles {
    NSArray *btnArray = @[];
    if (cancelButtonTitle.length && otherButtonTitles.length) {
        btnArray = @[dp_notEmptyStr(cancelButtonTitle),
                     dp_notEmptyStr(otherButtonTitles)];
    }else if (cancelButtonTitle.length && otherButtonTitles.length < 1) {
        btnArray = @[dp_notEmptyStr(cancelButtonTitle)];
    }else if (cancelButtonTitle.length < 1 && otherButtonTitles.length) {
        btnArray = @[dp_notEmptyStr(otherButtonTitles)];
    }
    self.aDelegate = delegate;
    self.tag = 0;
    dp_arc_block(self);
    [self showDPMessageAlertViewForTitle:title content:message buttonTitles:btnArray buttonBlock:^BOOL(DPMessageAlertView *aObject, NSInteger tapIndex) {
        if (weak_self.aDelegate && [weak_self.aDelegate respondsToSelector:@selector(CustomAlert:clickedButtonAtIndex:)]){
            return [weak_self.aDelegate CustomAlert:weak_self clickedButtonAtIndex:tapIndex];
        }
        return YES;
    }];
}
//显示消息弹框，block回调；默认父视 keyWindow；默认样式 DPMessageAlertStyleDefault；
- (void)showDPMessageAlertViewForTitle:(id)aTitle content:(id)aContent buttonTitles:(NSArray <id>*)buttonTitles buttonBlock:(ButtonActionBlock)aButtonBlock {
    [self showDPMessageAlertViewForVC:nil parentView:nil title:aTitle content:aContent alertStyle:DPMessageAlertStyleDefault buttonTitles:buttonTitles buttonBlock:aButtonBlock];
}
//显示消息弹框，delegate回调；
- (void)showDPMessageAlertViewForVC:(UIViewController *)aVC parentView:(UIView *)aParentView delegate:(id)aDelegate title:(id)aTitle content:(id)aContent alertStyle:(DPMessageAlertStyle)aAlertStyle buttonTitles:(NSArray <id>*)buttonTitles {
    self.aDelegate = aDelegate;
    self.tag = 0;
    dp_arc_block(self);
    [self showDPMessageAlertViewForTitle:aTitle content:aContent buttonTitles:buttonTitles buttonBlock:^BOOL(DPMessageAlertView *aObject, NSInteger tapIndex) {
        if (weak_self.aDelegate && [weak_self.aDelegate respondsToSelector:@selector(messageDpAlertView:tapIndex:)]){
            return [weak_self.aDelegate messageDpAlertView:aObject tapIndex:tapIndex];
        }
        return YES;
    }];
}
//显示消息弹框，block回调；
- (void)showDPMessageAlertViewForVC:(UIViewController *)aVC parentView:(UIView *)aParentView title:(id)aTitle content:(id)aContent alertStyle:(DPMessageAlertStyle)aAlertStyle buttonTitles:(NSArray <id>*)buttonTitles buttonBlock:(ButtonActionBlock)aButtonBlock {
    //刷新数据
    self.currentVC = aVC;
    self.currentParent = aParentView;
    self.currentTitle = aTitle;
    self.currentContent = aContent;
    self.buttonTitles = buttonTitles;
    self.currentStyle = aAlertStyle;
    self.aButtonBlock = aButtonBlock;
    
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
    
    if (_currentTitle == nil &&
        _currentContent == nil) {
        return;
    }
    
    if (_currentTitle &&
        _currentContent &&
        [_currentTitle isKindOfClass:[NSString class]] &&
        [_currentContent isKindOfClass:[NSString class]] &&
        ((NSString *)_currentTitle).length < 1 &&
        ((NSString *)_currentContent).length < 1) {
        return;
    }
    
    [self updateView];
    
    //动画显示弹框
    [self showViewCompletion:nil];
}

#pragma mark - 刷新UI布局
- (void)updateView {
    self.frame = _currentParent.bounds;

    //内容视图
    _bgView.dp_size = CGSizeMake(self.dp_width-DP_FrameWidth(20)*2, 0);
    _bgView.clipsToBounds = YES;
    
    //标题
    CGFloat minY = 0;
    if (_currentTitle != nil) {
        _titleLab.hidden = NO;
        if ([_currentTitle isKindOfClass:[NSString class]]) {
            _titleLab.textAlignment = NSTextAlignmentCenter;
            _titleLab.text = _currentTitle;
        }else {
            NSAttributedString *aAttri = ((NSAttributedString *)_currentTitle);
            NSDictionary <NSAttributedStringKey, id>*aDic = [aAttri attributesAtIndex:0 longestEffectiveRange:nil inRange:NSMakeRange(0, aAttri.string.length)];
            if (aDic[NSParagraphStyleAttributeName]) {
                _titleLab.textAlignment = (NSTextAlignment)aDic[NSParagraphStyleAttributeName];
            }
            _titleLab.attributedText = _currentTitle;
        }
        _titleLab.frame = CGRectMake(DP_FrameWidth(20), DP_FrameHeight(20), _bgView.dp_width-DP_FrameWidth(20)*2, 0);
        [_titleLab sizeToFit];
        _titleLab.frame = CGRectMake(DP_FrameWidth(20), DP_FrameHeight(20), _bgView.dp_width-DP_FrameWidth(20)*2, _titleLab.dp_height);
        minY = _titleLab.dp_yMax;
    }else {
        _titleLab.hidden = YES;
    }
    
    //详细内容，可滑动
    if (_currentContent != nil) {
        _contentView.hidden = NO;
        _contentView.frame = CGRectMake(DP_FrameWidth(20), minY+DP_FrameHeight(20), _bgView.dp_width-DP_FrameWidth(20)*2, 0);
        _contentView.contentSize = CGSizeMake(_contentView.dp_width, 0);
        
        if ([_currentContent isKindOfClass:[NSString class]]) {
            _contentLab.textAlignment = NSTextAlignmentCenter;
            _contentLab.text = _currentContent;
        }else {
            NSAttributedString *aAttri = ((NSAttributedString *)_currentContent);
            NSDictionary <NSAttributedStringKey, id>*aDic = [aAttri attributesAtIndex:0 longestEffectiveRange:nil inRange:NSMakeRange(0, aAttri.string.length)];
            if (aDic[NSParagraphStyleAttributeName]) {
                _contentLab.textAlignment = (NSTextAlignment)aDic[NSParagraphStyleAttributeName];
            }
            _contentLab.attributedText = _currentContent;
        }
        _contentLab.frame = CGRectMake(0, 0, _contentView.contentSize.width, _contentView.contentSize.height);
        [_contentLab sizeToFit];
        _contentLab.frame = CGRectMake(0, 0, _contentView.contentSize.width, _contentLab.dp_height);
        
        _contentView.contentSize = CGSizeMake(_contentView.dp_width, _contentLab.dp_height);
        _contentView.dp_height = _contentView.contentSize.height;
        minY = _contentView.dp_yMax;
    }else {
        _contentView.hidden = YES;
    }
    
    if (_currentStyle == DPMessageAlertStyleDefault) {
        //按钮顶部水平分割线
        _lineView.hidden = NO;
        _lineView.frame = CGRectMake(0, minY+DP_FrameHeight(20), _bgView.dp_width, [DPSMDate.alertMsgBtn_borderLineStyle[@"borderWidth"] floatValue]);
        
        //多个按钮，等分水平布局
        CGFloat aBtnMinWidth = _bgView.dp_width/_buttonTitles.count;
        CGFloat aBtnMinHeight = DP_FrameHeight(50);
        for (int i = 0; i < ButtonMaxCount; i++) {
            UIButton *aBtn = [self viewWithTag:ButtonInitTag+i];
            if (i < _buttonTitles.count) {
                aBtn.hidden = NO;
                if ([_buttonTitles[i] isKindOfClass:[NSString class]]) {
                    if (i == 0) {
                        aBtn.backgroundColor = DPSMDate.alertMsg_btnStyle[@"bgColor"];
                        [aBtn setTitleColor:DPSMDate.alertMsg_btnStyle[@"titleColor"] forState:UIControlStateNormal];
                    }else {
                        aBtn.backgroundColor = DPSMDate.alertMsgOther_btnStyle[@"bgColor"];
                        [aBtn setTitleColor:DPSMDate.alertMsgOther_btnStyle[@"titleColor"] forState:UIControlStateNormal];
                    }
                    [aBtn setTitle:_buttonTitles[i] forState:UIControlStateNormal];
                }else {
                    [aBtn setAttributedTitle:_buttonTitles[i] forState:UIControlStateNormal];
                }
                aBtn.frame = CGRectMake(aBtnMinWidth*i, minY+DP_FrameHeight(20), aBtnMinWidth, aBtnMinHeight);
                aBtn.layer.masksToBounds = NO;
                aBtn.layer.cornerRadius = 0;
                
                UIView *btnLineView = [aBtn viewWithTag:1000+aBtn.tag];
                if (btnLineView) {
                    btnLineView.hidden = NO;
                    btnLineView.dp_height = aBtn.dp_height;
                }
            }else {
                aBtn.hidden = YES;
            }
        }
        minY = _buttonTitles.count > 0 ? minY+DP_FrameHeight(20)+aBtnMinHeight : minY;
        
        //内容视图，高度重定义
        _bgView.dp_height = minY;
    }else if (_currentStyle == DPMessageAlertStyleOne) {
        //按钮顶部水平分割线
        _lineView.hidden = YES;
        
        //多个按钮，按钮赋值，计算frame
        CGFloat aBtnMinWidth = 0;
        if (_buttonTitles.count == 1) {
            aBtnMinWidth = DP_FrameWidth(210);
        }else if (_buttonTitles.count == 2) {
            aBtnMinWidth = DP_FrameWidth(120);
        }
        CGFloat aBtnMinHeight = DP_FrameHeight(40);
        CGFloat aBtnMaxHeight = 0;
        CGFloat aBtnWSum = 0;
        for (int i = 0; i < ButtonMaxCount; i++) {
            UIButton *aBtn = [self viewWithTag:ButtonInitTag+i];
            
            UIView *btnLineView = [aBtn viewWithTag:1000+aBtn.tag];
            if (btnLineView) {
                btnLineView.hidden = YES;
            }
            
            if (i < _buttonTitles.count) {
                aBtn.hidden = NO;
                if ([_buttonTitles[i] isKindOfClass:[NSString class]]) {
                    aBtn.backgroundColor = DPSMDate.alertMsgOther_btnStyle[@"bgColor"];
                    [aBtn setTitleColor:DPSMDate.alertMsgOther_btnStyle[@"titleColor"] forState:UIControlStateNormal];
                    [aBtn setTitle:_buttonTitles[i] forState:UIControlStateNormal];
                }else {
                    [aBtn setAttributedTitle:_buttonTitles[i] forState:UIControlStateNormal];
                }
                aBtn.frame = CGRectZero;
                [aBtn sizeToFit];
                aBtn.frame = CGRectMake(0, 0, aBtn.dp_width, aBtn.dp_height);
                aBtn.dp_height = MAX(aBtn.dp_height, aBtnMinHeight);
                aBtn.dp_width = MAX(aBtn.dp_width, aBtn.dp_height+DP_FrameWidth(30));
                aBtn.dp_width = MAX(aBtn.dp_width, aBtnMinWidth);
                aBtn.layer.masksToBounds = YES;
                aBtn.layer.cornerRadius = aBtn.dp_height/2;
                
                aBtnMaxHeight = MAX(aBtn.dp_height, aBtnMaxHeight);
                aBtnWSum = aBtnWSum+aBtn.dp_width;
            }else {
                aBtn.hidden = YES;
            }
        }
        
        //多个按钮，计算aGap，按钮水平布局
        CGFloat aGap = (_bgView.dp_width-aBtnWSum)/(_buttonTitles.count+1);
        for (int i = 0; i < _buttonTitles.count; i++) {
            UIButton *aBtn = [self viewWithTag:ButtonInitTag+i];
            if (i == 0) {
                aBtn.dp_x = aGap;
                aBtn.dp_centerY = minY+DP_FrameHeight(20)+aBtnMaxHeight/2;
            }else {
                UIButton *fontBtn = [self viewWithTag:ButtonInitTag+i-1];
                aBtn.dp_x = fontBtn.dp_xMax+aGap;
                aBtn.dp_centerY = fontBtn.dp_centerY;
            }
            minY = MAX(aBtn.dp_yMax, minY);
        }
        
        //内容视图，高度重定义
        _bgView.dp_height = minY+DP_FrameHeight(20);
    }
    
    //弹框超出显示范围，显示内容重新布局
    CGFloat reduceHeight = _bgView.dp_height- (self.dp_height-ContentViewTBMaxGap*2);
    if (reduceHeight > 0) {
        _contentView.dp_height = _contentView.dp_height-reduceHeight;
        for (int i = 0; i < _buttonTitles.count; i++) {
            UIButton *aBtn = [self viewWithTag:ButtonInitTag+i];
            aBtn.dp_centerY = aBtn.dp_centerY-reduceHeight;
        }
        _bgView.dp_height = _bgView.dp_height-reduceHeight;
    }
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

        if (self.hidden == YES) {
            self.alpha = 0;
            self.hidden = NO;
            dp_arc_block(self);
            [UIView animateWithDuration:DPMAVAnimateDuration animations:^{
                weak_self.alpha = 1;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
        }else {
            self.alpha = 1;
        }
    });
}
//动画隐藏弹框
- (void)hiddenViewFinishBlock:(void (^)(DPMessageAlertView *aObject))finishBlock {
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
        
        dp_arc_block(self);
        [UIView animateWithDuration:DPMAVAnimateDuration animations:^{
            weak_self.alpha = 0;
        } completion:^(BOOL finished) {
            weak_self.hidden = YES;
            [weak_self removeFromSuperview];
            if (weak_self.currentParent == weak_self.customWindow) {
                weak_self.currentParent.hidden = YES;
            }

            if (finishBlock) {
                finishBlock(self);
            }
        }];
    });
}

#pragma mark - 消息弹框显示内容自定义
//消息内容添加文字点击事件，可多次调用添加点击事件；aAddIndex 多个相同对象，指定响应位置：0、1、2、3……，默认 0，-1 响应全部对象，越界响应最后一个
- (void)addTapContentForText:(NSString *)aText url:(NSString *)aUrl attributes:(NSDictionary *)aAttributes addIndex:(NSInteger)aAddIndex block:(BOOL (^)(DPMessageAlertView *aObject, NSString *aText, NSString *aUrlStr))aBlock {
    if (((NSString *)_contentLab.text).length < 1 || aText.length < 1) {
        return;
    }
    
    NSArray <NSValue *>* rangeArray = [_contentLab.text dp_rangeOfSubString:aText];
    if (rangeArray.count < 1) {
        return;
    }
    
    if (aAddIndex > -1) {
        if (aAddIndex < rangeArray.count) {
            rangeArray = @[rangeArray[aAddIndex]];
        }else {
            rangeArray = @[rangeArray.lastObject];
        }
    }
    
    NSDictionary *pLinkAttributes = aAttributes != nil ? aAttributes : @{
        (id)kCTForegroundColorAttributeName:DPSMDate.alertMsg_btnStyle[@"titleColor"],
        (id)kCTUnderlineStyleAttributeName:[NSNumber numberWithInt:kCTUnderlineStyleNone]
    };
    _contentLab.linkAttributes = pLinkAttributes;
    _contentLab.activeLinkAttributes = pLinkAttributes;
    _contentLab.inactiveLinkAttributes = pLinkAttributes;
    dp_arc_block(self);
    for (NSValue *aRange in rangeArray) {
        [_contentLab addLinkToURL:nil withRange:aRange.rangeValue].linkTapBlock = ^(TTTAttributedLabel *attributedLabel, TTTAttributedLabelLink *attributedLabelLink) {
            //弹框“内容文字”点击事件
            if (aBlock) {
                BOOL isCanFinish = aBlock(weak_self, aText, aUrl);
                if (isCanFinish) {
                    [weak_self hiddenViewFinishBlock:nil];
                }
            }else {
                [weak_self hiddenViewFinishBlock:nil];
            }
        };
    }
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

