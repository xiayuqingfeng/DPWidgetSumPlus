//
//  DPBaseTextView.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import "DPBaseTextView.h"
#import "DPWidgetSumPlus.h"

@implementation DPBaseTextView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.baseTextDidChangeBlock) {
        self.baseTextDidChangeBlock = nil;
    }
}
- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:self];
        
        self.notTextViewPerform = DPBaseTextViewPerformNil;
    }
    return self;
}

#pragma mark <--------------UITextViewNotification-------------->
- (void)textViewTextDidChange:(NSNotification *)aNotification {
    //获取高亮部分
    UITextRange *selectedRange = [self markedTextRange];
    NSString *newText = [self textInRange:selectedRange];
    //联想输入状态，不做处理
    if (newText.length != 0) {
        return;
    }
    
    if (self.baseTextDidChangeBlock) {
        self.baseTextDidChangeBlock(self);
    }
}

#pragma mark <-------------系统函数扩展------------->
//输入框操作禁用
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (_notTextViewPerform & DPBaseTextViewPerformmAllTypes) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        if (menuController) {
            [UIMenuController sharedMenuController].menuVisible = NO;
        }
        return NO;
    }else {
        if (_notTextViewPerform & DPBaseTextViewPerformCut) {
            if (action == @selector(cut:)) {
                return NO;
            }
        }
        if (_notTextViewPerform & DPBaseTextViewPerformCopy) {
            if (action == @selector(copy:)) {
                return NO;
            }
        }
        if (_notTextViewPerform & DPBaseTextViewPerformSelect) {
            if (action == @selector(select:)) {
                return NO;
            }
        }
        if (_notTextViewPerform & DPBaseTextViewPerformSelectAll) {
            if (action == @selector(selectAll:)) {
                return NO;
            }
        }
        if (_notTextViewPerform & DPBaseTextViewPerformPaste) {
            if (action == @selector(delete:)) {
                return NO;
            }
        }
    }
    return [super canPerformAction:action withSender:sender];
}

#pragma mark <-------------Setter_methods------------->
- (void)setText:(NSString *)text {
    [super setText:text];
    if (self.baseTextDidChangeBlock) {
        self.baseTextDidChangeBlock(self);
    }
}
@end
