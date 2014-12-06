//
//  CosjiViewController.m
//  CosjiApp
//
//  Created by AlexZhu on 13-7-11.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiViewController.h"
#import "StoreKit/StoreKit.h"
#import "CosjiMP3Player.h"
#import "MobClick.h"
#import "CosjiNormalWebViewController.h"
#import "CosjiServerHelper.h"
#import "CosjiLoginViewController.h"
#import "SVProgressHUD.h"
#import "CosjiGuideViewController.h"
#import "CosjiItemListViewController.h"
#import "TopIOSClient.h"
#import "CosjiItemFanliDetailViewController.h"
#import "TopAttachment.h"
#import "CosjiWelcomeViewController.h"
#import "CosjiFanLiListViewController.h"


@interface CosjiViewController ()
{

    UIView *searchView;
    UITextField *searchField;
    BOOL searchViewShowing;
    UIView *backgroundView;
    
}
@end

@implementation CosjiViewController
@synthesize userIds;
static UINavigationController* nc;

-(void)loadView
{
    [super loadView];
    UIView *primaryView=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    primaryView.backgroundColor=[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:100];
    self.view=primaryView;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.automaticallyAdjustsScrollViewInsets=NO;
        self.CustomHeadView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
        // self.CustomHeadView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景130"]];
        self.CustomHeadView.backgroundColor=[UIColor colorWithRed:225.0/255.0 green:47.0/255.0 blue:50.0/255.0 alpha:100];
        
        self.mainTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 65, 320, [UIScreen mainScreen].bounds.size.height-65-49)];
        searchField=[[UITextField alloc] initWithFrame:CGRectMake(10, 25, 300, 35)];
        UIImageView *blogoImage=[[UIImageView alloc] initWithFrame:CGRectMake(160-124/4,self.CustomHeadView.frame.size.height-34, 124/2, 40/2)];
        blogoImage.image=[UIImage imageNamed:@"kejiwang扁平"];
        [self.CustomHeadView addSubview:blogoImage];
    }
    else
    {
        self.mainTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 45, 320, [UIScreen mainScreen].bounds.size.height-45-49-20)];
        self.CustomHeadView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
        self.CustomHeadView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
        searchField=[[UITextField alloc] initWithFrame:CGRectMake(10, 5, 300, 35)];
        UIImageView *blogoImage=[[UIImageView alloc] initWithFrame:CGRectMake(129,self.CustomHeadView.frame.size.height-34, 126/2, 42/2)];
        blogoImage.image=[UIImage imageNamed:@"工具栏背景-logo"];
        [self.CustomHeadView addSubview:blogoImage];

    }
    self.mainTableView.delegate=self;
    self.mainTableView.dataSource=self;
    self.mainTableView.backgroundColor=[UIColor clearColor];
    self.mainTableView.backgroundView=nil;
    [self.mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.mainTableView];
    //初始化生成搜索按钮
    UIButton *searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame=CGRectMake(self.CustomHeadView.frame.size.width-40, self.self.CustomHeadView.frame.size.height-44, 64/2, 82/2);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"工具栏背景-搜索"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(showSearchView) forControlEvents:UIControlEventTouchDown];
    [self.CustomHeadView addSubview:searchBtn];
    //搜索框
    searchView=[[UIView alloc] initWithFrame:self.CustomHeadView.frame];
    searchView.backgroundColor=[UIColor whiteColor];
    searchField.borderStyle=UITextBorderStyleRoundedRect;
    searchField.returnKeyType=UIReturnKeySearch;
    searchField.delegate=self;
    searchField.clearButtonMode=UITextFieldViewModeWhileEditing;
    searchField.textAlignment=NSTextAlignmentLeft;
    searchField.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    searchField.backgroundColor=[UIColor clearColor];
    searchField.font=[UIFont fontWithName:@"Arial" size:16];
    searchField.placeholder=@"粘贴商品全名或输入关键字，拿返利";
    [searchView addSubview:searchField];
    [searchField addTarget:self action:@selector(searchItemFrom:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:searchView];
    searchViewShowing=NO;
    [self.view addSubview:self.CustomHeadView];
    
    UIImageView *llogoImage=[[UIImageView alloc] initWithFrame:CGRectMake(6,self.CustomHeadView.frame.size.height-39, 156/2, 65/2)];
    llogoImage.image=[UIImage imageNamed:@"工具栏背景-标语"];
    [self.CustomHeadView addSubview:llogoImage];

    backgroundView=[[UIView alloc] initWithFrame:CGRectMake(10, 7, 300, 184/2)];
    backgroundView.backgroundColor=[UIColor whiteColor];
    UIButton *helperBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    helperBtn.frame=CGRectMake(10, 10, 155/2, 109/2);
    [helperBtn addTarget:self action:@selector(presentStoreBrowseViewController:) forControlEvents:UIControlEventTouchUpInside];
    [helperBtn setImage:[UIImage imageNamed:@"新返利教程图片"] forState:UIControlStateNormal];
    UILabel *helperLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, helperBtn.frame.size.height, 150/2, 40/2)];
    helperLabel.text=@"返利教程";
    helperLabel.textAlignment=NSTextAlignmentCenter;
    helperLabel.backgroundColor=[UIColor clearColor];
    helperLabel.font=[UIFont fontWithName:@"Arial" size:10];
    [helperBtn addSubview:helperLabel];
    helperBtn.tag=0;
    [backgroundView addSubview:helperBtn];
    UIImageView *shulineImage=[[UIImageView alloc] initWithFrame:CGRectMake(99, 184/4-170/4, 1, 170/2)];
    [shulineImage setImage:[UIImage imageNamed:@"yishu1"]];
    [backgroundView addSubview:shulineImage];
    
    UIButton *tmallBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    tmallBtn.frame=CGRectMake(111, 10, 155/2, 109/2);
    [tmallBtn addTarget:self action:@selector(presentStoreBrowseViewController:) forControlEvents:UIControlEventTouchUpInside];
    [tmallBtn setImage:[UIImage imageNamed:@"zhemai"] forState:UIControlStateNormal];
    UILabel *tmallLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, tmallBtn.frame.size.height, 150/2, 40/2)];
    tmallLabel.text=@"折买特惠";
    tmallLabel.textAlignment=NSTextAlignmentCenter;
    tmallLabel.backgroundColor=[UIColor clearColor];
    tmallLabel.font=[UIFont fontWithName:@"Arial" size:10];
    [tmallBtn addSubview:tmallLabel];
    tmallBtn.tag=2;
    [backgroundView addSubview:tmallBtn];
    
    UIImageView *shulineImage2=[[UIImageView alloc] initWithFrame:CGRectMake(199, 184/4-170/4, 1, 170/2)];
    [shulineImage2 setImage:[UIImage imageNamed:@"yishu1"]];
    [backgroundView addSubview:shulineImage2];
    
    UIButton *juhuasuanBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    juhuasuanBtn.frame=CGRectMake(300-12-155/2, 10, 155/2, 109/2);
    [juhuasuanBtn addTarget:self action:@selector(showBuTie) forControlEvents:UIControlEventTouchUpInside];
    [juhuasuanBtn setImage:[UIImage imageNamed:@"button_butie"] forState:UIControlStateNormal];
    UILabel *juhuasuanLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, juhuasuanBtn.frame.size.height, 150/2, 40/2)];
    juhuasuanLabel.text=@"领取补贴";
    juhuasuanLabel.textAlignment=NSTextAlignmentCenter;
    juhuasuanLabel.backgroundColor=[UIColor clearColor];
    juhuasuanLabel.font=[UIFont fontWithName:@"Arial" size:10];
    [juhuasuanBtn addSubview:juhuasuanLabel];
    juhuasuanBtn.tag=1;
    [backgroundView addSubview:juhuasuanBtn];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    topListArray=[[NSMutableArray alloc] initWithCapacity:0];
    storeListArray=[[NSMutableArray alloc] initWithCapacity:0];
    brandListArray=[[NSMutableArray alloc] initWithCapacity:0];
    page=[[UIPageControl alloc] initWithFrame:CGRectMake(141, 110, 38,36)];
    //page.center=CGPointMake(160, 126);
    sv=[[UIScrollView alloc] initWithFrame:CGRectMake(10, 5, 300, 130)];
    sv.delegate=self;
    sv.showsHorizontalScrollIndicator=NO;
    sv.backgroundColor=[UIColor clearColor];
    
    [NSTimer scheduledTimerWithTimeInterval:0.7 target: self selector: @selector(handleTimer:)  userInfo:nil  repeats: YES];
    [self AdImg:topListArray];
    [self setCurrentPage:page.currentPage];
    self.webViewController=[[CosjiWebViewController alloc] init];
    self.storeBrowse=[[UINavigationController alloc] initWithRootViewController:self.webViewController];
    self.navigationController.navigationBarHidden=YES;
    selectSection=99;
}
-(void)viewDidAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"首页"];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"首页"];
    [searchField resignFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=NO;
   // float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    #endif
    CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
    if ([storeListArray count]==0)
    {
        [SVProgressHUD showWithStatus:@"正在载入..."];
       // [topListArray addObjectsFromArray:[NSArray arrayWithObjects:@"ggtu",@"tbly", nil]];
        
       
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSDictionary *tmpDic=[serverHelper getJsonDictionary:@"/mall/hot/"];
                NSDictionary *topDic=[serverHelper getJsonDictionary:@"/slide/acquire/?num=5"];
                if (topDic!=nil) {
                    NSDictionary *body=[topDic objectForKey:@"body"];
                    topListArray=[NSMutableArray arrayWithArray:[body objectForKey:@"record"]];
                }
                if ([tmpDic objectForKey:@"body"]!=nil)
                {
                    storeListArray=[NSMutableArray arrayWithArray:[tmpDic objectForKey:@"body"]];
                    NSLog(@"get Store %d",[storeListArray count]);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self AdImg:topListArray];
                        [self setCurrentPage:page.currentPage];
                        [self.mainTableView reloadData];
                    });
                }else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"服务器无法连接，请稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
                        [alert show];

                    });
                    
                }
            });
    }else
    {
    }
    [SVProgressHUD dismiss];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunch"])
    {
        CosjiWelcomeViewController *welcomeViewController=[[CosjiWelcomeViewController alloc] init];
        [self presentViewController:welcomeViewController animated:YES completion:^{
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunch"];
        }];
    }
}
-(void)checkDidResign
{
    CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
    [serverHelper jsonTest];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    page.currentPage=scrollView.contentOffset.x/320;
    [self setCurrentPage:page.currentPage];
}

