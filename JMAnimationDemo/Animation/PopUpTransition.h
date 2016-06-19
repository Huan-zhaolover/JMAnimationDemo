//
//  PopUpTransition.h
//  JMAnimationDemo
//
//  Created by jm on 16/6/19.
//  Copyright © 2016年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopUpTransition : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithAnimationControllerForOperation:(UINavigationControllerOperation)operation duration:(CGFloat)duration;

@end
