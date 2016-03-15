//
//  SlideMenuButton.h
//  JMAnimationDemo
//
//  Created by jm on 16/3/15.
//  Copyright © 2016年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideMenuButton : UIView

- (instancetype)initWithTitle:(NSString *)title;

@property (nonatomic, strong) UIColor *buttonColor;

@property (nonatomic, copy) void(^buttonClickBlock)(void);

@end