- (void) handleTimer: (NSTimer *) timer
{
    if (TimeNum % 5 == 0 ) {
        //Tend 默认值为No
        if (!Tend) {
           // NSLog(@"curretn page is %d",page.currentPage);
            page.currentPage++;
            if (page.currentPage==page.numberOfPages-1) {
                Tend=YES;
            }
        }else{
           // NSLog(@"curretn page is %d",page.currentPage);
            page.currentPage--;
            if (page.currentPage==0) {
                Tend=NO;
            }
        }
        [UIView animateWithDuration:0.7 //速度0.7秒
                         animations:^{//修改坐标
                             sv.contentOffset = CGPointMake(page.currentPage*320,0);
                         }];
    }
    TimeNum ++;
}
- (void) setCurrentPage:(NSInteger)secondPage {
    
    for (NSUInteger subviewIndex = 0; subviewIndex < [page.subviews count]; subviewIndex++) {
     //   float version = [[[UIDevice currentDevice] systemVersion] floatValue];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        UIImageView* subview = [page.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 6;
        size.width = 6;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     size.width,size.height)];
        if (subviewIndex == secondPage)
            [subview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"引导页动态"]]];
        else [subview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"引导页默认"]]];
#else
        UIImageView* subview = [page.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 6;
        size.width = 6;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     size.width,size.height)];
        if (subviewIndex == secondPage)
            [subview setImage:[UIImage imageNamed:@"首页-焦点图-动态"]];
        else [subview setImage:[UIImage imageNamed:@"首页-焦点图-默认"]];
