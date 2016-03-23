//
//  ViewController.m
//  JMAnimationDemo
//
//  Created by jm on 16/3/14.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController {
    UITableView *_tableView;
    NSMutableArray *_titles;
    NSMutableArray *_classNames;
}

- (void)loadView {
    [super loadView];
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.rowHeight = 44;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    _titles = @[].mutableCopy;
    _classNames = @[].mutableCopy;
    [self addCell:@"Animated circle" class:@"CircleViewController"];
    [self addCell:@"Gooey Slide Menu" class:@"GooeySlideMenuViewController"];
    [self addCell:@"Red Dot" class:@"RedDotViewController"];
}

- (void)addCell:(NSString *)title class:(NSString *)className {
    [_titles addObject:title];
    [_classNames addObject:className];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = _classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *VC = class.new;
        VC.title = _titles[indexPath.row];
        [self.navigationController pushViewController:VC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
