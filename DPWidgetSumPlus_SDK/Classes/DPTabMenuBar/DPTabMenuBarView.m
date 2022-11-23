//
//  SUNSlideSwitchView.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 zcw. All rights reserved.
//

#import "DPTabMenuBarView.h"
#import "DPWidgetSumPlus.h"

#define ButtonTagValue 1001

@interface DPTabMenuBarView()<UIScrollViewDelegate>{
    
}
//代理
@property (nonatomic, weak) id<DPTabMenuBarViewDelegate> aViewDelegate;

//可滑动按钮菜单 UIScrollView 父视图
@property (nonatomic, strong) UIScrollView *topScrollView;
//按钮点击状态标注线
@property (nonatomic, strong) UIView *tagLineView;
//主显示区域 UIScrollView 父视图
@property (nonatomic, strong) UIScrollView *rootScrollView;
//底部分割线
@property (nonatomic, strong) UIView *gapLineView;

//右侧按钮
@property (nonatomic, strong) UIButton *rigthSideButton;
@end

@implementation DPTabMenuBarView
- (void)dealloc {
    //清理加载的内容进行释放
    [self clearVcORView];
}
- (id)initWithFrame:(CGRect)frame delegate:(id<DPTabMenuBarViewDelegate>)aDelegate{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.clipsToBounds = YES;
        self.aViewDelegate = aDelegate;
        _selectIndex = 0;
        [self makeContentView];
    }
    return self;
}

