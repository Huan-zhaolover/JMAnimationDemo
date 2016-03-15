//
//  CircleView.m
//  JMAnimationDemo
//
//  Created by jm on 16/3/14.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

+ (Class)layerClass {
    return [CircleLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _circleLayer = [CircleLayer layer];
        _circleLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _circleLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:_circleLayer];
    }
    return self;
}

@end
