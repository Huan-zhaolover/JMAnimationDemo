//
//  RedDotViewController.m
//  JMAnimationDemo
//
//  Created by jm on 16/3/16.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "RedDotViewController.h"
#import "RedDotView.h"

@interface RedDotViewController() <UITableViewDelegate, UITableViewDataSource>

@end

@implementation RedDotViewController {
    UITableView *_tableView;
}

-(void)loadView {
    [super loadView];
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.rowHeight = 55;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RedDotView *view = [[RedDotView alloc] initWithPoint:CGPointMake(300, 10) bubbleWidth:35 viscosity:20 bubbleColor:[UIColor redColor] superView:cell.contentView];
        view.bubbleText = @"10";
    }
    cell.textLabel.text = [NSString stringWithFormat:@"No.%ld", indexPath.row];
    return cell;
}

@end
