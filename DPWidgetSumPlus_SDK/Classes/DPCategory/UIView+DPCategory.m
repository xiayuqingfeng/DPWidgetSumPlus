//
//  UIView+DPCategory.m
//  ZCWBaseApp
//
//  Created by apple on 14-6-27.
//  Copyright (c) 2021年 xiayupeng. All rights reserved.
//

#import "UIView+DPCategory.h"
#import "DPWidgetSumPlus.h"

@implementation UIView (DPCategory)
///找到第一相应者
- (UIView *)dp_findFirstResponder{
    if (self.isFirstResponder) {
        return self;
    }
    NSArray * viewArray = [self subviews];
    for (UIView *subView in viewArray) {
        UIView *firstResponder = [subView dp_findFirstResponder];
        if (nil != firstResponder) {
            return firstResponder;
        }
    }
    return nil;
}

///释放第一响应者||若是 UITextField UITextView  就取消第一响应者
- (void)dp_resignTheFirstResponder{
    UIView * firstView = [self dp_findFirstResponder];
    if(nil != firstView){
        if([firstView isKindOfClass:[UITextField class]] || [firstView isKindOfClass:[UITextView class]])
        {
            [firstView resignFirstResponder];
        }
    }
}

///移除所有的GestureRecognizer
-(void)dp_removeAllGestureRecognizer{
    while([[self gestureRecognizers] count]>0) {
        [self removeGestureRecognizer:[[self gestureRecognizers] firstObject]];
    }
}
@end

@implementation UIView (DPLayoutViewExtend)
- (CGFloat)dp_x {
    return self.frame.origin.x;
}

- (void)setDp_x:(CGFloat)x {
    CGRect rect=CGRectMake(x, self.dp_y, self.dp_width, self.dp_height);
    [self setFrame:rect];
    
}

- (CGFloat)dp_y {
    return self.frame.origin.y;
    
}

- (void)setDp_y:(CGFloat)y {
    CGRect rect=CGRectMake(self.dp_x, y, self.dp_width, self.dp_height);
    [self setFrame:rect];
    
}

- (CGFloat)dp_xMax {
    return CGRectGetMaxX(self.frame);
}

- (void)setDp_xMax:(CGFloat)xMax {
    CGRect frame = self.frame;
    frame.origin.x = xMax - frame.size.width;
    self.frame = frame;
}

- (CGFloat)dp_yMax {
    return CGRectGetMaxY(self.frame);
}

- (void)setDp_yMax:(CGFloat)yMax {
    CGRect frame = self.frame;
    frame.origin.y = yMax - frame.size.height;
    self.frame = frame;
}

- (CGSize)dp_size {
    return self.frame.size;
}

- (void)setDp_size:(CGSize)size {
    CGRect rect=CGRectMake(self.dp_x, self.dp_y, size.width, size.height);
    [self setFrame:rect];
}

- (CGPoint)dp_origin {
    return self.frame.origin;
}

- (void)setDp_origin:(CGPoint)origin {
    CGRect rect=CGRectMake(origin.x, origin.y, self.dp_width, self.dp_height);
    [self setFrame:rect];
}

- (CGFloat)dp_left {
    return self.frame.origin.x;
}

- (void)setDp_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)dp_top {
    return self.frame.origin.y;
}

- (void)setDp_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)dp_right {
    return self.frame.origin.x + self.dp_width;
}

- (void)setDp_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)dp_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setDp_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)dp_centerX {
    return self.center.x;
}

- (void)setDp_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)dp_centerY {
    return self.center.y;
}

- (void)setDp_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)dp_width {
    return self.frame.size.width;
}

- (void)setDp_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)dp_height {
    return self.frame.size.height;
}

- (void)setDp_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
@end
