//
//  CosjiSpecialActivityViewController.m
//  CosjiApp
//
//  Created by Darsky on 13-7-14.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiSpecialActivityViewController.h"

#import "MobClick.h"
#import "CosjiServerHelper.h"
#import "CosjiWebViewController.h"
#import "SVProgressHUD.h"
#import "CosjiLoginViewController.h"
#import "CosjiItemListViewController.h"
#import "CosjiItemFanliDetailViewController.h"
#import "MJRefresh.h"
#import "CosjiTimerView.h"

#define kAppKey             @"21428060"
#define kAppSecret          @"dda4af6d892e2024c26cd621b05dd2d0"
#define kAppRedirectURI     @"http://cosjii.com"
#define httpAdd @"http://zhemai.com"

@interface CosjiSpecialActivityViewController ()
{

    UILabel *tishiLabel;
    BOOL searchViewShowing;
    MJRefreshFooterView *_footer;
    CosjiTimerView *timer;
}

@end

@implementation CosjiSpecialActivityViewController
@synthesize tableView,CustomNav;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"折买团购"];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"折买团购"];
}
-(void)loadView
{
    [super loadView];
    UIView *primary=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    primary.backgroundColor=[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:100];
    self.view=primary;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 65, 320, [UIScreen mainScreen].bounds.size.height-65-49)  style:UITableViewStylePlain];
        self.CustomNav=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
        self.CustomNav.backgroundColor=[UIColor colorWithRed:225.0/255.0 green:47.0/255.0 blue:50.0/255.0 alpha:100];
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    else
    {
        self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 45, 320, [UIScreen mainScreen].bounds.size.height-45-49-20) style:UITableViewStylePlain];
        self.CustomNav=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
        self.CustomNav.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
    }

    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.backgroundView=nil;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.CustomNav];
    UIImageView *llogoImage=[[UIImageView alloc] initWithFrame:CGRectMake(6, self.CustomNav.frame.size.height-39, 156/2, 65/2)];
    llogoImage.image=[UIImage imageNamed:@"工具栏背景-标语"];
    [self.CustomNav addSubview:llogoImage];
    UIImageView *blogoImage=[[UIImageView alloc] initWithFrame:CGRectMake(160-176/4,self.CustomNav.frame.size.height-34, 176/2, 39/2)];
    blogoImage.image=[UIImage imageNamed:@"zhemaituangou2"];
    [self.CustomNav addSubview:blogoImage];
    self.webViewController=[[CosjiWebViewController alloc] init];
    self.itemBrose=[[UINavigationController alloc] initWithRootViewController:self.webViewController];
    timer=[[CosjiTimerView alloc] initWithFrame:CGRectMake(0, 0, 320, 226/2)];
    [self addFooter];
    UIButton *yugaoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    yugaoBtn.frame=CGRectMake(285, self.CustomNav.frame.size.height-33, 40/2, 42/2);
    [yugaoBtn setBackgroundImage:[UIImage imageNamed:@"naoz"] forState:UIControlStateNormal];
    [yugaoBtn addTarget:self action:@selector(showYugao) forControlEvents:UIControlEventTouchDown];
    [self.CustomNav addSubview:yugaoBtn];

}
- (void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 增加5条假数据
        [self performSelector:@selector(doneLoadingTableViewData) withObject:Nil afterDelay:2.0];
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
    [self.tableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=NO;
    [SVProgressHUD showWithStatus:@"正在加载..."];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"lowMode"])
    {
        isSaveMode=YES;
    }else
        isSaveMode=NO;
    if ([itemsArray count]==0)
    {
        currentPage=1;
        CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
        //[serverHelper jsonTest];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:@"/product/ship/?page=1&&num=16"]];
        if (tmpDic!=nil)
        {
            NSDictionary *recordDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
                itemsArray=[NSMutableArray arrayWithArray:[recordDic objectForKey:@"record"]];
            NSLog(@"get Store %d",[itemsArray count]);
            NSLog(@"get Store %@",itemsArray);

                dispatch_async(dispatch_get_main_queue(), ^{
                   [self.tableView reloadData];
                });
                
        }else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"服务器无法连接，请稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
        }
        });

    }else
    {
        
    }
    [SVProgressHUD dismiss];
    [timer initTimer];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    itemsArray=[[NSMutableArray alloc] initWithCapacity:0];

}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([itemsArray count]%2!=0) {
        return [itemsArray count]/2+1+1;
    }else
        return [itemsArray count]/2+1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 226/2;
    }else
    return 162;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // static NSString *cellIdentifier = @"MyCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    // cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier]
    if (indexPath.section==0)
    {
        [cell addSubview:timer];
    }else
    {
        UIFont *nameFont= [UIFont fontWithName:@"Arial" size:12];
        UIFont *font = [UIFont fontWithName:@"Arial" size:15];
        [cell setBackgroundColor:[UIColor clearColor]];
        for (int x=0; x<2; x++)
        {
            if ((indexPath.section-1)*2+x<[itemsArray count])
            {
                NSDictionary *leftItemDic=[NSDictionary dictionaryWithDictionary:[itemsArray objectAtIndex:(indexPath.section-1)*2+x]];
                UIButton *leftItemBtn=[UIButton buttonWithType:UIButtonTypeCustom];
                leftItemBtn.frame=CGRectMake(4+x*159,0, 306/2, 214/2);
                leftItemBtn.tag=(indexPath.section-1)*2+x;
                [leftItemBtn setBackgroundImage:[UIImage imageNamed:@"加载图_折扣优惠"] forState:UIControlStateNormal];
                NSString *itemLefturl=[NSString stringWithFormat:@"%@",[leftItemDic objectForKey:@"imgUrl"]];
                if ([itemLefturl rangeOfString:@"http://"].location==NSNotFound)
                {
                    itemLefturl=[NSString stringWithFormat:@"%@%@",httpAdd,itemLefturl];
                }
                itemLefturl=[itemLefturl stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                NSLog(@"%@",itemLefturl);
                if (isSaveMode) {
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
                                       NSString *filename = [dirName stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[leftItemDic objectForKey:@"id"]]];
                                       if (![[NSFileManager defaultManager] fileExistsAtPath:filename])
                                       {
                                           NSData * data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:itemLefturl]];
                                           UIImage * cacheimage = [[UIImage alloc] initWithData:data];
                                           [UIImageJPEGRepresentation(cacheimage, 0.5) writeToFile:filename atomically:YES];
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               NSData *imageData=[NSData dataWithContentsOfFile:filename];
                                               [leftItemBtn setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                                           });
                                       }else
                                       {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               NSData *imageData=[NSData dataWithContentsOfFile:filename];
                                               [leftItemBtn setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                                           });
                                       }
                                   });
                    
                }else
                {
                    ItemImageFromURL( [NSURL URLWithString:itemLefturl], ^( UIImage * image )
                                     {
                                         [leftItemBtn setBackgroundImage:image forState:UIControlStateNormal];
                                     },
                                     ^(void){
                                     });
                }
                [leftItemBtn addTarget:self action:@selector(qiangGou:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:leftItemBtn];
                UILabel *itemLeftPrice=[[UILabel alloc] initWithFrame:CGRectMake(leftItemBtn.frame.origin.x, leftItemBtn.frame.size.height+leftItemBtn.frame.origin.y,leftItemBtn.frame.size.width, 20)];
                [itemLeftPrice setFont:font];
                itemLeftPrice.backgroundColor=[UIColor redColor];
                [itemLeftPrice setTextColor:[UIColor whiteColor]];
                [itemLeftPrice setText:[NSString stringWithFormat:@"￥%@       有返利",[leftItemDic objectForKey:@"promotion"]]];
                UILabel *itemLeftName=[[UILabel alloc] initWithFrame:CGRectMake(itemLeftPrice.frame.origin.x, itemLeftPrice.frame.size.height+itemLeftPrice.frame.origin.y+4,itemLeftPrice.frame.size.width, 28)];
                [itemLeftName setText:[NSString stringWithFormat:@"        %@",[leftItemDic objectForKey:@"name"]]];
                [itemLeftName setFont:nameFont];
                itemLeftName.numberOfLines=0;
                itemLeftName.backgroundColor=[UIColor clearColor];
                UIImageView *baoyouImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 1.5, 48/2, 24/2)];
                [baoyouImageView setImage:[UIImage imageNamed:@"ispost"]];
                [itemLeftName addSubview:baoyouImageView];
                [cell addSubview:itemLeftName];
                [cell addSubview:itemLeftPrice];
                
            }
        }

    }
    return cell;
}
void ItemImageFromURL( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
{
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       NSData * data = [[NSData alloc] initWithContentsOfURL:URL] ;
                       UIImage * image = [[UIImage alloc] initWithData:data];
                       dispatch_async( dispatch_get_main_queue(), ^(void){
                           if( image != nil )
                           {
                               imageBlock( image );
                           } else {
                               errorBlock();
                           }
                       });
                   });
}
-(void)qiangGou:(id)sender
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"havelogined"])
    {
        NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[itemsArray objectAtIndex:[sender tag]]];
        CosjiItemFanliDetailViewController *fanliDetailVC=[CosjiItemFanliDetailViewController shareCosjiItemFanliDetailViewController];
        NSDictionary *qianggouDic=[NSDictionary dictionaryWithObjectsAndKeys:[tmpDic objectForKey:@"name"],@"title",[tmpDic objectForKey:@"promotion"],@"price",[NSString stringWithFormat:@"%@%@",httpAdd,[tmpDic objectForKey:@"imgUrl"]],@"pic_url",[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"iid"]],@"num_iid", nil];
        [self presentViewController:fanliDetailVC animated:YES completion:nil];
        [fanliDetailVC loadZheMainItemInfoWithDic:qianggouDic];

    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"登录获取返利" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录",nil];
        alert.tag=1;
        [alert show];
    }
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
                NSLog(@"case 1");
                CosjiLoginViewController *loginViewController=[CosjiLoginViewController shareCosjiLoginViewController];
                [self presentViewController:loginViewController animated:YES completion:nil];
            }
                break;
        }
    }
    if (alertView.tag==10) {
        switch (buttonIndex) {
            case 0:{
            }
                break;
            case 1:
            {
                NSURL *url =[NSURL URLWithString:@"http://www.zhemai.com/index.php?m=index&a=preview"];
                [[UIApplication sharedApplication] openURL:url];
            }
                break;
        }

    }
}
/*
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"%f %f",scrollView.contentOffset.y,scrollView.contentSize.height - scrollView.frame.size.height);
    if (scrollView.contentOffset.y>=(scrollView.contentSize.height - scrollView.frame.size.height)+100&&scrollView.contentOffset.y>0)
    {
        [SVProgressHUD showWithStatus:@"正在载入..."];
        [self performSelector:@selector(doneLoadingTableViewData) withObject:Nil afterDelay:2.0];
    }
    
}*/
- (void) loadDataBegin
{
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
}

- (void)doneLoadingTableViewData{
    NSLog(@"===加载完数据");
    NSLog(@"%d",currentPage);
    CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
    currentPage+=1;
    
    NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:[NSString stringWithFormat:@"/product/ship/?page=%d&&num=16",currentPage]]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *recordDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
        NSArray *loadArray=[[NSArray alloc] initWithArray:[recordDic objectForKey:@"record"]];
        if ([loadArray count]>0) {
            prePoint=CGPointMake(0,self.tableView.contentSize.height);
            NSLog(@"load Store %d",[itemsArray count]);
            [itemsArray addObjectsFromArray:loadArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
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
    [self.tableView setContentOffset:prePoint animated:YES];
}
-(void)showYugao
{
    //确定进入折买网查看下一场活动商品？
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"确定进入折买网查看下一场活动商品？" delegate:self cancelButtonTitle:@"稍后" otherButtonTitles:@"访问", nil];
    alert.tag=10;
    [alert show];
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
    [self setTableView:nil];
    [self setCustomNav:nil];
    [super viewDidUnload];
}
@end