#endif
    }
}
-(void)AdImg:(NSMutableArray*)arr{
    [sv setContentSize:CGSizeMake(310*[arr count], 130)];
    page.numberOfPages=[arr count];
    
    for ( int i=0; i<[topListArray count]; i++) {
        NSDictionary *item=[topListArray objectAtIndex:i];
        UIButton *img=[[UIButton alloc]initWithFrame:CGRectMake(320*i, 0, 300, 130)];
        [img addTarget:self action:@selector(Action:) forControlEvents:UIControlEventTouchUpInside];
        img.tag=i;
        [sv addSubview:img];
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[item objectForKey:@"imgUrl"]];
        imageUrl=[imageUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        if ([imageUrl rangeOfString:@"http://www.Cosji.com/"].location==NSNotFound) {
            imageUrl=[NSString stringWithFormat:@"http://www.Cosji.com/%@",imageUrl];
        }
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
                           NSString *filename = [dirName stringByAppendingPathComponent:[NSString stringWithFormat:@"top%@",[item objectForKey:@"id"]]];
                           if (![[NSFileManager defaultManager] fileExistsAtPath:filename])
                           {
                               NSData * data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                               UIImage * cacheimage = [[UIImage alloc] initWithData:data];
                               [UIImageJPEGRepresentation(cacheimage, 0.5) writeToFile:filename atomically:YES];
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   NSData *imageData=[NSData dataWithContentsOfFile:filename];
                                   [img setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                               });
                           }else
                           {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   NSData *imageData=[NSData dataWithContentsOfFile:filename];
                                   [img setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                               });
                           }
                       });
    }
    
}
-(void)Action:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    NSDictionary *topDic=[topListArray objectAtIndex:btn.tag];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[topDic objectForKey:@"url"]]]];
    CosjiNormalWebViewController *normalWebViewController=[[CosjiNormalWebViewController alloc] init];
    [self  presentViewController:normalWebViewController animated:YES completion:nil];
    [normalWebViewController setThisWebViewWithName:request name:[NSString stringWithFormat:@"%@",[topDic objectForKey:@"title"]]];
}
void TopImageFromURL( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
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

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int number = 0;
    switch (section) {
        case 0:
        {
            number=1;
        }
            break;
        case 1:
        {
            number=1;
        }
            break;
        case 2:
        {
            if ([storeListArray count]==0)
            {
                number=0;
            }else
            {
                number=5;
            }
        }
            break;
    }
    return number;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    float height;
    switch (indexPath.section) {
        case 0:
        {
            height=140.0;
        }
            break;
        case 1:
        {
            height=184/2+7;
        }
            break;
        case 2:
        {
            height=152.0/2;
        }
            break;
    }
    return height;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 7)];
        headerView.backgroundColor=[UIColor clearColor];
        return headerView;
    }else
        return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        return 7;
    }else
        return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // static NSString *cellIdentifier = @"MyCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    // cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >=7.0)
    {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    switch (indexPath.section) {
        case 0:
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell addSubview:sv];
            [cell addSubview:page];
        }
            break;
        case 1:
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell addSubview:backgroundView];
        }
            break;
        case 2:
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            //商城左
            for (int x=0; x<3; x++)
            {
                if (indexPath.row*3+x<[storeListArray count])
                {
                    if (indexPath.row*3+x==[storeListArray count]-1)
                    {
                        UIView *btnView=[[UIView alloc] initWithFrame:CGRectMake(10+100*2, 0, 198/2, 150/2)];
                        btnView.backgroundColor=[UIColor whiteColor];
                        UIButton *moreButton=[UIButton buttonWithType:UIButtonTypeCustom];
                        moreButton.frame=CGRectMake(15, 15, 69, 45);
                       // [moreButton setBackgroundImage:[UIImage imageNamed:@"首页-更多"] forState:UIControlStateNormal];
                        [moreButton setTitle:@"更多商城" forState:UIControlStateNormal];
                      // [moreButton setBackgroundColor:[UIColor redColor]];
                        [moreButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                        moreButton.titleLabel.font=[UIFont fontWithName:@"Arial" size:15];
                        [moreButton addTarget:self action:@selector(allMalls) forControlEvents:UIControlEventTouchDown];
                        [btnView addSubview:moreButton];
                        [cell addSubview:btnView];
                    }else
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
                                                   [button setBackgroundImage:[UIImage imageWithData:imageData scale:0.8] forState:UIControlStateNormal];
                                               });
                                           }
                                       });
                        [button addTarget:self action:@selector(opRemenshangcheng:) forControlEvents:UIControlEventTouchUpInside];
                        [btnView addSubview:button];
                        [cell addSubview:btnView];
                        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 50, 95, 20)];
                        label.font=[UIFont fontWithName:@"Arial" size:10];
                        label.backgroundColor=[UIColor lightTextColor];
                        label.textAlignment=NSTextAlignmentCenter;
                        label.text=[NSString stringWithFormat:@"最高返利%@",[storeDic objectForKey:@"profit" ]];
                        [btnView addSubview:label];

                    }
                }
            }
        }
            break;
        case 3:
        {
            UIButton *moreButton=[UIButton buttonWithType:UIButtonTypeCustom];
            moreButton.frame=CGRectMake(10, 0, 198/2, 150/2);
            [moreButton setBackgroundImage:[UIImage imageNamed:@"首页-更多"] forState:UIControlStateNormal];
            [moreButton addTarget:self action:@selector(allMalls) forControlEvents:UIControlEventTouchDown];
            [cell addSubview:moreButton];
        }
            break;
    }
    return cell;
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
                NSURLRequest *request =[NSURLRequest requestWithURL:url];
                CosjiNormalWebViewController *normalWebViewController=[[CosjiNormalWebViewController alloc] init];
                [self  presentViewController:normalWebViewController animated:YES completion:nil];
                [normalWebViewController setThisWebViewWithName:request name:[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"name"]]];
               // [self.webViewController.webView loadRequest:request];
                //[self.webViewController.storeName setText:[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"name"]]];
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
    else if(alertView.tag==10)
        {
            if (buttonIndex==1) {
                NSURL *url =[NSURL URLWithString:@"http://www.zhemai.com"];
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    else
    {
        if (buttonIndex==1) {
            CosjiLoginViewController *loginViewController=[CosjiLoginViewController shareCosjiLoginViewController];
            [self presentViewController:loginViewController animated:YES completion:nil];
        }
    }
}


-(void)presentStoreBrowseViewController:(id)sender
{
    switch ([sender tag]) {
        case 0:
        {
            CosjiGuideViewController *guideViewController=[CosjiGuideViewController shareCosjiGuideViewController];
            [self presentViewController:guideViewController animated:YES completion:nil];
        }
            break;
        case 1:
        {
            NSURL *url =[NSURL URLWithString:@"http://ju.m.taobao.com"];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            CosjiWebViewController *webViewC=[[CosjiWebViewController alloc] init];
            UINavigationController *tmpNavController=[[UINavigationController alloc] initWithRootViewController:webViewC];
            [self  presentViewController:tmpNavController animated:YES completion:nil];
            [webViewC setThisWebViewWithName:request name:[NSString stringWithFormat:@"已进入聚划算"]];
        }
            break;
        case 2:
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"折买网(zhemai.com)每天上新数百款优质商品，一折起全场包邮，确定现在访问？" delegate:self cancelButtonTitle:@"稍后" otherButtonTitles:@"访问", nil];
            alert.tag=10;
            [alert show];

        }
            break;
    }
}
-(void)showSearchView
{
    if (searchViewShowing==NO) {
        NSLog(@"SHOW");
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        CGFloat translation = 45;
        searchView.transform = CGAffineTransformMakeTranslation(0, translation);
        [UIView commitAnimations];
        searchViewShowing=YES;
    }else
    {
        NSLog(@"HIDE");
        [searchField resignFirstResponder];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        CGFloat translation = 0;
        searchView.transform = CGAffineTransformMakeTranslation(0,translation);
        [UIView commitAnimations];
        searchViewShowing=NO;
    }
}
-(void)searchItemFrom:(UITextField*)textField
{
    [textField resignFirstResponder];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"havelogined"])
    {
        if (textField!=nil&&![textField.text isEqualToString:@""])
        {
            [self showFanliDetailWebView:textField.text];
//            NSLog(@"开始搜索");
//            
//            CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
//            if ([self isPureInt:searchField.text])
//            {
//                NSString *num_iid=[NSString stringWithFormat:@"%@",searchField.text];
//                NSDictionary *infoDic=[serverHelper getItemFromTop:num_iid];
//                if (infoDic==nil)
//                {
//                    [SVProgressHUD showErrorWithStatus:@"搜索不到该商品或该商品没有返利" duration:3];
//                }else
//                {
//                    CosjiItemFanliDetailViewController *fanliDetailVC=[CosjiItemFanliDetailViewController shareCosjiItemFanliDetailViewController];
//                    
//                    [self presentViewController:fanliDetailVC animated:YES completion:nil];
//                    [fanliDetailVC loadItemInfoWithDic:infoDic];
//                }
//            }else
//            {
//                NSDictionary *resultDic=[CosjiUrlFilter filterUrl:searchField.text];
//                if (resultDic == nil)
//                {
//                    return;
//                }
//                NSNumber *resultNumber=[resultDic objectForKey:@"UrlType"];
//                NSLog(@"%@",[resultDic objectForKey:@"UrlType"]);
//                switch ([resultNumber intValue]) {
//                    case 0:
//                    {
//                        NSLog(@"//普通链接");
//                        [self presentViewController:self.storeBrowse animated:YES completion:nil];
//                        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"url"]]];
//                        [self.webViewController setThisWebViewWithName:[NSURLRequest requestWithURL:url] name:@"查找返利"];
//                    }
//                        break;
//                    case 1://混合链接
//                    {
//                        NSLog(@"//混合链接");
//                        [self presentViewController:self.storeBrowse animated:YES completion:nil];
//                        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"url"]]];
//                        [self.webViewController setThisWebViewWithName:[NSURLRequest requestWithURL:url] name:@"查找返利"];
//                    }
//                        break;
//                    case 2://特别链接（带有淘宝推广的链接）
//                    {
//                        NSLog(@"//特别链接");
//                        
//                        [self presentFanliDetailVCWithNumID:[resultDic objectForKey:@"num_iid"]];
//                    }
//                        break;
//                    case 3://淘宝商品链接
//                    {
//                        NSLog(@"//淘宝链接");
//                        
//                        [self presentFanliDetailVCWithNumID:[resultDic objectForKey:@"num_iid"]];
//                        
//                    }
//                        break;
//                    case 4://天猫商品链接
//                    {
//                        NSLog(@"//天猫链接");
//                        
//                        [self presentFanliDetailVCWithNumID:[resultDic objectForKey:@"num_iid"]];
//                        
//                    }
//                        break;
//                    case 5:
//                    {
//                        NSLog(@"//纯文本");
//                        [self presentItemList:[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"String"]]];
//                    }
//                        break;
//                    case 6:
//                    {
//                        [self presentFanliDetailVCWithNumID:[resultDic objectForKey:@"num_iid"]];
//                    }
//                        break;
//                }
//                
//            }
//
        }else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入您想要搜索的商品" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
        }
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"登录查询获取返利" delegate:self cancelButtonTitle:@"跳过" otherButtonTitles:@"登陆",nil];
        alert.tag=1;
        [alert show];
    }
}
//-(void)showApiResponse:(id)data
//{
//    if ([data isKindOfClass:[TopApiResponse class]])
//    {
//        TopApiResponse *response = (TopApiResponse *)data;
//        
//        if ([response content])
//        {
//            NSLog(@"%@",[response content]);
//        }
//        else {
//            NSLog(@"%@",[(NSError *)[response error] userInfo]);
//        }
//        
//        NSDictionary *dictionary = (NSDictionary *)[response reqParams];
//        
//        for (id key in dictionary) {
//            
//            NSLog(@"key: %@, value: %@", key, [dictionary objectForKey:key]);
//            
//        }
//    }
//    
//}

