//
//  DPTimeAlertPickerView.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DPTimeAlertPickerView;

typedef enum {
    ///样式一，有选择按钮
    DPTimeViewStyleOne = 0,
    ///样式二，没有选择按钮
    DPTimeViewStyleTow = 1
}DPTimeViewStyle;

typedef void(^DPTimePickerViewBlock)(DPTimeAlertPickerView *aObject);

@interface DPTimeAlertPickerView : UIView
///当前使用时间
@property (nonatomic, strong) NSDate *selectDate;
///当前时间区间，最小时间
@property (nonatomic, strong) NSDate *minDate;
///当前时间区间，最大时间
@property (nonatomic, strong) NSDate *maxDate;

/**
 *  年、月、日地址三级选择框显示，类方法调用（中国时区 zh）
 *
 *  @param aParent 弹框父视图，不能为空
 *  @param aUuid 唯一标识符，父视图只会根据不同的标识符生成当前控件
 *  @param aAlertViewStyle 弹框样式
 *  @param aLevel 省市区层级：年月日层级，1 年，2 年月，3 年月日
 *
 *  @return DPTimeAlertPickerView: 当前控件，控件内部进行addSubview
 */
+ (DPTimeAlertPickerView *)alertViewForParent:(UIView *)aParent uuid:(NSInteger)aUuid alertViewStyle:(DPTimeViewStyle)aAlertViewStyle alertBlock:(DPTimePickerViewBlock)aAlertBlock;

/**
 *  年、月、日地址三级选择框隐藏，类方法调用
 *
 *  @param aParent 弹框父视图，不能为空
 *  @param aUuid 唯一标识符，父视图标识符隐藏当前控件
 *  @param aIsShow 显示状态，YES 显示， NO 隐藏
 *
 */
+ (void)showTypeAlertViewForParent:(UIView *)aParent uuid:(NSInteger)aUuid isShow:(BOOL)aIsShow;

/**
 *  年、月、日地址三级选择框隐藏，实例方法调用
 *
 *  @param aIsShow 显示状态，YES 显示， NO 隐藏
 *
 */
- (void)showTypeAlertViewForIsShow:(BOOL)aIsShow;
@end
