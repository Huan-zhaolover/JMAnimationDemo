//
//  RedDotView.m
//  JMAnimationDemo
//
//  Created by jm on 16/3/16.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "RedDotView.h"

@implementation RedDotView {
    NSMutableDictionary *_separateBlockDictionary;//view消失时触发的block
    UIPanGestureRecognizer *_gesture;//手势。
    UIBezierPath *_cutePath;
    UIColor *_fillColorForCute;
    UIDynamicAnimator *_animator;
    UISnapBehavior *_snap;
    UIView *_touchView;
//    CGFloat _viscosity;
    UIColor *_bubbleColor;
    CGFloat _bubbleWidth;
    UIImageView *_prototypeView;
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
    
//    CGPoint _touchesStartPoint;
}

- (void)attach:(UIView *)item withSeparateBlock:(SeparateBlock)separateBlock {
    NSValue *viewValue = [NSValue valueWithNonretainedObject:item];
    if (!_separateBlockDictionary[viewValue]) {
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDragGesture:)];
        item.userInteractionEnabled = YES;
        [item addGestureRecognizer:gesture];
    }
    if (separateBlock) {
        [_separateBlockDictionary setObject:separateBlock forKey:[NSValue valueWithNonretainedObject:item]];
    } else {
        SeparateBlock block = ^BOOL(UIView *view) {
            return NO;
        };
        [_separateBlockDictionary setObject:block forKey:[NSValue valueWithNonretainedObject:item]];
    }
}

- (instancetype)initWithMaxDistance:(CGFloat)maxDistance bubbleColor:(UIColor *)bubbleColor {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        _bubbleColor = bubbleColor;
        _maxDistance = maxDistance;
        _prototypeView = [[UIImageView alloc] init];
        _separateBlockDictionary = [[NSMutableDictionary alloc] init];
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setUp {
    _shapeLayer = [CAShapeLayer layer];
    _R2 = _bubbleWidth/2;
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(_prototypeView.center.x - _R2, _prototypeView.center.y - _R2, _bubbleWidth, _bubbleWidth)];
    _R1 = _bubbleWidth/2;
    _backView.layer.cornerRadius = _R1;
    _backView.backgroundColor = _bubbleColor;
    
    _frontView = [[UIView alloc] initWithFrame:CGRectMake(_prototypeView.center.x - _R1, _prototypeView.center.y - _R1, _bubbleWidth, _bubbleWidth)];
    _frontView.layer.cornerRadius = _R2;
    _frontView.backgroundColor = _bubbleColor;
    [self addSubview:_backView];
    [self addSubview:_frontView];
    [self addSubview:_prototypeView];
    _X1 = _backView.center.x;
    _Y1 = _backView.center.y;
    _X2 = _prototypeView.center.x;
    _Y2 = _prototypeView.center.y;
    
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
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _touchView = gesture.view;
        CGPoint dragPountInView = [gesture locationInView:gesture.view];
        _deviationPoint = CGPointMake(dragPountInView.x - gesture.view.frame.size.width/2, dragPountInView.y - gesture.view.frame.size.height/2);
        [[[UIApplication sharedApplication].delegate window] addSubview:self];
        _prototypeView.image = [self getImageFromView:_touchView];
        _bubbleWidth = MIN(_touchView.frame.size.width, _touchView.frame.size.height) - 1;
        _centerDistance = 0;
        CGPoint animationViewOrigin = [_touchView convertPoint:CGPointMake(0, 0) toView:self];
        _prototypeView.frame = CGRectMake(animationViewOrigin.x, animationViewOrigin.y, _touchView.frame.size.width, _touchView.frame.size.height);
        [self setUp];
        _fillColorForCute = _bubbleColor;
        _touchView.hidden = YES;
        _backView.hidden = NO;
        _frontView.hidden = NO;
        self.userInteractionEnabled = YES;
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        _prototypeView.center =  CGPointMake(dragPoint.x - _deviationPoint.x, dragPoint.y - _deviationPoint.y);
        _frontView.center = _prototypeView.center;
        if (_centerDistance > _maxDistance) {
            _fillColorForCute = [UIColor clearColor];
            _backView.hidden = YES;
            _frontView.hidden = YES;
            [_shapeLayer removeFromSuperlayer];
        }
        [self drawRect];
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateFailed) {
        _fillColorForCute = [UIColor clearColor];
        _backView.hidden = YES;
        _frontView.hidden = YES;
        [_shapeLayer removeFromSuperlayer];
        if (_centerDistance > _maxDistance) {
            SeparateBlock block = _separateBlockDictionary[[NSValue valueWithNonretainedObject:_touchView]];
            if (block) {
                BOOL animationEnable = block(_touchView);
                if (animationEnable) {
                    [_prototypeView removeFromSuperview];
                    [self explosion:_prototypeView.center radius:_bubbleWidth];
                } else {
                    [self springBack:_prototypeView point:_oldBackViewCenter];
                }
            }
        } else {
            [self springBack:_prototypeView point:_oldBackViewCenter];
        }
    }
}

- (void)drawRect {
    _X1 = _backView.center.x;
    _Y1 = _backView.center.y;
    _X2 = _prototypeView.center.x;
    _Y2 = _prototypeView.center.y;
    
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
        [self.layer insertSublayer:_shapeLayer below:_prototypeView.layer];
    }
}

//爆炸效果
- (void)explosion:(CGPoint)explosionPoint radius:(CGFloat)radius {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 1; i < 6; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"red_dot_image_%d", i]];
        [array addObject:image];
    }
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, radius*2, radius*2);
    imageView.center = explosionPoint;
    imageView.animationImages = array;
    [imageView setAnimationDuration:0.25];
    [imageView setAnimationRepeatCount:1];
    [imageView startAnimating];
    [self addSubview:imageView];
    [self performSelector:@selector(explosionComplete) withObject:nil afterDelay:0.25 inModes:@[NSDefaultRunLoopMode]];
}

//爆炸动画结束
- (void)explosionComplete {
    _touchView.hidden = YES;
    [self removeFromSuperview];
}

//回弹效果
- (void)springBack:(UIView *)view point:(CGPoint)point {
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.center = point;
    } completion:^(BOOL finished) {
        if (finished) {
            _touchView.hidden = NO;
            self.userInteractionEnabled = NO;
            [view removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

- (UIView *)deepCopyView:(UIView *)view {
    UIImageView *copyView = [[UIImageView alloc] initWithFrame:view.frame];
    copyView.image = [self getImageFromView:view];
    return copyView;
}

- (UIImage *)getImageFromView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, UIScreen.mainScreen.scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)dealloc {
    NSLog(@"dealloc");
}

@end
