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

- (instancetype)initWithFrame:(CGRect)frame bubbleWidth:(CGFloat)bubbleWidth viscosity:(CGFloat)viscosity bubbleColor:(UIColor *)bubbleColor superView:(UIView *)containerView;

- (instancetype)initWithMaxDistance:(CGFloat)maxDistance bubbleColor:(UIColor *)bubbleColor;

- (void)attach:(UIView *)item;

@end
