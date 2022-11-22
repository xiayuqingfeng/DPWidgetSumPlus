//
//  DPBaseTextField.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, DPBaseTextFieldPerform) {
    ///空
    DPBaseTextFieldPerformNil       = 1 << 0,
    ///剪切
    DPBaseTextFieldPerformCut       = 1 << 1,
    ///拷贝
    DPBaseTextFieldPerformCopy      = 1 << 2,
    ///选择
    DPBaseTextFieldPerformSelect    = 1 << 3,
    //全选
    DPBaseTextFieldPerformSelectAll = 1 << 4,
    ///粘贴
    DPBaseTextFieldPerformPaste     = 1 << 5,
    ///删除
    DPBaseTextFieldPerformDelete    = 1 << 6,
    ///所有操作
    DPBaseTextFieldPerformmAllTypes = 1 << 7
};

@interface DPBaseTextField : UITextField
///文字加载完成(联想结束) 或 text赋值完成(set赋值) block回调事件
@property (nonatomic, copy) void(^baseTextDidChangeBlock)(DPBaseTextField *aObject);

@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) UIFont *placeholderFont;
///输入框禁用操作类型，默认：DPBaseTextFieldPerformNil
@property (nonatomic, assign) DPBaseTextFieldPerform notTextFieldPerformType;
///自定义安全文本使用类型：0 使用系统密文处理方法（无中文键盘，无第三方键盘），1 使用自定义密文处理方法（有中文键盘，有第三方键盘），默认：0；
@property (nonatomic, assign) NSInteger secureTextEntryType;
///自定义安全文本显示状态：YES 密文，NO 明文，默认：NO；
@property (nonatomic, assign) BOOL secureTextEntryDP;
@end

