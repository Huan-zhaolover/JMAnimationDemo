//
//  GooeySlideMenu.m
//  JMAnimationDemo
//
//  Created by jm on 16/3/15.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "GooeySlideMenu.h"
#import "SlideMenuButton.h"

static NSInteger kButtonSpace = 30;
static NSInteger kMenuBlankWidth = 50;

@implementation GooeySlideMenu {
    CADisplayLink *_displayLink;
    NSInteger _animationCount;
    UIVisualEffectView *_blurView;
    UIView *_helperSideView;
    UIView *_helperCenterView;
    UIWindow *_keyWindow;
    BOOL _triggered;
    CGFloat _diff;
    UIColor *_menuColor;
    CGFloat menuButonHeight;
}

- (instancetype)initWithTitle:(NSArray<NSString *> *)titles {
    return [self initWithTitle:titles withButtonHeight:40 withMenuColor:[UIColor colorWithRed:0 green:0.722 blue:1 alpha:1] withBackBlurStyle:UIBlurEffectStyleDark];
}

- (instancetype)initWithTitle:(NSArray<NSString *> *)titles withButtonHeight:(CGFloat)height withMenuColor:(UIColor *)menuColor withBackBlurStyle:(UIBlurEffectStyle)style {
    self = [super init];
    if (self) {
        _keyWindow = [[UIApplication sharedApplication] keyWindow];
        
        _blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:style]];
        _blurView.frame = _keyWindow.frame;
        _blurView.alpha = 0;
        
        _helperSideView = [[UIView alloc] initWithFrame:CGRectMake(-40, 0, 40, 40)];
        _helperSideView.backgroundColor = [self colorFromRGB:0x99CCCC];
        _helperSideView.hidden = YES;
        [_keyWindow addSubview:_helperSideView];
        
        _helperCenterView = [[UIView alloc] initWithFrame:CGRectMake(-40, CGRectGetHeight(_keyWindow.frame)/2 - 20, 40, 40)];
        _helperCenterView.backgroundColor = [UIColor yellowColor];
        _helperCenterView.hidden = YES;
        [_keyWindow addSubview:_helperCenterView];
        
        self.frame = CGRectMake(-_keyWindow.frame.size.width/2 - kMenuBlankWidth, 0, _keyWindow.frame.size.width/2 + kMenuBlankWidth, _keyWindow.frame.size.height);
        self.backgroundColor = [UIColor clearColor];
        [_keyWindow insertSubview:self belowSubview:_helperCenterView];
        
        _menuColor = menuColor;
        menuButonHeight = height;
        [self addButtons:titles];
    }
    return self;
}

- (void)addButtons:(NSArray *)titles {
    if (titles.count % 2 == 0) {
        NSInteger indexDown = titles.count/2;
        NSInteger indexUp = -1;
        for (NSInteger i = 0; i < titles.count; i++) {
            NSString *title = titles[i];
            SlideMenuButton *homeButton = [[SlideMenuButton alloc] initWithTitle:title];
            if (i >= titles.count/2) {
                indexUp ++;
                homeButton.center = CGPointMake(_keyWindow.frame.size.width/4, _keyWindow.frame.size.height/2 + (menuButonHeight + kButtonSpace)*(indexUp + 0.5));
            } else {
                indexDown --;
                homeButton.center = CGPointMake(_keyWindow.frame.size.width/4, _keyWindow.frame.size.height/2 - (menuButonHeight + kButtonSpace)*(indexDown + 0.5));
            }
            homeButton.bounds = CGRectMake(0, 0, _keyWindow.frame.size.width/2 - 20*2, menuButonHeight);
            homeButton.buttonColor = _menuColor;
            [self addSubview:homeButton];
            __weak typeof(self) weakSelf = self;
            homeButton.buttonClickBlock = ^() {
                [weakSelf tapToUntrigger];
                weakSelf.menuClickBlock(i, title, titles.count);
            };
        }
    } else {
        NSInteger index = (titles.count - 1)/2 + 1;
        for (NSInteger i = 0; i < titles.count; i++) {
            index --;
            NSString *title = titles[i];
            SlideMenuButton *homeButton = [[SlideMenuButton alloc] initWithTitle:title];
            homeButton.center = CGPointMake(_keyWindow.frame.size.width/4, _keyWindow.frame.size.height/2 - menuButonHeight*index - 20*index);
            homeButton.bounds = CGRectMake(0, 0, _keyWindow.frame.size.width/2 - 20*2, menuButonHeight);
            homeButton.buttonColor = _menuColor;
            [self addSubview:homeButton];
            __weak typeof(self) weakSelf = self;
            homeButton.buttonClickBlock = ^() {
                [weakSelf tapToUntrigger];
                weakSelf.menuClickBlock(i, title, titles.count);
            };
        }
    }
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.frame.size.width - kMenuBlankWidth, 0)];
    [path addQuadCurveToPoint:CGPointMake(self.frame.size.width - kMenuBlankWidth, self.frame.size.height) controlPoint:CGPointMake(_keyWindow.frame.size.width/2 + _diff, _keyWindow.frame.size.height/2)];
    [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [path closePath];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path.CGPath);
    [_menuColor set];
    CGContextFillPath(context);
}