#pragma mark <--------------创建内容，代理获取配置属性-------------->
- (void)makeContentView {
    //清理 历史加载的内容
    [self clearVcORView];
    
    //清理 当前菜单队里展示的内容载体 根据外部遵守代理获取配置数据
    [self setValue:nil forKey:@"selectContent"];
    
    //创建 全局配置载体
    if (_aAttribute != nil) {
        _aAttribute = nil;
    }
    _aAttribute = [[DPTabMenuBarAttribute alloc] init];
    _aAttribute = [_aViewDelegate attributeOfTab:self attribute:_aAttribute];

    //创建 整体菜单队列载体 根据外部遵守代理获取配置数据
    _contentArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < _aAttribute.count; i++) {
        DPTabMenuBarContent *aContent = [[DPTabMenuBarContent alloc] init];
        aContent = [_aViewDelegate slideSwitchView:self content:aContent viewOfTab:i];
        //记录 当前载体在整体菜单队列中的位置
        [aContent setValue:[NSString dp_int:i] forKey:@"aIndex"];
        dp_arc_block(self);
        aContent.aBlock = ^(DPTabMenuBarContent *aObject) {
            [weak_self layoutSubviewsCustom];
        };
        [_contentArray addObject:aContent];
    }
    
    //创建 可滑动按钮菜单UIScrollView父视图
    if (_topScrollView == nil) {
        self.topScrollView = [[UIScrollView alloc] init];
        _topScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        _topScrollView.delegate = self;
        _topScrollView.clipsToBounds = YES;
        _topScrollView.pagingEnabled = NO;
        _topScrollView.showsHorizontalScrollIndicator = NO;
        _topScrollView.showsVerticalScrollIndicator = NO;
        _topScrollView.scrollsToTop = NO;
    }
    [self addSubview:_topScrollView];
    
    //清理 可滑动按钮菜单UIScrollView父视图
    for (UIView *aView in _topScrollView.subviews) {
        [aView removeFromSuperview];
    }
    
    //创建 菜单按钮
    for (int i = 0; i < _contentArray.count; i++) {
        DPTabMenuButton *button = [DPTabMenuButton tabMenuButtonWithType:UIButtonTypeCustom];
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        button.tag = ButtonTagValue+i;
        [button addTarget:self action:@selector(buttonSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [_topScrollView addSubview:button];
        
        DPTabMenuBarContent *aContent = _contentArray[i];
        aContent.btn = button;
    }

    //创建 按钮点击状态标注线
    if (_tagLineView == nil) {
        self.tagLineView = [[UIView alloc] init];
        _tagLineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    [_topScrollView addSubview:_tagLineView];
    
    //创建 主显示区域UIScrollView父视图
    if (_rootScrollView == nil) {
        self.rootScrollView = [[UIScrollView alloc] init];
        _rootScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _rootScrollView.backgroundColor = [UIColor clearColor];
        _rootScrollView.delegate = self;
        _rootScrollView.clipsToBounds = YES;
        _rootScrollView.pagingEnabled = YES;
        _rootScrollView.userInteractionEnabled = YES;
        _rootScrollView.scrollsToTop = NO;
        _rootScrollView.showsHorizontalScrollIndicator = NO;
        _rootScrollView.showsVerticalScrollIndicator = NO;

        //传递滑动事件给下一层
        [_rootScrollView.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
    }
    [self addSubview:_rootScrollView];
    
    //清理 主显示区域UIScrollView父视图
    for (UIView *aView in _rootScrollView.subviews) {
        [aView removeFromSuperview];
    }
    
    //主显示区域 显示内容如果为VC控制器，添加子控制器逻辑，同步子、父控制器生命周期
    for (DPTabMenuBarContent *aContent in _contentArray) {
        if ([aContent.aVcOrView isKindOfClass:[UIViewController class]] && ![((UIViewController *)_aViewDelegate).childViewControllers containsObject:aContent.aVcOrView]) {
            [((UIViewController *)_aViewDelegate) addChildViewController:aContent.aVcOrView];
        }
    }
    
    //创建 底部分割线
    if (_gapLineView == nil) {
        self.gapLineView = [[UIView alloc] init];
    }
    [self addSubview:_gapLineView];

    //刷新全局UI布局
    [self layoutSubviewsCustom];
}
//传递滑动事件给下一层
- (void)scrollHandlePan:(UIPanGestureRecognizer*)panParam {
    //当滑道左边界时，传递滑动事件给代理
    if(_rootScrollView.contentOffset.x <= 0) {
        if (_aViewDelegate
            && [_aViewDelegate respondsToSelector:@selector(slideSwitchView:panLeftEdge:)]) {
            [_aViewDelegate slideSwitchView:self panLeftEdge:panParam];
        }
    } else if(_rootScrollView.contentOffset.x >= _rootScrollView.contentSize.width - _rootScrollView.bounds.size.width) {
        if (_aViewDelegate
            && [_aViewDelegate respondsToSelector:@selector(slideSwitchView:panRightEdge:)]) {
            [_aViewDelegate slideSwitchView:self panRightEdge:panParam];
        }
    }
}
//菜单按钮点击事件
- (void)buttonSelectAction:(DPTabMenuButton *)sender {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(buttonClickedAction:) object:sender];
    [self performSelector:@selector(buttonClickedAction:) withObject:sender afterDelay:0.25];
}
- (void)buttonClickedAction:(UIButton *)sender {
    //菜单选择回调代理
    if (_aViewDelegate &&
        [_aViewDelegate respondsToSelector:@selector(slideSwitchViewForButtonEanble:viewIndex:)]
        &&![_aViewDelegate slideSwitchViewForButtonEanble:self viewIndex:sender.tag-ButtonTagValue]) {
        return;
    }
    [self selectButtonForIndex:sender.tag-ButtonTagValue isAnimate:YES];
}

#pragma mark <--------------UI布局自适应-------------->
- (void)layoutSubviews {
    [self layoutSubviewsCustom];
}
//刷新全局UI布局
- (void)layoutSubviewsCustom {
    if (_contentArray.count < 1) {
        return;
    }
    
    //记录 当前菜单导航栏选择位置内容载体
    _selectContent = [_contentArray dp_objectAtIndex:_selectIndex];
    
    //布局刷新 可滑动按钮菜单UIScrollView父视图
    _topScrollView.frame = CGRectMake(0, _aAttribute.topTGap, self.dp_width, _aAttribute.topHeight);
    _topScrollView.contentSize = CGSizeMake(_topScrollView.dp_width, _topScrollView.dp_height);
    _topScrollView.backgroundColor = _aAttribute.topBGColor;
    
    //布局刷新 菜单按钮 属性刷新
    for (int i = 0; i < _contentArray.count; i++) {
        DPTabMenuBarContent *aContent = _contentArray[i];
        [aContent.btn setBackgroundImage:aContent.btnNormalBackgroundImage forState:UIControlStateNormal];
        [aContent.btn setBackgroundImage:aContent.btnSelectedBackgroundImage forState:UIControlStateSelected];
        aContent.btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        aContent.btn.titleLabel.font = aContent.btnFont;
        [aContent.btn setNormalFont:aContent.btnFont];
        [aContent.btn setSelectFont:aContent.btnSelectFont];
        [aContent.btn setNormalColor:aContent.btnNormalColor];
        [aContent.btn setSelectedColor:aContent.btnSelectedColor];
        if ([aContent.btnTitle rangeOfString:@"\n"].location == NSNotFound) {
            [aContent.btn setTitle:aContent.btnTitle forState:UIControlStateNormal];
        }else {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:aContent.btnTitle];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            paragraphStyle.maximumLineHeight = aContent.btnFont.lineHeight-DP_FrameHeight(2);
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, aContent.btnTitle.length)];
            [attributedString addAttribute:NSForegroundColorAttributeName value:aContent.btnNormalColor range:NSMakeRange(0, aContent.btnTitle.length)];
            [aContent.btn setAttributedTitle:attributedString forState:UIControlStateNormal];
        }
        if (aContent.btnSelectTitle.length) {
            if ([aContent.btnSelectTitle rangeOfString:@"\n"].location == NSNotFound) {
                [aContent.btn setTitle:aContent.btnSelectTitle forState:UIControlStateSelected];
            }else {
                NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:aContent.btnSelectTitle];
                NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
                style.alignment = NSTextAlignmentCenter;
                style.maximumLineHeight = aContent.btnSelectFont.lineHeight-DP_FrameHeight(2);
                [attr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, aContent.btnSelectTitle.length)];
                [attr addAttribute:NSForegroundColorAttributeName value:aContent.btnSelectedColor range:NSMakeRange(0, aContent.btnSelectTitle.length)];
                [aContent.btn setAttributedTitle:attr forState:UIControlStateHighlighted];
                [aContent.btn setAttributedTitle:attr forState:UIControlStateSelected];
            }
        }
    }
    
    //布局刷新 菜单按钮 布局类型刷新 显示类型：0 按钮水平一排，1 按钮表格排列，默认 0
    if (_aAttribute.menuStyle == 0) {
        //菜单左右边界间隙
        CGFloat currentTopLRGap = _aAttribute.topLRGap;
        
        //菜单按钮 计算所有按钮总宽度
        CGFloat btnSumW = 0;
        for (int i = 0; i < _contentArray.count; i++) {
            DPTabMenuBarContent *aContent = _contentArray[i];
            //btnWidth 菜单区域，指定按钮宽度，为-1宽度自适应，默认：-1
            if (aContent.btnWidth == -1) {
                //根据文字计算按钮的宽度
                CGSize btnSize = CGSizeZero;
                if (aContent.btnTitle.length) {
                    btnSize = [aContent.btnTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : aContent.btnFont} context:nil].size;
                }
                CGSize btnSelectSize = CGSizeZero;
                if (aContent.btnSelectTitle.length) {
                    UIFont *aFont = aContent.btnSelectFont;
                    if (aFont == nil) {
                        aFont = aContent.btnFont;
                    }
                    btnSelectSize = [aContent.btnSelectTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : aFont} context:nil].size;
                }else if (aContent.btnSelectFont) {
                    btnSelectSize = [aContent.btnTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : aContent.btnSelectFont} context:nil].size;
                }
                CGSize aSize = btnSize.width > btnSelectSize.width ? btnSize : btnSelectSize;
                aContent.btn.dp_size = CGSizeMake(aSize.width+aContent.btnWidthMax, _topScrollView.dp_height);
            }else {
                //使用指定的按钮宽度
                aContent.btn.dp_size = CGSizeMake(aContent.btnWidth, _topScrollView.dp_height);
            }
            btnSumW = btnSumW+aContent.btn.dp_width;
        }
        
        //根据按钮显示范围，重定义“菜单左右边界间隙”和“按钮左右间隙”
        CGFloat currentBtnLRGap = 0;
        if (_aAttribute.btnLRGap == -1) {
            if (btnSumW <= _topScrollView.dp_width) {
                if (_contentArray.count > 1) {
                    currentBtnLRGap = (_topScrollView.dp_width-currentTopLRGap*2-btnSumW)/(_contentArray.count-1);
                }
            }
        }else {
            currentBtnLRGap = _aAttribute.btnLRGap;
        }

        //菜单按钮排列，超出父视图可滑动
        for (int i = 0; i < _contentArray.count; i++) {
            DPTabMenuBarContent *aContent = _contentArray[i];
            if (i > 0) {
                DPTabMenuBarContent *fontContent = _contentArray[i-1];
                aContent.btn.dp_x = fontContent.btn.dp_xMax+currentBtnLRGap;
                aContent.btn.dp_y = 0;
            }else {
                aContent.btn.dp_x = currentTopLRGap;
                aContent.btn.dp_y = 0;
            }
            
            //记录按钮（按钮centerX）距离左、右（按钮center）的距离
            DPTabMenuBarContent *leftContent = [_contentArray dp_objectAtIndex:i-1];
            if (i == 0) {
                [aContent setValue:[NSString dp_int:0] forKey:@"btnCenterXLGap"];
            }else if (leftContent) {
                [leftContent setValue:[NSString dp_int:aContent.btn.dp_centerX-CGRectGetMidX(leftContent.btn.frame)] forKey:@"btnCenterXRGap"];
                [aContent setValue:[NSString dp_int:aContent.btn.dp_centerX-CGRectGetMidX(leftContent.btn.frame)] forKey:@"btnCenterXLGap"];
                [aContent setValue:[NSString dp_int:0] forKey:@"btnCenterXRGap"];
            }

            //根据按钮显示区域，超出父视图，刷新父视图宽度
            if (aContent.btn.dp_xMax+currentTopLRGap > _topScrollView.dp_width) {
                _topScrollView.contentSize = CGSizeMake(aContent.btn.dp_xMax+currentTopLRGap, _topScrollView.dp_height);
            }
        }
    }else if (_aAttribute.menuStyle == 1) {
        
    }
    
    //布局刷新 菜单按钮 选择状态刷新
    for (int i = 0; i < _contentArray.count; i++) {
        DPTabMenuBarContent *aContent = _contentArray[i];
        DPTabMenuButton *aButton = aContent.btn;
        aButton.titleLabel.font = aContent.btnFont;
        if (_selectIndex == i) {
            aButton.selected = YES;

            //选中按钮以显示区域中线为准，滑动到最佳显示位置
            CGFloat contentOffsetX = [self getBestLocationOffsetXForScrollView:_topScrollView centerX:aButton.dp_centerX];
            if (_topScrollView.contentOffset.x != contentOffsetX) {
                _topScrollView.contentOffset = CGPointMake(contentOffsetX, _topScrollView.contentOffset.y);
            }
        }else {
            aButton.selected = NO;
        }
    }
    
    //布局刷新 按钮点击状态标注线
    _tagLineView.backgroundColor = _selectContent.tagLineColor;
    CGFloat tagWidth = _selectContent.btn.dp_width;
    if (_aAttribute.tagLineWidth > 0) {
        tagWidth = _aAttribute.tagLineWidth;
    }else {
        tagWidth = _selectContent.btn.dp_width+_aAttribute.tagLineWidthMax;
    }
    _tagLineView.frame = CGRectMake(_selectContent.btn.dp_centerX-tagWidth/2, _selectContent.btn.dp_yMax-_aAttribute.tagLineHeight, tagWidth, _aAttribute.tagLineHeight);
    if (_aAttribute.tagLineRadius > 0) {
        _tagLineView.layer.cornerRadius = _tagLineView.dp_height*_aAttribute.tagLineRadius;
    }else {
        _tagLineView.layer.cornerRadius = 0;
    }

    //布局刷新 主显示区域UIScrollView父视图
    _rootScrollView.frame = CGRectMake(0, _topScrollView.dp_yMax, self.dp_width, self.dp_height-_topScrollView.dp_yMax);
    _rootScrollView.backgroundColor = _aAttribute.bottomBGColor;
    _rootScrollView.contentSize = CGSizeMake(_rootScrollView.dp_width*_contentArray.count, _rootScrollView.dp_height);
    _rootScrollView.contentOffset = CGPointMake(_rootScrollView.dp_width*_selectIndex, 0);
    
    //loadType 主显示区域内容加载方式：0 显示时加载当前内容（节省资源），1 预先全部加载所有内容，默认 0
    if (_aAttribute.loadType == 0) {
        [self addContentForIndex:_selectIndex];
    }else if (_aAttribute.loadType == 1) {
        for (int i = 0; i < _contentArray.count; i++) {
            [self addContentForIndex:i];
        }
    }

    //底部分割线 显示状态刷新
    _gapLineView.frame = CGRectMake(0, _topScrollView.dp_yMax-_aAttribute.gapLineHeight, self.dp_width, _aAttribute.gapLineHeight);
    _gapLineView.backgroundColor = _aAttribute.gapLineColor;
    
    //菜单选择回调代理
    if (_aViewDelegate &&
        [_aViewDelegate respondsToSelector:@selector(slideSwitchView:content:viewOldIndex:viewIndex:)]) {
        [_aViewDelegate slideSwitchView:self content:_selectContent viewOldIndex:-1 viewIndex:_selectIndex];
    }
}

