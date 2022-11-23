//
//  DPAddressAlertPickerView.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DPProvinceModel.h"
@class DPAddressAlertPickerView;

typedef enum {
    ///样式一，有选择按钮
    DPAddressViewStyleOne = 0,
    ///样式二，没有选择按钮
    DPAddressViewStyleTow = 1
}DPAddressViewStyle;

typedef void(^DPAddressPickerSelectBlock)(DPAddressAlertPickerView *aObject);
typedef NSArray <DPProvinceModel *>* (^DPAddressPickerLoadBlock)(DPAddressAlertPickerView *aObject);
typedef NSArray <DPProvinceModel *>* (^DPAddressPickerQueryBlock)(DPProvinceModel *aProvinceModel, DPCityModel *aDPCityModel, DPCountyModel *aCountyModel);

@interface DPAddressAlertPickerView : UIView
///当前使用"省"数据model
@property (nonatomic, strong) DPProvinceModel *selectProvinceModel;
///当前使用"市"数据model
@property (nonatomic, strong) DPCityModel *selectCityModel;
///当前使用"区(县)" 数据model
@property (nonatomic, strong) DPCountyModel *selectCountyModel;

/**
 *  省、市、区(县)地址三级选择框隐藏，实例方法调用
 *
 *  @param aIsShow 显示状态，YES 显示， NO 隐藏
 *  @param aBlock 回调获取地址列表数据
 *
 */
- (void)showTypeAlertViewForIsShow:(BOOL)aIsShow updateDataBlock:(DPAddressPickerLoadBlock)aUpdateDataBlock;

/**
 *  设置默认选择省、市、区(县)地址，实例方法调用
 *
 *  @param aProvince 省code
 *  @param aCity 市code
 *  @param aCounty 区(县)code
 *  @param aIsAlertBlock 是否调用aAlertBlock回调函数，执行地址选择项，默认：NO 不调用
 *
 */
- (void)setAlertViewForProvince:(NSString *)aProvince city:(NSString *)aCity county:(NSString *)aCounty isAlertBlock:(BOOL)aIsAlertBlock;

/**
 *  省、市、区(县)地址三级选择框显示
 *
 *  @param aParent 弹框父视图，不能为空
 *  @param aUuid 唯一标识符，父视图只会根据不同的标识符生成当前控件
 *  @param aAlertViewStyle 弹框样式
 *  @param aLevel 省市区(县)层级：省、市、区(县)层级，1 省，2 省市，3 省市区(县)
 *
 *  @return DPAddressAlertPickerView: 当前控件，控件内部进行addSubview
 */
+ (DPAddressAlertPickerView *)alertViewForParent:(UIView *)aParent uuid:(NSInteger)aUuid alertViewStyle:(DPAddressViewStyle)aAlertViewStyle level:(NSInteger)aLevel selctBlock:(DPAddressPickerSelectBlock)aSelctBlock;

/**
 *  省、市、区(县)地址三级选择框显示
 *
 *  @param aParent 弹框父视图，不能为空
 *  @param aUuid 唯一标识符，父视图标识符隐藏当前控件
 *  @param aIsShow 显示状态，YES 显示， NO 隐藏
 *
 */
+ (void)showTypeAlertViewForParent:(UIView *)aParent uuid:(NSInteger)aUuid alertViewStyle:(DPAddressViewStyle)aAlertViewStyle level:(NSInteger)aLevel isShow:(BOOL)aIsShow updateDataBlock:(DPAddressPickerLoadBlock)aUpdateDataBlock selctBlock:(DPAddressPickerSelectBlock)aSelctBlock;

/**
 *  获取拼接好的省、市、区(县)地址
 *
 *  @param aProvinceCode 省code
 *  @param aCityCode 市code
 *  @param aCountyCode 区(县)code
 *
 *  @return 拼接好的省、市、区(县)地址
 */
+ (void)addressSumForProvinceCode:(NSString *)aProvinceCode cityCode:(NSString *)aCityCode countyCode:(NSString *)aCountyCode updateDataBlock:(DPAddressPickerLoadBlock)aUpdateDataBlock callBackBlock:(DPAddressPickerQueryBlock)callBackBlock;
@end
