//
//  DPTextView.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 zcw. All rights reserved.
//

#import "DPTextView.h"
#import "DPWidgetSumPlus.h"

@interface DPTextView ()<UITextViewDelegate>{
    
}
@property (nonatomic, weak) UIViewController *aDelegate;
@property (nonatomic, weak) UIView *aSuperView;

//左边标题
@property (nonatomic, strong) UILabel *leftLabel;
//左边图片
@property (nonatomic, strong) UIImageView *aImageView;
///输入框TextView父视图
@property (nonatomic, strong) UIView *aTextSuperView;
//默认提示语
@property (nonatomic, strong) UILabel *phLab;
//记数器
@property (nonatomic, strong) UILabel *countLab;
@end

@implementation DPTextView
- (void)dealloc {
    if (self.textViewTextDidChangeSetTextBlock) {
        self.textViewTextDidChangeSetTextBlock = nil;
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
   
        _leftImageSize = CGSizeMake(20, 20);
        
        _leftLabNumLine = 1;
        _leftLabtextFont = DP_Font(13);
        _leftLabtextColor = DP_RGBA(43, 56, 120, 1);
        
        _rightImageSize = CGSizeMake(20, 20);
        
        _textFont = DP_Font(15);
        _textColor = DP_RGBA(43, 56, 120, 1);
        
        _placeholderFont = DP_Font(15);
        _placeholderColor = DP_RGBA(115, 127, 174, 1);
        
        _countTextFont = DP_Font(10);
        _countTextColor = DP_RGBA(115, 127, 174, 1);
        
        _textLimitType = 0;
        _textLengthMax = DPSMDate.inputBox_textValus[@"textOne"];
        _textMaxMessage = DPSMDate.inputBox_textValus[@"textTow"];
        _textNoRegular = @"";
        _textNoRegularMessage = DPSMDate.inputBox_textValus[@"textThree"];
        _textRegular = @"";
        _textRegularMessage = DPSMDate.inputBox_textValus[@"textFour"];
        _textFormatRegular = @[];
        _textFormatRegularMessage = DPSMDate.inputBox_textValus[@"textFive"];

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
        
        
        self.aTextSuperView = [[UIView alloc] init];
        [self addSubview:_aTextSuperView];
        
        self.aTextView = [[DPBaseTextView alloc] init];
        _aTextView.delegate = self;
        _aTextView.font = _textFont;
        _aTextView.textColor = _textColor;
        _aTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        dp_arc_block(self);
        _aTextView.baseTextDidChangeBlock = ^(DPBaseTextView *aObject) {
            [weak_self textViewTextDidChangeOperation];
        };
        [_aTextSuperView addSubview:_aTextView];
        
        self.phLab = [[UILabel alloc] init];
        _phLab.numberOfLines = 0;
        _phLab.textAlignment = NSTextAlignmentLeft;
        _phLab.font = _placeholderFont;
        _phLab.textColor = _placeholderColor;
        [_aTextSuperView addSubview:_phLab];
        
        self.countLab = [[UILabel alloc] init];
        _countLab.numberOfLines = 1;
        _countLab.textAlignment = NSTextAlignmentRight;
        _countLab.font = _countTextFont;
        _countLab.textColor = _countTextColor;
        [_aTextSuperView addSubview:_countLab];

        [self loadViewLayout];
    }
    return self;
}

#pragma mark <-------------Setter_methods------------->
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

- (void)setLeftImage:(UIImage *)leftImage{
    _leftImage = leftImage;
    [self loadViewLayout];
}
- (void)setLeftImageSize:(CGSize)leftImageSize {
    _leftImageSize = leftImageSize;
    [self loadViewLayout];
}

