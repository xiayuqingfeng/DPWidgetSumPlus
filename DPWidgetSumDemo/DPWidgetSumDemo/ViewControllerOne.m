//
//  ViewController.m
//  test
//
//  Created by xiayupeng on 2018/12/17.
//  Copyright © 2018 yupeng xia. All rights reserved.
//

#import "ViewControllerOne.h"
#import "DPWidgetSum.h"
#import "DPTextField.h"
#import "DPAddressAlertPickerView.h"
#import "DPTimeAlertPickerView.h"
#import "DPDownMenuView.h"

@interface ViewControllerOne () {
    
}
@property (nonatomic, strong) DPTextField *addressField;
@property (nonatomic, strong) DPTextField *addressField1;
@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UILabel *dateLab1;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) DPDownMenuView *downMenuView;
@end

@implementation ViewControllerOne
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavBarView = YES;
    
    self.addressField = [[DPTextField alloc] initWithFrame:CGRectMake(0, DP_FrameHeight(15), self.contentView.dp_width, DP_FrameHeight(35)) delegate:self superView:self.contentView];
    _addressField.lrGap = DP_FrameWidth(14);
    _addressField.itGap = DP_FrameWidth(12);
    _addressField.lineViewColor = [UIColor clearColor];
    _addressField.leftLabWidth = DP_FrameWidth(90);
    _addressField.leftLabtextFont = DP_FontBold(13);
    _addressField.leftLabText = @"三级地址有选择按钮:";
    _addressField.textFont = DP_Font(13);
    _addressField.placeholderFont = DP_Font(13);
    _addressField.placeholder = @"请选择地区";
    _addressField.bordLineType = 1;
    [self.contentView addSubview:_addressField];
    
    UITapGestureRecognizer *addressTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressTapTap:)];
    [_addressField.aTextField addGestureRecognizer:addressTap];
    
    self.addressField1 = [[DPTextField alloc] initWithFrame:CGRectMake(0, _addressField.dp_yMax+DP_FrameHeight(15), self.contentView.dp_width, DP_FrameHeight(35)) delegate:self superView:self.contentView];
    _addressField1.lrGap = DP_FrameWidth(14);
    _addressField1.itGap = DP_FrameWidth(12);
    _addressField1.lineViewColor = [UIColor clearColor];
    _addressField1.leftLabWidth = DP_FrameWidth(90);
    _addressField1.leftLabtextFont = DP_FontBold(13);
    _addressField1.leftLabText = @"二级地址没有选择按钮:";
    _addressField1.textFont = DP_Font(13);
    _addressField1.placeholderFont = DP_Font(13);
    _addressField1.placeholder = @"请选择地区";
    _addressField1.bordLineType = 1;
    [self.contentView addSubview:_addressField1];
    
    UITapGestureRecognizer *addressTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressTap1Tap:)];
    [_addressField1.aTextField addGestureRecognizer:addressTap1];
    
    
    self.dateLab = [[UILabel alloc] init];
    _dateLab.userInteractionEnabled = YES;
    _dateLab.frame = CGRectMake(0, _addressField1.dp_yMax+DP_FrameHeight(10), self.contentView.dp_width, DP_FrameHeight(40));
    _dateLab.backgroundColor = [UIColor greenColor];
    _dateLab.text = @"选择时间：";
    [self.contentView addSubview:_dateLab];
    
    UITapGestureRecognizer *dateLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateLabelTapAction:)];
    [_dateLab addGestureRecognizer:dateLabelTap];
    
    self.dateLab1 = [[UILabel alloc] init];
    _dateLab1.userInteractionEnabled = YES;
    _dateLab1.frame = CGRectMake(0, _dateLab.dp_yMax+DP_FrameHeight(10), self.contentView.dp_width, DP_FrameHeight(40));
    _dateLab1.backgroundColor = [UIColor greenColor];
    _dateLab1.text = @"选择时间：";
    [self.contentView addSubview:_dateLab1];
    
    UITapGestureRecognizer *dateLabelTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateLabelTapAction1:)];
    [_dateLab1 addGestureRecognizer:dateLabelTap1];
    
    
    self.priceLab = [[UILabel alloc]init];
    _priceLab.numberOfLines = 1;
    _priceLab.font = DP_Font(13);
    _priceLab.textColor = DP_RGBA(43, 56, 120, 1);
    _priceLab.text = @"方案价格:";
    [_priceLab sizeToFit];
    _priceLab.frame = CGRectMake(DP_FrameWidth(14), _dateLab1.dp_yMax+DP_FrameHeight(24), _priceLab.dp_width, _priceLab.dp_height);
    [self.contentView addSubview:_priceLab];
    
    self.downMenuView = [DPDownMenuView initWithSuperView:self.contentView rootView:self.contentView selectBlock:nil];
    _downMenuView.frame = CGRectMake(_priceLab.dp_xMax+DP_FrameWidth(10), _priceLab.dp_y, DP_FrameWidth(90), DP_FrameHeight(30));
    _downMenuView.dp_centerY = _priceLab.dp_centerY;
    _downMenuView.backgroundColor = DP_RGBA(255, 255, 255, 1);
    _downMenuView.aTapEnabledBlock = ^BOOL(DPDownMenuView *aObject) {
        return YES;
    };
    _downMenuView.aTapBlock = ^(DPDownMenuView *aObject, NSInteger aType) {
        
    };
    _downMenuView.dataArray = @[@{@"":@"1元"}, @{@"":@"2元"}, @{@"":@"3元"}, @{@"":@"4元"}];
}
- (void)addressTapTap:(id)sender {
    //省、市、区(县)地址选择框
    dp_arc_block(self);
    [DPAddressAlertPickerView showTypeAlertViewForParent:self.view uuid:110 alertViewStyle:DPAddressViewStyleOne level:3 isShow:YES updateDataBlock:^NSArray<DPProvinceModel *> *(DPAddressAlertPickerView *aObject) {
        DPCountyModel *selectCountyModel = [[DPCountyModel alloc] init];
        selectCountyModel.countyCode = @"111";
        selectCountyModel.county = @"滑县";
        
        DPCityModel *selectCityModel = [[DPCityModel alloc] init];
        selectCityModel.cityCode = @"222";
        selectCityModel.city = @"安阳市";
        selectCityModel.array = [@[selectCountyModel] mutableCopy];
        
        DPProvinceModel *selectProvinceModel = [[DPProvinceModel alloc] init];
        selectProvinceModel.proCode = @"333";
        selectProvinceModel.province = @"河南省";
        selectProvinceModel.array = [@[selectCityModel] mutableCopy];
        
        DPCountyModel *selectCountyModel1 = [[DPCountyModel alloc] init];
        selectCountyModel1.countyCode = @"111";
        selectCountyModel1.county = @"清河";
        
        DPCityModel *selectCityModel1 = [[DPCityModel alloc] init];
        selectCityModel1.cityCode = @"222";
        selectCityModel1.city = @"保定";
        selectCityModel1.array = [@[selectCountyModel1] mutableCopy];
        
        DPProvinceModel *selectProvinceModel1 = [[DPProvinceModel alloc] init];
        selectProvinceModel1.proCode = @"333";
        selectProvinceModel1.province = @"河北省";
        selectProvinceModel1.array = [@[selectCityModel1] mutableCopy];
        
        NSArray <DPProvinceModel *>* aProvinceArray = @[selectProvinceModel, selectProvinceModel1];
        
        return aProvinceArray;
    } selctBlock:^(DPAddressAlertPickerView *aObject) {
        NSString *addressStr = @"";
        if (aObject.selectProvinceModel.province.length) {
            addressStr = [NSString stringWithFormat:@"%@ %@",addressStr,aObject.selectProvinceModel.province];
        }
        if (aObject.selectCityModel.city.length) {
            addressStr = [NSString stringWithFormat:@"%@ %@",addressStr,aObject.selectCityModel.city];
        }
        if (aObject.selectCountyModel.county.length) {
            addressStr = [NSString stringWithFormat:@"%@ %@",addressStr,aObject.selectCountyModel.county];
        }
        weak_self.addressField.aTextField.text = addressStr;
    }];
}

