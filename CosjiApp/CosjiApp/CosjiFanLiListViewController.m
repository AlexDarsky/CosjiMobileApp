//
//  CosjiFanLiListViewController.m
//  CosjiApp
//
//  Created by Darsky on 13-10-28.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiFanLiListViewController.h"
#import "CosjiServerHelper.h"
#import "CosjiLoginViewController.h"
#import "SVProgressHUD.h"
@interface CosjiFanLiListViewController ()

@end

@implementation CosjiFanLiListViewController
@synthesize listTableView,customNarBar,fanliTitle,segmentCon,userID;

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
    self.customNarBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    self.customNarBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(11, 12, 13, 21);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self  action:@selector(exitThisView:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNarBar addSubview:backBtn];
    self.fanliTitle=[[UILabel alloc] initWithFrame:CGRectMake(90, 0, 140, 40)];
    self.fanliTitle.backgroundColor=[UIColor clearColor];
    self.fanliTitle.textColor=[UIColor whiteColor];
    self.fanliTitle.textAlignment=NSTextAlignmentCenter;
    [self.customNarBar addSubview:self.fanliTitle];
    [self.view addSubview:self.customNarBar];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"我的可及-背景"]]];
    
    self.segmentCon=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"淘宝",@"拍拍",@"商城", nil]];
    self.segmentCon.frame=CGRectMake(-5, 45, 330, 29);
    self.segmentCon.multipleTouchEnabled=NO;
    [self.segmentCon setSelectedSegmentIndex:0];
    [self.segmentCon addTarget:self action:@selector(loadFanLiListFor:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentCon];
    self.listTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 70, 320, [UIScreen mainScreen].bounds.size.height-70) style:UITableViewStyleGrouped];
    self.listTableView.dataSource=self;
    self.listTableView.delegate=self;
    self.listTableView.backgroundView=nil;
    [self.view addSubview:self.listTableView];

    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    itemsArray=[[NSMutableArray alloc] initWithCapacity:0];

}
-(void)viewWillAppear:(BOOL)animated
{
    [self loadFanLiListFor:self.segmentCon];
}
#pragma mark mainMethod
-(void)loadFanLiListFor:(UISegmentedControl *)Seg
{
    [SVProgressHUD showWithStatus:@"正在载入..."];
    if ([itemsArray count]>0)
    {
        [itemsArray removeAllObjects];
    }
    NSInteger Index = Seg.selectedSegmentIndex;
    currentPage=1;
    NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
    NSDictionary *infoDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
    self.userID=[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"userId"]];
    NSString *requestURL=[NSString stringWithFormat:@"/order/"];
    switch (Index) {
            case 0:
            {
                self.fanliTitle.text=[NSString stringWithFormat:@"淘宝返利"];
                requestURL=[requestURL stringByAppendingFormat:@"toList/"];
                
            }
                break;
            case 1:
            {
                self.fanliTitle.text=[NSString stringWithFormat:@"拍拍返利"];
                requestURL=[requestURL stringByAppendingFormat:@"poList/"];
            }
                break;
            case 2:
            {
                self.fanliTitle.text=[NSString stringWithFormat:@"商城返利"];
                requestURL=[requestURL stringByAppendingFormat:@"moList/"];
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
                    [self.listTableView reloadData];
                });
            
        }else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"服务器无法连接，请稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
        }
    });
}
void FanLiItemImageDownloadURL( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
{
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       NSData * data = [[NSData alloc] initWithContentsOfURL:URL] ;
                       UIImage * image = [[UIImage alloc] initWithData:data];
                       dispatch_async( dispatch_get_main_queue(), ^(void){
                           if( image != nil )
                           {
                               imageBlock(image);
                               
                           }
                           else {
                               errorBlock();
                           }
                       });
                   });
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:{
            
        }
            break;
            
        case 1:
        {
            NSLog(@"case 1");
            CosjiLoginViewController *loginViewController=[CosjiLoginViewController shareCosjiLoginViewController];
            [self presentViewController:loginViewController animated:YES completion:nil];
            
        }
            break;
            
    }
    
}
#pragma mark tableviewmethod
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [itemsArray count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height;
    switch (indexPath.row) {
        case 0:
        {
            height=20.0;
        }
            break;
        case 1:
        {
            height=100.0;;
        }
            break;
        case 2:
        {
            height=20.0;
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
    switch (indexPath.row) {
        case 0:
        {
            UILabel *chengjiaoLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 280, 20)];
            chengjiaoLabel.text=[NSString stringWithFormat:@"成交时间:%@",[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"chargeTime"]]];
            chengjiaoLabel.backgroundColor=[UIColor clearColor];
            chengjiaoLabel.font=[UIFont fontWithName:@"Arial" size:11];
            [cell addSubview:chengjiaoLabel];
        }
            break;
        case 1:
        {
            UIImageView *itemImageView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 90, 90)];
            NSString *imageUrl=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"imgUrl"]];
            imageUrl=[imageUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            FanLiItemImageDownloadURL([NSURL URLWithString:imageUrl], ^( UIImage * image )
                                 {
                                     [itemImageView setImage:image ];
                                 }, ^(void){
                                 });
            [cell addSubview:itemImageView];
            UILabel *orderIDLabel=[[UILabel alloc] initWithFrame:CGRectMake(120, 10, 180, 20)];
            orderIDLabel.text=[NSString stringWithFormat:@"订单号：%@",[itemDic objectForKey:@"orderNo"]];
            orderIDLabel.font=[UIFont fontWithName:@"Arial" size:11];
            orderIDLabel.backgroundColor=[UIColor clearColor];
            [cell addSubview:orderIDLabel];
            UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(120, 20, 180, 60)];
            nameLabel.text=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"name"]];
            nameLabel.numberOfLines=0;
            nameLabel.adjustsFontSizeToFitWidth=YES;
            nameLabel.backgroundColor=[UIColor clearColor];
            nameLabel.font=[UIFont fontWithName:@"Arial" size:11];
            [cell addSubview:nameLabel];
            
            UILabel *priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(120, 80, 180, 20)];
            priceLabel.text=[NSString stringWithFormat:@"￥ %@",[itemDic objectForKey:@"amount"]];
            priceLabel.backgroundColor=[UIColor clearColor];
            priceLabel.font=[UIFont fontWithName:@"Arial" size:11];
            [cell addSubview:priceLabel];

        }
            break;
        case 2:
        {
            UILabel *profitLabel=[[UILabel alloc] initWithFrame:CGRectMake(160, 0, 100, 20)];
            profitLabel.text=[NSString stringWithFormat:@"获得%@",[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"profit"]]];
            profitLabel.backgroundColor=[UIColor clearColor];
            profitLabel.font=[UIFont fontWithName:@"Arial" size:11];
            [cell addSubview:profitLabel];

        }
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    
}
- (void)exitThisView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setListTableView:nil];
    [self setCustomNarBar:nil];
    [self setFanliTitle:nil];
    [self setSegmentCon:nil];
    [super viewDidUnload];
}
@end
