//
//  CosjiAccountViewController.m
//  CosjiApp
//
//  Created by Darsky on 13-11-28.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiAccountViewController.h"
#import "CosjiServerHelper.h"
#import "CosjiAccountItemView.h"

@interface CosjiAccountViewController ()

@end

@implementation CosjiAccountViewController

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
    UIView *primaryView=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    primaryView.backgroundColor=[UIColor whiteColor];
    self.view=primaryView;
    self.customNavBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.customNavBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
    UIButton *dismissBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [dismissBtn addTarget:self action:@selector(dismisThisViewController:) forControlEvents:UIControlEventTouchUpInside];
    [dismissBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    dismissBtn.frame=CGRectMake(11, 2.5, 100/2, 80/2);
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(90, 2.5, 140, 40)];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[UIColor whiteColor];
    title.text=@"账户明细";
    title.font=[UIFont fontWithName:@"Arial" size:18];
    title.textAlignment=NSTextAlignmentCenter;
    [self.customNavBar addSubview:title];
    [self.customNavBar addSubview:dismissBtn];
    self.myTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 88, 320, [UIScreen mainScreen].bounds.size.height-108)];
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    [self.view addSubview:self.myTableView];
    [self.view addSubview:self.customNavBar];
    self.accountModelSC=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"我的收入",@"我的提现", nil]];
    self.accountModelSC.frame=CGRectMake(-10, 44, 340, 44);
    [self.accountModelSC addTarget:self action:@selector(changeAccountModel:) forControlEvents:UIControlEventValueChanged];
    [self.accountModelSC setSelectedSegmentIndex:0];
    [self.view addSubview:self.accountModelSC];
    accountModel=0;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [SVProgressHUD showWithStatus:@"正在载入..."];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"] isEqualToString:@"YES"])
    {
        if ([itemsArray count]>0)
        {
            [itemsArray removeAllObjects];
        }
        currentPage=1;
        NSDictionary *tmpUserDic=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
        NSDictionary *infoDic=[NSDictionary dictionaryWithDictionary:[tmpUserDic objectForKey:@"body"]];
        NSString *targetURL=nil;
        switch (accountModel) {
            case 0:
            {
                targetURL=[NSString stringWithFormat:@"/account/income/"];
            }
                break;
            default:
            {
                targetURL=[NSString stringWithFormat:@"/account/withdraw/"];
            }
                break;
        }

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
            NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:[NSString stringWithFormat:@"%@?userID=%@&num=10&page=%d",targetURL,[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"userId"]],currentPage]]];
                if ([tmpDic objectForKey:@"body"]!=nil)
                {
                    NSDictionary *recordDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
                    itemsArray=[NSMutableArray arrayWithArray:[recordDic objectForKey:@"record"]];
                    NSLog(@"get Store %d",[itemsArray count]);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.myTableView reloadData];
                    });
                }else
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"服务器无法连接,请稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
                    [alert show];
                }
        });
    }
    [SVProgressHUD dismiss];
}

#pragma mark tableviewmethod


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [itemsArray count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MyCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    switch (accountModel) {
        case 0:
        {
            NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[itemsArray objectAtIndex:indexPath.section]];
            CosjiAccountItemView *itemView=[[CosjiAccountItemView alloc] initWithFrame:CGRectMake(10, 0, cell.frame.size.width-20, 80) withInfo:tmpDic forModel:accountModel];
            itemView.backgroundColor=[UIColor clearColor];
            [cell addSubview:itemView];
        }
            break;
        default:
        {
            NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[itemsArray objectAtIndex:indexPath.section]];
            CosjiAccountItemView *itemView=[[CosjiAccountItemView alloc] initWithFrame:CGRectMake(10, 0, cell.frame.size.width-20, 80) withInfo:tmpDic forModel:accountModel];
            itemView.backgroundColor=[UIColor clearColor];
            [cell addSubview:itemView];
        }
            break;
    }
   
    return cell;
}
-(void)changeAccountModel:(id)sender
{
    [SVProgressHUD showWithStatus:@"正在载入..."];
    if ([itemsArray count]>0)
    {
        [itemsArray removeAllObjects];
    }
    UISegmentedControl *Seg=(UISegmentedControl*)sender;
    NSInteger Index = Seg.selectedSegmentIndex;
    NSDictionary *tmpUserDic=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
    NSDictionary *infoDic=[NSDictionary dictionaryWithDictionary:[tmpUserDic objectForKey:@"body"]];
    currentPage=1;
    accountModel=Index;
    switch (accountModel) {
        case 0:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
                NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:[NSString stringWithFormat:@"/account/income/?userID=%@&num=10&page=%d",[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"userId"]],currentPage]]];
                if ([tmpDic objectForKey:@"body"]!=nil)
                {
                    NSDictionary *recordDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
                    itemsArray=[NSMutableArray arrayWithArray:[recordDic objectForKey:@"record"]];
                    NSLog(@"get Store %d",[itemsArray count]);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                        [self.myTableView reloadData];
                    });
                }else
                {
                    [SVProgressHUD dismiss];
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"服务器无法连接,请稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
                    [alert show];
                }
            });
        }
            break;
        default:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
                NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:[NSString stringWithFormat:@"/account/withdraw/?userID=%@&num=10&page=%d",[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"userId"]],currentPage]]];
                if ([tmpDic objectForKey:@"body"]!=nil)
                {
                    NSDictionary *recordDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
                    itemsArray=[NSMutableArray arrayWithArray:[recordDic objectForKey:@"record"]];
                    NSLog(@"get Store %d",[itemsArray count]);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                        [self.myTableView reloadData];
                    });
                }else
                {
                    [SVProgressHUD dismiss];
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"服务器无法连接,请稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
                    [alert show];
                }
            });
            

        }
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"%f %f",scrollView.contentOffset.y,scrollView.contentSize.height - scrollView.frame.size.height);
    if(scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height))&&scrollView.contentOffset.y>0)
        
    {
        [self getMoreDataFromServer];
    }
    
}
-(void)getMoreDataFromServer
{
    [SVProgressHUD showWithStatus:@"正在载入..."];
    currentPage+=1;
    NSString *targetURL=nil;
    switch (accountModel) {
        case 0:
        {
            targetURL=[NSString stringWithFormat:@"/account/income/"];
        }
            break;
        default:
        {
            targetURL=[NSString stringWithFormat:@"/account/withdraw/"];
        }
            break;
    }
    NSDictionary *tmpUserDic=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
    NSDictionary *infoDic=[NSDictionary dictionaryWithDictionary:[tmpUserDic objectForKey:@"body"]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
        NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:[NSString stringWithFormat:@"%@?userID=%@&num=10&page=%d",targetURL,[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"userId"]],currentPage]]];
        if ([tmpDic objectForKey:@"body"]!=nil)
        {
            NSDictionary *recordDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
            [itemsArray addObjectsFromArray:[recordDic objectForKey:@"record"]];
            NSLog(@"get Store %d",[itemsArray count]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [self.myTableView reloadData];
            });
        }else
        {
            [SVProgressHUD dismiss];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"服务器无法连接,请稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
        }
    });

}
- (void)dismisThisViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