- (void)showBuTie
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"havelogined"])
    {
        CosjiFanLiListViewController *viewController = [[CosjiFanLiListViewController alloc] init];
        [self presentViewController:viewController animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"登录获取返利" delegate:self cancelButtonTitle:@"跳过" otherButtonTitles:@"登陆",nil];
        alert.tag=110;
        [alert show];
        return;
    }
}

- (void)showFanliDetailWebView:(NSString*)keyWord
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"havelogined"])
    {
        NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
        NSDictionary *infoDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
        NSString *userID = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"userId"]];
        
        
        NSString *prepareUrlString = [NSString stringWithFormat:@"http://ai.m.taobao.com/search.html?back=true&q=%@&pid=mm_26039255_8350334_28114441&unid=%@",[self URLEncodedString:keyWord],userID];
        
        
        
        CosjiNewWebViewController *storeWebViewController=[[CosjiNewWebViewController alloc] init];
        
        UINavigationController *tmpNav=[[UINavigationController alloc] initWithRootViewController:storeWebViewController];
        tmpNav.navigationBarHidden=YES;
        [self presentViewController:tmpNav animated:YES completion:nil];
        storeWebViewController.itemName = keyWord;
        storeWebViewController.urlStirng = prepareUrlString;
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"登录获取返利" delegate:self cancelButtonTitle:@"跳过" otherButtonTitles:@"登陆",nil];
        alert.tag=110;
        [alert show];
        return;
    }
    
}

