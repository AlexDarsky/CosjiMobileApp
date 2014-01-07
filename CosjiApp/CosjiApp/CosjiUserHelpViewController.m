//
//  CosjiUserHelpViewController.m
//  CosjiApp
//
//  Created by Darsky on 13-10-15.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiUserHelpViewController.h"
#import "CosjiServerHelper.h"
#import "SVProgressHUD.h"

@interface CosjiUserHelpViewController ()

@end

@implementation CosjiUserHelpViewController
@synthesize tableView,customNavBar;
static CosjiUserHelpViewController *shareCosjiUserHelpViewController = nil;

+(CosjiUserHelpViewController *)shareCosjiUserHelpViewController;
{
    if (shareCosjiUserHelpViewController == nil) {
        shareCosjiUserHelpViewController = [[super allocWithZone:NULL] init];
    }
    return shareCosjiUserHelpViewController;
}
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
    UIView *primary=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view=primary;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"我的可及-系统设置-背景"]];
    self.customNavBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    self.customNavBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
    self.titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(90, 0, 140, 40)];
    self.titleLabel.backgroundColor=[UIColor clearColor];
    self.titleLabel.textColor=[UIColor whiteColor];
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    [self.customNavBar addSubview:self.titleLabel];
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(11, 2.5, 100/2, 80/2);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self  action:@selector(dismisThisViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavBar addSubview:backBtn];
        [self.view addSubview:self.customNavBar];
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 45, 320, [UIScreen mainScreen].bounds.size.height-45) style:UITableViewStyleGrouped];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.backgroundView=nil;
    [self.view addSubview:self.tableView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    itemsArray=[[NSMutableArray alloc] initWithCapacity:0];
    currentID=0;
    selectedSection=99;

    
}
-(void)setUserHelpFor:(int)requestID
{
    [SVProgressHUD showWithStatus:@"正在载入..."];
    if ([itemsArray count]>0)
    {
        [itemsArray removeAllObjects];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"catId%d",requestID]]==nil)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
            NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:[NSString stringWithFormat:@"/help/?catId=%d",requestID]]];
            if ([tmpDic objectForKey:@"body"]!=nil)
            {
                [[NSUserDefaults standardUserDefaults] setObject:tmpDic forKey:[NSString stringWithFormat:@"catId%d",requestID]];
                itemsArray=[NSMutableArray arrayWithArray:[tmpDic objectForKey:@"body"]];
                [SVProgressHUD dismiss];
                NSLog(@"get items %d",[itemsArray count]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                
            }else
            {
                [SVProgressHUD dismiss];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"服务器无法连接,请稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
                [alert show];
            }
        });

    }else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"catId%d",requestID]]];
            if ([tmpDic objectForKey:@"body"]!=nil)
            {
                [[NSUserDefaults standardUserDefaults] setObject:tmpDic forKey:[NSString stringWithFormat:@"catId%d",requestID]];
                itemsArray=[NSMutableArray arrayWithArray:[tmpDic objectForKey:@"body"]];
                NSLog(@"get items %d",[itemsArray count]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [self.tableView reloadData];
                });
                
            }else
            {
                [SVProgressHUD dismiss];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"服务器无法连接,请稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
                [alert show];
            }
        });

    }
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==selectedSection) {
        return 2;
    }else
    return 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [itemsArray count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 44;
    }else
    return 180;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // static NSString *cellIdentifier = @"MyCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    NSDictionary *itemDic=[NSDictionary dictionaryWithDictionary:[itemsArray objectAtIndex:indexPath.section]];
    if (indexPath.row==0) {
        UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 40)];
        title.text=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"title"]];
        title.adjustsFontSizeToFitWidth=YES;
        title.backgroundColor=[UIColor clearColor];
        [cell addSubview:title];
    }
    else
    {
        UITextView *contextView=[[UITextView alloc] initWithFrame:CGRectMake(20, 10, 280, 160)];
        contextView.text=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"content"]];
        contextView.backgroundColor=[UIColor clearColor];
        [cell addSubview:contextView];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedSection==99) {
        self.tableView.userInteractionEnabled=NO;
        selectedSection=indexPath.section;
        [self performSelector:@selector(setContentOff) withObject:nil afterDelay:0.3];

    }else
    {
        if (selectedSection!=indexPath.section) {
            NSLog(@"关了再开");

            NSArray *deletPath=[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:selectedSection],nil];
            selectedSection=99;
            [self.tableView deleteRowsAtIndexPaths:deletPath withRowAnimation:UITableViewRowAnimationAutomatic];
            selectedSection=indexPath.section;
            [self performSelector:@selector(setContentOff) withObject:nil afterDelay:0.5];
        }
        else{
            NSLog(@"关");
            NSArray *deletPath=[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:selectedSection],nil];
            selectedSection=99;
            [self.tableView deleteRowsAtIndexPaths:deletPath withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }

    }
    }
-(void)setContentOff
{
    NSLog(@"%d setcontent",selectedSection);
    
    CGPoint point=CGPointMake(0,44*selectedSection);
    [self.tableView setContentOffset:point animated:YES];
    [self performSelector:@selector(addRows) withObject:nil afterDelay:0.3];
}
-(void)addRows
{
    NSLog(@"%d addRows",selectedSection);
   // [self.tableView reloadData];
    NSArray *indexes=[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:selectedSection],nil];
    [self.tableView insertRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationAutomatic];
    self.tableView.userInteractionEnabled=YES;
    // [self performSelector:@selector(resetTableView:) withObject:self.tableView afterDelay:0];
}

-(void)TablereloadData
{
    [self.tableView reloadData];
    [self.tableView setUserInteractionEnabled:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dismisThisViewController:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"firstLaunch"];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidUnload {
    [self setTableView:nil];
    [self setCustomNavBar:nil];
    [self setTitleLabel:nil];
    [super viewDidUnload];
}
@end
