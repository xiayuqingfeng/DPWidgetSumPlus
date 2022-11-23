//
//  UIView+DPCategory.h
//  ZCWBaseApp
//
//  Created by apple on 14-6-27.
//  Copyright (c) 2021年 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (DPCategory)
///找到第一相应者
- (UIView *)dp_findFirstResponder;

///释放第一响应者||若是 UITextField UITextView  就取消第一响应者
- (void)dp_resignTheFirstResponder;

///移除所有的GestureRecognizer
- (void)dp_removeAllGestureRecognizer;
@end

@interface UIView (DPLayoutViewExtend)
/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = dp_x
 */
@property (nonatomic) CGFloat dp_x;

/**
 * Shortcut for frame.origin.y.
 *
 * Sets frame.origin.x = dp_y
 */
@property (nonatomic) CGFloat dp_y;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = dp_xMax - frame.size.width
 */
@property (nonatomic) CGFloat dp_xMax;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = dp_yMax - frame.size.height
 */
@property (nonatomic) CGFloat dp_yMax;

/**
 * Shortcut for frame.size
 *
 * Sets frame.dp_size = dp_size
 */
@property (nonatomic) CGSize dp_size;

/**
 * Shortcut for frame.origin
 *
 * Sets frame.origin = dp_origin
 */
@property (nonatomic) CGPoint dp_origin;

/**
 * Shortcut for frame.origin.x
 *
 * Sets frame.origin.x = dp_left
 */
@property (nonatomic) CGFloat dp_left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = dp_top
 */
@property (nonatomic) CGFloat dp_top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = dp_right - frame.size.width
 */
@property (nonatomic) CGFloat dp_right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = dp_bottom - frame.size.height
 */
@property (nonatomic) CGFloat dp_bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = dp_width
 */
@property (nonatomic) CGFloat dp_width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = dp_height
 */
@property (nonatomic) CGFloat dp_height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = dp_centerX
 */
@property (nonatomic) CGFloat dp_centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = dp_centerY
 */
@property (nonatomic) CGFloat dp_centerY;
@end
