//
//  CosjiMallsListViewController.m
//  CosjiApp
//
//  Created by Darsky on 13-12-17.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiMallsListViewController.h"
#import "CosjiWebViewController.h"
#import "CosjiNormalWebViewController.h"
#import "MJRefresh.h"
#import "CosjiLoginViewController.h"

@interface CosjiMallsListViewController ()
{
    MJRefreshFooterView *_footer;
}

@end

@implementation CosjiMallsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)loadView
{
    [super loadView];
    UIView *primaryView=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    primaryView.backgroundColor=[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:100];
    self.view=primaryView;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
    {
        self.CustomHeadView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
        //   self.CustomHeadView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景130"]];
        self.CustomHeadView.backgroundColor=[UIColor colorWithRed:225.0/255.0 green:47.0/255.0 blue:50.0/255.0 alpha:100];
        
        self.mainTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 65, 320, [UIScreen mainScreen].bounds.size.height-65-49)];
        //self.automaticallyAdjustsScrollViewInsets=NO;
    }
    else
    {
        self.mainTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 45, 320, [UIScreen mainScreen].bounds.size.height-45-49-20)];
        self.CustomHeadView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
        self.CustomHeadView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
    }
    self.mainTableView.delegate=self;
    self.mainTableView.dataSource=self;
    self.mainTableView.backgroundColor=[UIColor clearColor];
    self.mainTableView.backgroundView=nil;
    [self.mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.mainTableView];
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(11, self.CustomHeadView.frame.size.height/2-80/4, 100/2, 80/2);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self  action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.CustomHeadView addSubview:backBtn];
    [self.view addSubview:self.CustomHeadView];
    [self addFooter];
}
- (void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.mainTableView;
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
    [self.mainTableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    storeListArray=[[NSMutableArray alloc] initWithCapacity:0];
    self.webViewController=[CosjiWebViewController shareCosjiWebViewController];
    self.storeBrowse=[[UINavigationController alloc] initWithRootViewController:self.webViewController];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=NO;
    if ([storeListArray count]==0)
    {
        [SVProgressHUD showWithStatus:@"正在载入..."];
        currentPage=1;
        CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
        NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:[NSString stringWithFormat:@"/mall/getAll/?page=%d&&num=21",currentPage]]];
        if ([tmpDic objectForKey:@"body"]!=nil)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSDictionary *recordDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
                storeListArray=[NSMutableArray arrayWithArray:[recordDic objectForKey:@"record"]];
                NSLog(@"get Store %d",[storeListArray count]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mainTableView reloadData];
                });
                
            });
        }else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"服务器无法连接，请稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
        }
    }else
    {
        
    }
    [SVProgressHUD dismiss];
}
- (void)backAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [storeListArray count]/3;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 152/2;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // static NSString *cellIdentifier = @"MyCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];
    //商城左
    for (int x=0; x<3; x++)
    {
        if (indexPath.row*3+x<[storeListArray count])
        {
            NSDictionary *storeDic=[NSDictionary dictionaryWithDictionary:[storeListArray objectAtIndex:indexPath.row*3+x]];
            UIView *btnView=[[UIView alloc] initWithFrame:CGRectMake(10+100*x, 0, 198/2, 150/2)];
            btnView.backgroundColor=[UIColor whiteColor];
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(198/4-95/1.5/2,150/4-50/1.5/2-10, 95/1.5, 50/1.5);
            button.tag=indexPath.row*3+x;
            NSString *imageUrl1=[NSString stringWithFormat:@"%@",[storeDic objectForKey:@"logo"]];
            imageUrl1=[imageUrl1 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            if ([imageUrl1 rangeOfString:@"http://www.Cosji.com/"].location==NSNotFound) {
                imageUrl1=[NSString stringWithFormat:@"http://www.Cosji.com/%@",imageUrl1];
            }
            //缓存图片
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                           ^{
                               NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                               NSString *cachePath = [paths objectAtIndex:0];
                               BOOL isDir = YES;
                               NSString *dirName=[cachePath stringByAppendingPathComponent:@"cacheImages"];
                               if (![[NSFileManager defaultManager] fileExistsAtPath:dirName isDirectory:&isDir])
                               {
                                   [[NSFileManager defaultManager] createDirectoryAtPath:dirName withIntermediateDirectories:YES attributes:nil error:nil];
                               }
                               NSString *filename = [dirName stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[storeDic objectForKey:@"id"]]];
                               if (![[NSFileManager defaultManager] fileExistsAtPath:filename])
                               {
                                   NSData * data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl1]];
                                   UIImage * cacheimage = [[UIImage alloc] initWithData:data];
                                   [UIImageJPEGRepresentation(cacheimage, 0.5) writeToFile:filename atomically:YES];
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSData *imageData=[NSData dataWithContentsOfFile:filename];
                                       [button setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                                   });
                               }else
                               {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSData *imageData=[NSData dataWithContentsOfFile:filename];
                                       [button setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                                   });
                               }
                           });
            
            [button addTarget:self action:@selector(opRemenshangcheng:) forControlEvents:UIControlEventTouchUpInside];
            [btnView addSubview:button];
            [cell addSubview:btnView];
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 55, 95, 20)];
            label.adjustsFontSizeToFitWidth=YES;
            label.backgroundColor=[UIColor lightTextColor];
            label.font=[UIFont fontWithName:@"Arial" size:10];
            label.textAlignment=NSTextAlignmentCenter;
            label.text=[NSString stringWithFormat:@"最高返利%@",[storeDic objectForKey:@"profit" ]];
            [btnView addSubview:label];
        }
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
    CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
    currentPage+=1;
    NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:[NSString stringWithFormat:@"/mall/getAll/?page=%d&&num=21",currentPage]]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *recordDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
        NSArray *loadArray=[[NSArray alloc] initWithArray:[recordDic objectForKey:@"record"]];
        if ([loadArray count]>0) {
            prePoint=CGPointMake(0,self.mainTableView.contentSize.height);
            NSLog(@"load Store %d",[storeListArray count]);
            [storeListArray addObjectsFromArray:loadArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainTableView reloadData];
                [self performSelector:@selector(startContentOffset:) withObject:nil afterDelay:0.5];
            });
        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                currentPage-=1;
            });
        }
    });
    [SVProgressHUD dismiss];
}
-(void)startContentOffset:(CGPoint)point
{
    [self.mainTableView setContentOffset:prePoint animated:YES];
}
-(void)opRemenshangcheng:(id)sender
{
    selectedIndex=[sender tag];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"havelogined"]) {
        NSDictionary *userDic=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
        NSDictionary *infoDic=[NSDictionary dictionaryWithDictionary:[userDic objectForKey:@"body"]];
        NSString *uid =[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"userId"]];
        NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[storeListArray objectAtIndex:selectedIndex]];
        NSString *storeUrl=[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"yiqifaurl"]];
        storeUrl=[storeUrl stringByReplacingOccurrencesOfString:@"&e=" withString:[NSString stringWithFormat:@"&e=%@",uid]];
        NSLog(@"storeUrl is %@",storeUrl);
        NSURL *url =[NSURL URLWithString:[storeUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        CosjiNormalWebViewController *normalWebViewController=[[CosjiNormalWebViewController alloc] init];
        [self  presentViewController:normalWebViewController animated:YES completion:nil];
        [normalWebViewController setThisWebViewWithName:request name:[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"name"]]];
        
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"登录获取返利" delegate:self cancelButtonTitle:@"跳过" otherButtonTitles:@"登录",nil];
        alert.tag=1;
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1) {
        switch (buttonIndex) {
            case 0:{
                NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[storeListArray objectAtIndex:selectedIndex]];
                NSString *storeUrl=[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"yiqifaurl"]];
                
                NSURL *url =[NSURL URLWithString:[storeUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
                CosjiNormalWebViewController *normalWebViewController=[[CosjiNormalWebViewController alloc] init];
                [self  presentViewController:normalWebViewController animated:YES completion:nil];
                [normalWebViewController setThisWebViewWithName:[NSURLRequest requestWithURL:url] name:[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"name"]]];
              
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
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
