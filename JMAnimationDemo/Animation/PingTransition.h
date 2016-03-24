//
//  PingTransition.h
//  JMAnimationDemo
//
//  Created by jm on 16/3/24.
//  Copyright © 2016年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PingTransition : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithAnimationControllerForOperation:(UINavigationControllerOperation)operation startPoint:(CGPoint)startPoint duration:(CGFloat)duration;

@end
