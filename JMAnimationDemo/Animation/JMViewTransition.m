//
//  JMViewTransition.m
//  JMAnimationDemo
//
//  Created by 饶志臻 on 16/6/21.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "JMViewTransition.h"

@implementation JMViewTransition {
    id <UIViewControllerContextTransitioning> _transitionContext;
    UINavigationControllerOperation _operation;
    UIViewController *_firstVC;
    UIViewController *_secondVC;
    UIView *_startView;
    NSString *_endViewName;
    CGFloat _duration;
}

- (instancetype)initWithAnimationControllerForOperation:(UINavigationControllerOperation)operation startView:(UIView *)view endViewName:(NSString *)viewName duration:(CGFloat)duration {
    self = [JMViewTransition new];
    if (self) {
        _operation = operation;
        _startView = view;
        _endViewName = viewName;
        _duration = duration;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return _duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    _transitionContext = transitionContext;
    if (_operation == UINavigationControllerOperationPush) {
        _firstVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        _secondVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView *contView = [transitionContext containerView];
        
        UIView *endView = [_secondVC valueForKey:_endViewName];
        
        CGRect startFrame = [_startView convertRect:_startView.frame toView:_firstVC.view];
        CGRect endFrame = [endView convertRect:endView.bounds toView:_secondVC.view];
        
        UIImageView *startImageView = [[UIImageView alloc] initWithFrame:startFrame];
        CGFloat scale = MAX(endView.frame.size.width / _startView.frame.size.width, endView.frame.size.height / _startView.frame.size.width);
        startImageView.image = [self getImageFromView:endView scale:scale];
        startImageView.contentMode = UIViewContentModeScaleAspectFill;
        startImageView.clipsToBounds = YES;
        _startView.hidden = YES;
        endView.hidden = YES;
        [contView addSubview:_secondVC.view];
        [contView addSubview:_firstVC.view];
        
        [contView addSubview:startImageView];
        
        [UIView animateWithDuration:_duration animations:^{
            _firstVC.view.alpha = 0.0;
            startImageView.frame = endFrame;
        } completion:^(BOOL finished) {
            endView.hidden = NO;
            [startImageView removeFromSuperview];
            [_firstVC.view removeFromSuperview];
            [_transitionContext completeTransition:![_transitionContext transitionWasCancelled]];
        }];
    } else {
        _secondVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        _firstVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView *contView = [transitionContext containerView];
        UIView *endView = [_secondVC valueForKey:_endViewName];
        CGRect startFrame = [_startView convertRect:_startView.frame toView:_firstVC.view];
        CGRect endFrame = [endView convertRect:endView.bounds toView:_secondVC.view];
        
        UIImageView *startImageView = [[UIImageView alloc] initWithFrame:endFrame];
        
        CGFloat scale = MAX(_startView.frame.size.width / endView.frame.size.width, _startView.frame.size.width / endView.frame.size.height);
        startImageView.image = [self getImageFromView:endView scale:scale];
        startImageView.contentMode = UIViewContentModeScaleAspectFill;
        startImageView.clipsToBounds = YES;
        _startView.hidden = YES;
        endView.hidden = YES;
        [contView addSubview:_secondVC.view];
        [contView addSubview:_firstVC.view];
        _firstVC.view.alpha = 0.0;

        [contView addSubview:startImageView];
        
        [UIView animateWithDuration:_duration animations:^{
            _firstVC.view.alpha = 1.0;
            startImageView.frame = startFrame;
        } completion:^(BOOL finished) {
            [_secondVC.view removeFromSuperview];
            _startView.hidden = NO;
            [startImageView removeFromSuperview];
            [_transitionContext completeTransition:![_transitionContext transitionWasCancelled]];
        }];
    }
}

- (UIImage *)getImageFromView:(UIView *)view scale:(CGFloat)scale {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, MAX(UIScreen.mainScreen.scale, scale ));
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