- (void)addressTap1Tap:(id)sender {
    //省、市、区(县)地址选择框
    dp_arc_block(self);
    [DPAddressAlertPickerView showTypeAlertViewForParent:self.view uuid:111 alertViewStyle:DPAddressViewStyleTow level:2 isShow:YES updateDataBlock:^NSArray<DPProvinceModel *> *(DPAddressAlertPickerView *aObject) {
        DPCountyModel *selectCountyModel = [[DPCountyModel alloc] init];
        selectCountyModel.countyCode = @"111";
        selectCountyModel.county = @"滑县";
        
        DPCityModel *selectCityModel = [[DPCityModel alloc] init];
        selectCityModel.cityCode = @"222";
        selectCityModel.city = @"安阳市";
        selectCityModel.array = [@[selectCountyModel] mutableCopy];
        
        DPProvinceModel *selectProvinceModel = [[DPProvinceModel alloc] init];
        selectProvinceModel.proCode = @"333";
        selectProvinceModel.province = @"河南省";
        selectProvinceModel.array = [@[selectCityModel] mutableCopy];
        
        DPCountyModel *selectCountyModel1 = [[DPCountyModel alloc] init];
        selectCountyModel1.countyCode = @"111";
        selectCountyModel1.county = @"清河";
        
        DPCityModel *selectCityModel1 = [[DPCityModel alloc] init];
        selectCityModel1.cityCode = @"222";
        selectCityModel1.city = @"保定";
        selectCityModel1.array = [@[selectCountyModel1] mutableCopy];
        
        DPProvinceModel *selectProvinceModel1 = [[DPProvinceModel alloc] init];
        selectProvinceModel1.proCode = @"333";
        selectProvinceModel1.province = @"河北省";
        selectProvinceModel1.array = [@[selectCityModel1] mutableCopy];
        
        NSArray <DPProvinceModel *>* aProvinceArray = @[selectProvinceModel, selectProvinceModel1];
        
        return aProvinceArray;
    } selctBlock:^(DPAddressAlertPickerView *aObject) {
        NSString *addressStr = @"";
        if (aObject.selectProvinceModel.province.length) {
            addressStr = [NSString stringWithFormat:@"%@ %@",addressStr,aObject.selectProvinceModel.province];
        }
        if (aObject.selectCityModel.city.length) {
            addressStr = [NSString stringWithFormat:@"%@ %@",addressStr,aObject.selectCityModel.city];
        }
        if (aObject.selectCountyModel.county.length) {
            addressStr = [NSString stringWithFormat:@"%@ %@",addressStr,aObject.selectCountyModel.county];
        }
        weak_self.addressField1.aTextField.text = addressStr;
    }];
}

