//
//  CosjiTBViewController.h
//  可及网
//
//  Created by Darsky on 13-8-23.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CosjiWebViewController.h"
#import "CosjiUrlFilter.h"

@interface CosjiTBViewController : UIViewController<UITextFieldDelegate,NSURLConnectionDelegate>
{
    UIView *_hotWordView;
}
@property (strong, nonatomic)  UIView *customNavBar;
@property (strong,nonatomic) UITextField *searchField;

@property (strong,nonatomic) UINavigationController *storeBrowse;
@property (strong,nonatomic) UINavigationController *itemsListNavCon;
@property (strong,nonatomic) CosjiWebViewController *webViewController;


@end
