//
//  DPTabMenuBarContent.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import "DPTabMenuBarContent.h"
#import "DPWidgetSumPlus.h"

@implementation DPTabMenuBarContent
- (void)dealloc {
    if (self.aBlock) {
        self.aBlock = nil;
    }
}
- (id)init{
    self = [super init];
    if (self != nil) {
        _btnWidth = -1;
        _btnWidthMax = 6;
        _btnNormalColor = DP_RGBCOLOR(255, 0, 0);
        _btnSelectedColor = DP_RGBCOLOR(255, 0, 0);
        _btnNormalBackgroundImage = nil;
        _btnSelectedBackgroundImage = nil;
        _btnFont = DP_Font(16);
        _btnSelectFont = DP_Font(16);
        
        _tagLineColor = DP_RGBCOLOR(255, 0, 0);
    }
    return self;
}
- (void)setBtnTitle:(NSString *)btnTitle {
    _btnTitle = btnTitle;
    
    if (_btnSelectTitle.length < 1) {
        _btnSelectTitle = _btnTitle;
    }
    
    if (self.aBlock) {
        self.aBlock(self);
    }
}
- (void)setBtnSelectTitle:(NSString *)btnSelectTitle {
    _btnSelectTitle = btnSelectTitle;
    
    if (self.aBlock) {
        self.aBlock(self);
    }
}
- (void)setBtnFont:(UIFont *)btnFont {
    _btnFont = btnFont;
    
    if (_btnFont == nil) {
        _btnSelectFont = _btnFont;
    }
    
    if (self.aBlock) {
        self.aBlock(self);
    }
}
- (void)setBtnSelectFont:(UIFont *)btnSelectFont {
    _btnSelectFont = btnSelectFont;
    
    if (self.aBlock) {
        self.aBlock(self);
    }
}
- (void)setBtnNormalColor:(UIColor *)btnNormalColor {
    _btnNormalColor = btnNormalColor;
    
    if (_btnSelectedColor == nil) {
        _btnSelectedColor = _btnNormalColor;
    }
    
    if (self.aBlock) {
        self.aBlock(self);
    }
}
@end