- (void)trigger {
    if (!_triggered) {
        [_keyWindow insertSubview:_blurView belowSubview:self];
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = self.bounds;
        }];
        
        [self beforeAnimation];
        //弹簧动画
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.9 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            _helperSideView.center = CGPointMake(_keyWindow.center.x, _helperSideView.frame.size.height/2);
        } completion:^(BOOL finished) {
            [self finishAnimation];
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            _blurView.alpha = 1.0;
        }];
        
        [self beforeAnimation];
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            _helperCenterView.center = _keyWindow.center;
        } completion:^(BOOL finished) {
            if (finished) {
                UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToUntrigger)];
                [_blurView addGestureRecognizer:tapGestureRecognizer];
                [self finishAnimation];
            }
        }];
        [self animateButtons];
        _triggered = YES;
    } else {
        [self tapToUntrigger];
    }
}

- (void)animateButtons {
    for (NSInteger i = 0; i < self.subviews.count; i ++) {
        UIView *menuButton = self.subviews[i];
        if ([menuButton isKindOfClass:[SlideMenuButton class]]) {
            menuButton.transform = CGAffineTransformMakeTranslation(-90, 0);
            [UIView animateWithDuration:0.7 delay:i*(0.3/self.subviews.count) usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
                menuButton.transform = CGAffineTransformIdentity;
            } completion:NULL];
        }
    }
}

- (void)tapToUntrigger {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(-_keyWindow.frame.size.width/2 - menuButonHeight, 0, _keyWindow.frame.size.width/2 + kMenuBlankWidth, _keyWindow.frame.size.height);
    }];
    
    [self beforeAnimation];
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.9 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        _helperSideView.center = CGPointMake(-_helperSideView.frame.size.width/2, _helperSideView.frame.size.height/2);
    } completion:^(BOOL finished) {
        [self finishAnimation];
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        _blurView.alpha = 0.0f;
    }];
    
    [self beforeAnimation];
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:2.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        _helperCenterView.center = CGPointMake(-_helperSideView.frame.size.height/2, CGRectGetHeight(_keyWindow.frame)/2);
    } completion:^(BOOL finished) {
        [self finishAnimation];
    }];
    _triggered = NO;
}

- (void)beforeAnimation {
    _animationCount ++;
    if (_displayLink == nil) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)finishAnimation {
    _animationCount --;
    if (_animationCount == 0) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)displayLinkAction:(CADisplayLink *)displayLink {
    CALayer *sideHelperPresentationLayer = [_helperSideView.layer presentationLayer];
    CALayer *centerHelperPresentationLayer = [_helperCenterView.layer presentationLayer];
    CGRect centerRect = [[centerHelperPresentationLayer valueForKeyPath:@"frame"] CGRectValue];
    CGRect sideRect = [[sideHelperPresentationLayer valueForKeyPath:@"frame"] CGRectValue];
    
    _diff = sideRect.origin.x - centerRect.origin.x;
    [self setNeedsDisplay];
}

- (UIColor *)colorFromRGB:(NSInteger)RGBValue {
    return [UIColor colorWithRed:((float)((RGBValue & 0xFF0000) >> 16))/255.0 green:((float)((RGBValue & 0xFF00) >> 8))/255.0 blue:((float)(RGBValue & 0xFF))/255.0 alpha:1.0];
}
@end
