//
//  CosjiSettingViewController.m
//  CosjiApp
//
//  Created by Darsky on 13-10-5.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiSettingViewController.h"
#import "CosjiUserHelpViewController.h"
#import "CosjiGuideViewController.h"
#import "CosjiUserViewController.h"
#import <Frontia/Frontia.h>

@interface CosjiSettingViewController ()

@end

@implementation CosjiSettingViewController
@synthesize settingDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

-(void)loadView
{
    UIView *primaryView=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view=primaryView;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"我的可及_置_背景"]];

    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version <7.0)
    {
            self.myTableView=[[UITableView alloc] initWithFrame:CGRectMake(40, 0, 280,[UIScreen mainScreen].bounds.size.height-49-20)];
    }else
            self.myTableView=[[UITableView alloc] initWithFrame:CGRectMake(40, 20, 280,[UIScreen mainScreen].bounds.size.height-49)];
   // self.myTableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"我的可及-系统设置-背景"]];
    self.myTableView.backgroundColor=[UIColor clearColor];
    [self.myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.myTableView setSeparatorColor:[UIColor grayColor]];
    self.myTableView.backgroundView=nil;
    self.myTableView.dataSource=self;
    self.myTableView.delegate=self;
    [self.view addSubview:self.myTableView];
    itemArray=[[NSArray alloc] initWithObjects:@"返利教程",@"返利问题",@"常见问题",@"分享软件",@"意见反馈",@"清除缓存",@"检测更新",@"流量节省模式",@"注销账户",nil];
    saveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame=CGRectMake(180, 40/2-43/4, 69/2, 43/2);
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"节省流量模式_默认"] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"设置开关槽-打开"] forState:UIControlStateSelected];
    [saveBtn addTarget:self action:@selector(changeSaveMode) forControlEvents:UIControlEventTouchDown];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"lowMode"]) {
        NSLog(@"初始化打开");
        saveBtn.selected=YES;
    }else
    {
        NSLog(@"初始化不打开");
        saveBtn.selected=NO;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.myTableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark tableviewmethod
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 4;
    }else
    return 5;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 33)];
    switch (section) {
        case 0:
        {
            headerView.backgroundColor=[UIColor clearColor];
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 96, 33)];
            label.text=[NSString stringWithFormat:@"新手帮助"];
            label.font=[UIFont fontWithName:@"Arial" size:14];
            label.backgroundColor=[UIColor clearColor];
            label.textColor=[UIColor darkGrayColor];
            [headerView addSubview:label];
            return headerView;
            
        }
            break;
        case 1:
        {
            headerView.backgroundColor=[UIColor clearColor];
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 96, 33)];
            label.text=[NSString stringWithFormat:@"应用设置"];
            label.font=[UIFont fontWithName:@"Arial" size:14];
            label.backgroundColor=[UIColor clearColor];
            label.textColor=[UIColor darkGrayColor];
            [headerView addSubview:label];
            return headerView;
        }
            break;
    }
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // static NSString *cellIdentifier = @"MyCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >=7.0)
    {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    switch (indexPath.section) {
        case 0:
        {

                UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 3.5/2,  70/2, 73/2)];
                NSString *cellName=[NSString stringWithFormat:@"%@",[itemArray objectAtIndex:indexPath.row]];
                [iconImage setImage:[UIImage imageNamed:cellName]];
                UILabel *cellLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 5, 240, 30)];
                cellLabel.text=[NSString stringWithFormat:@"%@",[itemArray objectAtIndex:indexPath.row]];
                cellLabel.backgroundColor=[UIColor clearColor];
                cellLabel.textColor=[UIColor lightTextColor];
                [cell addSubview:iconImage];
                [cell addSubview:cellLabel];
        }
            break;
        case 1:
        {
            if (indexPath.row==3)
            {
                UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 3.5/2, 70/2, 73/2)];
                NSString *cellName=[NSString stringWithFormat:@"%@",[itemArray objectAtIndex:indexPath.row+4]];
                [iconImage setImage:[UIImage imageNamed:cellName]];
                UILabel *cellLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 5, 240, 30)];
                cellLabel.text=[NSString stringWithFormat:@"%@",[itemArray objectAtIndex:indexPath.row+4]];
                cellLabel.backgroundColor=[UIColor clearColor];
                cellLabel.textColor=[UIColor lightTextColor];
                [cell addSubview:saveBtn];
                [cell addSubview:iconImage];
                [cell addSubview:cellLabel];
            }else
            {
                UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 3.5/2,  70/2, 73/2)];
                NSString *cellName=[NSString stringWithFormat:@"%@",[itemArray objectAtIndex:indexPath.row+4]];
                [iconImage setImage:[UIImage imageNamed:cellName]];
                UILabel *cellLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 5, 240, 30)];
                cellLabel.text=[NSString stringWithFormat:@"%@",[itemArray objectAtIndex:indexPath.row+4]];
                cellLabel.backgroundColor=[UIColor clearColor];
                cellLabel.textColor=[UIColor lightTextColor];
                [cell addSubview:iconImage];
                [cell addSubview:cellLabel];
            }
        }
            break;
    }

    return cell;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField           // became first responder
{
    [textField.window makeKeyAndVisible];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            UITableViewCell *cell=[self.myTableView cellForRowAtIndexPath:indexPath];
            if (grayImageView==nil)
            {
                grayImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
                grayImageView.image=[UIImage imageNamed:@"gerenzhonxin shez"];
            }
            [cell addSubview:grayImageView];
            switch (indexPath.row) {
                case 0:
                {
                    NSLog(@"返利教程");
                    CosjiGuideViewController *guideViewController=[CosjiGuideViewController shareCosjiGuideViewController];
                    [self presentViewController:guideViewController animated:YES completion:nil];
                }
                    break;
                case 1:
                {
                    CosjiUserHelpViewController *userHelpViewController=[CosjiUserHelpViewController shareCosjiUserHelpViewController];
                    [self presentViewController:userHelpViewController animated:YES completion:nil];
                    [userHelpViewController setUserHelpFor:29];
                    [userHelpViewController.titleLabel setText:[NSString stringWithFormat:@"%@",[itemArray objectAtIndex:indexPath.row]]];
                    
                }
                    break;
                case 2:
                {
                    CosjiUserHelpViewController *userHelpViewController=[CosjiUserHelpViewController shareCosjiUserHelpViewController];
                    NSLog(@"%@",[itemArray objectAtIndex:indexPath.row]);
                    [self presentViewController:userHelpViewController animated:YES completion:nil];
                    [userHelpViewController setUserHelpFor:30];
                    [userHelpViewController.titleLabel setText:[NSString stringWithFormat:@"%@",[itemArray objectAtIndex:indexPath.row]]];
                }
                    break;
                case 3:
                {
                    FrontiaShareContent *content = [[FrontiaShareContent alloc] init];
                    content.url = CosjiAppiTunesAddress;
                    content.description = @"可及网是淘宝省钱助手，通过可及网进入淘宝等商城购物最高可返利50%，推荐你也来试一试吧。";
                    content.title = @"可及网";
                    content.imageObj = [UIImage imageNamed:@"Icon"];
                    
                    FrontiaShareCancelCallback onCancel = ^(){
                        NSLog(@"OnCancel: share is cancelled");
                    };
                    
                    //分享失败回调函数
                    FrontiaShareFailureCallback onFailure = ^(int errorCode, NSString *errorMessage){
                        NSLog(@"OnFailure: %d  %@", errorCode, errorMessage);
                    };
                    
                    //分享成功回调函数
                    FrontiaMultiShareResultCallback onResult = ^(NSDictionary *respones){
                        NSArray *successPlatforms = [respones objectForKey:@"success"];
                        NSArray *failPlatforms = [respones objectForKey:@"fail"];
                        
                    };
                    
                    
                    NSArray * sharePlatforms = [NSArray arrayWithObjects:FRONTIA_SOCIAL_SHARE_PLATFORM_SINAWEIBO,FRONTIA_SOCIAL_SHARE_PLATFORM_WEIXIN_SESSION,FRONTIA_SOCIAL_SHARE_PLATFORM_WEIXIN_TIMELINE, nil];
                    
                    FrontiaShare *share = [Frontia getShare];
                    
                    
                    
                    [share showShareMenuWithShareContent:content displayPlatforms:sharePlatforms supportedInterfaceOrientations:UIInterfaceOrientationMaskAllButUpsideDown
                                       isStatusBarHidden:NO
                                        targetViewForPad:nil
                                          cancelListener:^{
                        
                    }
                                         failureListener:^(int errorCode, NSString *errorMessage) {
                        
                    }
                                          resultListener:^(NSDictionary *respones)
                    {
                        
                    }];

                    

                }
                    break;
            }
        }
            break;
        default:
        {
            UITableViewCell *cell=[self.myTableView cellForRowAtIndexPath:indexPath];
            if (grayImageView==nil)
            {
                grayImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
                grayImageView.image=[UIImage imageNamed:@"gerenzhonxin shez"];
            }
            [cell addSubview:grayImageView];
            switch (indexPath.row) {
                case 0:
                {
                    NSLog(@"意见反馈");
                    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"havelogined"] )
                    {
                        [settingDelegate toMessageViewController:1];
                    }else
                    {
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请登录账号" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
                        [alert show];
                    }
                }
                    break;
                case 1:
                {
                    NSLog(@"清除缓存");
                    [CosjiFileManager quickCleanCacheFile];
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"清除缓存成功" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
                    [alert show];
                    
                }
                    break;
                case 2:
                {
                    NSLog(@"检测更新");
                    [SVProgressHUD showWithStatus:@"检测更新..."];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
                        NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:@"/version/check/?type=2"]];
                        NSLog(@"%@",tmpDic);
                        NSDictionary *headDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"head"]];
                        if ([[headDic objectForKey:@"msg"]isEqualToString:@"success"]) {
                           NSDictionary *bodyDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
                            NSString *versionString=[NSString stringWithFormat:@"%@",[bodyDic objectForKey:@"version"]];
                            if ([versionString floatValue]>=[[NSUserDefaults standardUserDefaults] floatForKey:@"APPversion"]) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [SVProgressHUD dismiss];
                                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"已有新版本,是否前往更新" delegate:self cancelButtonTitle:@"不了" otherButtonTitles:@"马上更新", nil];
                                    alert.tag=1;
                                    [alert show];
                                });
                            }else
                            {
                                 [SVProgressHUD dismissWithSuccess:@"您使用的是最新版本" afterDelay:3.0];
                            }
                           
                        }else
                        {
                            [SVProgressHUD dismiss];
                            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器无法连接，请稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
                            [alert show];
                         //   [SVProgressHUD dismissWithSuccess:@"您已是最新版本" afterDelay:3.0];
                        }
                    });
                }
                    break;
                case 3:
                {
                    NSLog(@"流量节省模式");
                    [self changeSaveMode];
                }
                    break;
                case 4:
                {
                    NSLog(@"注销");
                    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"havelogined"] )
                    {
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"havelogined"];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AutoLogin"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
                    [settingDelegate userQuite];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginDic"];
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"已注销用户" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
                    [alert show];
                    [self.myTableView reloadData];
                    }
                }
                    break;
            }

        }
            break;
    }

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1) {
        switch (buttonIndex) {
            case 1:
            {
                NSString *urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/ke-ji-wang-tao-bao-sheng-qian/id802627559?ls=1&mt=8"];
                NSURL *url = [NSURL URLWithString:urlStr];
                [[UIApplication sharedApplication] openURL:url];

            }
                break;
        default:
                break;
        }
    }
}

-(void)changeSaveMode
{
    if (saveBtn.selected==YES)
    {
        NSLog(@"不节省流量");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"lowMode"];
        saveBtn.selected=NO;
    }else
    {
        NSLog(@"节省流量");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"lowMode"];
        saveBtn.selected=YES;
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    if (grayImageView!=nil) {
        [grayImageView removeFromSuperview];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
