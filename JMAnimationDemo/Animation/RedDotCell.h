//
//  RedDotCell.h
//  JMAnimationDemo
//
//  Created by jm on 16/3/17.
//  Copyright © 2016年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RedDotCellModel.h"

@interface RedDotCell : UITableViewCell

@property (nonatomic, strong) RedDotCellModel *cellModel;

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *redDotLabel;

@end
