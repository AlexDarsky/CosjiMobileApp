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
#import "MJRefresh.h"
@interface CosjiFanLiListViewController ()
{
    MJRefreshFooterView *_footer;
}

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
    [super loadView];
    UIView *primary=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view=primary;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
    {
        self.customNarBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
        self.customNarBar.backgroundColor=[UIColor colorWithRed:225.0/255.0 green:47.0/255.0 blue:50.0/255.0 alpha:100];
        self.fanliTitle=[[UILabel alloc] initWithFrame:CGRectMake(90, 22.5, 140, 40)];
        self.fanliTitle.backgroundColor=[UIColor clearColor];
        self.fanliTitle.textColor=[UIColor whiteColor];
        self.fanliTitle.font=[UIFont fontWithName:@"Arial" size:18];
        self.fanliTitle.textAlignment=NSTextAlignmentCenter;
        [self.customNarBar addSubview:self.fanliTitle];
        UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame=CGRectMake(11, 22.5, 100/2, 80/2);
        [backBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [backBtn addTarget:self  action:@selector(exitThisView:) forControlEvents:UIControlEventTouchUpInside];
        [self.customNarBar addSubview:backBtn];
        [self.view addSubview:self.customNarBar];
        self.segmentCon=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"淘宝",@"拍拍",@"商城", nil]];
        self.segmentCon.frame=CGRectMake(-10, 65, 340, 29);
        self.listTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 94, 320, [UIScreen mainScreen].bounds.size.height-94) style:UITableViewStyleGrouped];
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    else
    {
        self.customNarBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
        self.customNarBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
        self.fanliTitle=[[UILabel alloc] initWithFrame:CGRectMake(90, 2.5, 140, 40)];
        self.fanliTitle.backgroundColor=[UIColor clearColor];
        self.fanliTitle.textColor=[UIColor whiteColor];
        self.fanliTitle.font=[UIFont fontWithName:@"Arial" size:18];
        self.fanliTitle.textAlignment=NSTextAlignmentCenter;
        [self.customNarBar addSubview:self.fanliTitle];
        UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame=CGRectMake(11, 2.5, 100/2, 80/2);
        [backBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [backBtn addTarget:self  action:@selector(exitThisView:) forControlEvents:UIControlEventTouchUpInside];
        [self.customNarBar addSubview:backBtn];
        [self.view addSubview:self.customNarBar];
        self.segmentCon=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"淘宝",@"拍拍",@"商城", nil]];
        self.segmentCon.frame=CGRectMake(-10, 45, 340, 29);
        self.listTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 74, 320, [UIScreen mainScreen].bounds.size.height-74) style:UITableViewStyleGrouped];

    }
    [self.view setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:100]];
    self.segmentCon.multipleTouchEnabled=NO;
    [self.segmentCon setSelectedSegmentIndex:0];
    dingdanMode=self.segmentCon.selectedSegmentIndex;
    [self.segmentCon addTarget:self action:@selector(loadFanLiListFor:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentCon];

    self.listTableView.dataSource=self;
    self.listTableView.delegate=self;
    self.listTableView.backgroundView=nil;
    [self.view addSubview:self.listTableView];
    [self addFooter];

    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    itemsArray=[[NSMutableArray alloc] initWithCapacity:0];
}
- (void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.listTableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 增加5条假数据
        [self performSelector:@selector(loadDataBegin) withObject:Nil afterDelay:2.0];
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        [self performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    _footer = footer;
}
- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.listTableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self loadFanLiListFor:self.segmentCon];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
}
#pragma mark mainMethod
-(void)loadFanLiListFor:(UISegmentedControl *)Seg
{
    [SVProgressHUD showWithStatus:@"正在载入..."];
    if ([itemsArray count]>0)
    {
        [itemsArray removeAllObjects];
        [self.listTableView reloadData];
    }
    NSInteger Index = Seg.selectedSegmentIndex;
    dingdanMode=Index;
    currentPage=1;
    NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
    NSDictionary *infoDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
    self.userID=[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"userId"]];
    NSString *requestURL=[NSString stringWithFormat:@"/order/"];
    switch (dingdanMode) {
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
            height=52.0/2;
        }
            break;
        case 1:
        {
            height=148.0/2;;
        }
            break;
        case 2:
        {
            height=68/2.0;
        }
            break;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // static NSString *cellIdentifier = @"MyCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSDictionary *itemDic=[NSDictionary dictionaryWithDictionary:[itemsArray objectAtIndex:indexPath.section]];
    switch (indexPath.row) {
        case 0:
        {
            UILabel *chengjiaoLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 5, 280, 20)];
            NSLog(@"time is%@",[itemDic objectForKey:@"chargeTime"]);
                switch (dingdanMode) {
                case 0:
                {
                    chengjiaoLabel.text=[NSString stringWithFormat:@"成交时间:%@",[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"chargeTime"]]];

                }
                    break;
                case 1:
                {
                    chengjiaoLabel.text=[NSString stringWithFormat:@"成交时间:%@",[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"chargeTime"]]];
                }
                    break;
                case 2:
                {
                    NSString *chargeTimeString=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"chargeTime"]];
                    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateStyle:NSDateFormatterMediumStyle];
                    [formatter setTimeStyle:NSDateFormatterShortStyle];
                    [formatter setDateFormat:@"yyyy-MM-dd HH:MM:ss"];
                    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[chargeTimeString intValue]];
                    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
                    chengjiaoLabel.text=[NSString stringWithFormat:@"成交时间:%@",confromTimespStr];

                }
                    break;

            }
            chengjiaoLabel.textColor=[UIColor lightGrayColor];
            chengjiaoLabel.backgroundColor=[UIColor clearColor];
            chengjiaoLabel.font=[UIFont fontWithName:@"Arial" size:12];
            [cell addSubview:chengjiaoLabel];
        }
            break;
        case 1:
        {
            
            UILabel *orderIDLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 5, 280, 20)];
            orderIDLabel.font=[UIFont fontWithName:@"Arial" size:11];
            orderIDLabel.backgroundColor=[UIColor clearColor];
            [cell addSubview:orderIDLabel];
            UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 75/2)];
            nameLabel.numberOfLines=0;
            nameLabel.adjustsFontSizeToFitWidth=YES;
            nameLabel.backgroundColor=[UIColor clearColor];
            nameLabel.font=[UIFont fontWithName:@"Arial" size:12];
            [cell addSubview:nameLabel];
