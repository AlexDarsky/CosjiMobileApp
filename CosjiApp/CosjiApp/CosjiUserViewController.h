//
//  CosjiUserViewController.h
//  CosjiApp
//
//  Created by Darsky on 13-7-14.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CosjiSettingViewController.h"
#import "CosjiFanLiListViewController.h"
#import "CosjiAccountViewController.h"

@interface CosjiUserViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (weak, nonatomic) IBOutlet UIView *SliderBackView;
@property (weak, nonatomic) IBOutlet UIView *MainBoard;
@property (weak, nonatomic) IBOutlet UIView *customNavBar;
@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *vipImage;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *jifenbaoLabel;
@property (strong,nonatomic) UIImageView *userHeadImage;
@property (strong,nonatomic) CosjiSettingViewController *settingViewController;
@property (strong,nonatomic) CosjiFanLiListViewController *fanliListViewController;
@property (strong,nonatomic) CosjiAccountViewController *accountViewController;

@end
