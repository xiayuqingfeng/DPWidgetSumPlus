//
//  ViewControllerSeven.m
//  YQYLApp
//
//  Created by yupeng xia on 2020/12/7.
//  Copyright © 2020 zcw. All rights reserved.
//

#import "ViewControllerSeven.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "DPWidgetSumPlus.h"
#import "DPTextField.h"
#import "DPTextView.h"
#import "DPDownMenuView.h"

@interface ViewControllerSeven () {
    
}
@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) UIView *aBottomView;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) DPDownMenuView *downMenuView;
@property (nonatomic, strong) DPTextView *titleTextView;
@property (nonatomic, strong) UILabel *freeLab;
@property (nonatomic, strong) DPTextView *freeTextView;
@property (nonatomic, strong) UILabel *tollLab;
@property (nonatomic, strong) DPTextView *tollTextView;
@end

@implementation ViewControllerSeven
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavBarView = YES;
    self.titleLabel.text = @"方案发布";

    self.bgScrollView = [[UIScrollView alloc] init];
    _bgScrollView.frame = CGRectMake(0, 0, self.contentView.dp_width, self.contentView.dp_height-DP_FrameHeight(60));
    _bgScrollView.contentSize = _bgScrollView.dp_size;
    [self.contentView addSubview:_bgScrollView];

    self.aBottomView = [[UIView alloc] init];
    _aBottomView.frame = CGRectMake(0, DP_FrameHeight(10), _bgScrollView.dp_width, 0);
    _aBottomView.backgroundColor = DP_RGBA(255, 255, 255, 1);
    [_bgScrollView addSubview:_aBottomView];
    
    self.priceLab = [[UILabel alloc]init];
    _priceLab.numberOfLines = 1;
    _priceLab.font = DP_Font(13);
    _priceLab.textColor = DP_RGBA(43, 56, 120, 1);
    _priceLab.text = @"方案价格:";
    [_priceLab sizeToFit];
    _priceLab.frame = CGRectMake(DP_FrameWidth(14), DP_FrameHeight(24), _priceLab.dp_width, _priceLab.dp_height);
    [_aBottomView addSubview:_priceLab];
    
    self.downMenuView = [DPDownMenuView initWithSuperView:_aBottomView rootView:self.contentView selectBlock:nil];
    _downMenuView.frame = CGRectMake(_priceLab.dp_xMax+DP_FrameWidth(10), _priceLab.dp_y, DP_FrameWidth(90), DP_FrameHeight(30));
    _downMenuView.dp_centerY = _priceLab.dp_centerY;
    _downMenuView.backgroundColor = DP_RGBA(255, 255, 255, 1);
    _downMenuView.aTapEnabledBlock = ^BOOL(DPDownMenuView *aObject) {
        [DPTool showToastMsg:@"获取价格列表失败，重新获取！"];
        return YES;
    };
    _downMenuView.aTapBlock = ^(DPDownMenuView *aObject, NSInteger aType) {
        
    };
    
    UILabel *pTitleLab = [[UILabel alloc]init];
    pTitleLab.numberOfLines = 1;
    pTitleLab.font = DP_Font(13);
    pTitleLab.textColor = DP_RGBA(43, 56, 120, 1);
    pTitleLab.text = @"方案标题:";
    [pTitleLab sizeToFit];
    pTitleLab.frame = CGRectMake(DP_FrameWidth(14), _priceLab.dp_yMax+DP_FrameHeight(24), pTitleLab.dp_width, pTitleLab.dp_height);
    [_aBottomView addSubview:pTitleLab];
    
    self.titleTextView = [[DPTextView alloc] initWithFrame:CGRectMake(DP_FrameWidth(14), pTitleLab.dp_yMax+DP_FrameHeight(10), _aBottomView.dp_width-DP_FrameWidth(14)*2, DP_FrameHeight(60)) delegate:self superView:_bgScrollView];
    _titleTextView.lrGap = 0;
    _titleTextView.textFont = DP_Font(13);
    _titleTextView.placeholderFont = DP_Font(13);
    _titleTextView.placeholder = @"请输入20-40个字";
    _titleTextView.textLengthMax = @"40";
    _titleTextView.textMaxMessage = @"标题长度最多为40个字";
    _titleTextView.aTextView.returnKeyType = UIReturnKeyNext;
    _titleTextView.bordLineType = 1;
    _titleTextView.textNoRegular = @" \n";
    [_aBottomView addSubview:_titleTextView];

    self.freeLab = [[UILabel alloc]init];
    _freeLab.numberOfLines = 1;
    _freeLab.font = DP_Font(13);
    _freeLab.textColor = DP_RGBA(43, 56, 120, 1);
    _freeLab.text = @"方案免费可见理由[选填]:";
    [_freeLab sizeToFit];
    _freeLab.frame = CGRectMake(DP_FrameWidth(14), _titleTextView.dp_yMax+DP_FrameHeight(16), _freeLab.dp_width, _freeLab.dp_height);
    [_aBottomView addSubview:_freeLab];
    
    self.freeTextView = [[DPTextView alloc] initWithFrame:CGRectMake(DP_FrameWidth(14), _freeLab.dp_yMax+DP_FrameHeight(10), _aBottomView.dp_width-DP_FrameWidth(14)*2, DP_FrameHeight(90)) delegate:self superView:_bgScrollView];
    _freeTextView.lrGap = 0;
    _freeTextView.textFont = DP_Font(13);
    _freeTextView.placeholderFont = DP_Font(13);
    _freeTextView.placeholder = @"免费可见理由最多100字";
    _freeTextView.textLengthMax = @"100";
    _freeTextView.aTextView.returnKeyType = UIReturnKeyNext;
    _freeTextView.fontTextView = _titleTextView;
    _freeTextView.bordLineType = 1;
    _freeTextView.textNoRegular = @" ";
    [_aBottomView addSubview:_freeTextView];

    self.tollLab = [[UILabel alloc]init];
    _tollLab.numberOfLines = 1;
    _tollLab.font = DP_Font(13);
    _tollLab.textColor = DP_RGBA(43, 56, 120, 1);
    _tollLab.text = @"方案付费可见理由[必填]:";
    [_tollLab sizeToFit];
    _tollLab.frame = CGRectMake(DP_FrameWidth(14), _freeTextView.dp_yMax+DP_FrameHeight(16), _tollLab.dp_width, _tollLab.dp_height);
    [_aBottomView addSubview:_tollLab];
    
    self.tollTextView = [[DPTextView alloc] initWithFrame:CGRectMake(DP_FrameWidth(14), _tollLab.dp_yMax+DP_FrameHeight(10), _aBottomView.dp_width-DP_FrameWidth(14)*2, DP_FrameHeight(160)) delegate:self superView:_bgScrollView];
    _tollTextView.lrGap = 0;
    _tollTextView.textFont = DP_Font(13);
    _tollTextView.placeholderFont = DP_Font(13);
    _tollTextView.placeholder = @"推荐一场至少输入200字；两场至少输入300字；最多可输入2000字。";
    _tollTextView.textLengthMax = @"2000";
    _tollTextView.fontTextView = _freeTextView;
    _tollTextView.bordLineType = 1;
    _tollTextView.textNoRegular = @" ";
    _tollTextView.aTextView.returnKeyType = UIReturnKeyDone;
    [_aBottomView addSubview:_tollTextView];

    _aBottomView.dp_height = _tollTextView.dp_yMax+DP_FrameHeight(16);
    _bgScrollView.contentSize = CGSizeMake(_bgScrollView.dp_width, MAX(_aBottomView.dp_yMax, _bgScrollView.dp_height));
}
@end
