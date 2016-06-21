//
//  PopUpViewController.m
//  JMAnimationDemo
//
//  Created by jm on 16/6/19.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "PopUpViewController.h"
#import "PopUpLoginViewController.h"
#import "PopUpTransition.h"

@interface PopUpViewController () <UINavigationControllerDelegate>

@end

@implementation PopUpViewController {
    UIButton *_popButton;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _popButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _popButton.center = self.view.center;
    _popButton.bounds = CGRectMake(0, 0, 100, 44);
    [_popButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_popButton setTitle:@"button" forState:UIControlStateNormal];
    [_popButton addTarget:self action:@selector(popButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_popButton];
}

- (void)popButtonAction {
    PopUpLoginViewController *VC = [[PopUpLoginViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if ((fromVC == self && operation == UINavigationControllerOperationPush )|| (toVC == self && operation == UINavigationControllerOperationPop)) {
        PopUpTransition *popUpTransition = [[PopUpTransition alloc] initWithAnimationControllerForOperation:operation duration:0.6];
        return popUpTransition;
    }
    return nil;
}

@end
