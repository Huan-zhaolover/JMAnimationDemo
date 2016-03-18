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
#import "RedDotCellModel.h"

@interface RedDotViewController() <UITableViewDelegate, UITableViewDataSource>

@end

@implementation RedDotViewController {
    UITableView *_tableView;
    NSArray *_array;
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

    [self.view addSubview:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 100; i ++) {
        RedDotCellModel *model = [[RedDotCellModel alloc] init];
        model.name = @"name";
        model.message = @"这是一条信息";
        model.time = @"19:00";
        model.messageCount = @99;
        model.avatar = [UIImage imageNamed:@"avatar.jpg"];
        [array addObject:model];
    }
    _array = array.copy;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RedDotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    RedDotCellModel *model = _array[indexPath.row];
    cell.cellModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [_redDotView attach:cell.avatarView withSeparateBlock:^BOOL(UIView *view) {
        return NO;
    }];
    
    [_redDotView attach:cell.nameLabel withSeparateBlock:nil];
    
    [_redDotView attach:cell.messageLabel withSeparateBlock:^BOOL(UIView *view) {
        model.message = nil;
        return YES;
    }];
    
    [_redDotView attach:cell.timeLabel withSeparateBlock:^BOOL(UIView *view) {
        model.time = nil;
        return YES;
    }];
    
    [_redDotView attach:cell.redDotLabel withSeparateBlock:^BOOL(UIView *view) {
        model.messageCount = nil;
        return YES;
    }];
    
    [_redDotView2 attach:cell.contentView withSeparateBlock:^BOOL(UIView *view) {
        model.contentViewHidden = YES;
        return YES;
    }];
    return cell;
}

@end
