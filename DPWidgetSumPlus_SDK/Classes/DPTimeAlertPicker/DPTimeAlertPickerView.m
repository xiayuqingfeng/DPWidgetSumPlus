//
//  DPTimeAlertPickerView.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//  中彩_地址选择滚轮

#import "DPTimeAlertPickerView.h"
#import "DPWidgetSumPlus.h"
#import <ReactiveObjC/ReactiveObjC.h>

#define DPTimeAlertPickerViewTag 16800400

@interface DPTimeAlertPickerView (){
    
}
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *leftBut;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *rightBut;
@property (nonatomic, strong) UIDatePicker *aPickerView;

//回调
@property (nonatomic, copy) DPTimePickerViewBlock aAlertBlock;
//弹框父视图
@property (nonatomic, weak) UIView *parent;
//唯一标识符，父视图只会根据不同的标识符生成当前控件
@property (nonatomic, assign) NSInteger uuid;
//弹框样式
@property (nonatomic, assign) DPTimeViewStyle timeViewStyle;

///当前展示用时间
@property (nonatomic, strong) NSDate *currentDate;
@end

@implementation DPTimeAlertPickerView
- (void)dealloc {
    if (_aAlertBlock) {
        _aAlertBlock = nil;
    }
}
+ (DPTimeAlertPickerView *)alertViewForParent:(UIView *)aParent uuid:(NSInteger)aUuid alertViewStyle:(DPTimeViewStyle)aAlertViewStyle alertBlock:(DPTimePickerViewBlock)aAlertBlock {
    //传参错误
    if (aParent == nil) {
        NSLog(@"\nError: DPTimeAlertPickerView父视图aParent不能为空!\n");
        return nil;
    }
    
    //通过父视图，获取当前控件，防止重复创建
    DPTimeAlertPickerView *aAlertPickerView = nil;
    for (UIView *aView in aParent.subviews) {
        if ([aView isKindOfClass:[DPTimeAlertPickerView class]] && aView.tag == DPTimeAlertPickerViewTag+aUuid) {
            aAlertPickerView = (DPTimeAlertPickerView *)aView;
        }
    }
    
    //当前控件初始化
    if (aAlertPickerView == nil) {
        aAlertPickerView = [[DPTimeAlertPickerView alloc] initWithFrame:aParent.bounds];
        aAlertPickerView.tag = DPTimeAlertPickerViewTag+aUuid;
    }
    aAlertPickerView.parent = aParent;
    aAlertPickerView.uuid = aUuid;
    aAlertPickerView.timeViewStyle = aAlertViewStyle;
    aAlertPickerView.aAlertBlock = aAlertBlock;
    
    return aAlertPickerView;
}
+ (void)showTypeAlertViewForParent:(UIView *)aParent uuid:(NSInteger)aUuid isShow:(BOOL)aIsShow {
    for (UIView *aView in aParent.subviews) {
        if ([aView isKindOfClass:[DPTimeAlertPickerView class]] && aView.tag == DPTimeAlertPickerViewTag+aUuid) {
            [((DPTimeAlertPickerView *)aView) showTypeAlertViewForIsShow:aIsShow];
        }
    }
}

