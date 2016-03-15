//
//  GooeySlideMenu.h
//  JMAnimationDemo
//
//  Created by jm on 16/3/15.
//  Copyright © 2016年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MenuButtonClickedBlock) (NSInteger index, NSString *title, NSInteger titleCounts);

@interface GooeySlideMenu : UIView

- (instancetype)initWithTitle:(NSArray<NSString *> *)titles;

- (instancetype)initWithTitle:(NSArray<NSString *> *)titles withButtonHeight:(CGFloat)height withMenuColor:(UIColor *)menuColor withBackBlurStyle:(UIBlurEffectStyle)style;

- (void)trigger;

@property (nonatomic, copy) MenuButtonClickedBlock menuClickBlock;

@end
