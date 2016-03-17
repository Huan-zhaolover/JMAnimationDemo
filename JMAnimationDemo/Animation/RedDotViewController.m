//
//  RedDotViewController.m
//  JMAnimationDemo
//
//  Created by jm on 16/3/16.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "RedDotViewController.h"
#import "RedDotView.h"
#import "RedDotCell.h"

@interface RedDotViewController() <UITableViewDelegate, UITableViewDataSource>

@end

@implementation RedDotViewController {
    UITableView *_tableView;
    RedDotView *_redDotView;
    RedDotView *_redDotView2;
}

-(void)loadView {
    [super loadView];
    _redDotView = [[RedDotView alloc] initWithMaxDistance:100 bubbleColor:[UIColor redColor]];
    _redDotView2 = [[RedDotView alloc] initWithMaxDistance:200 bubbleColor:[UIColor blueColor]];
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.rowHeight = 55;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[RedDotCell class] forCellReuseIdentifier:@"cell"];
    
    UIButton *view = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [view setBackgroundImage:[UIImage imageNamed:@"avatar.jpg"] forState:UIControlStateNormal];
    
    [_redDotView2 attach:view];
    [self.view addSubview:_tableView];
    [self.view addSubview:view];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RedDotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.nameLabel.text = @"Name";
    cell.messageLabel.text = @"阳春三月";
    cell.timeLabel.text = @"19:00";
    cell.redDotLabel.text = @"99+";
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [_redDotView attach:cell.avatarView];
    [_redDotView attach:cell.nameLabel];
    [_redDotView attach:cell.messageLabel];
    [_redDotView attach:cell.timeLabel];
    [_redDotView attach:cell.redDotLabel];
    [_redDotView2 attach:cell.contentView];
    return cell;
}

@end
