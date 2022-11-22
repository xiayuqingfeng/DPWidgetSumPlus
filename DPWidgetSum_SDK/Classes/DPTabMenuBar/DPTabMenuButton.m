//
//  DPTabMenuButton.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import "DPTabMenuButton.h"
#import "DPWidgetSum.h"

@interface DPTabMenuButton(){
    
}
@end

@implementation DPTabMenuButton
+ (DPTabMenuButton *)tabMenuButtonWithType:(UIButtonType)buttonType {
    DPTabMenuButton *button = [DPTabMenuButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectZero;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    return button;
}
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        if (_selectFont) {
            self.titleLabel.font = _selectFont;
        }else {
            if (_normalFont) {
                self.titleLabel.font = _normalFont;
            }
        }
        if (_selectedColor) {
            [self setTitleColor:_selectedColor forState:UIControlStateSelected];
        }else {
            if (_normalColor) {
                [self setTitleColor:_normalColor forState:UIControlStateSelected];
            }
        }
    }else {
        if (_normalFont) {
            self.titleLabel.font = _normalFont;
        }
        if (_normalColor) {
            [self setTitleColor:_normalColor forState:UIControlStateNormal];
        }
    }
}
- (void)setNormalFont:(UIFont *)normalFont {
    _normalFont = normalFont;
    self.selected = self.selected;
}
- (void)setSelectFont:(UIFont *)btnSelectFont {
    _selectFont = btnSelectFont;
    self.selected = self.selected;
}
- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    self.selected = self.selected;
}
- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    self.selected = self.selected;
}
@end
