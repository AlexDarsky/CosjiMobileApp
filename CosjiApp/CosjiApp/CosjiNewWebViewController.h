//
//  CosjiWebViewController.h
//  CosjiApp
//
//  Created by Darsky on 13-7-27.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CosjiNewWebViewController : UIViewController<UIWebViewDelegate>
{
    
}
+(CosjiNewWebViewController*)shareCosjiNewWebViewController;
@property (strong, nonatomic)  UIView *customNavBar;
@property (strong, nonatomic)  UILabel *storeName;
@property (strong, nonatomic) NSString *itemName;

@property (strong, nonatomic)  UIWebView *webView;

@property (strong, nonatomic) NSString *backString;
@property (strong, nonatomic) NSString *urlStirng;

@end
