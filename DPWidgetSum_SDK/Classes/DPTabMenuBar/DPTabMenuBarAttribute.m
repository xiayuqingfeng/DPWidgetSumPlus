//
//  DPTabMenuBarAttribute.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import "DPTabMenuBarAttribute.h"
#import "DPWidgetSum.h"

@implementation DPTabMenuBarAttribute
- (id)init{
    self = [super init];
    if (self != nil) {
        _menuStyle = 0;
        _topBGColor = DP_RGBA(255, 255, 255, 1);
        _bottomBGColor = [UIColor clearColor];
        _topTGap = 0;
        _topHeight = 40;
        _topLRGap = 0;
        _btnLRGap = -1;
        _tagLineRadius = 0;
        _tagLineWidth = 0;
        _tagLineWidthMax = 0;
        _tagLineHeight = 2;
        _gapLineHeight = 0.5;
        _gapLineColor = DP_RGBCOLOR(200, 199, 204);
    }
    return self;
}
@end