- (void)setLeftLabNumLine:(NSUInteger)leftLabLine {
    _leftLabNumLine = leftLabLine;
    if (_leftLabel) {
        _leftLabel.numberOfLines = _leftLabNumLine;
        [self loadViewLayout];
    }
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
    if (_aTextView) {
        _aTextView.font = _textFont;
    }
}
- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    if (_aTextView) {
        _aTextView.textColor = _textColor;
    }
}
- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = placeholderFont;
    if (_phLab) {
        _phLab.font = _placeholderFont;
        [self loadViewLayout];
    }
}
- (void)setPlaceholderColor:(UIColor *)placeHolderColor {
    _placeholderColor = placeHolderColor;
    if (_phLab) {
        _phLab.textColor = _placeholderColor;
    }
}
- (void)setPlaceholder:(NSString *)placeHolder {
    _placeholder = placeHolder;
    if (_phLab) {
        _phLab.text = _placeholder;
        [self loadViewLayout];
    }
}
- (void)setBordLineType:(BOOL)leftLabBordType {
    _bordLineType = leftLabBordType;
    if (_aTextView) {
        [self loadViewLayout];
    }
}
- (void)setFontTextView:(DPTextView *)fontTextView {
    _fontTextView = fontTextView;
    _fontTextView.nextTextView = self;
}

#pragma mark <-------------layout------------->
//刷新页面布局
- (void)loadViewLayout {
    //“输入框”TextView父视图frame重定义
    _aTextSuperView.frame = CGRectMake(_lrGap, 0, self.dp_width-_lrGap*2, self.dp_height);
    
    CGFloat textViewMinX = _lrGap;
    
    //“左边图片”frame重定义
    if (_leftImage != nil) {
        _aImageView.hidden = NO;
        _aImageView.frame = CGRectMake(_lrGap, 0, _leftImageSize.width, _leftImageSize.height);
        _aImageView.dp_centerY = self.dp_height/2;
        _aImageView.image = _leftImage;
        
        textViewMinX = _aImageView.dp_xMax+_itGap;
    }
    
    //“左边标题”frame重定义
    if (_leftLabText.length > 0) {
        if (_leftImage != nil) {
            textViewMinX = _aImageView.dp_xMax+_ilGap;
        }
        
        if (_leftLabNumLine == 1) {
            if (_leftLabWidth > 0) {
                _leftLabel.frame = CGRectMake(textViewMinX, 0, _leftLabWidth, self.dp_height);
            }else {
                _leftLabel.frame = CGRectZero;
                [_leftLabel sizeToFit];
                _leftLabel.frame = CGRectMake(textViewMinX, 0, _leftLabel.dp_width, self.dp_height);
            }
        }else {
            CGFloat labMinY = DP_FrameHeight(6);
            if (_leftLabWidth > 0) {
                _leftLabel.frame = CGRectMake(textViewMinX, labMinY, _leftLabWidth, 0);
                [_leftLabel sizeToFit];
                _leftLabel.frame = CGRectMake(textViewMinX, labMinY, _leftLabWidth, _leftLabel.dp_height);
            }else {
                _leftLabel.frame = CGRectZero;
                [_leftLabel sizeToFit];
                _leftLabel.frame = CGRectMake(textViewMinX, labMinY, _leftLabel.dp_width, _leftLabel.dp_height);
            }
        }
        textViewMinX = _leftLabel.dp_xMax+_itGap;
    }
    
    //“输入框”frame重定义
    _aTextSuperView.dp_x = textViewMinX;
    _aTextSuperView.dp_width = self.dp_width-_lrGap-textViewMinX;
    
    //“输入框”边框
    if (_bordLineType == YES) {
        _aTextSuperView.layer.masksToBounds = YES;
        _aTextSuperView.layer.cornerRadius = 3;
        _aTextSuperView.layer.borderWidth = 0.5;
        _aTextSuperView.layer.borderColor = DP_RGBA(230, 233, 240, 1).CGColor;
    }else {
        _aTextSuperView.layer.borderWidth = 0;
    }
    
    //“默认提示语”frame重定义
    _phLab.frame = CGRectMake(4, _aTextView.font.lineHeight/3.00, _aTextSuperView.dp_width-4, 0);
    [_phLab sizeToFit];
    _phLab.frame = CGRectMake(4, _aTextView.font.lineHeight/3.00, _aTextSuperView.dp_width-4, _phLab.dp_height);

    if (_countHidden == NO) {
        //“计数器”frame重定义
        _countLab.hidden = NO;
        _countLab.frame = CGRectMake(DP_FrameWidth(4), _aTextSuperView.dp_height-DP_FrameHeight(4)-_countTextFont.lineHeight, _aTextSuperView.dp_width-DP_FrameWidth(4)*2, _countTextFont.lineHeight);
        //“计数器”文字更新
        [self updateCountLabText];

        //“输入框”frame重定义
        _aTextView.frame = CGRectMake(0, 0, _aTextSuperView.dp_width, _countLab.dp_y);
    }else {
        //“计数器”frame重定义
        _countLab.hidden = YES;
        _countLab.frame = CGRectZero;
  
        //“输入框”frame重定义
        _aTextView.frame = _aTextSuperView.bounds;
    }
}

