//
//  CosjiMallsListViewController.m
//  CosjiApp
//
//  Created by Darsky on 13-12-17.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiMallsListViewController.h"

@interface CosjiMallsListViewController ()

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
    self.mainTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 49, 320, [UIScreen mainScreen].bounds.size.height-49-20)];
    self.mainTableView.delegate=self;
    self.mainTableView.dataSource=self;
    self.mainTableView.backgroundColor=[UIColor clearColor];
    self.mainTableView.backgroundView=nil;
    [self.mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.mainTableView];
    self.CustomHeadView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    self.CustomHeadView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(11, 12,60/2, 41/2);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self  action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.CustomHeadView addSubview:backBtn];
    [self.view addSubview:self.CustomHeadView];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    storeListArray=[[NSMutableArray alloc] initWithCapacity:0];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=NO;
    if ([storeListArray count]==0)
    {
        [SVProgressHUD showWithStatus:@"正在载入。。。"];
        currentPage=1;
        CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
        NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:[NSString stringWithFormat:@"/mall/getAll/?page=%d",currentPage]]];
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
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    return 82;
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
    //商城左
    for (int x=0; x<3; x++)
    {
        if (indexPath.row*3+x<[storeListArray count])
        {
            NSDictionary *storeDic=[NSDictionary dictionaryWithDictionary:[storeListArray objectAtIndex:indexPath.row*3+x]];
            UIView *btnView=[[UIView alloc] initWithFrame:CGRectMake(10+100*x, 0, 95, 55)];
            btnView.backgroundColor=[UIColor whiteColor];
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(0,5, 95, 50);
            button.tag=indexPath.row*3;
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
                                   NSLog(@"download cacheImage %@",filename);
                                   NSData * data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl1]];
                                   UIImage * cacheimage = [[UIImage alloc] initWithData:data];
                                   [UIImageJPEGRepresentation(cacheimage, 1.0) writeToFile:filename atomically:YES];
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSData *imageData=[NSData dataWithContentsOfFile:filename];
                                       [button setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                                   });
                               }else
                               {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSLog(@"load cacheImage %@",filename);
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
            label.text=[NSString stringWithFormat:@"最高返利%@",[storeDic objectForKey:@"profit" ]];
            [btnView addSubview:label];
        }
    }
    return cell;
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"%f %f",scrollView.contentOffset.y,scrollView.contentSize.height - scrollView.frame.size.height);
    if(scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height))&&scrollView.contentOffset.y>0)
        
    {
        [self loadDataBegin];
    }
    
}
-(void)loadDataBegin
{
    NSLog(@"%d",currentPage);
    CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
    currentPage+=1;
    NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:[NSString stringWithFormat:@"/mall/ship/?page=%d&&num=16",currentPage]]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *recordDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
        NSArray *loadArray=[[NSArray alloc] initWithArray:[recordDic objectForKey:@"record"]];
        if ([loadArray count]>0) {
            NSLog(@"load Store %d",[storeListArray count]);
            [storeListArray addObjectsFromArray:loadArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainTableView reloadData];
                [SVProgressHUD dismiss];
            });
        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                currentPage-=1;
                [SVProgressHUD dismiss];
            });
        }
    });
    [SVProgressHUD dismiss];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