- (void)dateLabelTapAction:(UITapGestureRecognizer *)tap {
    dp_arc_block(self);
    DPTimeAlertPickerView *datePickerView = [DPTimeAlertPickerView alertViewForParent:self.contentView uuid:0 alertViewStyle:DPTimeViewStyleOne alertBlock:^(DPTimeAlertPickerView *aObject) {
        NSString *dateStr = [NSDate dp_getStrForDateOrStr:aObject.selectDate formatter:@"yyyy-MM-dd" isIntercept:NO];
        if (dateStr.length) {
            weak_self.dateLab.text = [@"选择时间： " stringByAppendingString:dp_notEmptyStr(dateStr)];
        }
    }];
    NSDate *maxDate = [NSDate date];
    NSDate *minDate = [NSDate dp_getPriousorLaterDateFromDate:maxDate withMonth:-3];
    datePickerView.minDate = minDate;
    datePickerView.maxDate = maxDate;
    [datePickerView showTypeAlertViewForIsShow:YES];
}

- (void)dateLabelTapAction1:(UITapGestureRecognizer *)tap {
    dp_arc_block(self);
    DPTimeAlertPickerView *datePickerView = [DPTimeAlertPickerView alertViewForParent:self.contentView uuid:1 alertViewStyle:DPTimeViewStyleTow alertBlock:^(DPTimeAlertPickerView *aObject) {
        NSString *dateStr = [NSDate dp_getStrForDateOrStr:aObject.selectDate formatter:@"yyyy-MM-dd" isIntercept:NO];
        if (dateStr.length) {
            weak_self.dateLab1.text = [@"选择时间： " stringByAppendingString:dp_notEmptyStr(dateStr)];
        }
    }];
    NSDate *maxDate = [NSDate date];
    NSDate *minDate = [NSDate dp_getPriousorLaterDateFromDate:maxDate withMonth:-3];
    datePickerView.minDate = minDate;
    datePickerView.maxDate = maxDate;
    [datePickerView showTypeAlertViewForIsShow:YES];
}
@end
