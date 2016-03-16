//
//  GooeySlideMenuViewController.m
//  JMAnimationDemo
//
//  Created by jm on 16/3/15.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "GooeySlideMenuViewController.h"
#import "GooeySlideMenu.h"

@interface GooeySlideMenuViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation GooeySlideMenuViewController {
    GooeySlideMenu *_menu;
    UITableView *_tableView;
}

- (void)loadView {
    [super loadView];
    _menu = [[GooeySlideMenu alloc] initWithTitle:@[@"首页", @"消息", @"发布", @"发现", @"个人", @"设置",@"关于"] withButtonHeight:44 withMenuColor:[UIColor redColor] withBackBlurStyle:UIBlurEffectStyleLight];
    _menu.menuClickBlock = ^(NSInteger index, NSString *title, NSInteger titleCounts) {
        NSLog(@"index:%ld title:%@ titleCounts:%ld", index, title, titleCounts);
    };
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.rowHeight = 44;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"菜单" style:UIBarButtonItemStylePlain target:self action:@selector(buttonTrigger:)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"No.%ld", indexPath.row];
    return cell;
}

- (void)buttonTrigger:(UIButton *)sender {
    [_menu trigger];
}

@end
