//
//  DPTextField.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 zcw. All rights reserved.
//

#import "DPTextField.h"
#import "DPWidgetSumPlus.h"
#import <objc/runtime.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface DPTextField ()<UITextFieldDelegate>{
    
}
@property (nonatomic, weak) UIViewController *aDelegate;
@property (nonatomic, weak) UIView *aSuperView;

//底部分割线
@property (nonatomic, strong) UIView *lineView;
//左边标题
@property (nonatomic, strong) UILabel *leftLabel;
//左边图片
@property (nonatomic, strong) UIImageView *aImageView;
//密码是否可见按钮
@property (nonatomic, strong) UIButton *aButton;

//当前验证码时间
@property (nonatomic, assign) NSInteger currentSeconds;
//验证码倒计时
@property (nonatomic, strong) RACDisposable *disposable;
@end

@implementation DPTextField
- (void)dealloc {
    if (self.disposable != nil) {
        [self.disposable dispose];
    }
    if (self.textFieldButtonBlock) {
        self.textFieldButtonBlock = nil;
    }
    if (self.textFieldClearBlock) {
        self.textFieldClearBlock = nil;
    }
    if (self.textFieldTextDidChangeSetTextBlock) {
        self.textFieldTextDidChangeSetTextBlock = nil;
    }
}
- (id)initWithFrame:(CGRect)aFrame delegate:(UIViewController *)aDelegate superView:(UIView *)aSuperView {
    self = [super initWithFrame:aFrame];
    if (self) {
        self.aDelegate = aDelegate;
        self.aSuperView = aSuperView;
        
        _lrGap = DP_FrameWidth(16);
        _itGap = DP_FrameWidth(16);
        _ilGap = DP_FrameWidth(4);
        
        _lineViewColor = DP_RGBA(221, 221, 221, 1);
        
        _leftImageSize = CGSizeMake(20, 20);
        
        _leftLabtextFont = DP_Font(13);
        _leftLabtextColor = DP_RGBA(43, 56, 120, 1);
        
        _rightImageSize = CGSizeMake(20, 20);
        
        _textFont = DP_Font(15);
        _textColor = DP_RGBA(43, 56, 120, 1);
        
        _placeholderFont = DP_Font(15);
        _placeholderColor = DP_RGBA(115, 127, 174, 1);
        
        _textLimitType = 0;
        _textLengthMax = DPSMDate.inputBox_textValus[@"textOne"];
        _textMaxMessage = DPSMDate.inputBox_textValus[@"textTow"];
        _textNoRegular = @"";
        _textNoRegularMessage = DPSMDate.inputBox_textValus[@"textThree"];
        _textRegular = @"";
        _textRegularMessage = DPSMDate.inputBox_textValus[@"textFour"];
        _textFormatRegular = @[];
        _textFormatRegularMessage = DPSMDate.inputBox_textValus[@"textFive"];
        _remainSeconds = DPSMDate.inputBox_textValus[@"textSix"];
        
        self.lineView = [[UIView alloc] init];
        _lineView.backgroundColor = _lineViewColor;
        [self addSubview:_lineView];
        
        self.aImageView = [[UIImageView alloc] init];
        _aImageView.hidden = YES;
        _aImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_aImageView];
        
        self.leftLabel = [[UILabel alloc] init];
        _leftLabel.adjustsFontSizeToFitWidth = YES;
        _leftLabel.numberOfLines = 1;
        _leftLabel.textAlignment = NSTextAlignmentRight;
        _leftLabel.font = _leftLabtextFont;
        _leftLabel.textColor = _leftLabtextColor;
        [self addSubview:_leftLabel];
        
        self.aTextField = [[DPBaseTextField alloc] init];
        _aTextField.delegate = self;
        _aTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _aTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _aTextField.font = _textFont;
        _aTextField.textColor = _textColor;
        _aTextField.placeholderFont = _placeholderFont;
        _aTextField.placeholderColor = _placeholderColor;
        _aTextField.keyboardType = UIKeyboardTypeDefault;
        _aTextField.returnKeyType = UIReturnKeyDone;
        dp_arc_block(self);
        _aTextField.baseTextDidChangeBlock = ^(DPBaseTextField *aObject) {
            [weak_self textFieldTextDidChangeOperation];
        };
        [self addSubview:_aTextField];

        self.aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _aButton.hidden = YES;
        _aButton.contentMode = UIViewContentModeScaleAspectFit;
        [[_aButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (weak_self.textFieldType == DPTextFieldTypePassword || weak_self.textFieldType == DPTextFieldTypePasswordChinese) {
                x.selected = !x.selected;
                weak_self.aTextField.secureTextEntryDP = !x.selected;
            }else if (weak_self.textFieldType == DPTextFieldTypeCode) {
                if (weak_self.textFieldButtonBlock) {
                    weak_self.textFieldButtonBlock(weak_self);
                }
            }
        }];
        [self addSubview:_aButton];
        
        [self loadViewLayout];
    }
    return self;
}