- (NSString *)URLEncodedString:(NSString*)target{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)target,
                                                                                             NULL,
                                                                                             CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                             kCFStringEncodingUTF8));
    return result;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField           // became first responder
{
    [textField.window makeKeyAndVisible];
}
-(void)detailRemoteNotification:(NSDictionary*)infoDic
{
    if ([infoDic objectForKey:@"openUrl"]!=nil)
    {
        NSString *openUrl=[NSMutableString stringWithFormat:@"%@",[infoDic objectForKey:@"openUrl"]];
        NSURL *url =[NSURL URLWithString:[openUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
        NSDictionary *apsDic=[NSDictionary dictionaryWithDictionary:[infoDic objectForKey:@"aps"]];
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        [self  presentViewController:self.storeBrowse animated:YES completion:nil];
        [self.webViewController setThisWebViewWithName:request name:[NSString stringWithFormat:@"%@",[apsDic objectForKey:@"alert"]]];
    }
}
- (void)allMalls
{
    if (self.mallsListViewController==nil) {
        self.mallsListViewController=[[CosjiMallsListViewController alloc] init];
    }
    [self.navigationController pushViewController:self.mallsListViewController animated:YES];
}
-(void)presentItemList:(NSString*)keyword
{
    CosjiItemListViewController *itemsListViewController=[CosjiItemListViewController shareCosjiItemListViewController];
    if (self.itemsListNavCon==nil)
    {
        self.itemsListNavCon=[[UINavigationController alloc] initWithRootViewController:itemsListViewController];
        self.itemsListNavCon.navigationBarHidden=YES;
    }
    [self presentViewController:self.itemsListNavCon animated:YES completion:nil];
    [itemsListViewController loadInfoWith:keyword atPage:1];
}
-(void)presentFanliDetailVCWithNumID:(NSString*)num_id
{
    CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
    NSDictionary *infoDic=[serverHelper getItemFromTop:num_id];
    if (infoDic==nil)
    {
        [SVProgressHUD showErrorWithStatus:@"搜索不到该商品或该商品没有返利" duration:6];
    }else
    {
        CosjiItemFanliDetailViewController *fanliDetailVC=[CosjiItemFanliDetailViewController shareCosjiItemFanliDetailViewController];
        [self presentViewController:fanliDetailVC animated:YES completion:nil];
        [fanliDetailVC loadItemInfoWithDic:infoDic];
    }
    
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (IBAction)exitKeyboard:(id)sender {
    [sender resignFirstResponder];
}
- (void)viewDidUnload {
    [self setCustomHeadView:nil];
    [super viewDidUnload];
}


@end
