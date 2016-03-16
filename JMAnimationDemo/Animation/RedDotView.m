//
//  RedDotView.m
//  JMAnimationDemo
//
//  Created by jm on 16/3/16.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "RedDotView.h"

@implementation RedDotView {
    UIBezierPath *_cutePath;
    UIColor *_fillColorForCute;
    UIDynamicAnimator *_animator;
    UISnapBehavior *_snap;
    UIView *_containerView;
    CGFloat _viscosity;
    UIColor *_bubbleColor;
    CGFloat _bubbleWidth;
    UIView *_frontView;
    UILabel *_bubbleLabel;
    
    UIView *_backView;
    CGFloat _R1, _R2, _X1, _X2, _Y1, _Y2;
    CGFloat _centerDistance;
    CGFloat _cosDigree;
    CGFloat _sinDigree;
    
    CGPoint _pointA, _pointB, _pointC, _pointD, _pointO, _pointP;
    CGPoint _initialPoint;
    CGRect _oldBackViewFrame;
    CGPoint _oldBackViewCenter;
    CAShapeLayer *_shapeLayer;
}

- (instancetype)initWithPoint:(CGPoint)point bubbleWidth:(CGFloat)bubbleWidth viscosity:(CGFloat)viscosity bubbleColor:(UIColor *)bubbleColor superView:(UIView *)containerView {
    self = [super initWithFrame:CGRectMake(point.x, point.y, bubbleWidth, bubbleWidth)];
    if (self) {
        _initialPoint = point;
        _containerView = containerView;
        _bubbleWidth = bubbleWidth;
        _viscosity = viscosity;
        _bubbleColor = bubbleColor;
        [_containerView addSubview:self];
        [self setUp];
    }
    return self;
}

- (void)setUp {
    _shapeLayer = [CAShapeLayer layer];
    self.backgroundColor = [UIColor clearColor];
    _frontView = [[UIView alloc] initWithFrame:CGRectMake(_initialPoint.x, _initialPoint.y, _bubbleWidth, _bubbleWidth)];
    _R2 = _bubbleWidth/2;
    _frontView.layer.cornerRadius = _R2;
    _frontView.backgroundColor = _bubbleColor;
    
    _backView = [[UIView alloc] initWithFrame:_frontView.frame];
    _R1 = _bubbleWidth/2;
    _backView.layer.cornerRadius = _R1;
    _backView.backgroundColor = _bubbleColor;
    
    _bubbleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _frontView.bounds.size.width, _frontView.bounds.size.height)];
    _bubbleLabel.textColor = [UIColor whiteColor];
    _bubbleLabel.textAlignment = NSTextAlignmentCenter;
    [_frontView addSubview:_bubbleLabel];
    
    [_containerView addSubview:_backView];
    [_containerView addSubview:_frontView];
    
    _X1 = _backView.center.x;
    _Y1 = _backView.center.y;
    _X2 = _frontView.center.x;
    _Y2 = _frontView.center.y;
    
    _pointA = CGPointMake(_X1 - _R1, _Y1);
    _pointB = CGPointMake(_X1 + _R1, _Y1);
    _pointC = CGPointMake(_X2 + _R2, _Y2);
    _pointD = CGPointMake(_X2 - _R2, _Y2);
    _pointO = CGPointMake(_X1 - _R1, _Y1);
    _pointP = CGPointMake(_X2 + _R2, _Y2);
    
    _oldBackViewFrame = _backView.frame;
    _oldBackViewCenter = _backView.center;

    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDragGesture:)];
    [_frontView addGestureRecognizer:gesture];
}

- (void)handleDragGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint dragPoint = [gesture locationInView:_containerView];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _fillColorForCute = _bubbleColor;
        _backView.hidden = NO;
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        _frontView.center = dragPoint;
        if (_R1 <= 6) {
            _fillColorForCute = [UIColor clearColor];
            _backView.hidden = YES;
            [_shapeLayer removeFromSuperlayer];
        }
        [self drawRect];
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateFailed) {
        _backView.hidden = YES;
        _fillColorForCute = [UIColor clearColor];
        [_shapeLayer removeFromSuperlayer];
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.4 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _frontView.center = _oldBackViewCenter;
        } completion:NULL];
    }
}

- (void)drawRect {
    _X1 = _backView.center.x;
    _Y1 = _backView.center.y;
    _X2 = _frontView.center.x;
    _Y2 = _frontView.center.y;
    
    _centerDistance = sqrtf((_X2 - _X1)*(_X2 - _X1) + (_Y2 - _Y1)*(_Y2 - _Y1));
    if (_centerDistance == 0) {
        _cosDigree = 1;
        _sinDigree = 0;
    } else {
        _cosDigree = (_Y2 - _Y1)/_centerDistance;
        _sinDigree = (_X2 - _X1)/_centerDistance;
    }
    
    _R1 = _oldBackViewFrame.size.width/2 - _centerDistance/_viscosity;
    _pointA = CGPointMake(_X1 - _R1*_cosDigree, _Y1 + _R1*_sinDigree);
    _pointB = CGPointMake(_X1 + _R1*_cosDigree, _Y1 - _R1*_sinDigree);
    _pointC = CGPointMake(_X2 + _R2*_cosDigree, _Y2 - _R2*_sinDigree);
    _pointD = CGPointMake(_X2 - _R2*_cosDigree, _Y2 + _R2*_sinDigree);
    _pointO = CGPointMake(_pointA.x + _centerDistance/2*_sinDigree, _pointA.y + _centerDistance/2*_cosDigree);
    _pointP = CGPointMake(_pointB.x + _centerDistance/2*_sinDigree, _pointB.y + _centerDistance/2*_cosDigree);
    
    _backView.center = _oldBackViewCenter;
    _backView.bounds = CGRectMake(0, 0, _R1*2, _R1*2);
    _backView.layer.cornerRadius = _R1;
    
    _cutePath = [UIBezierPath bezierPath];
    [_cutePath moveToPoint:_pointA];
    [_cutePath addQuadCurveToPoint:_pointD controlPoint:_pointO];
    [_cutePath addLineToPoint:_pointC];
    [_cutePath addQuadCurveToPoint:_pointB controlPoint:_pointP];
    [_cutePath moveToPoint:_pointA];
    
    if (_backView.hidden == NO) {
        _shapeLayer.path = [_cutePath CGPath];
        _shapeLayer.fillColor = [_fillColorForCute CGColor];
        [_containerView.layer insertSublayer:_shapeLayer below:_frontView.layer];
    }
}

- (void)setBubbleText:(NSString *)bubbleText {
    _bubbleLabel.text = bubbleText;
}

@end
