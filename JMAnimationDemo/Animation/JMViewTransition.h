//
//  JMViewTransition.h
//  JMAnimationDemo
//
//  Created by 饶志臻 on 16/6/21.
//  Copyright © 2016年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMViewTransition : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithAnimationControllerForOperation:(UINavigationControllerOperation)operation startView:(UIView *)view endViewName:(NSString *)viewName duration:(CGFloat)duration;

@end
