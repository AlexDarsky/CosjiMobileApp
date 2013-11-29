//
//  CosjiLoginViewController.h
//  CosjiApp
//
//  Created by Darsky on 13-10-4.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CosjiLoginViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic)  UITextField *userName;
@property (strong, nonatomic)  UITextField *passWord;
@property (strong, nonatomic)  UIButton *rememberBtn;
@property (strong, nonatomic)  UIButton *registerBtn;
@property (strong, nonatomic)  UIButton *forgetBtn;
+(CosjiLoginViewController*)shareCosjiLoginViewController;
@end
