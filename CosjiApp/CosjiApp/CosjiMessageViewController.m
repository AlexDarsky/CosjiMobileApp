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
#import "CosjiMessagCell.h"

@interface CosjiMessageViewController ()
{
    UIButton *selectBtn;
    UITextField *messageSenderField;
    UIButton *messageSendBtn;
    UIButton *deleteBtn;
    UILabel *selectAllLabel;
}
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
    self.listTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 74, 320, [UIScreen mainScreen].bounds.size.height-74-100/2) style:UITableViewStyleGrouped];
    self.listTableView.dataSource=self;
    self.listTableView.delegate=self;
    self.listTableView.backgroundView=nil;
    [self.view addSubview:self.listTableView];
    self.buttomToolBar=[[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-100/2-20, 320, 100/2)];
    [self.buttomToolBar setBackgroundColor:[UIColor colorWithRed:70.0/255.0 green:59.0/255.0 blue:55.0/255.0 alpha:100]];
    [self.view addSubview:self.buttomToolBar];
    selectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame=CGRectMake(10, self.buttomToolBar.frame.size.height/2-43/4, 42/2, 43/2);
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"登陆页-记住密码-默认"] forState:UIControlStateNormal];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"登陆页-记住密码-动态"] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(selectAllCell:) forControlEvents:UIControlEventTouchDown];
    [self.buttomToolBar addSubview:selectBtn];
    selectAllLabel=[[UILabel alloc] initWithFrame:CGRectMake(selectBtn.frame.origin.x+selectBtn.frame.size.width+5, selectBtn.frame.origin.y, 74/2, 40/2)];
    selectAllLabel.text=@"全选";
    selectAllLabel.backgroundColor=[UIColor clearColor];
    selectAllLabel.textColor=[UIColor whiteColor];
    selectAllLabel.adjustsFontSizeToFitWidth=YES;
    [self.buttomToolBar addSubview:selectAllLabel];
    deleteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame=CGRectMake(258/2, self.buttomToolBar.frame.size.height/2-66/4, 120/2, 66/2);
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setBackgroundColor:[UIColor redColor]];
    [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchDown];
    [self.buttomToolBar addSubview:deleteBtn];
    messageSenderField=[[UITextField alloc] initWithFrame:CGRectMake(10, self.buttomToolBar.frame.size.height/2-86/4, 469/2, 80/2)];
    messageSenderField.returnKeyType=UIReturnKeyDone;
    messageSenderField.delegate=self;
    messageSenderField.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    messageSenderField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [messageSenderField setBackground:[UIImage imageNamed:@"登陆页-登陆框-动态"]];
    [self.buttomToolBar addSubview:messageSenderField];
    messageSendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    messageSendBtn.frame=CGRectMake(self.buttomToolBar.frame.size.width-120/2-10, self.buttomToolBar.frame.size.height/2-64/4, 120/2, 64/2);
    [messageSendBtn setBackgroundColor:[UIColor redColor]];
    [messageSendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchDown];
    [messageSendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [self.buttomToolBar addSubview:messageSendBtn];
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
        [selectedArray removeAllObjects];
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
            selectBtn.hidden=deleteBtn.hidden=NO;
            messageSenderField.hidden=messageSendBtn.hidden=YES;
        }
            break;
        case 1:
        {
            requestURL=[requestURL stringByAppendingFormat:@"outbox/"];
            selectBtn.hidden=deleteBtn.hidden=YES;
            messageSenderField.hidden=messageSendBtn.hidden=NO;
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
            for (int x=0; x<[itemsArray count]; x++) {
                [selectedArray addObject:@"NO"];
            }
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
    CosjiMessagCell *cell = [[CosjiMessagCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

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
    switch (messageMode) {
        case 0:
        {
            UIButton *selectCellBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [selectCellBtn setBackgroundImage:[UIImage imageNamed:@"登陆页-记住密码-默认"] forState:UIControlStateNormal];
            [selectCellBtn setBackgroundImage:[UIImage imageNamed:@"登陆页-记住密码-动态"] forState:UIControlStateSelected];
            selectCellBtn.frame=CGRectMake(20, 5, 42/2, 43/2);
            selectCellBtn.tag=indexPath.section;
            if ([[selectedArray objectAtIndex:indexPath.section] isEqualToString:@"YES"])
            {
                selectCellBtn.selected=YES;
            }
            else
                selectCellBtn.selected=NO;
            [selectCellBtn addTarget:self action:@selector(didSelectedTouched:) forControlEvents:UIControlEventTouchDown];
            [cell addSubview:selectCellBtn];
 
        }
            break;
        default:
            break;
    }
        return cell;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

}
- (void)exitThisView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.buttomToolBar.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height-240-self.buttomToolBar.frame.size.height, self.buttomToolBar.frame.size.width, self.buttomToolBar.frame.size.height);
    
}// became first responder
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    self.buttomToolBar.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height-100/2-20, self.buttomToolBar.frame.size.width, self.buttomToolBar.frame.size.height);
    return YES;
}
-(void)selectAllCell:(UIButton*)sender
{
    if (sender.selected)
    {
        sender.selected=NO;
        [selectedArray removeAllObjects];
        for (int x=0; x<[itemsArray count]; x++) {
            [selectedArray addObject:@"NO"];
        }
        [self.listTableView reloadData];
    }
    else
    {
        sender.selected=YES;
        [selectedArray removeAllObjects];
        for (int x=0; x<[itemsArray count]; x++) {
            [selectedArray addObject:@"YES"];
        }
        [self.listTableView reloadData];
    }
}
-(void)sendAction:(id)sender
{
    if (![messageSenderField.text isEqualToString:@""]&&messageSenderField.text!=nil) {
        NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
        NSDictionary *infoDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
        self.userID=[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"userId"]];
        NSString *requestURL=[NSString stringWithFormat:@"/message/send/"];
        requestURL=[requestURL stringByAppendingFormat:@"?userID=%@&num=10&content=%@",self.userID,messageSenderField.text];
        CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
        NSDictionary *requestDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:requestURL]];
        NSLog(@"%@",requestDic);
        NSDictionary *headDic=[NSDictionary dictionaryWithDictionary:[requestDic objectForKey:@"head"]];
        if ([[headDic objectForKey:@"msg"] isEqualToString:@"success"])
        {
            messageSenderField.text=@"";
            [SVProgressHUD showSuccessWithStatus:@"发送成功" duration:1];
            [self performSelector:@selector(loadFanLiListFor:) withObject:self.segmentCon afterDelay:2];
        }
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"您不能发送空消息" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
   
}
-(void)didSelectedTouched:(UIButton*)sender
{
    if (sender.selected)
    {
        [selectedArray replaceObjectAtIndex:sender.tag withObject:@"NO"];
    }
    else
    {
        [selectedArray replaceObjectAtIndex:sender.tag withObject:@"YES"];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.listTableView reloadSections:[NSIndexSet indexSetWithIndex:[sender tag]] withRowAnimation:    UITableViewRowAnimationNone];

    });
}
-(void)deleteAction:(id)sender
{
    NSMutableIndexSet *deleteIndexSet=[[NSMutableIndexSet alloc] init];
    for (int x=0;x<[selectedArray count];x++)
    {
        if ([[selectedArray objectAtIndex:x] isEqualToString:@"YES"])
        {
            [deleteIndexSet addIndex:x];
        }
    }
    [itemsArray removeObjectsAtIndexes:deleteIndexSet];
    [selectedArray removeObjectsAtIndexes:deleteIndexSet];
    [self.listTableView deleteSections:deleteIndexSet withRowAnimation:UITableViewRowAnimationLeft];
    self.listTableView.userInteractionEnabled=NO;
    [self.listTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
    self.listTableView.userInteractionEnabled=YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    itemsArray=[[NSMutableArray alloc] initWithCapacity:0];
    selectedArray=[[NSMutableArray alloc] initWithCapacity:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end