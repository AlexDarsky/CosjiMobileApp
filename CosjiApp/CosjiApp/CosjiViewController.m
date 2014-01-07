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
#import "MobileProbe.h"
#import "CosjiServerHelper.h"
#import "CosjiLoginViewController.h"
#import "SVProgressHUD.h"
#import "CosjiGuideViewController.h"
#import "CosjiItemListViewController.h"
#import "TopIOSClient.h"
#import "CosjiItemFanliDetailViewController.h"
#import "TopAttachment.h"
#import "CosjiWelcomeViewController.h"



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
    self.mainTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 48, 320, [UIScreen mainScreen].bounds.size.height-48-49-20)];
    self.mainTableView.delegate=self;
    self.mainTableView.dataSource=self;
    self.mainTableView.backgroundColor=[UIColor clearColor];
    self.mainTableView.backgroundView=nil;
    [self.mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.mainTableView];
    self.CustomHeadView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    self.CustomHeadView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
    UIButton *searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame=CGRectMake(self.CustomHeadView.frame.size.width-40, self.CustomHeadView.frame.size.height/2-82/4, 64/2, 82/2);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"工具栏背景-搜索"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(showSearchView) forControlEvents:UIControlEventTouchDown];
    [self.CustomHeadView addSubview:searchBtn];
    searchView=[[UIView alloc] initWithFrame:self.CustomHeadView.frame];
    searchView.backgroundColor=[UIColor whiteColor];
    searchField=[[UITextField alloc] initWithFrame:CGRectMake(10, 5, 300, 35)];
    searchField.borderStyle=UITextBorderStyleRoundedRect;
    searchField.returnKeyType=UIReturnKeySearch;
    searchField.clearButtonMode=UITextFieldViewModeWhileEditing;
    searchField.textAlignment=UITextAlignmentLeft;
    searchField.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    searchField.backgroundColor=[UIColor clearColor];
    searchField.font=[UIFont fontWithName:@"Arial" size:18];
    searchField.placeholder=@"输入商品名称/网址/ID,查询返利";
    [searchView addSubview:searchField];
    [searchField addTarget:self action:@selector(searchItemFrom:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:searchView];
    searchViewShowing=NO;
    [self.view addSubview:self.CustomHeadView];
    UIImageView *llogoImage=[[UIImageView alloc] initWithFrame:CGRectMake(14, 6, 156/2, 65/2)];
    llogoImage.image=[UIImage imageNamed:@"工具栏背景-标语"];
    [self.CustomHeadView addSubview:llogoImage];
    UIImageView *blogoImage=[[UIImageView alloc] initWithFrame:CGRectMake(129,13, 126/2, 42/2)];
    blogoImage.image=[UIImage imageNamed:@"工具栏背景-logo"];
    [self.CustomHeadView addSubview:blogoImage];
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
    [tmallBtn setImage:[UIImage imageNamed:@"新首页天猫"] forState:UIControlStateNormal];
    UILabel *tmallLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, tmallBtn.frame.size.height, 150/2, 40/2)];
    tmallLabel.text=@"天猫商城";
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
    juhuasuanBtn.frame=CGRectMake(300-12-155/2, 20, 155/2, 109/2);
    [juhuasuanBtn addTarget:self action:@selector(presentStoreBrowseViewController:) forControlEvents:UIControlEventTouchUpInside];
    [juhuasuanBtn setImage:[UIImage imageNamed:@"新首页聚划算"] forState:UIControlStateNormal];
    UILabel *juhuasuanLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, juhuasuanBtn.frame.size.height-10, 150/2, 40/2)];
    juhuasuanLabel.text=@"聚划算";
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
    topListArray=[[NSMutableArray alloc] initWithObjects:@"ggtu",@"tbly", nil];
    storeListArray=[[NSMutableArray alloc] initWithCapacity:0];
    brandListArray=[[NSMutableArray alloc] initWithCapacity:0];
    page=[[UIPageControl alloc] initWithFrame:CGRectMake(141, 110, 38,36)];
    //page.center=CGPointMake(160, 126);
    sv=[[UIScrollView alloc] initWithFrame:CGRectMake(10, 5, 300, 130)];
    sv.delegate=self;
    sv.showsHorizontalScrollIndicator=NO;
    sv.backgroundColor=[UIColor clearColor];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target: self selector: @selector(handleTimer:)  userInfo:nil  repeats: YES];
    [self AdImg:topListArray];
    [self setCurrentPage:page.currentPage];
    self.storeBrowseViewController=[[CosjiWebViewController alloc] initWithNibName:@"CosjiWebViewController" bundle:nil];
    self.navigationController.navigationBarHidden=YES;
    selectSection=99;
}
-(void)viewDidAppear:(BOOL)animated
{
    [MobileProbe pageBeginWithName:@"首页"];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [MobileProbe pageEndWithName:@"首页"];
    [searchField resignFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=NO;
    
    CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
    if ([storeListArray count]==0)
    {
        [SVProgressHUD showWithStatus:@"正在载入..."];

        NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:@"/mall/hot/"]];
        if ([tmpDic objectForKey:@"body"]!=nil)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                storeListArray=[NSMutableArray arrayWithArray:[tmpDic objectForKey:@"body"]];
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
        UIImageView* subview = [page.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 6;
        size.width = 6;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     size.width,size.height)];
        
        if (subviewIndex == secondPage) [subview setImage:[UIImage imageNamed:@"首页-焦点图-动态"]];
        else [subview setImage:[UIImage imageNamed:@"首页-焦点图-默认"]];
        
    }
}
-(void)AdImg:(NSMutableArray*)arr{
    [sv setContentSize:CGSizeMake(310*[arr count], 130)];
    page.numberOfPages=[arr count];
    
    for ( int i=0; i<[topListArray count]; i++) {
        
        UIButton *img=[[UIButton alloc]initWithFrame:CGRectMake(320*i, 0, 300, 130)];
        [img addTarget:self action:@selector(Action:) forControlEvents:UIControlEventTouchUpInside];
        img.tag=i;
        [sv addSubview:img];
        [img setImage:[UIImage imageNamed:[topListArray objectAtIndex:i]] forState:UIControlStateNormal];
    }
    
}
-(void)Action:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    switch (btn.tag) {
        case 0:
        {
            NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://s.click.taobao.com/t?e=zGU34CA7K%2BPkqB05%2Bm7rfGGjlY60oHcc7bkKOQYnIZl9roglx55ogY7XuIFA0XBbk%2Fzm7aeOZ3PlyybISkbOM7EtEdqHK%2B3%2B2VdLKXhDskZ4%2Fp2dh4NGvuCXRstUW1YAfVUjzoW0F55hwbLHDGosDrPX%2FGtVj28pHoIIzbTeYkfNwFLQ7ML46dUp2gxPHRwH7gFin%2BDZsAILX5h9mGLjjAhRlA%3D%3D"]];
            [self.navigationController pushViewController:self.storeBrowseViewController animated:YES];
            [self.storeBrowseViewController.webView loadRequest:request];
            [self.storeBrowseViewController.storeName setText:@"底价抢大牌"];

       }
            break;
        case 1:
        {
            NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://s.click.taobao.com/t?e=zGU34CA7K%2BPkqB05%2Bm7rfGKas1PIKp0U37pZuBotzOg7OjY%2F2R0Ke3HHzv2kJZUH%2FehqodvBvxouiCPW7UkqmIn4pk08catp7aU2wpqfONSeQJM%3D&pid=mm_26039255_0_0"]];
            [self.navigationController pushViewController:self.storeBrowseViewController animated:YES];
            [self.storeBrowseViewController.webView loadRequest:request];
            [self.storeBrowseViewController.storeName setText:@"淘宝旅行"];
        }
            break;
    }
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
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"]isEqualToString:@"YES"]) {
        NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[storeListArray objectAtIndex:selectedIndex]];
        NSString *storeUrl=[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"yiqifaurl"]];
        NSLog(@"storeUrl is %@",tmpDic);
        NSURL *url =[NSURL URLWithString:[storeUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        //[self.storeBrowseViewController setUrlString:[NSString stringWithFormat:@"%@",storeUrl]];
        [self.navigationController pushViewController:self.storeBrowseViewController animated:YES];

      [self.storeBrowseViewController.webView loadRequest:request];
        [self.storeBrowseViewController.storeName setText:[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"name"]]];


    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"登录获取返利" delegate:self cancelButtonTitle:@"跳过" otherButtonTitles:@"登陆",nil];
        alert.tag=1;
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1) {
        switch (buttonIndex) {
            case 0:{
                NSLog(@"case 0");
                NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[storeListArray objectAtIndex:selectedIndex]];
                NSString *storeUrl=[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"yiqifaurl"]];
                NSLog(@"%@",[storeUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""]);
                
                NSURL *url =[NSURL URLWithString:[storeUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
                NSURLRequest *request =[NSURLRequest requestWithURL:url];
                [self.navigationController pushViewController:self.storeBrowseViewController animated:YES];
                [self.storeBrowseViewController.webView loadRequest:request];
                [self.storeBrowseViewController.storeName setText:[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"name"]]];
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
    }else
    {
        if (buttonIndex==1) {
            CosjiLoginViewController *loginViewController=[CosjiLoginViewController shareCosjiLoginViewController];
            [self presentViewController:loginViewController animated:YES completion:nil];
        }
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:{
            NSLog(@"case 0");
            NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[storeListArray objectAtIndex:selectedIndex]];
            NSString *storeUrl=[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"yiqifaurl"]];
            NSLog(@"%@",[storeUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""]);
            NSURL *url =[NSURL URLWithString:[storeUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            [self.navigationController pushViewController:self.storeBrowseViewController animated:YES];
            [self.storeBrowseViewController.webView loadRequest:request];
            [self.storeBrowseViewController.storeName setText:[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"name"]]];
            
        }
            break;
            
        case 1:
        {
            CosjiLoginViewController *loginViewController=[CosjiLoginViewController shareCosjiLoginViewController];
            [self presentViewController:loginViewController animated:YES completion:nil];
            NSLog(@"case 1");
        }
            break;
    }
}
-(void)presentStoreBrowseViewController:(id)sender
{
    NSLog(@"%d",[sender tag]);
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
            [self.navigationController pushViewController:self.storeBrowseViewController animated:YES];
            [self.storeBrowseViewController.webView loadRequest:request];
            [self.storeBrowseViewController.storeName setText:@"已进入聚划算"];
        }
            break;
        case 2:
        {
            NSURL *url =[NSURL URLWithString:@"http://m.tmall.com"];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
             [self.navigationController pushViewController:self.storeBrowseViewController animated:YES];
            [self.storeBrowseViewController.webView loadRequest:request];
            [self.storeBrowseViewController.storeName setText:@"已进入天猫"];
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
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"]isEqualToString:@"YES"])
    {
        if (textField!=nil&&![textField.text isEqualToString:@""])
        {
            NSLog(@"开始搜索");
            CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
            switch ([serverHelper getSearchItemType:searchField.text]) {
                case 0:
                {
                    NSLog(@"这个是地址");
                    int location=[[NSString stringWithFormat:@"%@",searchField.text] rangeOfString:@"id="].location;
                    NSString *num_iid=[[NSString stringWithFormat:@"%@",searchField.text] substringWithRange:NSMakeRange(location+3, 11)];
                    NSDictionary *infoDic=[NSDictionary dictionaryWithDictionary:[serverHelper getItemFromTop:num_iid]];
                    if (infoDic==nil)
                    {
                        [SVProgressHUD showErrorWithStatus:@"搜索不到该商品或该商品没有返利" duration:3];
                    }else
                    {
                        CosjiItemFanliDetailViewController *fanliDetailVC=[CosjiItemFanliDetailViewController shareCosjiItemFanliDetailViewController];

                        [self presentViewController:fanliDetailVC animated:YES completion:nil];
                        [fanliDetailVC loadItemInfoWithDic:infoDic];
                    }
                }
                    break;
                case 1:
                {
                    NSLog(@"这个是ID");
                    NSString *num_iid=[NSString stringWithFormat:@"%@",searchField.text];
                    NSDictionary *infoDic=[NSDictionary dictionaryWithDictionary:[serverHelper getItemFromTop:num_iid]];
                    if (infoDic==nil)
                    {
                        [SVProgressHUD showErrorWithStatus:@"搜索不到该商品或该商品没有返利" duration:3];
                    }else
                    {
                        CosjiItemFanliDetailViewController *fanliDetailVC=[CosjiItemFanliDetailViewController shareCosjiItemFanliDetailViewController];
                        
                        [self presentViewController:fanliDetailVC animated:YES completion:nil];
                        [fanliDetailVC loadItemInfoWithDic:infoDic];
                    }
                }
                    break;
                case 2:
                {
                    CosjiItemListViewController *itemsListViewController=[CosjiItemListViewController shareCosjiItemListViewController];
                    [self presentViewController:itemsListViewController animated:YES completion:nil];
                    [itemsListViewController loadInfoWith:[NSString stringWithFormat:@"%@",searchField.text] atPage:1];
                }
                default:
                    break;
            }

        }else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入您想要搜索的商品或查询的网址" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
        }

    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"登录查询获取返利" delegate:self cancelButtonTitle:@"跳过" otherButtonTitles:@"登陆",nil];
        alert.tag=1;
        [alert show];
    }
}
-(void)showApiResponse:(id)data
{
    if ([data isKindOfClass:[TopApiResponse class]])
    {
        TopApiResponse *response = (TopApiResponse *)data;
        
        if ([response content])
        {
            NSLog(@"%@",[response content]);
        }
        else {
            NSLog(@"%@",[(NSError *)[response error] userInfo]);
        }
        
        NSDictionary *dictionary = (NSDictionary *)[response reqParams];
        
        for (id key in dictionary) {
            
            NSLog(@"key: %@, value: %@", key, [dictionary objectForKey:key]);
            
        }
    }
    
}

- (void)allMalls
{
    if (self.mallsListViewController==nil) {
        self.mallsListViewController=[[CosjiMallsListViewController alloc] init];
    }
    [self presentViewController:self.mallsListViewController animated:YES completion:nil];
}
-(void)closeAuthView{
    [nc dismissModalViewControllerAnimated:YES];
    nc = nil;
}
- (IBAction)exitKeyboard:(id)sender {
    [sender resignFirstResponder];
}
- (void)viewDidUnload {
    [self setCustomHeadView:nil];
    [super viewDidUnload];
}


@end
