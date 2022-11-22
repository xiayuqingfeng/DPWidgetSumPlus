//
//  DPShareBtn.m
//  DPWidgetSumDemo
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import "DPShareBtn.h"

@interface DPShareBtn () {
    
}
@end

@implementation DPShareBtn
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, 0, contentRect.size.width, contentRect.size.width);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(-10, contentRect.size.width+10, contentRect.size.width+20, contentRect.size.height-(contentRect.size.width+10));
}
@end

