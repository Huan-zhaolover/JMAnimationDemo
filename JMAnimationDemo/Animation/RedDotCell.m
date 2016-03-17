//
//  RedDotCell.m
//  JMAnimationDemo
//
//  Created by jm on 16/3/17.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "RedDotCell.h"

@implementation RedDotCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    _avatarView.image = [UIImage imageNamed:@"avatar.jpg"];
    _avatarView.layer.cornerRadius = 20;
    _avatarView.layer.masksToBounds = YES;
    _avatarView.layer.borderWidth = 0.5;
    _avatarView.layer.borderColor = [UIColor blueColor].CGColor;
    [self.contentView addSubview:_avatarView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 50, 20)];
    _nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_nameLabel];
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 80, 20)];
    _messageLabel.textColor = [UIColor blackColor];
    _messageLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_messageLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 60, 10, 50, 20)];
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timeLabel];
    
    _redDotLabel = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 50, 30, 40, 20)];
    _redDotLabel.layer.cornerRadius = 10;
    _redDotLabel.textColor = [UIColor whiteColor];
    _redDotLabel.layer.backgroundColor = [UIColor redColor].CGColor;
    _redDotLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_redDotLabel];
}

@end