- (void)showTypeAlertViewForIsShow:(BOOL)aIsShow {
    dp_arc_block(self);
    if (aIsShow) {
        self.hidden = NO;
        self.frame = _parent.bounds;
        [_parent addSubview:self];
        
        _bgView.dp_y = self.dp_height;
        
        //根据指定样式隐藏或显示“取消”、“确定”按钮
        if (_timeViewStyle == DPTimeViewStyleOne) {
            _leftBut.hidden = NO;
            _rightBut.hidden = NO;
        }else if (_timeViewStyle == DPTimeViewStyleTow) {
            _leftBut.hidden = YES;
            _rightBut.hidden = YES;
        }
        
        if (_selectDate != nil) {
            self.currentDate = _selectDate;
            _aPickerView.date = _currentDate;
        }

        [UIView animateWithDuration:0.2 animations:^{
            weak_self.bgView.dp_y = weak_self.dp_height-weak_self.bgView.dp_height;
        }completion:nil];
    }else {
        [UIView animateWithDuration:0.2 animations:^{
            weak_self.bgView.dp_y = weak_self.dp_height;
        }completion:^(BOOL finished) {
            if (finished) {
                weak_self.hidden = YES;
            }
        }];
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        self.hidden = YES;
        
        dp_arc_block(self);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
        
        self.bgView = [[UIView alloc] init];
        _bgView.frame = CGRectMake(0, self.dp_height, self.dp_width, 240);
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bgView.dp_width, 0.5)];
        lineView.backgroundColor = DP_RGBA(230, 233, 240, 1);
        [_bgView addSubview:lineView];
        
        self.titleLab = [[UILabel alloc] init];
        _titleLab.frame = CGRectMake(0, 0, _bgView.dp_width, DP_FrameHeight(30));
        _titleLab.backgroundColor = DP_RGBA(245, 245, 245, 1);
        _titleLab.numberOfLines = 1;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = DP_Font(16);
        _titleLab.textColor = DP_RGBA(0, 0, 0, 1);
        _titleLab.text = @"日期选择";
        [_bgView addSubview:_titleLab];
        
        self.leftBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBut.frame = CGRectMake(DP_FrameWidth(14), 0, DP_FrameWidth(40), _titleLab.dp_height);
        _leftBut.titleLabel.font = DP_Font(16);
        [_leftBut setTitleColor:DP_RGBA(108, 161, 225, 1) forState:UIControlStateNormal];
        [_leftBut setTitle:@"取消" forState:UIControlStateNormal];
        [[_leftBut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [UIView animateWithDuration:0.2 animations:^{
                weak_self.bgView.dp_y = weak_self.dp_height;
            }completion:^(BOOL finished) {
                weak_self.hidden = YES;
            }];
        }];
        [_bgView addSubview:_leftBut];
        
        self.rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBut.frame = CGRectMake(_bgView.dp_width-DP_FrameWidth(14)-DP_FrameWidth(40), 0, DP_FrameWidth(40), _titleLab.dp_height);
        _rightBut.titleLabel.font = DP_Font(16);
        [_rightBut setTitleColor:DP_RGBA(108, 161, 225, 1) forState:UIControlStateNormal];
        [_rightBut setTitle:@"确定" forState:UIControlStateNormal];
        [[_rightBut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [UIView animateWithDuration:0.2 animations:^{
                weak_self.bgView.dp_y = weak_self.dp_height;
            }completion:^(BOOL finished) {
                weak_self.hidden = YES;
                
                //当前使用时间
                weak_self.selectDate = weak_self.currentDate;

                if (weak_self.aAlertBlock) {
                    weak_self.aAlertBlock(weak_self);
                }
            }];
        }];
        [_bgView addSubview:_rightBut];
        
        self.aPickerView = [[UIDatePicker alloc] init];
        _aPickerView.frame = CGRectMake(_bgView.dp_width, _titleLab.dp_yMax, _bgView.dp_width, _bgView.dp_height-_titleLab.dp_yMax);
        _aPickerView.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        _aPickerView.datePickerMode = UIDatePickerModeDate;
        if (@available(iOS 13.4, *)) {
            _aPickerView.preferredDatePickerStyle = UIDatePickerStyleWheels;
        }
        _aPickerView.minimumDate = _minDate;
        _aPickerView.maximumDate = _maxDate;
        _aPickerView.dp_centerX = _bgView.dp_width/2;
        [_aPickerView addTarget:self action:@selector(pickerViewChange:) forControlEvents:UIControlEventValueChanged];
        [_bgView addSubview:_aPickerView];
    }
    return self;
}
- (void)tapAction:(UITapGestureRecognizer *)aTap {
    if (_timeViewStyle == DPTimeViewStyleTow) {
        dp_arc_block(self);
        [UIView animateWithDuration:0.2 animations:^{
            weak_self.bgView.dp_y = weak_self.dp_height;
        }completion:^(BOOL finished) {
            weak_self.hidden = YES;
        }];
    }
}
- (void)pickerViewChange:(UIDatePicker *)pickerView {
    self.currentDate = pickerView.date;
    
    if (_timeViewStyle == DPTimeViewStyleTow) {
        //当前使用时间
        self.selectDate = _currentDate;

        if (self.aAlertBlock) {
            self.aAlertBlock(self);
        }
    }
}

#pragma mark <-------------Setter_methods------------->
- (void)setMinDate:(NSDate *)minDate {
    _minDate = minDate;
    
    _aPickerView.minimumDate = _minDate;
}
- (void)setMaxDate:(NSDate *)maxDate {
    _maxDate = maxDate;
    
    _aPickerView.maximumDate = _maxDate;
}
@end