#pragma mark <-------------Setter_methods------------->
- (void)setTextFieldType:(DPTextFieldType)textFieldType {
    _textFieldType = textFieldType;
    if (_textFieldType == DPTextFieldTypePassword || _textFieldType == DPTextFieldTypePasswordChinese) {
        if (_textFieldType == DPTextFieldTypePassword) {
            _aTextField.secureTextEntryType = 0;
        }else {
            _aTextField.secureTextEntryType = 1;
        }
        _aTextField.secureTextEntryDP = YES;
        _aTextField.notTextFieldPerformType = DPBaseTextFieldPerformmAllTypes;
    }else if (_textFieldType == DPTextFieldTypeCode) {
        //键盘获取短信验证码快捷输入
        if (@available(iOS 12.0, *)) {
            _aTextField.textContentType = UITextContentTypeOneTimeCode;
        }
    }
    [self loadViewLayout];
}
- (void)setLrGap:(CGFloat)lrGap {
    _lrGap = lrGap;
    [self loadViewLayout];
}
- (void)setItGap:(CGFloat)itGap {
    _itGap = itGap;
    [self loadViewLayout];
}
- (void)setIlGap:(CGFloat)ilGap {
    _ilGap = ilGap;
    [self loadViewLayout];
}

- (void)setLineViewColor:(UIColor *)lineViewColor {
    _lineViewColor = lineViewColor;
    if (_lineView) {
        _lineView.backgroundColor = _lineViewColor;
    }
}

- (void)setLeftImage:(UIImage *)leftImage{
    _leftImage = leftImage;
    [self loadViewLayout];
}
- (void)setLeftImageSize:(CGSize)leftImageSize {
    _leftImageSize = leftImageSize;
    [self loadViewLayout];
}

- (void)setLeftLabWidth:(CGFloat)leftLabWidth {
    _leftLabWidth = leftLabWidth;
    if (_leftLabel) {
        [self loadViewLayout];
    }
}
- (void)setLeftLabtextFont:(UIFont *)leftLabtextFont {
    _leftLabtextFont = leftLabtextFont;
    if (_leftLabel) {
        _leftLabel.font = _leftLabtextFont;
        [self loadViewLayout];
    }
}
- (void)setLeftLabtextColor:(UIColor *)leftLabtextColor {
    _leftLabtextColor = leftLabtextColor;
    if (_leftLabel) {
        _leftLabel.textColor = _leftLabtextColor;
    }
}
- (void)setLeftLabText:(NSString *)leftLabText {
    _leftLabText = leftLabText;
    if (_leftLabel) {
        _leftLabel.text = _leftLabText;
        [self loadViewLayout];
    }
}

- (void)setRightNImage:(UIImage *)rightNImage {
    _rightNImage = rightNImage;
    [self loadViewLayout];
}
- (void)setRightSImage:(UIImage *)rightSImage {
    _rightSImage = rightSImage;
    [self loadViewLayout];
}
- (void)setRightImageSize:(CGSize)rightImageSize {
    _rightImageSize = rightImageSize;
    [self loadViewLayout];
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    if (_aTextField) {
        _aTextField.font = _textFont;
    }
}
- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    if (_aTextField) {
        _aTextField.textColor = _textColor;
    }
}
- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = placeholderFont;
    if (_aTextField) {
        _aTextField.placeholderFont = _placeholderFont;
    }
}
- (void)setPlaceholderColor:(UIColor *)placeHolderColor {
    _placeholderColor = placeHolderColor;
    if (_aTextField) {
        _aTextField.placeholderColor = _placeholderColor;
    }
}
- (void)setPlaceholder:(NSString *)placeHolder {
    _placeholder = placeHolder;
    if (_aTextField) {
        _aTextField.placeholder = _placeholder;
    }
}
- (void)setBordLineType:(BOOL)leftLabBordType {
    _bordLineType = leftLabBordType;
    if (_aTextField) {
        [self loadViewLayout];
    }
}
- (void)setRemainSeconds:(NSString *)remainSeconds {
    _remainSeconds = remainSeconds;
}
- (void)setFontTextField:(DPTextField *)fontTextField {
    _fontTextField = fontTextField;
    _fontTextField.nextTextField = self;
}

