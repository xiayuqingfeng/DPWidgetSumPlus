//
//  DPAddressAlertPickerView.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//  中彩_地址选择滚轮

#import "DPAddressAlertPickerView.h"
#import "DPWidgetSumPlus.h"
#import <ReactiveObjC/ReactiveObjC.h>

#define DPAddressAlertPickerViewTag 16800100

@interface DPAddressAlertPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    
}
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *leftBut;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *rightBut;
@property (nonatomic, strong) UIPickerView *aPickerView;

//回调
@property (nonatomic, copy) DPAddressPickerSelectBlock aAlertBlock;
//弹框父视图
@property (nonatomic, weak) UIView *parent;
//唯一标识符，父视图只会根据不同的标识符生成当前控件
@property (nonatomic, assign) NSInteger uuid;
//弹框样式
@property (nonatomic, assign) DPAddressViewStyle addressViewStyle;
//省市区(县)层级 1 省，2 省市，3 省市区(县)
@property (nonatomic, assign) NSInteger level;

//当前"省、市、区(县) "数据列表
@property (nonatomic, strong) NSArray <DPProvinceModel *>*aProvinceArray;
//当前展示"省"临时数据model
@property (nonatomic, strong) DPProvinceModel *aProvinceModel;
//当前展示"市"临时数据model
@property (nonatomic, strong) DPCityModel *aCityModel;
//当前展示"区(县)" 临时数据model
@property (nonatomic, strong) DPCountyModel *aCountyModel;
@end

@implementation DPAddressAlertPickerView
- (void)dealloc {
    if (_aAlertBlock) {
        _aAlertBlock = nil;
    }
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        self.hidden = YES;

        self.aProvinceArray = [NSArray array];
        
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
        _titleLab.text = @"地址选择";
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
                
                //当前"省"数据model
                weak_self.selectProvinceModel = weak_self.aProvinceModel;
                //当前"市"数据model
                weak_self.selectCityModel = weak_self.aCityModel;
                //当前"区(县)" 数据model
                weak_self.selectCountyModel = weak_self.aCountyModel;
                
                if (weak_self.aAlertBlock) {
                    weak_self.aAlertBlock(weak_self);
                }
            }];
        }];
        [_bgView addSubview:_rightBut];
        
        self.aPickerView = [[UIPickerView alloc] init];
        _aPickerView.frame = CGRectMake(0, _titleLab.dp_yMax+DP_FrameHeight(10), _bgView.dp_width, _bgView.dp_height-_titleLab.dp_yMax-DP_FrameHeight(10)*2);
        _aPickerView.dataSource = self;
        _aPickerView.delegate = self;
        _aPickerView.backgroundColor = [UIColor clearColor];
        _aPickerView.showsSelectionIndicator = YES;
        [_bgView addSubview:_aPickerView];
    }
    return self;
}
- (void)tapAction:(UITapGestureRecognizer *)aTap {
    if (_addressViewStyle == DPAddressViewStyleTow) {
        dp_arc_block(self);
        [UIView animateWithDuration:0.2 animations:^{
            weak_self.bgView.dp_y = weak_self.dp_height;
        }completion:^(BOOL finished) {
            weak_self.hidden = YES;
        }];
    }
}
//生成PickerView默认加载数据
- (void)getPickerViewDataModel {
    if (_level > 0) {
        if (_selectProvinceModel == nil) {
            self.aProvinceModel = [_aProvinceArray dp_objectAtIndex:0];
            self.selectProvinceModel = _aProvinceModel;
        }else {
            self.aProvinceModel = _selectProvinceModel;
        }
    }
    
    if (_level > 1) {
        if (_selectCityModel == nil) {
            self.aCityModel = [[self getCityArray] dp_objectAtIndex:0];
            self.selectCityModel = _aCityModel;
        }else {
            self.aCityModel = _selectCityModel;
        }
    }
    
    if (_level > 2) {
        if (_selectCountyModel == nil) {
            self.aCountyModel = [[self getCountyArray] dp_objectAtIndex:0];
            self.selectCountyModel = _aCountyModel;
        }else {
            self.aCountyModel = _selectCountyModel;
        }
    }
}
//根据当前数据刷新PickerView选择位置
- (void)reloadPickerViewDataModel {
    if (_level > 0) {
        NSInteger row = 0;
        for (int i = 0; i < _aProvinceArray.count; i++) {
            if (_aProvinceModel.proCode.integerValue == _aProvinceArray[i].proCode.integerValue) {
                row = i;
                break;
            }
        }
        [_aPickerView selectRow:row inComponent:0 animated:YES];
    }
    
    if (_level > 1) {
        NSInteger row = 0;
        for (int i = 0; i < _selectProvinceModel.array.count; i++) {
            if (_aCityModel.cityCode.integerValue == _selectProvinceModel.array[i].cityCode.integerValue) {
                row = i;
                break;
            }
        }
        [_aPickerView selectRow:row inComponent:1 animated:YES];
    }
    
    if (_level > 2) {
        NSInteger row = 0;
        for (int i = 0; i < _aCityModel.array.count; i++) {
            if (_aCountyModel.countyCode.integerValue == _aCityModel.array[i].countyCode.integerValue) {
                row = i;
                break;
            }
        }
        [_aPickerView selectRow:row inComponent:2 animated:YES];
    }
    
    [_aPickerView reloadAllComponents];
}

