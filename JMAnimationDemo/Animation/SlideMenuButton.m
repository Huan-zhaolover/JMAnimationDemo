//
//  SlideMenuButton.m
//  JMAnimationDemo
//
//  Created by jm on 16/3/15.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "SlideMenuButton.h"

@implementation SlideMenuButton {
    NSString *_buttonTitle;
}

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _buttonTitle = title;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context, rect);
    [_buttonColor set];//设置和笔画和填充颜色
    CGContextFillPath(context);
    
    UIBezierPath *roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 1, 1) cornerRadius:rect.size.height/2];
    [_buttonColor setFill];//单独设置填充颜色
    [roundedRectanglePath fill];
    [[UIColor whiteColor] setStroke];//单独设置笔画颜色
    roundedRectanglePath.lineWidth = 1;
    [roundedRectanglePath stroke];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributeString = @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont systemFontOfSize:24], NSForegroundColorAttributeName:[UIColor whiteColor]};
    CGSize size = [_buttonTitle sizeWithAttributes:attributeString];
    CGRect buttonRect = CGRectMake(rect.origin.x, rect.origin.y + (rect.size.height - size.height)/2.0, rect.size.width, size.height);
    [_buttonTitle drawInRect:buttonRect withAttributes:attributeString];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSUInteger tapCount = touch.tapCount;
    switch (tapCount) {
        case 1:
            _buttonClickBlock();
            break;
            
        default:
            break;
    }
}

@end
