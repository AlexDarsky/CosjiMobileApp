//
//  CosjiItemListViewController.m
//  CosjiApp
//
//  Created by Darsky on 13-10-6.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiItemListViewController.h"
#import "CosjiServerHelper.h"
#import "CosjiWebViewController.h"
#import "SVProgressHUD.h"
#import "TopIOSClient.h"
#import "TopAttachment.h"
#import "JSONKit.h"
#import "CosjiLoginViewController.h"
#import "MJRefresh.h"
#import "CosjiItemFanliDetailViewController.h"

@interface CosjiItemListViewController ()
{
    MJRefreshFooterView *_footer;
}

@end

@implementation CosjiItemListViewController
static CosjiItemListViewController* shareCosjiItemListViewController;
@synthesize customNavBar,titleLabel,tableView;
+(CosjiItemListViewController*)shareCosjiItemListViewController
{
    if (shareCosjiItemListViewController == nil) {
        shareCosjiItemListViewController = [[super allocWithZone:NULL] init];
    }
    return shareCosjiItemListViewController;
}

-(void)loadView
{
    UIView *primary=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    primary.backgroundColor=[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:100];
    self.view=primary;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    self.customNavBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
    self.customNavBar.backgroundColor=[UIColor colorWithRed:225.0/255.0 green:47.0/255.0 blue:50.0/255.0 alpha:100];
    self.titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(32, 31, 200, 21)];
    self.titleLabel.backgroundColor=[UIColor clearColor];
    self.titleLabel.text=nil;
    self.titleLabel.textColor=[UIColor whiteColor];
    [self.customNavBar addSubview:self.titleLabel];
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(11, 22.5, 100/2, 80/2);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self  action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavBar addSubview:backBtn];
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 65, 320, [UIScreen mainScreen].bounds.size.height-65)];

    
#else
    self.customNavBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    self.customNavBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
    self.titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(32, 11, 200, 21)];
    self.titleLabel.backgroundColor=[UIColor clearColor];
    self.titleLabel.text=nil;
    self.titleLabel.textColor=[UIColor whiteColor];
    [self.customNavBar addSubview:self.titleLabel];
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(11, 2.5, 100/2, 80/2);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self  action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavBar addSubview:backBtn];
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 45, 320, [UIScreen mainScreen].bounds.size.height-45-20)];

#endif
    [self.view addSubview:self.customNavBar];

    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.tableView.backgroundView=nil;
    [self.view addSubview:self.tableView];
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
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //tableview开始重新加载
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
        // 这里的refreshView其实就是footer
        [self performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    _footer = footer;
}
- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    NSString *tmpPath=[NSTemporaryDirectory() stringByAppendingPathComponent:@"/tmpImage"];
    BOOL isDir = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:tmpPath isDirectory:&isDir])
    {
        [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];
    }

}
-(void)loadInfoWith:(NSString*)textString atPage:(int)pageNumber
{
    [SVProgressHUD showWithStatus:@"正在载入..."];
    if ([itemsArray count]>0) {
        [itemsArray removeAllObjects];
        [self.tableView reloadData];
    }
    currentPage=pageNumber;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
        itemsArray=[[serverHelper getItemsFromTopByKeyWord:textString atPage:pageNumber] mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.titleLabel.text=textString;
            if ([itemsArray count]>0) {
                [SVProgressHUD dismiss];
                [self.tableView reloadData];
            }else
            {
                [SVProgressHUD dismiss];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"搜索不到该商品或该商品没有返利" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
                [alert show];
            }

        });
        //    从服务器获取商品数据
        });
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [itemsArray count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // static NSString *cellIdentifier = @"MyCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    // cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSDictionary *itemDic=[NSDictionary dictionaryWithDictionary:[itemsArray objectAtIndex:indexPath.row]];
    UIImageView *itemImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    [itemImageView setImage:[UIImage imageNamed:@"imageLoading"]];
    [cell addSubview:itemImageView];
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"pic_url"]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSString *tmpPath=[NSTemporaryDirectory() stringByAppendingPathComponent:@"/tmpImage"];
                       BOOL isDir = YES;
                       if (![[NSFileManager defaultManager] fileExistsAtPath:tmpPath isDirectory:&isDir])
                       {
                           [[NSFileManager defaultManager] createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
                       }
                       NSString *filename = [tmpPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"num_iid"]]];
                       if (![[NSFileManager defaultManager] fileExistsAtPath:filename])
                       {
                           NSData * data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                           UIImage * cacheimage = [[UIImage alloc] initWithData:data];
                           [UIImageJPEGRepresentation(cacheimage, 0.5) writeToFile:filename atomically:YES];
                           dispatch_async(dispatch_get_main_queue(), ^{
                               NSData *imageData=[NSData dataWithContentsOfFile:filename];
                               [itemImageView setImage:[UIImage imageWithData:imageData]];
                           });
                       }else
                       {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               NSData *imageData=[NSData dataWithContentsOfFile:filename];
                               [itemImageView setImage:[UIImage imageWithData:imageData]];
                           });
                       }
                   });