- (void)showTypeAlertViewForIsShow:(BOOL)aIsShow updateDataBlock:(DPAddressPickerLoadBlock)aUpdateDataBlock {
    dp_arc_block(self);
    if (aIsShow) {
        if (aUpdateDataBlock) {
            self.aProvinceArray = aUpdateDataBlock(self);
        }
        if (_aProvinceArray.count < 1) {
            [DPTool showToastMsg:@"地址列表为空！"];
            return;
        }
        
        self.hidden = NO;
        self.frame = _parent.bounds;
        [_parent addSubview:self];
        
        _bgView.dp_y = self.dp_height;
        
        //根据指定样式隐藏或显示“取消”、“确定”按钮
        if (_addressViewStyle == DPAddressViewStyleOne) {
            _leftBut.hidden = NO;
            _rightBut.hidden = NO;
        }else if (_addressViewStyle == DPAddressViewStyleTow) {
            _leftBut.hidden = YES;
            _rightBut.hidden = YES;
        }

        //根据指定层级，获取省、市、区(县)三级初始化数据
        [self getPickerViewDataModel];
        [self reloadPickerViewDataModel];

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

- (void)setAlertViewForProvince:(NSString *)aProvince city:(NSString *)aCity county:(NSString *)aCounty isAlertBlock:(BOOL)aIsAlertBlock {
    if (aProvince.length) {
        for (int i = 0; i < _aProvinceArray.count; i++) {
            if (aProvince.integerValue == _aProvinceArray[i].proCode.integerValue) {
                self.selectProvinceModel = _aProvinceArray[i];
            }
        }
    }
    
    if (aCity.length) {
        for (int i = 0; i < _selectProvinceModel.array.count; i++) {
            if (aCity.integerValue == _selectProvinceModel.array[i].cityCode.integerValue) {
                self.selectCityModel = _selectProvinceModel.array[i];
            }
        }
    }
    
    if (aCounty.length) {
        for (int i = 0; i < _selectCityModel.array.count; i++) {
            if (aCounty.integerValue == _selectCityModel.array[i].countyCode.integerValue) {
                self.selectCountyModel = _selectCityModel.array[i];
            }
        }
    }
    
    if (aIsAlertBlock && self.aAlertBlock) {
        self.aAlertBlock(self);
    }
}

#pragma mark <--------------UIPickerViewDelegate,UIPickerViewDataSource-------------->
//列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return _level;
}
//行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger aCount = 0;
    if (component == 0) {
        aCount = _aProvinceArray.count;
    }else if (component == 1) {
        aCount = _aProvinceModel.array.count;
    }else if (component == 2) {
        aCount = _aCityModel.array.count;
    }
    return aCount;
}
//列宽
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return DP_ScreenWidth/_level;
}
//列/行/赋值
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *str = @"";
    if (component == 0) {
        str = dp_notEmptyStr(_aProvinceArray[row].province);
    }else if (component == 1) {
        str = dp_notEmptyStr(_aProvinceModel.array[row].city);
    }else if (component == 2) {
        str = dp_notEmptyStr(_aCityModel.array[row].county);
    }
    return str;
}
//选择行数据
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:{
            if (_level > 0) {
                self.aProvinceModel = [_aProvinceArray dp_objectAtIndex:row];
            }
            if (_level > 1) {
                self.aCityModel = [_aProvinceModel.array dp_objectAtIndex:0];
                [pickerView selectRow:0 inComponent:1 animated:NO];
            }
            if (_level > 2) {
                self.aCountyModel = [_aCityModel.array dp_objectAtIndex:0];
                [pickerView selectRow:0 inComponent:2 animated:NO];
            }
        }
            break;
        case 1:{
            self.aCityModel = [_aProvinceModel.array dp_objectAtIndex:row];
            if (_level > 2) {
                self.aCountyModel = [_aCityModel.array dp_objectAtIndex:0];
                [pickerView selectRow:0 inComponent:2 animated:NO];
            }
        }
            break;
        case 2:{
            self.aCountyModel = [_aCityModel.array dp_objectAtIndex:row];
        }
            break;
        default:
            break;
    }
    [pickerView reloadAllComponents];
    
    if (_addressViewStyle == DPAddressViewStyleTow) {
        //当前"省"数据model
        self.selectProvinceModel = _aProvinceModel;
        //当前"市"数据model
        self.selectCityModel = _aCityModel;
        //当前"区(县)" 数据model
        self.selectCountyModel = _aCountyModel;
        
        if (self.aAlertBlock) {
            self.aAlertBlock(self);
        }
    }
}

