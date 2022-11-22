//
//  DPTextField.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 zcw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DPTextInputTool.h"
#import "DPBaseTextField.h"

typedef NS_ENUM(NSInteger, DPTextFieldType) {
    //密码,限制系统键盘
    DPTextFieldTypePassword = 0,
    //密码,不限制键盘类型 和 输入类型
    DPTextFieldTypePasswordChinese = 1,
    //验证码
    DPTextFieldTypeCode = 2
};

@interface DPTextField : UIView
///按钮回调
@property (nonatomic, copy) void(^textFieldButtonBlock)(DPTextField *aObject);
///清空回调
@property (nonatomic, copy) void(^textFieldClearBlock)(DPTextField *aObject);
///输入框文字监听，外部加载代码块，return 修正textField.text。（修改节点：文字加载完成(联想结束) 或 text赋值完成(set赋值)）
@property (nonatomic, copy) NSString *(^textFieldTextDidChangeSetTextBlock)(DPTextField *aObject);

///输入框TextField
@property (nonatomic, strong) DPBaseTextField *aTextField;

///输入框自定义类型
@property (nonatomic, assign) DPTextFieldType textFieldType;

///输入框输入超限限制类型：0 根据字符串长度限制，1 根据字符长度判断；默认：0；
@property (nonatomic, assign) NSInteger textLimitType;
///输入框输入最大长度，为空时使用：DPSMDate.inputBox_textValus[@"textOne"]；
@property (nonatomic, strong) NSString *textLengthMax;
///输入框输入长度超限提示语，为空时使用：DPSMDate.inputBox_textValus[@"textTow"]；
@property (nonatomic, strong) NSString *textMaxMessage;
///正则指定不匹配字符格式(不需要元字符、修饰符)，正则删除不匹配字符格式，默认：nil；
@property (nonatomic, strong) NSString *textNoRegular;
///正则指定不匹配字符格式，违法提示语，为空时使用：DPSMDate.inputBox_textValus[@"textThree"]；
@property (nonatomic, strong) NSString *textNoRegularMessage;
///正则指定匹配字符格式(不需要元字符、修饰符)，正则删除不匹配字符格式，默认：nil；
@property (nonatomic, strong) NSString *textRegular;
///正则指定匹配字符格式，违法提示语，为空时使用：DPSMDate.inputBox_textValus[@"textFour"]；
@property (nonatomic, strong) NSString *textRegularMessage;
///正则指定匹配字符串格式(完整表达式)，从右到左遍历删除字符，直至匹配所有格式，默认：nil；
@property (nonatomic, strong) NSArray <NSString *>*textFormatRegular;
///正则指定匹配字符串格式，违法提示语，为空时使用：DPSMDate.inputBox_textValus[@"textFive"]；
@property (nonatomic, strong) NSString *textFormatRegularMessage;

///整体内容左右间隙，默认：DP_FrameWidth(16)；
@property (nonatomic, assign) CGFloat lrGap;
///(icon或左标题lab)和输入框的间隙，默认：DP_FrameWidth(16)；
@property (nonatomic, assign) CGFloat itGap;
///icon和左标题lab的间隙，默认：DP_FrameWidth(4)；
@property (nonatomic, assign) CGFloat ilGap;

///底部分割线颜色，默认：DP_RGBA(221, 221, 221, 1)；
@property (nonatomic, strong) UIColor *lineViewColor;

///左边icon，默认：nil；
@property (nonatomic, strong) UIImage *leftImage;
///左边icon的size，默认：(20, 20)；
@property (nonatomic, assign) CGSize leftImageSize;

///左边标题Label宽度，默认：0 宽度自适应文字宽度；
@property (nonatomic, assign) CGFloat leftLabWidth;
///左边标题Label字体大小，默认：DP_Font(13)
@property (nonatomic, strong) UIFont *leftLabtextFont;
///左边标题Label字体颜色，默认：DP_RGBA(43, 56, 120, 1)
@property (nonatomic, strong) UIColor *leftLabtextColor;
///左边标题Label文字，默认：nil；
@property (nonatomic, strong) NSString *leftLabText;

///右边icon，状态normal
@property (nonatomic, strong) UIImage *rightNImage;
///右边icon，状态selected
@property (nonatomic, strong) UIImage *rightSImage;
///右边icon的size，默认：(20, 20)；
@property (nonatomic, assign) CGSize rightImageSize;

///输入框字体大小，默认：DP_Font(15)；
@property (nonatomic, strong) UIFont *textFont;
///输入框字体颜色，默认：DP_RGBA(43, 56, 120, 1)；
@property (nonatomic, strong) UIColor *textColor;

///输入框默认字体大小，默认：DP_Font(15)；
@property (nonatomic, strong) UIFont *placeholderFont;
///输入框默认字体颜色，默认：DP_RGBA(115, 127, 174, 1)；
@property (nonatomic, strong) UIColor *placeholderColor;
///输入框默认文字，默认：nil；
@property (nonatomic, strong) NSString *placeholder;

///输入框边框，默认：NO 不显示；
@property (nonatomic, assign) BOOL bordLineType;

///倒计时按钮最大秒数，为空时使用：DPSMDate.inputBox_textValus[@"textSix"]；
@property (nonatomic ,strong) NSString *remainSeconds;

///上一个TextField，（returnKeyType == UIReturnKeyNext）同一类型使用
@property (nonatomic, weak) DPTextField *fontTextField;
///下一个TextField，（returnKeyType == UIReturnKeyNext）使用
@property (nonatomic, weak) id nextTextField;


- (id)initWithFrame:(CGRect)aFrame delegate:(UIViewController *)aDelegate superView:(UIView *)aSuperView;
///开启验证码倒计时
- (void)beginCodeTimer;
@end
