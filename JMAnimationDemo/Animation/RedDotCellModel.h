//
//  RedDotCellModel.h
//  JMAnimationDemo
//
//  Created by jm on 16/3/18.
//  Copyright © 2016年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedDotCellModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSNumber *messageCount;
@property (nonatomic, strong) UIImage *avatar;
@property (nonatomic, assign) BOOL contentViewHidden;

@end
