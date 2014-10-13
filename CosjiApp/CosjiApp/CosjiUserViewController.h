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
#import "CosjiGetCashViewController.h"
#import "CosjiMessageViewController.h"
#import "CosjiAccountSettingViewController.h"
#import "CosjiGetCashJifenbaoViewController.h"

@interface CosjiUserViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (strong, nonatomic)  UIView *MainBoard;
@property (strong, nonatomic)  UIView *customNavBar;
@property (strong, nonatomic)  UIView *userInfoView;
@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic)  UILabel *userName;
@property (strong, nonatomic) UIButton *tixianBtn;
@property (strong, nonatomic) UIButton *tijifenbaoBtn;
@property (strong, nonatomic) UIButton *qiandaoBtn;
@property (strong,nonatomic) UIView *tixianLineView;
@property (strong, nonatomic)  UIButton *vipImage;
@property (strong, nonatomic)  UILabel *balanceLabel;
@property (strong, nonatomic)  UILabel *scoreLabel;
@property (strong, nonatomic)  UILabel *jifenbaoLabel;
@property (strong,nonatomic) UIImageView *userHeadImage;
@property (strong,nonatomic) CosjiSettingViewController *settingViewController;
@property (strong,nonatomic) CosjiFanLiListViewController *fanliListViewController;
@property (strong,nonatomic) CosjiAccountViewController *accountViewController;
@property (strong,nonatomic) CosjiGetCashViewController *getCashViewController;
@property (strong,nonatomic) CosjiGetCashJifenbaoViewController *getCashJifenbaoViewController;
@property (strong,nonatomic) CosjiMessageViewController *messageViewController;
@property (strong,nonatomic) CosjiAccountSettingViewController *accountSettingViewController;

-(void)hideUserInfoView:(BOOL)isHide;
-(void)userQuite;
- (IBAction)showOrHideBackView:(id)sender;
-(void)toMessageViewController:(int)order;
@end
