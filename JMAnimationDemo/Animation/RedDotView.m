//
//  RedDotView.m
//  JMAnimationDemo
//
//  Created by jm on 16/3/16.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "RedDotView.h"

typedef void (^DismissBlock)(UIView *);

@implementation RedDotView {
    UIBezierPath *_cutePath;
    UIColor *_fillColorForCute;
    UIDynamicAnimator *_animator;
    UISnapBehavior *_snap;
//    UIView *_containerView;
    CGFloat _viscosity;
    UIColor *_bubbleColor;
    CGFloat _bubbleWidth;
    UIView *_frontView;
    UILabel *_bubbleLabel;
    
//    UIView *_animationView;
    
    UIView *_backView;
    CGFloat _R1, _R2, _X1, _X2, _Y1, _Y2;
    CGFloat _centerDistance;
    CGFloat _maxDistance;
    CGFloat _cosDigree;
    CGFloat _sinDigree;
    
    CGPoint _pointA, _pointB, _pointC, _pointD, _pointO, _pointP, _pointTemp, _pointTemp2;
    CGPoint _deviationPoint;
    CGRect _oldBackViewFrame;
    CGPoint _oldBackViewCenter;
    CAShapeLayer *_shapeLayer;
    
    DismissBlock _dismissBlock;
//    CGPoint _touchesStartPoint;
}

- (void)attach:(UIView *)item {
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDragGesture:)];
    [item addGestureRecognizer:gesture];
}

- (instancetype)initWithFrame:(CGRect)frame bubbleWidth:(CGFloat)bubbleWidth viscosity:(CGFloat)viscosity bubbleColor:(UIColor *)bubbleColor superView:(UIView *)containerView {
    self = [super initWithFrame:frame];
    if (self) {
//        _containerView = containerView;
        _bubbleWidth = bubbleWidth;
        _viscosity = viscosity;
        _bubbleColor = bubbleColor;
        _maxDistance = 100;
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setUp {
    _shapeLayer = [CAShapeLayer layer];
    _R2 = _bubbleWidth/2;
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(_frontView.center.x - _R2, _frontView.center.y - _R2, _bubbleWidth, _bubbleWidth)];
    _R1 = _bubbleWidth/2;
    _backView.layer.cornerRadius = _R1;
    _backView.backgroundColor = _bubbleColor;
    
    [self addSubview:_backView];
    [self addSubview:_frontView];
    
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
}

- (void)handleDragGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint dragPoint = [gesture locationInView:self];
    UIView *touchView = gesture.view;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"我被抓住了");
        CGPoint dragPountInView = [gesture locationInView:gesture.view];
        _deviationPoint = CGPointMake(dragPountInView.x - gesture.view.frame.size.width/2, dragPountInView.y - gesture.view.frame.size.height/2);
        [[[UIApplication sharedApplication].delegate window] addSubview:self];
        NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:touchView];
        _frontView = [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
        _bubbleWidth = MIN(_frontView.frame.size.width, _frontView.frame.size.height);
        _centerDistance = 0;
        CGPoint animationViewOrigin = [touchView convertPoint:CGPointMake(0, 0) toView:self];
        _frontView.frame = CGRectMake(animationViewOrigin.x, animationViewOrigin.y, touchView.frame.size.width, touchView.frame.size.height);
        [self setUp];
        _fillColorForCute = _bubbleColor;
        touchView.hidden = YES;
        _backView.hidden = NO;
        self.userInteractionEnabled = YES;
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        _frontView.center =  CGPointMake(dragPoint.x - _deviationPoint.x, dragPoint.y - _deviationPoint.y);
        if (_centerDistance > _maxDistance) {
            _fillColorForCute = [UIColor clearColor];
            _backView.hidden = YES;
            [_shapeLayer removeFromSuperlayer];
        }
        [self drawRect];
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateFailed) {
        _fillColorForCute = [UIColor clearColor];
        _backView.hidden = YES;
        [_shapeLayer removeFromSuperlayer];
        if (_centerDistance > _maxDistance) {
            [_frontView removeFromSuperview];
            [self explosion];
            _frontView = touchView;
        } else {
            [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _frontView.center = _oldBackViewCenter;
            } completion:^(BOOL finished) {
                if (finished) {
                    touchView.hidden = NO;
                    self.userInteractionEnabled = NO;
                    [_frontView removeFromSuperview];
                    [self removeFromSuperview];
                }
            }];
        }
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
    CGFloat percentage = _centerDistance/_maxDistance;
    _R1 = (2 - percentage)*_oldBackViewFrame.size.width/4;
    _pointA = CGPointMake(_X1 - _R1*_cosDigree, _Y1 + _R1*_sinDigree);
    _pointB = CGPointMake(_X1 + _R1*_cosDigree, _Y1 - _R1*_sinDigree);
    _pointC = CGPointMake(_X2 + _R2*_cosDigree, _Y2 - _R2*_sinDigree);
    _pointD = CGPointMake(_X2 - _R2*_cosDigree, _Y2 + _R2*_sinDigree);
    _pointTemp = CGPointMake(_pointD.x + percentage*(_pointC.x - _pointD.x), _pointD.y + percentage*(_pointC.y - _pointD.y));//关键点
    _pointTemp2 = CGPointMake(_pointD.x + (1 - percentage)*(_pointC.x - _pointD.x), _pointD.y + (1 - percentage)*(_pointC.y - _pointD.y));
    _pointO = CGPointMake(_pointA.x + (_pointTemp.x - _pointA.x)/2, _pointA.y + (_pointTemp.y - _pointA.y)/2);
    _pointP = CGPointMake(_pointB.x + (_pointTemp2.x - _pointB.x)/2, _pointB.y + (_pointTemp2.y - _pointB.y)/2);
    
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
        [self.layer insertSublayer:_shapeLayer below:_frontView.layer];
    }
}

//爆炸效果
- (void)explosion {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSInteger i = 1; i < 6; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"red_dot_image_%ld", i]];
        [array addObject:image];
    }
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, 34, 34);
    imageView.center = _frontView.center;
    imageView.animationImages = array;
    [imageView setAnimationDuration:0.25];
    [imageView setAnimationRepeatCount:1];
    [imageView startAnimating];
    [self addSubview:imageView];
    [self performSelector:@selector(explosionComplete) withObject:nil afterDelay:0.25 inModes:@[NSDefaultRunLoopMode]];
}

- (void)explosionComplete {
    _frontView.hidden = NO;
    [self removeFromSuperview];
}

- (void)dealloc {
    NSLog(@"dealloc");
}

- (void)setBubbleText:(NSString *)bubbleText {
    _bubbleLabel.text = bubbleText;
}

@end
