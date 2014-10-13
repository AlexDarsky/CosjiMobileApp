//
//  CosjiWebViewController.h
//  CosjiApp
//
//  Created by Darsky on 13-7-27.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CosjiNormalWebViewController : UIViewController<UIWebViewDelegate>
{
    
}
@property (strong, nonatomic)  UIView *customNavBar;
@property (strong, nonatomic)  UILabel *storeName;
@property (strong, nonatomic)  UIWebView *webView;
@property (strong, nonatomic) NSString *backString;

-(void)setThisWebViewWithName:(NSURLRequest*)url name:(NSString*)name;

@end
