//
//  CosjiMessageViewController.m
//  CosjiApp
//
//  Created by Darsky on 13-12-12.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiMessageViewController.h"
#import "CosjiServerHelper.h"
#import "SVProgressHUD.h"
@interface CosjiMessageViewController ()

@end

@implementation CosjiMessageViewController

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
    [super loadView];
    UIView *primary=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view=primary;
    self.customNarBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    self.customNarBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(90, 0, 140, 40)];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[UIColor whiteColor];
    title.text=@"站内消息";
    title.textAlignment=NSTextAlignmentCenter;
    [self.customNarBar addSubview:title];
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(11, 12, 60/2, 41/2);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self  action:@selector(exitThisView:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNarBar addSubview:backBtn];
    [self.view addSubview:self.customNarBar];
    [self.view setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:100]];
    
    self.segmentCon=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"收到的消息",@"意见反馈", nil]];
    self.segmentCon.frame=CGRectMake(-10, 45, 340, 29);
    self.segmentCon.multipleTouchEnabled=NO;
    [self.segmentCon setSelectedSegmentIndex:0];
    messageMode=self.segmentCon.selectedSegmentIndex;
    [self.segmentCon addTarget:self action:@selector(loadFanLiListFor:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentCon];
    self.listTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 74, 320, [UIScreen mainScreen].bounds.size.height-74) style:UITableViewStyleGrouped];
    self.listTableView.dataSource=self;
    self.listTableView.delegate=self;
    self.listTableView.backgroundView=nil;
    [self.view addSubview:self.listTableView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self loadFanLiListFor:self.segmentCon];
}

-(void)loadFanLiListFor:(UISegmentedControl *)Seg
{
    [SVProgressHUD showWithStatus:@"正在载入..."];
    if ([itemsArray count]>0)
    {
        [itemsArray removeAllObjects];
    }
    NSInteger Index = Seg.selectedSegmentIndex;
    messageMode=Index;
    currentPage=1;
    NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
    NSDictionary *infoDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
    self.userID=[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"userId"]];
    NSString *requestURL=[NSString stringWithFormat:@"/message/"];
    switch (messageMode) {
        case 0:
        {
            requestURL=[requestURL stringByAppendingFormat:@"inbox/"];
            
        }
            break;
        case 1:
        {
            requestURL=[requestURL stringByAppendingFormat:@"outbox/"];
        }
            break;
    }
    requestURL=[requestURL stringByAppendingFormat:@"?userID=%@&num=10&page=%d",self.userID,currentPage];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
        NSDictionary *requestDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:requestURL]];
        if (requestDic!=nil)
        {
            NSDictionary *recordDic=[NSDictionary dictionaryWithDictionary:[requestDic objectForKey:@"body"]];
            itemsArray=[NSMutableArray arrayWithArray:[recordDic objectForKey:@"record"]];
            NSLog(@"get Store %d",[itemsArray count]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [self.listTableView reloadData];
            });
            
        }else
        {
            [SVProgressHUD dismiss];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"服务器无法连接，请稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
        }
    });
}
#pragma mark tableviewmethod
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [itemsArray count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height;
    switch (messageMode) {
        case 0:
        {
            height=265/2;
        }
            break;
        case 1:
        {
            height=160/2;;
        }
            break;
}
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // static NSString *cellIdentifier = @"MyCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    NSDictionary *itemDic=[NSDictionary dictionaryWithDictionary:[itemsArray objectAtIndex:indexPath.section]];
    UILabel *timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 0, 240, 65/2)];
    timeLabel.backgroundColor=[UIColor clearColor];
    timeLabel.textColor=[UIColor lightGrayColor];
    timeLabel.font=[UIFont fontWithName:@"Arial" size:14];
    timeLabel.text=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"time"]];
    [cell addSubview:timeLabel];
    UITextView *content=[[UITextView alloc] initWithFrame:CGRectMake(10, 65/2, 300, 200/2)];
    content.text=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"content"]];
    content.backgroundColor=[UIColor clearColor];
    content.editable=NO;
    [cell addSubview:content];
    UIButton *editBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setBackgroundImage:[UIImage imageNamed:@"登陆页-记住密码-默认"] forState:UIControlStateNormal];
    [editBtn setBackgroundImage:[UIImage imageNamed:@"登陆页-记住密码-动态"] forState:UIControlStateSelected];
    editBtn.frame=CGRectMake(20, 0, 42/2, 43/2);
    editBtn.tag=indexPath.section;
    [cell addSubview:editBtn];
    return cell;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)exitThisView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
