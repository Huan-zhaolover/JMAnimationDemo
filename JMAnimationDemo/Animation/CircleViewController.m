//
//  CircleViewController.m
//  JMAnimationDemo
//
//  Created by jm on 16/3/14.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "CircleViewController.h"
#import "CircleView.h"
#import "UIControl+YYAdd.h"

@implementation CircleViewController {
    CircleView *_circleView;
    UISlider *_slider0;
}

- (void)loadView {
    [super loadView];
    _circleView = [[CircleView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 320/2, self.view.frame.size.height/2 - 320/2, 320, 320)];
    _circleView.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:_circleView];
    
    _slider0 = [[UISlider alloc] initWithFrame:CGRectMake(_circleView.frame.origin.x, 600, 320, 20)];
    _slider0.minimumValue = 0;
    _slider0.maximumValue = 1;
    _slider0.value = 0.5;
    [self.view addSubview:_slider0];
    
    __weak typeof(self) _self = self;
    [_slider0 addBlockForControlEvents:UIControlEventValueChanged block:^(id sender) {
        [_self changed];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _circleView.circleLayer.progress = _slider0.value;
}

- (void)changed {
    _circleView.circleLayer.progress = _slider0.value;
}

@end