//            UILabel *priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 80, 180, 20)];
//            priceLabel.backgroundColor=[UIColor clearColor];
//            priceLabel.font=[UIFont fontWithName:@"Arial" size:12];
//            [cell addSubview:priceLabel];
            switch (dingdanMode) {
                case 0:
                {
                    orderIDLabel.text=[NSString stringWithFormat:@"订单号：%@",[itemDic objectForKey:@"orderNo"]];
                    nameLabel.text=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"name"]];
               //     priceLabel.text=[NSString stringWithFormat:@"￥ %@元",[itemDic objectForKey:@"amount"]];
                }
                    break;
                case 1:
                {
                    orderIDLabel.text=[NSString stringWithFormat:@"订单号：%@",[itemDic objectForKey:@"orderNo"]];
                    nameLabel.text=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"mallName"]];
             //       priceLabel.text=[NSString stringWithFormat:@"￥ %@元",[itemDic objectForKey:@"price"]];
                }
                    break;
                case 2:
                {
                    orderIDLabel.text=[NSString stringWithFormat:@"订单号：%@",[itemDic objectForKey:@"orderNo"]];
                    UILabel *mallNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 30, 280, 20)];
                    mallNameLabel.textColor=[UIColor lightGrayColor];
                    mallNameLabel.backgroundColor=[UIColor clearColor];
                    mallNameLabel.font=[UIFont fontWithName:@"Arial" size:12];
                    mallNameLabel.text=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"mallName"]];
                    [cell addSubview:mallNameLabel];
                    UILabel *numberLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 50, 280, 20)];
                    numberLabel.textColor=[UIColor lightGrayColor];
                    numberLabel.backgroundColor=[UIColor clearColor];
                    numberLabel.font=[UIFont fontWithName:@"Arial" size:12];
                    numberLabel.text=[NSString stringWithFormat:@"订单数：%@",[itemDic objectForKey:@"number"]];
                    [cell addSubview:numberLabel];
                  //  nameLabel.text=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"mallName"]];
                }
                    break;
                    
            }
        }
            break;
        case 2:
        {
            UILabel *priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 9, 180, 20)];
            priceLabel.backgroundColor=[UIColor clearColor];
            priceLabel.font=[UIFont fontWithName:@"Arial" size:12];
            [cell addSubview:priceLabel];
            priceLabel.text=[NSString stringWithFormat:@"￥ %@元",[itemDic objectForKey:@"amount"]];
            UILabel *profitLabel=[[UILabel alloc] initWithFrame:CGRectMake(180, 9/2, 120, 30)];
            switch (dingdanMode) {
                case 0:
                {
                    priceLabel.text=[NSString stringWithFormat:@"￥ %@元",[itemDic objectForKey:@"amount"]];
                    profitLabel.text=[NSString stringWithFormat:@"返利%@",[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"profit"]]];
                }
                    break;
                case 1:
                {
                    priceLabel.text=[NSString stringWithFormat:@"￥ %@元",[itemDic objectForKey:@"amount"]];
                    profitLabel.text=[NSString stringWithFormat:@"返利%@元",[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"profit"]]];
                }
                    break;
                case 2:
                {
                    priceLabel.text=[NSString stringWithFormat:@"￥ %@元",[itemDic objectForKey:@"price"]];
                    profitLabel.text=[NSString stringWithFormat:@"返利%@元",[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"profit"]]];
                }
                    break;
            }
            profitLabel.backgroundColor=[UIColor clearColor];
            profitLabel.font=[UIFont fontWithName:@"Arial" size:13];
            [cell addSubview:profitLabel];

        }
            break;
    }
    
    return cell;
}
/*
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
   // NSLog(@"%f %f",scrollView.contentOffset.y,scrollView.contentSize.height - scrollView.frame.size.height);
    if (scrollView.contentOffset.y>=(scrollView.contentSize.height - scrollView.frame.size.height)+100&&scrollView.contentOffset.y>0)
    {
        [SVProgressHUD showWithStatus:@"正在载入..."];
        [self performSelector:@selector(loadDataBegin) withObject:Nil afterDelay:2.0];
    }
}
 */
