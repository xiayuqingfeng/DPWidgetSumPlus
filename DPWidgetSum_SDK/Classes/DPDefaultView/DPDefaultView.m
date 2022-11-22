//
//  DPDefaultView.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 zcw. All rights reserved.
//

#import "DPDefaultView.h"
#import "DPWidgetSum.h"

@interface DPDefaultView(){
    UIView *centerView;
    UIImageView *imageV;
    UILabel *label;
    NSMutableArray <UIButton *>*btns;
}
@property (nonatomic, weak) UIView *superView;
@property (nonatomic, strong) UIImage *topImage;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray <NSString *>*btnTitles;
///1 内容整体靠上位置显示, 2 内容整体居中显示, 3 内容整体靠上（距离50）位置显;
@property (nonatomic, assign) int layoutType;
///1 只有提示语, 2 只有图片, 3 提示语+图片;
@property (nonatomic, assign) int showType;
@property (nonatomic, copy) DPDefaultViewButtonBlock btnBlock;
@end

@implementation DPDefaultView
/**
 *  显示默认视图，提示语+图片，内容整体居中显示
 *
 *  @param aSuperView: 父视图;
 *  @param aTopImage: 顶部图片，默认值：dp_BundleImageNamed(@"dp_no_data.png");
 *  @param aTitle: 提示语，默认值：@"获取数据为空";
 *  @param aBtnTitles:  按钮文字数组，默认值：@[@"重新获取"];
 *  @param aBtnBlock: 为nil不显示按钮;
 *
 */
+ (id)showDefaulWithSuperView:(UIView *)aSuperView topImage:(UIImage *)aTopImage title:(NSString *)aTitle btnTitles:(NSArray <NSString *>*)aBtnTitles btnBlock:(DPDefaultViewButtonBlock)aBtnBlock {
    return [[self class] showDefaulWithSuperView:aSuperView topImage:aTopImage title:aTitle btnTitles:aBtnTitles showType:3 layoutType:2 btnBlock:aBtnBlock];
}
/**
 *  显示默认视图
 *
 *  @param aSuperView: 父视图;
 *  @param aTopImage: 顶部图片，默认值：dp_BundleImageNamed(@"dp_no_data.png");
 *  @param aTitle: 提示语，默认值：@"获取数据为空";
 *  @param aBtnTitles: 按钮文字数组，默认值：@[@"重新获取"];
 *  @param aShowType: 1 只有提示语, 2 只有图片, 3 提示语+图片;
 *  @param aLayoutType: 1 内容整体靠上位置显示, 2 内容整体居中显示, 3 内容整体靠上（距离50）位置显;
 *  @param aBtnBlock: 为nil不显示按钮;
 *
 */
+ (id)showDefaulWithSuperView:(UIView *)aSuperView topImage:(UIImage *)aTopImage title:(NSString *)aTitle btnTitles:(NSArray <NSString *>*)aBtnTitles showType:(int)aShowType layoutType:(int)aLayoutType btnBlock:(DPDefaultViewButtonBlock)aBtnBlock {
    if (aSuperView != nil) {
        NSMutableArray *aArray = [NSMutableArray arrayWithCapacity:aSuperView.subviews.count];
        for (UIView *aView in aSuperView.subviews) {
            if ([aView isKindOfClass:[DPDefaultView class]]) {
                [aArray addObject:aView];
            }
        }
        
        DPDefaultView *currentView = nil;
        for (int i = 0; i < aArray.count; i++) {
            DPDefaultView *aView = aArray[i];
            if (i == 0) {
                currentView = aView;
            }else {
                [aView removeFromSuperview];
            }
        }

        if (currentView == nil) {
            currentView = [[DPDefaultView alloc] init];
        }
        currentView.superView = aSuperView;
        if (aTopImage != nil) {
            currentView.topImage = aTopImage;
        }
        if (aTitle != nil) {
            currentView.title = aTitle;
        }
        if (aBtnTitles != nil) {
            currentView.btnTitles = aBtnTitles;
        }
        currentView.layoutType = aLayoutType;
        currentView.showType = aShowType;
        currentView.btnBlock = aBtnBlock;

        [currentView updateLayout];
        currentView.hidden = NO;
        
        return currentView;
    }
    return nil;
}

/**
 *  隐藏默认视图
 *
 *  @param aSuperView: 父视图;
 *
 */
+ (void)hiddenDefaulTSuperView:(UIView *)aSuperView {
    for (UIView *aView in aSuperView.subviews) {
        if ([aView isKindOfClass:[DPDefaultView class]]) {
            aView.hidden = YES;
        }
    }
}
/**
 *  隐藏默认视图
 *
 */
- (void)hiddenDefaulTSuperView {
    for (UIView *aView in self.superView.subviews) {
        if ([aView isKindOfClass:[DPDefaultView class]]) {
            aView.hidden = YES;
        }
    }
}

