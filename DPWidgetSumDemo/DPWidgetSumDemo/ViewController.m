//
//  ViewController.m
//  test
//
//  Created by xiayupeng on 2018/12/17.
//  Copyright © 2018 yupeng xia. All rights reserved.
//

#import "ViewController.h"
#import "DPWidgetSum.h"
#import "DPTabMenuBarView.h"
#import "ViewController.h"
#import "ViewControllerOne.h"
#import "ViewControllerTow.h"
#import "ViewControllerThree.h"
#import "ViewControllerFour.h"
#import "ViewControllerFive.h"
#import "ViewControllerSix.h"
#import "ViewControllerSeven.h"

@interface ViewController ()<DPTabMenuBarViewDelegate> {
    
}
@property (nonatomic, strong) DPTabMenuBarView *tabMenuBarView;
@property (nonatomic, strong) NSMutableArray *vcArray;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"基础库";
    self.isHiddenBackBtn = YES;
    self.isAutorotateBase = YES;
    
    self.vcArray = [NSMutableArray arrayWithCapacity:3];
    
    ViewControllerOne *oneVc = [[ViewControllerOne alloc] init];
    [_vcArray addObject:@{@"地址/时间/下拉选择器" : oneVc}];
    
    ViewControllerTow *towVc = [[ViewControllerTow alloc] init];
    [_vcArray addObject:@{@"WebViewBase" : towVc}];
    
    ViewControllerThree *threeVc = [[ViewControllerThree alloc] init];
    [_vcArray addObject:@{@"轮播图" : threeVc}];
    
    ViewControllerFour *fourVc = [[ViewControllerFour alloc] init];
    [_vcArray addObject:@{@"默认图" : fourVc}];
    
    ViewControllerFive *fiveVc = [[ViewControllerFive alloc] init];
    [_vcArray addObject:@{@"相机/相册选择" : fiveVc}];
    
    ViewControllerSix *sixVc = [[ViewControllerSix alloc] init];
    [_vcArray addObject:@{@"TextField输入框" : sixVc}];
    
    ViewControllerSeven *sevenVc = [[ViewControllerSeven alloc] init];
    [_vcArray addObject:@{@"TextView输入框" : sevenVc}];
    
    self.tabMenuBarView = [[DPTabMenuBarView alloc] initWithFrame:self.contentView.bounds delegate:self];
    [self.contentView addSubview:_tabMenuBarView];
}

#pragma mark <-------------DPTabMenuBarViewDelegate,KaiJiangSlideListDelegate------------->
- (DPTabMenuBarAttribute *)attributeOfTab:(DPTabMenuBarView *)view attribute:(DPTabMenuBarAttribute *)aAttribute {
    aAttribute.count = _vcArray.count;
    aAttribute.topLRGap = DP_FrameWidth(20);
    aAttribute.tagLineRadius = 0.5;
    aAttribute.tagLineWidth = DP_FrameWidth(24);
    aAttribute.tagLineHeight = DP_FrameHeight(3);
    return aAttribute;
}
- (DPTabMenuBarContent *)slideSwitchView:(DPTabMenuBarView *)view content:(DPTabMenuBarContent *)aContent viewOfTab:(NSInteger)index{
    aContent.tagLineColor = DP_RGBA(51, 105, 227, 1);
    aContent.btnFont = DP_Font(14);
    aContent.btnSelectFont = DP_FontBold(16);
    aContent.btnNormalColor = DP_RGBA(115, 127, 174, 1);
    aContent.btnSelectedColor = DP_RGBA(51, 105, 227, 1);
    NSDictionary *aData = _vcArray[index];
    aContent.btnTitle = aData.allKeys.firstObject;
    aContent.aVcOrView = aData.allValues.firstObject;
    return aContent;
}
- (void)slideSwitchView:(DPTabMenuBarView *)view content:(DPTabMenuBarContent *)aContent viewOldIndex:(NSInteger)oldIndex viewIndex:(NSInteger)index{
    
}
@end
