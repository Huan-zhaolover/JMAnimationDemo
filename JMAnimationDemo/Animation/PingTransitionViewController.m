//
//  PingTransitionViewController.m
//  JMAnimationDemo
//
//  Created by jm on 16/3/24.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "PingTransitionViewController.h"
#import "SecondViewController.h"
#import "PingTransition.h"

@interface PingTransitionViewController () <UINavigationControllerDelegate>
@end

@implementation PingTransitionViewController {
    UIButton *_button;
    CGPoint _point;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.delegate = self;
}

- (void)loadView {
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
//    _button = [[UIButton alloc] initWithFrame:CGRectMake(200, 100, 40, 40)];
//    [_button setBackgroundColor:[UIColor blackColor]];
//    _button.layer.cornerRadius = 20;
//    _button.layer.backgroundColor = [self colorFromRGB:0x99CCCC].CGColor;
//    [_button addTarget:self action:@selector(transition) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_button];
//    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(transition:)];
    [self.view addGestureRecognizer:gesture];
}

- (void)transition:(UITapGestureRecognizer *)gesture {
    _point = [gesture locationInView:self.view];
    SecondViewController *vc = [[SecondViewController alloc] init];
    vc.view.backgroundColor = [self colorFromRGB:0x99CCCC];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if ((fromVC == self && operation == UINavigationControllerOperationPush )|| (toVC == self && operation == UINavigationControllerOperationPop)) {
        PingTransition *ping = [[PingTransition alloc] initWithAnimationControllerForOperation:operation startPoint:_point duration:0.5];
        return ping;
    }
    return nil;
}

- (UIColor *)colorFromRGB:(NSInteger)RGBValue {
    return [UIColor colorWithRed:((float)((RGBValue & 0xFF0000) >> 16))/255.0 green:((float)((RGBValue & 0xFF00) >> 8))/255.0 blue:((float)(RGBValue & 0xFF))/255.0 alpha:1.0];
}

@end
