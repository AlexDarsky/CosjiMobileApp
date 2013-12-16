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

@interface CosjiSettingViewController ()

@end

@implementation CosjiSettingViewController

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
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"我的可及-系统设置-背景"]];
    self.myTableView=[[UITableView alloc] initWithFrame:CGRectMake(40, 0, 280,[UIScreen mainScreen].bounds.size.height-49)];
   // self.myTableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"我的可及-系统设置-背景"]];
    self.myTableView.backgroundColor=[UIColor clearColor];
    [self.myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.myTableView setSeparatorColor:[UIColor grayColor]];
    self.myTableView.backgroundView=nil;
    self.myTableView.dataSource=self;
    self.myTableView.delegate=self;
    [self.view addSubview:self.myTableView];
    itemArray=[[NSArray alloc] initWithObjects:@"用户指南",@"返利问题",@"常见问题",@"客服在线",@"分享软件",@"意见反馈",@"清除缓存",@"检测更新",@"流量节省模式", nil];

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
        return 5;
    }else
    return 4;
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
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row==3)
            {
                UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 34, 30)];
                NSString *cellName=[NSString stringWithFormat:@"%@",[itemArray objectAtIndex:indexPath.row]];
                [iconImage setImage:[UIImage imageNamed:cellName]];
                UILabel *cellLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 5, 80, 30)];
                cellLabel.text=[NSString stringWithFormat:@"%@",[itemArray objectAtIndex:indexPath.row]];
                UILabel *number=[[UILabel alloc] initWithFrame:CGRectMake(130, 5, 150, 30)];
                number.font=[UIFont fontWithName:@"Arial" size:12];
                number.text=@"400-00347-678";
                cellLabel.textColor=number.textColor=[UIColor lightTextColor];
                cellLabel.backgroundColor=number.backgroundColor=[UIColor clearColor];
                [cell addSubview:iconImage];
                [cell addSubview:cellLabel];
                [cell addSubview:number];
            }else
            {
                UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 34, 30)];
                NSString *cellName=[NSString stringWithFormat:@"%@",[itemArray objectAtIndex:indexPath.row]];
                [iconImage setImage:[UIImage imageNamed:cellName]];
                UILabel *cellLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 5, 240, 30)];
                cellLabel.text=[NSString stringWithFormat:@"%@",[itemArray objectAtIndex:indexPath.row]];
                cellLabel.backgroundColor=[UIColor clearColor];
                cellLabel.textColor=[UIColor lightTextColor];

                [cell addSubview:iconImage];
                [cell addSubview:cellLabel];

            }
        }
            break;
        case 1:
        {
            if (indexPath.row==3)
            {
                UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 34, 30)];
                NSString *cellName=[NSString stringWithFormat:@"%@",[itemArray objectAtIndex:indexPath.row+5]];
                [iconImage setImage:[UIImage imageNamed:cellName]];
                UILabel *cellLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 5, 240, 30)];
                cellLabel.text=[NSString stringWithFormat:@"%@",[itemArray objectAtIndex:indexPath.row+5]];
                cellLabel.backgroundColor=[UIColor clearColor];
                cellLabel.textColor=[UIColor lightTextColor];
                [cell addSubview:iconImage];
                [cell addSubview:cellLabel];
                
            }else
            {
                UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 34, 30)];
                NSString *cellName=[NSString stringWithFormat:@"%@",[itemArray objectAtIndex:indexPath.row+5]];
                [iconImage setImage:[UIImage imageNamed:cellName]];
                UILabel *cellLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 5, 240, 30)];
                cellLabel.text=[NSString stringWithFormat:@"%@",[itemArray objectAtIndex:indexPath.row+5]];
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
                    [userHelpViewController setUserHelpFor:30];
                    [userHelpViewController.titleLabel setText:[NSString stringWithFormat:@"%@",[itemArray objectAtIndex:indexPath.row]]];
                    
                }
                    break;
                case 2:
                {
                    CosjiUserHelpViewController *userHelpViewController=[CosjiUserHelpViewController shareCosjiUserHelpViewController];
                    NSLog(@"%@",[itemArray objectAtIndex:indexPath.row]);
                    [self presentViewController:userHelpViewController animated:YES completion:nil];
                    [userHelpViewController setUserHelpFor:29];
                    [userHelpViewController.titleLabel setText:[NSString stringWithFormat:@"%@",[itemArray objectAtIndex:indexPath.row]]];

                }
                    break;
                case 3:
                {
                    NSLog(@"打电话");
                    NSString *num = [[NSString alloc] initWithFormat:@"tel://400-0034-7678"];                     
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; 
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
                    
                }
                    break;
                case 1:
                {
                    NSLog(@"清除缓存");
                    [CosjiFileManager quickCleanCacheFile];
                    
                }
                    break;
                case 2:
                {
                    NSLog(@"检测更新");
                    CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
                    [serverHelper jsonTest];
                }
                    break;
                case 3:
                {
                    NSLog(@"流量节省模式");
                }
                    break;
            }

        }
            
            break;
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