#pragma mark <-------------文字加载完成(联想结束) 或 text赋值完成(set赋值)------------->
- (void)textViewTextDidChangeOperation {
    NSString *tempText = _aTextView.text == nil ? nil : [NSString stringWithFormat:@"%@",_aTextView.text];

    //输入框文字监听，外部加载代码块，return 修正textField.text。（修改节点：文字加载完成(联想结束) 或 text赋值完成(set赋值)）
    if (self.textViewTextDidChangeSetTextBlock) {
        NSString *newStr = self.textViewTextDidChangeSetTextBlock(self);
        if (newStr.length != _aTextView.text.length) {
            _aTextView.text = newStr;
            return;
        }else if (newStr.length == _aTextView.text.length &&
                  newStr.length > 0 &&
                  [newStr isKindOfClass:[NSString class]]) {
            _aTextView.text = newStr;
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
            
            _aTextView.text = newStr;
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
            
            _aTextView.text = newStr;
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
            
            _aTextView.text = newStr;
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
                
                _aTextView.text = tempText;
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
                
                _aTextView.text = tempText;
                return;
            }
        }
    }
    
    //“默认提示语”显示状态
    [self updatePhLabStatus];
    
    //“计数器”文字更新
    [self updateCountLabText];
}

#pragma mark <--------------UITextViewDelegate-------------->
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    //特殊字符转义
    if ([textView.text isEqualToString:@"•"]) {
        textView.text = [textView.text stringByReplacingOccurrencesOfString:@"•" withString:@"."];
    }
}
- (void)textViewDidChangeSelection:(UITextView *)textView {
    //“默认提示语”显示状态
    [self updatePhLabStatus];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        if (textView.returnKeyType == UIReturnKeyNext && _nextTextView != nil) {
            if ([_nextTextView isKindOfClass:[UITextView class]]) {
                [((UITextView *)_nextTextView) becomeFirstResponder];
            }else if ([_nextTextView isKindOfClass:[UITextView class]]) {
                [((UITextView *)_nextTextView) becomeFirstResponder];
            }else if ([_nextTextView isKindOfClass:[DPTextView class]]) {
                [((DPTextView *)_nextTextView).aTextView becomeFirstResponder];
            }
            return NO;
        }else if (textView.returnKeyType == UIReturnKeyDone) {
            [_aTextView resignFirstResponder];
            return NO;
        }
    }
    return YES;
}

#pragma mark <--------------本类公共函数-------------->
//“默认提示语”显示状态
- (void)updatePhLabStatus {
    _phLab.hidden = _aTextView.text.length > 0;
}
//“计数器”文字更新
- (void)updateCountLabText {
    NSInteger currentCount = 0;
    if (_textLimitType == 0) {
        currentCount = _aTextView.text.length;
    }else if (_textLimitType == 1) {
        currentCount = [DPTextInputTool byteCountWithStr:_aTextView.text];
    }
    _countLab.text = [NSString stringWithFormat:@"%ld/%@",(long)currentCount,_textLengthMax];
}
@end