#pragma mark <--------------本类公共函数-------------->
//选择展示位置，按钮菜单展示状态刷新(位置滑动、点击状态……) 和 主显示区域展示状态刷新(位置滑动……)
- (void)selectButtonForIndex:(NSInteger)index isAnimate:(BOOL)aIsAnimate {
    if (index >= _contentArray.count) {
        return;
    }
    
    //标记 上次选择位置
    NSInteger oldSelectIndex = _selectIndex;
    DPTabMenuBarContent *oldContent = [_contentArray dp_objectAtIndex:oldSelectIndex];
    
    //标记 当前选择位置
    _selectIndex = index;
    
    //标记 当前展示内容
    if (_selectContent == nil) {
        oldSelectIndex = -1;
    }
    _selectContent = [_contentArray dp_objectAtIndex:_selectIndex];
    
    //加载错误
    if (_selectContent == nil) {
        NSLog(@"Error: 加载错误, DPTabMenuBarView, _selectContent == nil!");
        return;
    }
    
    //按钮 点击显示状态刷新
    for (int i = 0; i < _contentArray.count; i++) {
        DPTabMenuBarContent *aContent = _contentArray[i];
        if (aContent.btn) {
            if (_selectIndex == i) {
                aContent.btn.selected = YES;
            }else {
                aContent.btn.selected = NO;
            }
        }
    }
    //选中按钮以显示区域中线为准，滑动到最佳显示位置
    CGFloat contentOffsetX = [self getBestLocationOffsetXForScrollView:_topScrollView centerX:_selectContent.btn.dp_centerX];
    if (_topScrollView.contentOffset.x != contentOffsetX) {
        [_topScrollView setContentOffset:CGPointMake(contentOffsetX, _topScrollView.contentOffset.y) animated:aIsAnimate];
    }
    
    //按钮点击状态标注线 显示状态刷新
    if (_selectContent.btn && _aAttribute.tagLineHeight > 0) {
        //背景颜色
        _tagLineView.backgroundColor = _selectContent.tagLineColor;
        //宽度计算
        CGFloat tagWidth = _selectContent.btn.dp_width;
        if (_aAttribute.tagLineWidth > 0) {
            tagWidth = _aAttribute.tagLineWidth;
        }else {
            tagWidth = tagWidth+_aAttribute.tagLineWidthMax;
        }
        //当前Frame
        CGRect aBtomLineFrame = CGRectMake(_selectContent.btn.dp_centerX-tagWidth/2, _selectContent.btn.dp_yMax-_aAttribute.tagLineHeight, tagWidth, _aAttribute.tagLineHeight);
        //圆角设置
        CGFloat radiusValue = aBtomLineFrame.size.height*_aAttribute.tagLineRadius;
        if (_aAttribute.tagLineRadius > 0) {
            if (_tagLineView.layer.cornerRadius != radiusValue) {
                _tagLineView.layer.cornerRadius = radiusValue;
            }
        }else {
            _tagLineView.layer.cornerRadius = 0;
        }
        //Frame设置
        if (!CGRectEqualToRect(_tagLineView.frame, aBtomLineFrame)) {
            if (aIsAnimate
                && _tagLineView.dp_y == aBtomLineFrame.origin.y
                && CGSizeEqualToSize(_tagLineView.dp_size, aBtomLineFrame.size)) {
                dp_arc_block(self);
                [UIView animateWithDuration:0.25 animations:^{
                    weak_self.tagLineView.frame = aBtomLineFrame;
                }];
            }else {
                _tagLineView.frame = aBtomLineFrame;
            }
        }
    }
    
    //主显示区域 显示状态刷新
    CGPoint aRootOffset = CGPointMake(_rootScrollView.dp_width*_selectIndex, 0);
    if (!CGPointEqualToPoint(_rootScrollView.contentOffset, aRootOffset)) {
        [_rootScrollView setContentOffset:aRootOffset animated:NO];
        int pageNo = _rootScrollView.contentOffset.x/_rootScrollView.dp_width;
        [self addContentForIndex:pageNo];
    }
    
    //控制器切换生命周期调用
    if (oldContent != nil &&
        [oldContent.aVcOrView isKindOfClass:[UIViewController class]]) {
        [((UIViewController *)oldContent.aVcOrView) viewWillDisappear:YES];
        [((UIViewController *)oldContent.aVcOrView) viewDidDisappear:YES];
    }
    if (_selectContent != nil &&
        [_selectContent.aVcOrView isKindOfClass:[UIViewController class]]) {
        [((UIViewController *)_selectContent.aVcOrView) viewWillAppear:YES];
        [((UIViewController *)_selectContent.aVcOrView) viewDidAppear:YES];
    }
    
    //菜单选择回调代理
    if (_aViewDelegate &&
        [_aViewDelegate respondsToSelector:@selector(slideSwitchView:content:viewOldIndex:viewIndex:)]) {
        [_aViewDelegate slideSwitchView:self content:_selectContent viewOldIndex:oldSelectIndex viewIndex:_selectIndex];
    }
}
//获取ScrollView显示区域中线最佳位置，根据指定x坐标
- (CGFloat)getBestLocationOffsetXForScrollView:(UIScrollView *)aScrollView centerX:(CGFloat)aCenterX {
    CGFloat contentOffsetX = aScrollView.contentOffset.x;
    if (aScrollView.contentSize.width > aScrollView.dp_width) {
        if (aScrollView.contentOffset.x+aScrollView.dp_width/2 > aCenterX) {
            //当前按钮在”中线“左边
            if (aCenterX >= aScrollView.dp_width/2) {
                contentOffsetX = aCenterX-aScrollView.dp_width/2;
            }else {
                contentOffsetX = 0;
            }
        }else {
            //当前按钮在”中线“右边
            if (aScrollView.contentSize.width-aCenterX >= aScrollView.dp_width/2) {
                contentOffsetX = aCenterX-aScrollView.dp_width/2;
            }else {
                contentOffsetX = aScrollView.contentSize.width-aScrollView.dp_width;
            }
        }
    }else {
        contentOffsetX = aScrollView.contentOffset.x;
    }
    return contentOffsetX;
}
//”主显示区域“加载指定位置内容
- (void)addContentForIndex:(NSInteger)aIndex {
    DPTabMenuBarContent *aContent = [_contentArray dp_objectAtIndex:aIndex];
    if (aContent) {
        UIView *aView = nil;
        if ([aContent.aVcOrView isKindOfClass:[UIView class]]) {
            aView = (UIView *)aContent.aVcOrView;
        }else if ([aContent.aVcOrView isKindOfClass:[UIViewController class]]) {
            aView = ((UIViewController *)aContent.aVcOrView).view;
        }
        CGRect newFrame = CGRectMake(_rootScrollView.dp_width*aIndex, 0, _rootScrollView.dp_width, _rootScrollView.dp_height);
        if (!CGRectEqualToRect(aView.frame, newFrame)) {
            aView.frame = newFrame;
        }
        if (!aView.superview || (aView.superview && ![aView.superview isEqual:_rootScrollView])) {
            aView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [_rootScrollView addSubview:aView];
        }
    }
}
//清理加载的内容，进行释放
- (void)clearVcORView {
    if (_contentArray != nil) {
        for (UIView *aView in _rootScrollView.subviews) {
            [aView removeFromSuperview];
        }
        
        for (DPTabMenuBarContent *aContent in _contentArray) {
            if ([aContent.aVcOrView isKindOfClass:[UIViewController class]]
                && _aViewDelegate
                && [((UIViewController *)_aViewDelegate).childViewControllers containsObject:aContent.aVcOrView]) {
                [((UIViewController *)aContent.aVcOrView) removeFromParentViewController];
            }
        }
        [self.contentArray removeAllObjects];
    }
}