#pragma mark <-------------layout------------->
//刷新页面布局
- (void)loadViewLayout {
    //输入框 frame重定义
    _aTextField.frame = CGRectMake(_lrGap, 0, self.dp_width-_lrGap*2, self.dp_height);
    
    CGFloat textFieldMinX = _lrGap;
    
    //左边图片 frame重定义
    if (_leftImage != nil) {
        _aImageView.hidden = NO;
        _aImageView.frame = CGRectMake(_lrGap, 0, _leftImageSize.width, _leftImageSize.height);
        _aImageView.dp_centerY = self.dp_height/2;
        _aImageView.image = _leftImage;
        
        textFieldMinX = _aImageView.dp_xMax+_itGap;
    }
    
    //左边标题 frame重定义
    if (_leftLabText.length > 0) {
        if (_leftImage != nil) {
            textFieldMinX = _aImageView.dp_xMax+_ilGap;
        }
        
        if (_leftLabWidth > 0) {
            _leftLabel.frame = CGRectMake(textFieldMinX, 0, _leftLabWidth, self.dp_height);
        }else {
            _leftLabel.frame = CGRectZero;
            [_leftLabel sizeToFit];
            _leftLabel.frame = CGRectMake(textFieldMinX, 0, _leftLabel.dp_width, self.dp_height);
        }
        textFieldMinX = _leftLabel.dp_xMax+_itGap;
    }
    
    //输入框 frame重定义
    _aTextField.dp_x = textFieldMinX;
    _aTextField.dp_width = self.dp_width-_lrGap-textFieldMinX;
    
    _aButton.hidden = YES;
    if ((_textFieldType == DPTextFieldTypePassword || _textFieldType ==     DPTextFieldTypePasswordChinese) && _rightNImage != nil) {
        //“密码是否可见”按钮 frame重定义
        _aButton.hidden = NO;
        _aButton.frame = CGRectMake(self.dp_width-_lrGap-_rightImageSize.width, 0, _rightImageSize.width, _rightImageSize.height);
        _aButton.dp_centerY = self.dp_height/2;
        [_aButton setImage:_rightNImage forState:UIControlStateNormal];
        [_aButton setImage:_rightSImage forState:UIControlStateSelected];
        
        //输入框 frame重定义
        _aTextField.dp_width = _aButton.dp_x-_itGap-_aTextField.dp_x;
    }else if (_textFieldType == DPTextFieldTypeCode) {
        //“获取验证码”按钮 frame重定义
        _aButton.hidden = NO;
        _aButton.enabled = YES;
        _aButton.frame = CGRectMake(self.dp_width-_lrGap-DP_FrameWidth(90), 0, DP_FrameWidth(90), DP_FrameHeight(30));
        _aButton.dp_centerY = self.dp_height/2;
        _aButton.layer.masksToBounds = YES;
        _aButton.layer.cornerRadius = _aButton.dp_height/2;
        _aButton.layer.borderColor = DP_RGBA(51, 105, 227, 1).CGColor;
        _aButton.layer.borderWidth = 0.5;
        _aButton.titleLabel.font = DP_Font(14);
        [_aButton setTitleColor:DP_RGBA(51, 105, 227, 1) forState:UIControlStateNormal];
        [_aButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        //输入框 frame重定义
        _aTextField.dp_width = _aButton.dp_x-_itGap-_aTextField.dp_x;
    }
    
    //输入框边框
    if (_bordLineType == YES) {
        _aTextField.layer.masksToBounds = YES;
        _aTextField.layer.cornerRadius = 3;
        _aTextField.layer.borderWidth = 0.5;
        _aTextField.layer.borderColor = DP_RGBA(230, 233, 240, 1).CGColor;
        _aTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, _aTextField.dp_height)];
        _aTextField.leftViewMode = UITextFieldViewModeAlways;
    }else {
        _aTextField.layer.borderWidth = 0;
        _aTextField.leftView = nil;
    }
    
    //“底部分割线” frame重定义
    _lineView.frame = CGRectMake(_lrGap, self.dp_height-0.5, self.dp_width-_lrGap*2, 0.5);
}

