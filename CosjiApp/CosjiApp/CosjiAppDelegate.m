//
//  CosjiAppDelegate.m
//  CosjiApp
//
//  Created by AlexZhu on 13-7-11.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiAppDelegate.h"
#import "MobClick.h"
#import "CosjiViewController.h"
#import "CosjiSpecialActivityViewController.h"
#import "CosjiTBViewController.h"
#import "CosjiUserViewController.h"
#import <BaiduSocialShare/BDSocialShareSDK.h>
//#define CosjiAppKey             @"21602410"
//#define CosjiAppSecret          @"40b803eb95d919f230118ad0095bf55d"
//#define CosjiAppRedirectURI     @"http://cosjii.com"

@implementation CosjiAppDelegate
@synthesize viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   // self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    rootTabBarController=[[UITabBarController alloc] init];
    CosjiSpecialActivityViewController *specialActivityViewController=[[CosjiSpecialActivityViewController alloc] init];
    CosjiTBViewController *taoBaoFanliViewController=[[CosjiTBViewController alloc] init];
    CosjiUserViewController *userViewController=[[CosjiUserViewController alloc] init];    
    self.viewController=[[CosjiViewController alloc] init];
    //self.viewController.view.frame=CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    UINavigationController *mainNavCon=[[UINavigationController alloc] initWithRootViewController:self.viewController];
    mainNavCon.navigationBarHidden=YES;
    UINavigationController *tbFanliNavCon=[[UINavigationController alloc] initWithRootViewController:taoBaoFanliViewController];
    tbFanliNavCon.navigationBarHidden=YES;
    UINavigationController *sANavCon=[[UINavigationController alloc] initWithRootViewController:specialActivityViewController];
    sANavCon.navigationBarHidden=YES;
    rootTabBarController.viewControllers=[NSArray arrayWithObjects:mainNavCon,tbFanliNavCon,sANavCon,userViewController, nil];
    //设置tab bar item 图标的
    //[[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"logined"];
    [mainNavCon.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"新首页-动态"] withFinishedUnselectedImage:[UIImage imageNamed:@"新首页-默认"] ];
    [mainNavCon.tabBarItem setTitle:@"首页"];
    [tbFanliNavCon.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"新淘宝-动态"]  withFinishedUnselectedImage:[UIImage imageNamed:@"新淘宝-默认"]];

    [tbFanliNavCon.tabBarItem setTitle:@"返利通道"];
    [sANavCon.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"新折扣优惠-动态"] withFinishedUnselectedImage:[UIImage imageNamed:@"新折扣优惠-默认"]];
    [sANavCon.tabBarItem setTitle:@"折扣优惠"];
    [userViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"新我的可及-动态"] withFinishedUnselectedImage:[UIImage imageNamed:@"新我的可及-默认"]];
    [userViewController.tabBarItem setTitle:@"我的可及"];
    [rootTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"新导航"]];
    [rootTabBarController.tabBar setSelectionIndicatorImage:nil];
    [MobClick startWithAppkey:@"54828f99fd98c56609000014" reportPolicy:BATCH   channelId:@"Web"];
    //add transaction observer
    self.window.rootViewController = rootTabBarController;
   [self initCustomTabBarView];
    if ([[NSUserDefaults standardUserDefaults] floatForKey:@"APPversion"]==NSNotFound||[[NSUserDefaults standardUserDefaults] floatForKey:@"APPversion"]<1.1)
    {
        [[NSUserDefaults standardUserDefaults] setFloat:1.1 forKey:@"APPversion"];
    }
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"lowMode"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"lowMode"];
    }
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"haveRated"])
    {
        int openTime=[[NSUserDefaults standardUserDefaults] integerForKey:@"openTime"];
        NSLog(@"已经入了%d次",openTime);
        openTime++;
        [[NSUserDefaults standardUserDefaults] setInteger:openTime forKey:@"openTime"];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert| UIRemoteNotificationTypeBadge| UIRemoteNotificationTypeSound];
        NSArray *platforms = [NSArray arrayWithObjects:kBD_SOCIAL_SHARE_PLATFORM_SINAWEIBO,kBD_SOCIAL_SHARE_PLATFORM_QQWEIBO,kBD_SOCIAL_SHARE_PLATFORM_QQZONE,kBD_SOCIAL_SHARE_PLATFORM_KAIXIN,kBD_SOCIAL_SHARE_PLATFORM_WEIXIN_SESSION,kBD_SOCIAL_SHARE_PLATFORM_WEIXIN_TIMELINE,kBD_SOCIAL_SHARE_PLATFORM_QQFRIEND,kBD_SOCIAL_SHARE_PLATFORM_EMAIL,kBD_SOCIAL_SHARE_PLATFORM_SMS,kBD_SOCIAL_SHARE_PLATFORM_RENREN,nil];
        //初始化社交组件,supportPlatform 参数可以是 nil,代表支持所有平台
        [BDSocialShareSDK registerApiKey:@"4OrkK82k7o41mwYFsWAw4WYd" andSupportPlatforms:platforms];
        [BDSocialShareSDK registerWXApp:@"wxd566dac57b6b1f5f"];

        CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AutoLogin"])
        {
            [serverHelper quickLogin];
        }else
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"havelogined"];
    });
    if (launchOptions != nil) {
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [self.viewController detailRemoteNotification:userInfo];
    }
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)initCustomTabBarView
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version < 7.0)
    {
        customTabBarView=[[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-49, 320, 49)];
        [customTabBarView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"新导航"]]];
        
    }else
    {
        customTabBarView=[[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-49, 320, 49)];
        [customTabBarView setBackgroundColor:[UIColor colorWithRed:79.0/255.0 green:72.0/255.0 blue:66.0/255.0 alpha:1]];
    }

    [rootTabBarController.view addSubview:customTabBarView];
    NSArray *itemsArray=[NSArray arrayWithObjects:@"新首页",@"新返利通道",@"新折买团购",@"新我的可及", nil];
    for (int x=0; x<[itemsArray count]; x++)
    {
        UIButton *indexButton=[UIButton buttonWithType:UIButtonTypeCustom];
        indexButton.frame=CGRectMake(162/2*x, -5, 152/2, 90/2);
        [indexButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-动态",[itemsArray objectAtIndex:x]]] forState:UIControlStateSelected];
        NSString *nameString=[NSString stringWithFormat:@"%@",[itemsArray objectAtIndex:x]];
        [indexButton setTitle:[nameString stringByReplacingOccurrencesOfString:@"新" withString:@""] forState:UIControlStateNormal];
        [indexButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [indexButton setTitleColor:[UIColor colorWithRed:131.0/255.0 green:119.0/255.0 blue:113.0/255.0 alpha:100] forState:UIControlStateNormal];
        [indexButton.titleLabel setFont:[UIFont fontWithName:@"Arial" size:10]];
        [indexButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [indexButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 1, -40, 0)];
        [indexButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-默认",[itemsArray objectAtIndex:x]]] forState:UIControlStateNormal];
        [customTabBarView addSubview:indexButton];
        if (x==0) {
            indexButton.selected=YES;
        }
        indexButton.tag=x;
        [indexButton addTarget:self action:@selector(indexButtonSelect:) forControlEvents:UIControlEventTouchDown];
    }
    [rootTabBarController.view addSubview:customTabBarView];
    [self hideTabBar:YES];
}
-(void)indexButtonSelect:(UIButton*)indexBtn
{
    if (indexBtn.selected==NO) {
        
    
    for (UIButton *tmpBtn in customTabBarView.subviews)
    {
        if (tmpBtn.tag==indexBtn.tag)
        {
            tmpBtn.selected=YES;
            rootTabBarController.selectedIndex=tmpBtn.tag;
        }else
        {
            tmpBtn.selected=NO;
        }
    }
    }
}
- (void) hideTabBar:(BOOL) hidden{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    
    for(UIView *view in rootTabBarController.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, [UIScreen mainScreen].bounds.size.height+20, view.frame.size.width, view.frame.size.height)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, [UIScreen mainScreen].bounds.size.height-49-20, view.frame.size.width, view.frame.size.height)];
            }
        }
    }
    
    [UIView commitAnimations];
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
    [SVProgressHUD dismiss];
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
//    TopAppConnector *appConnector = [TopAppConnector getAppConnectorbyAppKey:CosjiAppKey];
//    [appConnector receiveMessageFromApp:[url absoluteString]];
//    return YES;
   return [BDSocialShareSDK handleOpenURL:url];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    [self.viewController detailRemoteNotification:userInfo];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL*)url
{
    
    return YES;
}
@end