-(void)loadDataBegin
{
    currentPage+=1;
    NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
    NSDictionary *infoDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
    self.userID=[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"userId"]];
    NSString *requestURL=[NSString stringWithFormat:@"/order/"];
    switch (dingdanMode) {
        case 0:
        {
            requestURL=[requestURL stringByAppendingFormat:@"toList/"];
            
        }
            break;
        case 1:
        {
            requestURL=[requestURL stringByAppendingFormat:@"poList/"];
        }
            break;
        case 2:
        {
            requestURL=[requestURL stringByAppendingFormat:@"moList/"];
        }
            break;
    }
    requestURL=[requestURL stringByAppendingFormat:@"?userID=%@&num=10&page=%d",self.userID,currentPage];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
        NSDictionary *requestDic=[serverHelper getJsonDictionary:requestURL];
        if (requestDic!=nil)
        {
            NSDictionary *recordDic=[NSDictionary dictionaryWithDictionary:[requestDic objectForKey:@"body"]];
            NSArray *recordArray=[recordDic objectForKey:@"record"];
            if ([recordArray count]>0) {
                [itemsArray addObjectsFromArray:[recordDic objectForKey:@"record"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listTableView reloadData];
                });
                
            }else
            {
                NSLog(@"没有更太多");
                dispatch_async(dispatch_get_main_queue(), ^{
                    currentPage-=1;
                    CGPoint point=CGPointMake(0,0);
                    [self.listTableView setContentOffset:point animated:YES];
                    [SVProgressHUD showErrorWithStatus:@"没有更多订单了"];
                });
            }

        }else
        {
            NSLog(@"没有更太多");
            currentPage-=1;
            CGPoint point=CGPointMake(0,0);
            [self.listTableView setContentOffset:point animated:NO];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"无法连接服务器,请稍后链接" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
            [alert show];
        }
    });
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
- (void)dealloc
{
    [_footer free];
}
- (void)viewDidUnload {
    [self setListTableView:nil];
    [self setCustomNarBar:nil];
    [self setFanliTitle:nil];
    [self setSegmentCon:nil];
    [super viewDidUnload];
}
@end
