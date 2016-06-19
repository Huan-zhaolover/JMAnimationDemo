//
//  AppDelegate.m
//  JMAnimationDemo
//
//  Created by jm on 16/3/14.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [_window makeKeyAndVisible];
    ViewController *VC = [[ViewController alloc] init];
    _window.rootViewController = [[UINavigationController alloc] initWithRootViewController:VC];
    VC.navigationController.navigationBar.barTintColor = [self colorFromRGB:0x99CCCC];
    
    [self initLaunchScreenAnimation];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)initLaunchScreenAnimation {
    UIView *backgroundView = [[UIView alloc] initWithFrame:_window.bounds];
    backgroundView.backgroundColor = [self colorFromRGB:0x99CCCC];
    [_window addSubview:backgroundView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _window.bounds.size.width, _window.bounds.size.height)];
    imageView.image = [self getImageFromView:_window.rootViewController.view];
    [_window addSubview:imageView];
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.contents = (id)[UIImage imageNamed:@"loveShape"].CGImage;
    maskLayer.position = CGPointMake(_window.bounds.size.width/2, _window.bounds.size.height/2 - 0);
    maskLayer.bounds = CGRectMake(0, 0, 60, 60);
    imageView.layer.mask = maskLayer;
    
    UIView *maskBackgroundView = [[UIView alloc] initWithFrame:imageView.bounds];
    maskBackgroundView.backgroundColor = [UIColor whiteColor];
    [imageView addSubview:maskBackgroundView];
    [imageView bringSubviewToFront:maskBackgroundView];
    
    CAKeyframeAnimation *logoMaskAnimation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    logoMaskAnimation.duration = 1.0f;
    
    CGRect initalBounds = maskLayer.bounds;
    CGRect secondBounds = CGRectMake(0, 0, 30, 30);
    CGRect finalBounds = CGRectMake(0, 0, 2000, 2000);
    
    logoMaskAnimation.values = @[[NSValue valueWithCGRect:initalBounds], [NSValue valueWithCGRect:secondBounds], [NSValue valueWithCGRect:finalBounds]];
    logoMaskAnimation.keyTimes = @[@(0), @(0.5),@(1)];
    logoMaskAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    logoMaskAnimation.removedOnCompletion = NO;
    logoMaskAnimation.beginTime = CACurrentMediaTime() + 1.0f;
    logoMaskAnimation.fillMode = kCAFillModeForwards;
    [imageView.layer.mask addAnimation:logoMaskAnimation forKey:@"logoMaskAnimation"];
    
    [UIView animateWithDuration:0.5 delay:1.35 options:UIViewAnimationOptionCurveEaseIn animations:^{
        maskBackgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [maskBackgroundView removeFromSuperview];
    }];
    
    [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionTransitionNone  animations:^{
        imageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            imageView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
            [backgroundView removeFromSuperview];
        }];
    }];
}

- (UIColor *)colorFromRGB:(NSInteger)RGBValue {
    return [UIColor colorWithRed:((float)((RGBValue & 0xFF0000) >> 16))/255.0 green:((float)((RGBValue & 0xFF00) >> 8))/255.0 blue:((float)(RGBValue & 0xFF))/255.0 alpha:1.0];
}

- (UIImage *)getImageFromView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, UIScreen.mainScreen.scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
