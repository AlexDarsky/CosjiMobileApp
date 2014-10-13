//
//  CosjiAppDelegate.h
//  CosjiApp
//
//  Created by AlexZhu on 13-7-11.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BPush.h"
@class CosjiViewController;

@interface CosjiAppDelegate : UIResponder <UIApplicationDelegate, BPushDelegate>
{
    UITabBarController *rootTabBarController;
    UIView *customTabBarView;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CosjiViewController *viewController;

//+(void)hideCustomTabBar;

@end