/*
    ItemImageDownloadURL([NSURL URLWithString:imageUrl], ^( UIImage * image )
                    {
                        [itemImageView setImage:image ];
                    }, ^(void){
                    });
 */
    UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(120, 10, 180, 50)];
    nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.numberOfLines=0;
    nameLabel.text=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"title"]];
    nameLabel.font=[UIFont fontWithName:@"Arial" size:14];
    [cell addSubview:nameLabel];

    UILabel *priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(120, 65, 80, 20)];
    priceLabel.text=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"price"]];
    priceLabel.textColor=[UIColor redColor];
    priceLabel.backgroundColor=[UIColor clearColor];
    UILabel *fanliLabel=[[UILabel alloc] initWithFrame:CGRectMake(200, 65, 80, 20)];
    fanliLabel.text=@"有返利";
    fanliLabel.textColor=[UIColor whiteColor];
    fanliLabel.backgroundColor=[UIColor redColor];
    fanliLabel.textAlignment=NSTextAlignmentCenter;
    [cell addSubview:fanliLabel];
    UILabel *sellLabel=[[UILabel alloc] initWithFrame:CGRectMake(120, 90, 180, 20)];
    sellLabel.text=[NSString stringWithFormat:@"最近售出%@件",[itemDic objectForKey:@"volume"]];
    sellLabel.font=[UIFont fontWithName:@"Arial" size:13];
    sellLabel.backgroundColor=[UIColor clearColor];
    [cell addSubview:nameLabel];
  //[cell addSubview:nameWebView];
    [cell addSubview:priceLabel];
    [cell addSubview:sellLabel];
     return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      if ([[NSUserDefaults standardUserDefaults] boolForKey:@"havelogined"])
    {
        NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[itemsArray objectAtIndex:indexPath.row]];
        CosjiItemFanliDetailViewController *fanliDetailVC=[CosjiItemFanliDetailViewController shareCosjiItemFanliDetailViewController];
        [self presentViewController:fanliDetailVC animated:YES completion:nil];
        [fanliDetailVC loadItemInfoWithDic:tmpDic];
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"登录获取返利" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录",nil];
        alert.tag=1;
        [alert show];
    }
//    NSString *storeUrl=[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"num_iid"]];
//    CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
//    NSURL *url =[NSURL URLWithString:[serverHelper getClick_urlFromTop:storeUrl]];
//    NSURLRequest *request =[NSURLRequest requestWithURL:url];
//    NSLog(@"request is %@",request);
//    CosjiWebViewController *webViewController=[CosjiWebViewController shareCosjiWebViewController];

}
/*
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
   // NSLog(@"%f %f",scrollView.contentOffset.y,scrollView.contentSize.height - scrollView.frame.size.height);
    if(scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height))&&scrollView.contentOffset.y>0)
    {
        [self loadDataBegin];
    }
    
}
 */
- (void) loadDataBegin

{
    
    //  [self doneLoadingTableViewData];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
    
}
- (void)doneLoadingTableViewData{
    if ([itemsArray count]>0)
    {
    CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
    currentPage+=1;
    NSArray *loadArray=[[NSArray alloc] initWithArray:[serverHelper getItemsFromTopByKeyWord:self.titleLabel.text atPage:currentPage]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([loadArray count]>0) {
            [itemsArray addObjectsFromArray:loadArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                CGPoint point=CGPointMake(0,120*20*(currentPage-1));
                [self.tableView setContentOffset:point animated:YES];
            });
        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                currentPage-=1;

            });

        }

        
    });
    }
}
void ItemImageDownloadURL( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
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
- (void)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1) {
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
}
- (void)dealloc
{
    [_footer free];
}
- (void)viewDidUnload {
    [self setCustomNavBar:nil];
    [self setTitleLabel:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
