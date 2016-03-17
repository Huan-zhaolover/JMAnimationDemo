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
    RedDotView *_redDotView;
}

-(void)loadView {
    [super loadView];
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.rowHeight = 55;
    _tableView.dataSource = self;
    _tableView.delegate = self;

    _redDotView = [[RedDotView alloc] initWithFrame:[UIScreen mainScreen].bounds bubbleWidth:35 viscosity:20 bubbleColor:[UIColor redColor] superView:nil];

    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.imageView.image = [UIImage imageNamed:@"avatar.jpg"];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(300, 20, 30, 30)];
        view.layer.backgroundColor = [UIColor redColor].CGColor;
        view.layer.cornerRadius = 2;
        [cell.contentView addSubview:view];
        
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(100, 20, 100, 30)];
        view2.backgroundColor = [UIColor blueColor];
        [cell.contentView addSubview:view2];
        [_redDotView attach:view];
        [_redDotView attach:view2];
        [_redDotView attach:cell];
        [_redDotView attach:cell.textLabel];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"No.%ld", indexPath.row];
    return cell;
}

@end
