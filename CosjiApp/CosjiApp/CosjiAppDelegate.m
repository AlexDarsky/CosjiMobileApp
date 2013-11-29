//
//  CosjiAppDelegate.m
//  CosjiApp
//
//  Created by AlexZhu on 13-7-11.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiAppDelegate.h"
#import "MobileProbe.h"
#import "CosjiViewController.h"
#import "CosjiSpecialActivityViewController.h"
#import "CosjiTBViewController.h"
#import "CosjiUserViewController.h";
#import "CosjiViewStoreFanliController.h"
#define kAppKey             @"21428060"
#define kAppSecret          @"dda4af6d892e2024c26cd621b05dd2d0"
#define kAppRedirectURI     @"http://cosjii.com"

@implementation CosjiAppDelegate
@synthesize viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UITabBarController *rootTabBarController=[[UITabBarController alloc] init];
    CosjiSpecialActivityViewController *specialActivityViewController=[[CosjiSpecialActivityViewController alloc] initWithNibName:@"CosjiSpecialActivityViewController" bundle:nil];
    CosjiTBViewController *taoBaoFanliViewController=[[CosjiTBViewController alloc] initWithNibName:@"CosjiTBViewController" bundle:nil];
    CosjiUserViewController *userViewController=[[CosjiUserViewController alloc] initWithNibName:@"CosjiUserViewController" bundle:nil];    
    self.viewController=[[CosjiViewController alloc] init];
    UINavigationController *mainNavCon=[[UINavigationController alloc] initWithRootViewController:self.viewController];
    mainNavCon.navigationBarHidden=YES;
    UINavigationController *tbFanliNavCon=[[UINavigationController alloc] initWithRootViewController:taoBaoFanliViewController];
    tbFanliNavCon.navigationBarHidden=YES;
    rootTabBarController.viewControllers=[NSArray arrayWithObjects:mainNavCon,tbFanliNavCon,specialActivityViewController,userViewController, nil];
    //设置tab bar item 图标的
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"logined"];
    [mainNavCon.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"首页-动态"] withFinishedUnselectedImage:[UIImage imageNamed:@"首页-默认"] ];
    [mainNavCon.tabBarItem setTitle:@"首页"];
    [tbFanliNavCon.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"淘宝-动态"]  withFinishedUnselectedImage:[UIImage imageNamed:@"淘宝-默认"]];
    [tbFanliNavCon.tabBarItem setTitle:@"淘宝返利"];
    [specialActivityViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"九元购-动态"] withFinishedUnselectedImage:[UIImage imageNamed:@"九元购-默认"]];
    [specialActivityViewController.tabBarItem setTitle:@"独享九元包邮"];
    [userViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"我的可及-动态"] withFinishedUnselectedImage:[UIImage imageNamed:@"我的可及-默认"]];
    [userViewController.tabBarItem setTitle:@"我的可及"];
    [rootTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"导航条"]];
       [MobileProbe initWithAppKey:@"cnzz.i_fmgf4sxqars5re7in5qrcg63" channel:@"iOSChannel"];
    //add transaction observer
    self.window.rootViewController = rootTabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //    TopAppConnector *appConnector = [TopAppConnector getAppConnectorbyAppKey:@"12642644"];
    //
    //    [appConnector receiveMessageFromApp:[url absoluteString]];
    

    
    return YES;
}

@end
