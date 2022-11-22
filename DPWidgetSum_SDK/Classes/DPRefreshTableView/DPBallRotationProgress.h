//
//  DPBallRotationProgress.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 zcw. All rights reserved.
//

#import <UIKit/UIKit.h>

///小球的半径
#define DEFAULT_RADIUS 6
///动画时间(小球移动的轨迹半径距离)
#define DEFAULT_DURATION 1.5
///小球移动的轨迹半径距离
#define DEFAULT_DISTANCE 15
///one小球背景颜色
#define DEFAULT_ONE_BALL_COLOR [UIColor blueColor]
///tow小球背景颜色
#define DEFAULT_TOW_BALL_COLOR [UIColor redColor]

@interface DPBallRotationProgress : UIView

///设置小球的半径
@property (nonatomic, assign) CGFloat radius;
///动画时间(小球移动的轨迹半径距离)
@property (nonatomic, assign) CGFloat duration;
///设置小球移动的轨迹半径距离
@property (nonatomic, assign) CGFloat distance;
///one小球背景颜色
@property (nonatomic, strong) UIColor *oneBallColor;
///tow小球背景颜色
@property (nonatomic, strong) UIColor *towBallColor;

/**
 *  开始动画
 */
- (void)startAnimator;

/**
 *  停止动画
 */
- (void)stopAnimator;
@end