#pragma mark <-------------文字加载完成(联想结束) 或 text赋值完成(set赋值)------------->
- (void)textFieldTextDidChangeOperation {
    NSString *tempText = _aTextField.text == nil ? nil : [NSString stringWithFormat:@"%@",_aTextField.text];
    
    //输入框文字监听，外部加载代码块，return 修正textField.text。（修改节点：文字加载完成(联想结束) 或 text赋值完成(set赋值)）
    if (self.textFieldTextDidChangeSetTextBlock) {
        NSString *newStr = self.textFieldTextDidChangeSetTextBlock(self);
        if (newStr.length != _aTextField.text.length) {
            _aTextField.text = newStr;
            return;
        }else if (newStr.length == _aTextField.text.length &&
                  newStr.length > 0 &&
                  [newStr isKindOfClass:[NSString class]] &&
                  _aTextField.text.length > 0 &&
                  ![newStr isEqualToString:_aTextField.text]) {
            _aTextField.text = newStr;
            return;
        }
    }

    if (tempText.length > 0 && _textNoRegular.length > 0) {
        //正则指定不匹配字符
        NSString *regularStr = [NSString stringWithFormat:@"[%@]",_textNoRegular];
        if ([DPTextInputTool regularCheckText:tempText regularStr:regularStr]) {
            //正则删除不匹配字符
            NSString *newStr = [DPTextInputTool regularReplacText:tempText replacStr:@"" regularStr:regularStr];
            
            //正则指定不匹配字符格式，违法提示语
            if (_textNoRegularMessage.length) {
                [DPTool showToastMsg:_textNoRegularMessage style:DPShowToastMsgStyleTop forView:_aSuperView];
            }
            
            _aTextField.text = newStr;
            return;
        }
    }
    
    if (tempText.length > 0 && _textRegular.length > 0) {
        //正则指定匹配字符
        NSString *regularStr = [NSString stringWithFormat:@"[^%@]",_textRegular];
        if ([DPTextInputTool regularCheckText:tempText regularStr:regularStr]) {
            //正则删除不匹配字符
            NSString *newStr = [DPTextInputTool regularReplacText:tempText replacStr:@"" regularStr:regularStr];
            
            //正则指定匹配字符格式，违法提示语
            if (_textRegularMessage.length) {
                [DPTool showToastMsg:_textRegularMessage style:DPShowToastMsgStyleTop forView:_aSuperView];
            }
            
            _aTextField.text = newStr;
            return;
        }
    }
    
    if (tempText.length > 0 && _textFormatRegular.count > 0) {
        //正则指定匹配字符串格式
        BOOL (^aAlterBlock)(NSArray <NSString *>*, NSString *) = ^(NSArray <NSString *>*regularAry, NSString *aText){
            BOOL bol = YES;
            for (NSString *aRegularStr in regularAry) {
                if (![DPTextInputTool regularCheckText:aText regularStr:aRegularStr]) {
                    bol = NO;
                    break;
                }
            }
            return bol;
        };

        //从右到左遍历删除字符，直至匹配所有格式
        if (aAlterBlock(_textFormatRegular, tempText) == NO) {
            NSString *newStr = @"";
            for (NSUInteger i = tempText.length; i > 0; i--) {
                NSString *rangeStr = [tempText substringWithRange:NSMakeRange(0, i)];
                if (aAlterBlock(_textFormatRegular, rangeStr) == NO) {
                    newStr = [tempText substringWithRange:NSMakeRange(0, i-1)];
                }else {
                    break;
                }
            }
            
            //正则指定匹配字符串格式，违法提示语
            if (_textFormatRegularMessage.length) {
                [DPTool showToastMsg:_textFormatRegularMessage style:DPShowToastMsgStyleTop forView:_aSuperView];
            }
            
            _aTextField.text = newStr;
            return;
        }
    }
    
    //输入长度限制处理
    if (tempText.length > 0) {
        if (_textLimitType == 0) {
            //根据字符串长度限制
            if (_textLengthMax.length > 0 && tempText.length > _textLengthMax.integerValue) {
                NSString *maxToastStr = @"";
                if (_textMaxMessage.length > 0) {
                    if ([_textMaxMessage containsString:@"$"]) {
                        NSArray *msgArray = [_textMaxMessage componentsSeparatedByString:@"$"];
                        maxToastStr = [msgArray dp_objectAtIndex:0];
                    }else {
                        maxToastStr = _textMaxMessage;
                    }
                    if ([maxToastStr containsString:@"?"]) {
                        maxToastStr = [maxToastStr stringByReplacingOccurrencesOfString:@"?" withString:_textLengthMax];
                    }else {
                        maxToastStr = _textMaxMessage;
                    }
                }
                if (maxToastStr.length < 1) {
                    maxToastStr = [NSString stringWithFormat:@"最多输入%@个字",_textLengthMax];
                }
                [DPTool showToastMsg:maxToastStr style:DPShowToastMsgStyleTop forView:_aSuperView];
                
                tempText = [tempText substringWithRange:NSMakeRange(0, _textLengthMax.integerValue)];
                //删除不可编码字符，编码格式：kCFStringEncodingGB_18030_2000；（表情符号截取会产生不可编码字符）
                tempText = [DPTextInputTool deleteUnableEncodeWithStr:tempText];
                
                _aTextField.text = tempText;
                return;
            }
        }else if (_textLimitType == 1) {
            //根据字符串"字符"长度限制
            if (_textLengthMax.length > 0 && [DPTextInputTool byteCountWithStr:tempText] > _textLengthMax.integerValue) {
                for (NSUInteger i = tempText.length; i > 0; i--) {
                    NSString *rangeStr = [tempText substringWithRange:NSMakeRange(0, i)];
                    if ([DPTextInputTool byteCountWithStr:rangeStr] <= _textLengthMax.integerValue) {
                        tempText = rangeStr;
                        break;
                    }
                }
                //删除不可编码字符，编码格式：kCFStringEncodingGB_18030_2000；（表情符号截取会产生不可编码字符）
                tempText = [DPTextInputTool deleteUnableEncodeWithStr:tempText];
                
                NSString *maxToastStr = @"";
                if (_textMaxMessage.length > 0) {
                    if ([_textMaxMessage containsString:@"$"]) {
                        NSArray *msgArray = [_textMaxMessage componentsSeparatedByString:@"$"];
                        maxToastStr = [msgArray dp_objectAtIndex:1];
                    }else {
                        maxToastStr = _textMaxMessage;
                    }
                    if ([maxToastStr containsString:@"?"]) {
                        maxToastStr = [maxToastStr stringByReplacingOccurrencesOfString:@"?" withString:_textLengthMax];
                    }else {
                        maxToastStr = _textMaxMessage;
                    }
                }
                if (maxToastStr.length < 1) {
                    maxToastStr = [NSString stringWithFormat:@"最多输入%@个字符",_textLengthMax];
                }
                [DPTool showToastMsg:maxToastStr style:DPShowToastMsgStyleTop forView:_aSuperView];
                
                _aTextField.text = tempText;
                return;
            }
        }
    }
}

