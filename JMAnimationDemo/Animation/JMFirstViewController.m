//
//  JMFirstViewController.m
//  JMAnimationDemo
//
//  Created by 饶志臻 on 16/6/21.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "JMFirstViewController.h"
#import "JMSecondViewController.h"
#import "JMViewTransition.h"

@interface JMFirstViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate>

@end

@implementation JMFirstViewController {
    UIView *_startView;
    NSString *_endString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 200;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"KKHIcon"].CGImage);
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    _startView = cell.contentView;
    if (indexPath.row % 3 == 0) {
        _endString = @"avatarImageView";
    }
    else if (indexPath.row % 3 == 1) {
        _endString = @"iconImageView";
    }
    else if (indexPath.row % 3 == 2) {
        _endString = @"detailImageView";
    }
    NSLog(@"cell被点击");
    [self.navigationController pushViewController:[JMSecondViewController new] animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.view.frame.size.width - 40) / 3, (self.view.frame.size.width - 40)/ 3);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if ((fromVC == self && operation == UINavigationControllerOperationPush ) || (toVC == self && operation == UINavigationControllerOperationPop)) {
        JMViewTransition *viewTransition = [[JMViewTransition alloc] initWithAnimationControllerForOperation:operation startView:_startView endViewName:_endString duration:0.5];
        return viewTransition;
    }
    return nil;
}

@end
