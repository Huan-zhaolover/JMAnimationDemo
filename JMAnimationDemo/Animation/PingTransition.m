//
//  PingTransition.m
//  JMAnimationDemo
//
//  Created by jm on 16/3/24.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "PingTransition.h"

@implementation PingTransition {
    id <UIViewControllerContextTransitioning> _transitionContext;
    UIViewController *_fromVC;
    UIViewController *_toVC;
    CGPoint _startPoint;
    CGFloat _duration;
    UINavigationControllerOperation _operation;
}

- (instancetype)initWithAnimationControllerForOperation:(UINavigationControllerOperation)operation startPoint:(CGPoint)startPoint duration:(CGFloat)duration {
    self = [PingTransition new];
    if (self) {
        _operation = operation;
        _startPoint = startPoint;
        _duration = duration;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return _duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    _transitionContext = transitionContext;
    _fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    _toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIBezierPath *maskStartBP =  [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_startPoint.x, _startPoint.y, 0, 0)];
   
    UIView *contView = [transitionContext containerView];
    
    CGPoint finalPoint;
    if (_startPoint.x > (_toVC.view.bounds.size.width/2)) {
        if ((_startPoint.y < (_toVC.view.bounds.size.height/2))) {
            finalPoint = CGPointMake(_startPoint.x, _toVC.view.bounds.size.height - _startPoint.y);
        } else {
            finalPoint = CGPointMake(_startPoint.x, _startPoint.y);
        }
    } else {
        if (_startPoint.y < (_toVC.view.bounds.size.height/2)) {
            finalPoint = CGPointMake(_toVC.view.bounds.size.width - _startPoint.x, _toVC.view.bounds.size.height - _startPoint.y);
        } else {
            finalPoint = CGPointMake(_toVC.view.bounds.size.width - _startPoint.x, _startPoint.y);
        }
    }
    CGFloat radius = sqrt(finalPoint.x*finalPoint.x + finalPoint.y*finalPoint.y);
    UIBezierPath *maskFinalBP = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_startPoint.x - radius, _startPoint.y - radius, 2 * radius, 2 * radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];

    if (_operation == UINavigationControllerOperationPush) {
        maskLayer.path = maskFinalBP.CGPath;//将它的 path 指定为最终的 path 来避免在动画完成后回弹
        _toVC.view.layer.mask = maskLayer;
        [contView addSubview:_fromVC.view];
        [contView addSubview:_toVC.view];
        maskLayerAnimation.fromValue = (__bridge id _Nullable)(maskStartBP.CGPath);
        maskLayerAnimation.toValue = (__bridge id _Nullable)(maskFinalBP.CGPath);
        maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    } else {
        maskLayer.path = maskStartBP.CGPath;
        _fromVC.view.layer.mask = maskLayer;
        [contView addSubview:_toVC.view];
        [contView addSubview:_fromVC.view];
        maskLayerAnimation.fromValue = (__bridge id _Nullable)(maskFinalBP.CGPath);
        maskLayerAnimation.toValue = (__bridge id _Nullable)(maskStartBP.CGPath);
        maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    }
    
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.delegate = self;
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}

#pragma mark - CABasicAnimation的Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [_transitionContext completeTransition:![_transitionContext transitionWasCancelled]];
    _fromVC.view.layer.mask = nil;
    _toVC.view.layer.mask = nil;
}

@end