#pragma mark <--------------UITextFieldDelegate-------------->
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason  API_AVAILABLE(ios(10.0)){
    if ([textField.text isEqualToString:@"•"]) {
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@"•" withString:@"."];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (self.textFieldClearBlock) {
        self.textFieldClearBlock(self);
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyNext && _nextTextField != nil) {
        if ([_nextTextField isKindOfClass:[UITextField class]]) {
            [((UITextField *)_nextTextField) becomeFirstResponder];
        }else if ([_nextTextField isKindOfClass:[UITextView class]]) {
            [((UITextView *)_nextTextField) becomeFirstResponder];
        }else if ([_nextTextField isKindOfClass:[DPTextField class]]) {
            [((DPTextField *)_nextTextField).aTextField becomeFirstResponder];
        }
        return NO;
    }else if (textField.returnKeyType == UIReturnKeyDone) {
        [_aTextField resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark <--------------外部调用函数-------------->
- (void)beginCodeTimer {
    self.currentSeconds = _remainSeconds.integerValue;
    
    _aButton.enabled = NO;
    _aButton.layer.borderColor = UIColor.grayColor.CGColor;
    [_aButton setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
    [_aButton setTitle:[NSString stringWithFormat:@"%ld秒可重发",(long)_currentSeconds] forState:UIControlStateNormal];
    
    dp_arc_block(self);
    self.disposable = [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        weak_self.currentSeconds = weak_self.currentSeconds-1;
        
        [weak_self.aButton setTitle:[NSString stringWithFormat:@"%ld秒可重发",(long)weak_self.currentSeconds] forState:UIControlStateNormal];
        
        //关闭计时器
        if (weak_self.currentSeconds <= 1) {
            [weak_self.disposable dispose];
            weak_self.aButton.enabled = YES;
            weak_self.aButton.layer.borderColor = DP_RGBA(51, 105, 227, 1).CGColor;
            [weak_self.aButton setTitleColor:DP_RGBA(51, 105, 227, 1) forState:UIControlStateNormal];
            [weak_self.aButton setTitle:@"重新获取" forState:UIControlStateNormal];
        }
    }];
}
@end