#pragma mark <--------------获取地址list-------------->
//获取市级单位数组
- (NSArray <DPCityModel *>*)getCityArray {
    for (DPProvinceModel *aModel in _aProvinceArray) {
        if ([aModel.proCode isEqualToString:_aProvinceModel.proCode]) {
            NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:aModel.array.count];
            for (DPCityModel *bModel in aModel.array) {
                [tempArray addObject:bModel];
            }
            return tempArray;
        }
    }
    return @[];
}
//获取区(县)级单位数组
- (NSArray <DPCountyModel *>*)getCountyArray{
    NSArray <DPCityModel *>* aCityArray = [self getCityArray];
    for (DPCityModel *bModel in aCityArray) {
        if ([bModel.cityCode isEqualToString:_aCityModel.cityCode]) {
            NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:bModel.array.count];
            for (DPCountyModel *cModel in bModel.array) {
                [tempArray addObject:cModel];
            }
            _aCountyModel = _aCountyModel ? _aCountyModel : [tempArray dp_objectAtIndex:0];
            return tempArray;
        }
    }
    return @[];
}

#pragma mark <--------------外部调用函数-------------->
+ (DPAddressAlertPickerView *)alertViewForParent:(UIView *)aParent uuid:(NSInteger)aUuid alertViewStyle:(DPAddressViewStyle)aAlertViewStyle level:(NSInteger)aLevel selctBlock:(DPAddressPickerSelectBlock)aSelctBlock {
    //传参错误
    if (aLevel < 1 || aLevel > 3) {
        NSLog(@"\nError: DPAddressAlertPickerView省市区(县)层级aLevel参数错误!\n");
        return nil;
    }
    if (aParent == nil) {
        NSLog(@"\nError: DPAddressAlertPickerView父视图aParent不能为空!\n");
        return nil;
    }
    
    //通过父视图，获取当前控件，防止重复创建
    DPAddressAlertPickerView *aAlertPickerView = nil;
    for (UIView *aView in aParent.subviews) {
        if ([aView isKindOfClass:[DPAddressAlertPickerView class]] && aView.tag == DPAddressAlertPickerViewTag+aUuid) {
            aAlertPickerView = (DPAddressAlertPickerView *)aView;
        }
    }
    
    //当前控件初始化
    if (aAlertPickerView == nil) {
        aAlertPickerView = [[DPAddressAlertPickerView alloc] initWithFrame:aParent.bounds];
        aAlertPickerView.tag = DPAddressAlertPickerViewTag+aUuid;
    }
    aAlertPickerView.parent = aParent;
    aAlertPickerView.uuid = aUuid;
    aAlertPickerView.addressViewStyle = aAlertViewStyle;
    aAlertPickerView.level = aLevel;
    aAlertPickerView.aAlertBlock = aSelctBlock;
    if (aParent) {
        [aParent addSubview:aAlertPickerView];
    }
    return aAlertPickerView;
}
+ (void)showTypeAlertViewForParent:(UIView *)aParent uuid:(NSInteger)aUuid alertViewStyle:(DPAddressViewStyle)aAlertViewStyle level:(NSInteger)aLevel isShow:(BOOL)aIsShow updateDataBlock:(DPAddressPickerLoadBlock)aUpdateDataBlock selctBlock:(DPAddressPickerSelectBlock)aSelctBlock {
    DPAddressAlertPickerView *aAlertPickerView = nil;
    for (UIView *aView in aParent.subviews) {
        if ([aView isKindOfClass:[DPAddressAlertPickerView class]] && aView.tag == DPAddressAlertPickerViewTag+aUuid) {
            aAlertPickerView = (DPAddressAlertPickerView *)aView;
        }
    }
    if (aAlertPickerView) {
        [aAlertPickerView showTypeAlertViewForIsShow:aIsShow updateDataBlock:aUpdateDataBlock];
    }else {
        if (aIsShow) {
            aAlertPickerView = [DPAddressAlertPickerView alertViewForParent:aParent uuid:aUuid alertViewStyle:aAlertViewStyle level:aLevel selctBlock:aSelctBlock];
            [aAlertPickerView showTypeAlertViewForIsShow:aIsShow updateDataBlock:aUpdateDataBlock];
        }
    }
}

