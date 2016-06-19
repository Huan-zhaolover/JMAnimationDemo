//
//  PopUpLoginViewController.m
//  JMAnimationDemo
//
//  Created by jm on 16/6/19.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "PopUpLoginViewController.h"

@implementation PopUpLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *_popButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _popButton.center = self.view.center;
    _popButton.bounds = CGRectMake(0, 0, 100, 44);
    [_popButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_popButton setTitle:@"button" forState:UIControlStateNormal];
    [_popButton addTarget:self action:@selector(popButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_popButton];
}

- (void)popButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