- (void)dealloc {
    
}
- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = DPSMDate.defaultViewBG_viewStyle[@"bgColor"];
        
        self.topImage = dp_BundleImageNamed(@"dp_no_failed.png");
        self.title = @"获取数据为空";
        self.btnTitles = @[@"重新获取"];
        
        centerView = [[UIView alloc] init];
        centerView.tag = 151;
        [self addSubview:centerView];
        
        //图片
        imageV = [[UIImageView alloc] init];
        imageV.tag = 152;
        [centerView addSubview:imageV];
        
        //提示语
        label = [[UILabel alloc] init];
        label.tag = 153;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = DPSMDate.defaultViewTitle_labStyle[@"font"];
        label.textColor = DPSMDate.defaultViewTitle_labStyle[@"textColor"];
        [centerView addSubview:label];
        
        //按钮
        btns = [NSMutableArray arrayWithCapacity:5];
        for (int i = 0; i < 5; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.hidden = YES;
            btn.tag = 154+i;
            btn.backgroundColor = DPSMDate.defaultView_btnStyle[@"bgColor"];
            btn.titleLabel.font = DPSMDate.defaultView_btnStyle[@"font"];
            [btn setTitleColor:DPSMDate.defaultView_btnStyle[@"titleColor"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(noDataShowLabelBtnSelct:) forControlEvents:UIControlEventTouchUpInside];
            [centerView addSubview:btn];
            
            [btns addObject:btn];
        }
    }
    return self;
}
- (void)noDataShowLabelBtnSelct:(UIButton *)button{
    if (self.btnBlock) {
        self.btnBlock(self, button.tag-154);
    }
}

- (void)updateLayout {
    self.frame = _superView.bounds;
    [_superView addSubview:self];
    
    centerView.frame = CGRectMake(0, 0, self.dp_width, 0);
    centerView.backgroundColor = [UIColor clearColor];
    
    imageV.hidden = YES;
    CGSize imageSize = _topImage.size;
    imageSize.width = DP_FrameWidth(imageSize.width);
    imageSize.height = DP_FrameHeight(imageSize.height);
    imageV.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    imageV.image = _topImage;
    imageV.dp_centerX = centerView.dp_width/2;
    
    label.hidden = YES;
    label.frame = CGRectMake(0, imageV.dp_yMax+DP_FrameHeight(20), centerView.dp_width, 0);
    label.text = _title;
    [label sizeToFit];
    label.frame = CGRectMake(0, imageV.dp_yMax+DP_FrameHeight(20), centerView.dp_width, label.dp_height);
    
    //showType: 1 只有提示语, 2 只有图片, 3 提示语+图片
    CGFloat maxY = 0;
    if (_showType == 1) {
        imageV.hidden = YES;
        label.hidden = NO;
        label.dp_y = 0;
        maxY = label.dp_yMax;
    }else if(_showType == 2){
        imageV.hidden = NO;
        label.hidden = YES;
        maxY = imageV.dp_yMax;
    }else if(_showType == 3){
        imageV.hidden = NO;
        label.hidden = NO;
        label.dp_y = imageV.dp_yMax+DP_FrameHeight(20);
        maxY = label.dp_yMax;
    }
    
    //点击按钮
    CGFloat btnWidth = btns.count > 1 ? DP_FrameWidth(80) : DP_FrameWidth(175);
    CGFloat gapBtn = DP_FrameWidth(20);
    CGFloat gapLR = (centerView.dp_width-(btns.count-1)*gapBtn)/2.0;
    for (int i = 0; i < btns.count; i++) {
        UIButton *btn = [btns dp_objectAtIndex:i];
        if (self.btnBlock && i < _btnTitles.count) {
            btn.hidden = NO;
            btn.frame = CGRectMake(gapLR+(gapBtn+btnWidth)*i, label.dp_yMax+DP_FrameHeight(30), btnWidth, DP_FrameHeight(34));
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = [DPSMDate.defaultView_btnStyle[@"radius"] floatValue];
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = ((UIColor *)DPSMDate.defaultView_btnStyle[@"borderColor"]).CGColor;
            [btn setTitle:[_btnTitles dp_objectAtIndex:i] forState:UIControlStateNormal];
            
            maxY = btn.dp_yMax;
        }else {
            btn.hidden = YES;
        }
    }
    centerView.dp_height = maxY;
    
    //layoutType: 1 内容整体靠上位置显示, 2 内容整体居中显示, 3 内容整体靠上（距离50）位置显;
    if (_layoutType == 1) {
        centerView.dp_y = 0;
    }else if(_layoutType == 2){
        centerView.dp_centerY = self.dp_height/2;
    }else if(_layoutType == 3){
        centerView.dp_y = DP_FrameHeight(50);
    }
}
@end
