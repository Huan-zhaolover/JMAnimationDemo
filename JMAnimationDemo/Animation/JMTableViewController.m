//
//  JMTableViewController.m
//  JMAnimationDemo
//
//  Created by 饶志臻 on 16/6/14.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "JMTableViewController.h"

@interface JMTableViewController () <UIScrollViewDelegate>

@end

@implementation JMTableViewController {
    CGFloat _scrollViewY;
    CGFloat _offsetY;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollViewY = -64;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.backgroundColor = [UIColor lightGrayColor];
    cell.textLabel.text = @"床前明月光，疑是地上霜，举头望明月，低头思故乡";
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    cell.layer.transform = CATransform3DMakeTranslation(0, _offsetY, 0);

    [UIView animateWithDuration:0.5 animations:^{
        cell.layer.transform = CATransform3DIdentity;
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollViewY = scrollView.contentOffset.y;
    if (_scrollViewY > scrollViewY) {
        _offsetY = -100;
    } else if (_scrollViewY < scrollViewY) {
        _offsetY = 100;
    }
    _scrollViewY = scrollViewY;
    
}

@end
