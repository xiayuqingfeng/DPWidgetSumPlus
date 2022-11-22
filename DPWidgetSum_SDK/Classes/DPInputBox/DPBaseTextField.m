//
//  DPBaseTextField.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import "DPBaseTextField.h"
#import <objc/runtime.h>
#import "DPWidgetSum.h"

///自定义密文输入框替换字符
#define SecureTextChar @"••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••"

@interface DPBaseTextField (){
    
}
///明文、密文转换进程标识：YES 正在转换，禁止所有监听、代理事件。 NO 非转换状态，允许监听、代理事件。
@property (nonatomic, assign) BOOL secureTextIsChang;
///自定义安全文本，明文记录
@property (nonatomic, strong) NSString *secureTempText;
@end

@implementation DPBaseTextField
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.baseTextDidChangeBlock) {
        self.baseTextDidChangeBlock = nil;
    }
}
- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:self];
        
        self.notTextFieldPerformType = DPBaseTextFieldPerformNil;
    }
    return self;
}

#pragma mark <--------------UITextFieldNotification-------------->
- (void)textFieldTextDidChange:(NSNotification *)aNotification {
    //获取高亮部分
    UITextRange *selectedRange = [self markedTextRange];
    NSString *newText = [self textInRange:selectedRange];
    //联想输入状态，不做处理
    if (newText.length != 0) {
        return;
    }
    
    if (_secureTextIsChang == NO) {
        [self recorDsecureText];
    }
    
    if (self.baseTextDidChangeBlock) {
        self.baseTextDidChangeBlock(self);
    }
}

#pragma mark <-------------系统函数扩展------------->
//输入框操作禁用
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (_notTextFieldPerformType & DPBaseTextFieldPerformmAllTypes) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        if (menuController) {
            [UIMenuController sharedMenuController].menuVisible = NO;
        }
        return NO;
    }else {
        if (_notTextFieldPerformType & DPBaseTextFieldPerformCut) {
            if (action == @selector(cut:)) {
                return NO;
            }
        }
        if (_notTextFieldPerformType & DPBaseTextFieldPerformCopy) {
            if (action == @selector(copy:)) {
                return NO;
            }
        }
        if (_notTextFieldPerformType & DPBaseTextFieldPerformSelect) {
            if (action == @selector(select:)) {
                return NO;
            }
        }
        if (_notTextFieldPerformType & DPBaseTextFieldPerformSelectAll) {
            if (action == @selector(selectAll:)) {
                return NO;
            }
        }
        if (_notTextFieldPerformType & DPBaseTextFieldPerformPaste) {
            if (action == @selector(delete:)) {
                return NO;
            }
        }
    }
    return [super canPerformAction:action withSender:sender];
}

#pragma mark <-------------Setter_methods------------->
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    [self changePlaceholder];
}
- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = placeholderFont;
    [self changePlaceholder];
}
- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    [self changePlaceholder];
}
- (void)setText:(NSString *)text {
    [super setText:text];
    
    if (_secureTextIsChang == NO) {
        self.secureTempText = @"";
        
        [self recorDsecureText];
        
        if (self.baseTextDidChangeBlock) {
            self.baseTextDidChangeBlock(self);
        }
    }
}
- (void)setSecureTextEntryType:(NSInteger)secureTextEntryType {
    _secureTextEntryType = secureTextEntryType;
}
- (void)setSecureTextEntryDP:(BOOL)secureTextEntryDP {
    if (_secureTextEntryType == 0) {
        _secureTextEntryDP = secureTextEntryDP;
        
        self.secureTextEntry = _secureTextEntryDP;
        NSString *text = self.text;
        self.text = @" ";
        self.text = text;
    }else if (_secureTextEntryType == 1) {
        if (secureTextEntryDP == YES && _secureTextEntryDP == NO) {
            //明文转密文，记录明文
            //kvo"_"获取TextField当前text，不触发get方法
            NSString *currentText = [self getTextCustom];
            
            self.secureTempText = currentText.length > 0 ? currentText : @"";
            NSString *changeText = SecureTextChar.length > _secureTempText.length ? [SecureTextChar substringToIndex:_secureTempText.length] : SecureTextChar;
            [self setTextCustom:changeText];
        }else if (secureTextEntryDP == YES && _secureTextEntryDP == YES) {
            //密文转密文
            NSString *changeText = SecureTextChar.length > _secureTempText.length ? [SecureTextChar substringToIndex:_secureTempText.length] : SecureTextChar;
            [self setTextCustom:changeText];
        }else if (secureTextEntryDP == NO && _secureTextEntryDP == YES) {
            //密文转明文，清空明文记录
            [self setTextCustom:_secureTempText];
            self.secureTempText = @"";
        }else if (secureTextEntryDP == NO && _secureTextEntryDP == NO) {
            //明文转明文
            [self setTextCustom:_secureTempText];
        }
        
        _secureTextEntryDP = secureTextEntryDP;
    }
}

#pragma mark <-------------getter/setter------------->
- (NSString *)text {
    if (_secureTextEntryType == 1 && _secureTextEntryDP == YES) {
        return _secureTempText;
    }else {
        return [super text];
    }
}

#pragma mark <-------------公共函数------------->
//当前text赋值，禁止监听、代理事件。
- (void)setTextCustom:(NSString *)aText {
    if (aText == nil) {
        aText = @"";
    }
    id aDelegate = self.delegate;
    self.secureTextIsChang = YES;
    self.text = [NSString stringWithFormat:@"%@",aText];
    self.delegate = aDelegate;
    self.secureTextIsChang = NO;
}
//kvo"_"获取TextField当前text，不触发get方法
- (NSString *)getTextCustom {
    NSString *aText = [self valueForKey:@"_text"];
    if (aText == nil) {
        aText = @"";
    }
    aText = [NSString stringWithFormat:@"%@",aText];
    return aText;
}
//修改默认文字字体、颜色
- (void)changePlaceholder {
    Ivar ivar = class_getInstanceVariable([UITextField class], "_placeholderLabel");
    UILabel *placeholderLabel = object_getIvar(self, ivar);
    placeholderLabel.textColor = _placeholderColor;
    placeholderLabel.font = _placeholderFont;
}

#pragma mark <-------------外部调用函数------------->
//记录TextField显示的明文
- (void)recorDsecureText {
    if (_secureTextEntryType == 1 && _secureTextEntryDP == YES) {
        //kvo"_"获取TextField当前text，不触发get方法
        NSString *currentText = [self getTextCustom];
        
        NSString *tempText = @"";
        if (currentText.length < _secureTempText.length) {
            tempText = [_secureTempText substringToIndex:currentText.length];
        }else if (currentText.length > _secureTempText.length) {
            tempText = [currentText substringFromIndex:_secureTempText.length];
            if (_secureTempText.length) {
                tempText = [_secureTempText stringByAppendingString:tempText];
            }
        }else if (currentText.length == _secureTempText.length) {
            tempText = _secureTempText;
            for (int i = 0; i < currentText.length; i++) {
                NSString *rangStr = [currentText substringWithRange:NSMakeRange(i, 1)];
                if (![rangStr isEqualToString:@"•"]) {
                    tempText = [_secureTempText substringToIndex:i];
                    currentText = [currentText substringFromIndex:i];
                    tempText = [tempText stringByAppendingString:currentText];
                    break;
                }
            }
        }
        self.secureTempText = tempText;
        
        //刷新当前TextField明文、密文显示状态
        self.secureTextEntryDP = _secureTextEntryDP;
    }
}
@end

