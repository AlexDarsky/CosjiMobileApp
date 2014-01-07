//
//  CosjiAccountSettingViewController.h
//  CosjiApp
//
//  Created by Darsky on 13-12-17.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CosjiAccountSettingViewController : UIViewController<UITextFieldDelegate>
{
    int settingMode;
}
@property (strong, nonatomic)  UIView *customNarBar;
@property (strong, nonatomic)  UILabel *settingTitle;
@property (strong, nonatomic)  UISegmentedControl *segmentCon;
@end
