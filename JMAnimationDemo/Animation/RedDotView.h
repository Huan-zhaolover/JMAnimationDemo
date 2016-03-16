//
//  RedDotView.h
//  JMAnimationDemo
//
//  Created by jm on 16/3/16.
//  Copyright © 2016年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedDotView : UIView

@property (nonatomic, copy) NSString *bubbleText;

- (instancetype)initWithPoint:(CGPoint)point bubbleWidth:(CGFloat)bubbleWidth viscosity:(CGFloat)viscosity bubbleColor:(UIColor *)bubbleColor superView:(UIView *)containerView;

- (void)setUp;

@end
