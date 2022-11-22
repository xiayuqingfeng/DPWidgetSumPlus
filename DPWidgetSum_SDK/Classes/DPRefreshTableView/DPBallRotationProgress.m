//
//  DPBallRotationProgress.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 zcw. All rights reserved.
//

#import "DPBallRotationProgress.h"
#import "DPWidgetSum.h"

@interface DPBallRotationProgress () {
    
}
@property (nonatomic,strong) CAShapeLayer *oneLayer;
@property (nonatomic,strong) CAShapeLayer *twoLayer;

@property (nonatomic,strong) CAAnimationGroup *oneAnimationGroup;
@property (nonatomic,strong) CAAnimationGroup *twoAnimationGroup;
@end

@implementation DPBallRotationProgress
- (void)dealloc {
    [self stopAnimator];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _duration = DEFAULT_DURATION;
        _radius = DEFAULT_RADIUS;
        _distance = DEFAULT_DISTANCE;
        _oneBallColor = DEFAULT_ONE_BALL_COLOR;
        _towBallColor = DEFAULT_TOW_BALL_COLOR;
        
        //添加两个CAShapeLayer
        [self.layer addSublayer:self.oneLayer];
        [self.layer addSublayer:self.twoLayer];
    }
    return self;
}

//球1
- (CAShapeLayer *)oneLayer {
    if (!_oneLayer) {
        _oneLayer = [CAShapeLayer layer];
        _oneLayer.frame = CGRectMake(0, 0, self.dp_width, self.dp_height);
        _oneLayer.fillColor = _oneBallColor.CGColor;
        _oneLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.dp_width/2.0, self.dp_height/2.0) radius:_radius startAngle:0 endAngle:M_PI*2 clockwise:YES].CGPath;
    }
    return _oneLayer;
}

//球2
- (CAShapeLayer *)twoLayer {
    if (!_twoLayer) {
        _twoLayer = [CAShapeLayer layer];
        _twoLayer.frame = CGRectMake(0, 0, self.dp_width, self.dp_height);
        _twoLayer.anchorPoint = CGPointMake(0.5, 0.5);
        _twoLayer.fillColor = _towBallColor.CGColor;
        _twoLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.dp_width/2.0, self.dp_height/2.0) radius:_radius startAngle:0 endAngle:M_PI*2 clockwise:YES].CGPath;
    }
    return _twoLayer;
}

//球1动画组合
- (CAAnimationGroup *)oneAnimationGroup {
    if (!_oneAnimationGroup) {
        CAKeyframeAnimation *transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.z"];
        transformAnimation.values = @[@1, @0, @0, @0, @1];
        
        //第一个小球位移动画
        CAKeyframeAnimation *oneFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, self.dp_width/2.0, self.dp_height/2.0);
        CGPathAddLineToPoint(path, NULL, self.dp_width/2.0+_distance, self.dp_height/2.0);
        CGPathAddLineToPoint(path, NULL, self.dp_width/2.0, self.dp_height/2.0);
        CGPathAddLineToPoint(path, NULL, self.dp_width/2.0-_distance, self.dp_height/2.0);
        CGPathAddLineToPoint(path, NULL, self.dp_width/2.0, self.dp_height/2.0);
        [oneFrameAnimation setPath:path];
        
        //第一个小球缩放动画
        CAKeyframeAnimation *oneScaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        oneScaleAnimation.values = @[@1, @0.5, @0.25, @0.5, @1];
        
        //第一个小球透明动画
        CAKeyframeAnimation *oneOpacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        oneOpacityAnimation.values = @[@1, @0.5, @0.25, @0.5, @1];

        //组合动画
        _oneAnimationGroup = [CAAnimationGroup animation];
        [_oneAnimationGroup setAnimations:@[transformAnimation, oneFrameAnimation, oneScaleAnimation, oneOpacityAnimation]];
        _oneAnimationGroup.duration = _duration;
        _oneAnimationGroup.repeatCount = HUGE;
    }
    return _oneAnimationGroup;
}

//球2动画组合
- (CAAnimationGroup *)twoAnimationGroup {
    if (!_twoAnimationGroup) {
        CAKeyframeAnimation *transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.z"];
        transformAnimation.values = @[@0, @0, @1, @0, @0];
        
        //第二个小球位移动画
        CAKeyframeAnimation *twoFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, self.dp_width/2.0, self.dp_height/2.0);
        CGPathAddLineToPoint(path, NULL, self.dp_width/2.0-_distance, self.dp_height/2.0);
        CGPathAddLineToPoint(path, NULL, self.dp_width/2.0, self.dp_height/2.0);
        CGPathAddLineToPoint(path, NULL, self.dp_width/2.0+_distance, self.dp_height/2.0);
        CGPathAddLineToPoint(path, NULL, self.dp_width/2.0, self.dp_height/2.0);
        [twoFrameAnimation setPath:path];
        
        //第二个小球缩放动画
        CAKeyframeAnimation *twoScaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        twoScaleAnimation.values = @[@0.25, @0.5, @1, @0.5, @0.25];
        
        //第二个小球透明动画
        CAKeyframeAnimation *twoOpacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        twoOpacityAnimation.values = @[@0.25, @0.5, @1, @0.5, @0.25];
        
        //组合动画
        _twoAnimationGroup = [CAAnimationGroup animation];
        [_twoAnimationGroup setAnimations:@[transformAnimation, twoFrameAnimation, twoScaleAnimation, twoOpacityAnimation]];
        _twoAnimationGroup.duration = _duration;
        _twoAnimationGroup.repeatCount = HUGE;
    }
    return _twoAnimationGroup;
}

#pragma mark <-------------Setter_methods------------->
- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    self.oneLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.dp_width/2.0, self.dp_height/2.0) radius:_radius startAngle:0 endAngle:M_PI*2 clockwise:YES].CGPath;
    self.twoLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.dp_width/2.0, self.dp_height/2.0) radius:_radius startAngle:0 endAngle:M_PI*2 clockwise:YES].CGPath;
}
- (void)setDuration:(CGFloat)duration {
    _duration = duration;
}
- (void)setDistance:(CGFloat)distance {
    _distance = distance;
    if (_distance > self.dp_width*0.5) {
        _distance = self.dp_width*0.5;
    }
}
- (void)setOneBallColor:(UIColor *)oneBallColor {
    _oneBallColor = oneBallColor;
    self.oneLayer.fillColor = _oneBallColor.CGColor;
}
- (void)setTwoBallColor:(UIColor *)towBallColor {
    _towBallColor = towBallColor;
    self.twoLayer.fillColor = _towBallColor.CGColor;
}

#pragma mark <-------------外部调用函数------------->
//开始动画
- (void)startAnimator {
    [self.oneLayer addAnimation:self.oneAnimationGroup forKey:@"oneAnimationGroup"];
    [self.twoLayer addAnimation:self.twoAnimationGroup forKey:@"twoAnimationGroup"];
}
//停止动画
- (void)stopAnimator {
    if ([self.oneLayer animationKeys].count > 0) {
        [self.oneLayer removeAllAnimations];
    }
    if ([self.twoLayer animationKeys].count > 0) {
        [self.twoLayer removeAllAnimations];
    }
}
@end