#pragma mark <--------------UIScrollViewDelegate-------------->
//拖拽开始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}
//滚动视图
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //主显示区手势拖动
    if (scrollView == _rootScrollView && _aAttribute.tagLineHeight > 0 && scrollView.contentOffset.x >= 0 && (scrollView.isTracking || scrollView.isDecelerating || scrollView.decelerating)) {
        
        //临时标记滑动位置
        NSInteger newIndex = (int)(scrollView.contentOffset.x/scrollView.dp_width);
        
        if (newIndex < 0) {
            newIndex = 0;
        }else if (newIndex > _contentArray.count-1) {
            newIndex = _contentArray.count-1;
        }

        //主显示区域即将显示的载体
        DPTabMenuBarContent *newContent = [_contentArray dp_objectAtIndex:newIndex];

        //菜单区域，按"按钮标注线"根据"主显示区域偏移量"移动
        _tagLineView.dp_centerX = newContent.btn.dp_centerX+newContent.btnCenterXRGap.floatValue*(scrollView.contentOffset.x-scrollView.dp_width*newIndex)/scrollView.dp_width;
        
        if (newContent && newContent.btnCenterXRGap.floatValue > 0) {
            CGFloat newRemainder = fabs(_tagLineView.dp_centerX-newContent.btn.dp_centerX)/newContent.btnCenterXRGap.floatValue;
            if (newContent.btnSelectFont && newRemainder < 0.5) {
                newContent.btn.titleLabel.font = newContent.btnSelectFont;
            }else {
                newContent.btn.titleLabel.font = newContent.btnFont;
            }
            UIColor *aColor = newContent.btnNormalColor;
            if (newContent.btnSelectedColor) {
                aColor = [UIColor dp_sectionColor:newContent.btnNormalColor endColor:newContent.btnSelectedColor ratio:newRemainder];
            }
            [newContent.btn setTitleColor:aColor forState:newContent.btn.selected ? UIControlStateSelected : UIControlStateNormal];
        }
        
        DPTabMenuBarContent *leftContent = [_contentArray dp_objectAtIndex:newIndex-1];
        if (leftContent) {
            leftContent.btn.titleLabel.font = leftContent.btnFont;
            [leftContent.btn setTitleColor:leftContent.btnNormalColor forState:leftContent.btn.selected ? UIControlStateSelected : UIControlStateNormal];
        }
        
        DPTabMenuBarContent *rightContent = [_contentArray dp_objectAtIndex:newIndex+1];
        if (rightContent && rightContent.btnCenterXLGap.floatValue > 0) {
            CGFloat newRemainder = fabs(rightContent.btn.dp_centerX-_tagLineView.dp_centerX)/rightContent.btnCenterXLGap.floatValue;
            if (rightContent.btnSelectFont && newRemainder < 0.5) {
                rightContent.btn.titleLabel.font = rightContent.btnSelectFont;
            }else {
                rightContent.btn.titleLabel.font = rightContent.btnFont;
            }
            UIColor *aColor = rightContent.btnNormalColor;
            if (rightContent.btnSelectedColor) {
                aColor = [UIColor dp_sectionColor:rightContent.btnNormalColor endColor:rightContent.btnSelectedColor ratio:newRemainder];
            }
            [rightContent.btn setTitleColor:aColor forState:rightContent.btn.selected ? UIControlStateSelected : UIControlStateNormal];
        }
    }
}
//拖拽减速滚动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _rootScrollView) {
        int pageNo = scrollView.contentOffset.x/scrollView.frame.size.width;
        [self selectButtonForIndex:pageNo isAnimate:YES];

        //loadType 主显示区域内容加载方式：0 显示时加载当前内容（节省资源），1 预先全部加载所有内容，默认 0
        if (_aAttribute.loadType == 0) {
            [self addContentForIndex:pageNo];
        }
    }
}

#pragma mark <--------------getter/setter-------------->
- (void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    
    [self selectButtonForIndex:_selectIndex isAnimate:YES];
}

#pragma mark <--------------外部调用函数-------------->
//创建加载内容, 刷新加载内容
- (void)reloadContentView {
    [self makeContentView];
}
@end