//根据省、市、区(县)code码获得拼接地址
+ (void)addressSumForProvinceCode:(NSString *)aProvinceCode cityCode:(NSString *)aCityCode countyCode:(NSString *)aCountyCode updateDataBlock:(DPAddressPickerLoadBlock)aUpdateDataBlock callBackBlock:(DPAddressPickerQueryBlock)callBackBlock {
    if (callBackBlock) {
        DPProvinceModel *selectProvinceModel = nil;
        DPCityModel *selectCityModel = nil;
        DPCountyModel *selectCountyModel = nil;
        
        NSArray <DPProvinceModel *>* aProvinceArray = [NSArray array];
        if (aUpdateDataBlock) {
            aProvinceArray = aUpdateDataBlock(nil);
        }
        
        if (aProvinceArray.count > 0) {
            NSArray <DPCityModel *>* aCityArray = nil;
            for (DPProvinceModel *aModel in aProvinceArray) {
                if ([aModel.proCode isEqualToString:aProvinceCode]) {
                    selectProvinceModel = aModel;
                    aCityArray = aModel.array;
                }
            }
            
            NSArray <DPCountyModel *>* aCountyArray = nil;
            for (DPCityModel *aModel in aCityArray) {
                if ([aModel.cityCode isEqualToString:aCityCode]) {
                    selectCityModel = aModel;
                    aCountyArray = aModel.array;
                }
            }
            
            for (DPCountyModel *aModel in aCountyArray) {
                if ([aModel.countyCode isEqualToString:aCountyCode]) {
                    selectCountyModel = aModel;
                }
            }
        }
        
        callBackBlock(selectProvinceModel, selectCityModel, selectCountyModel);
    }
}
@end

