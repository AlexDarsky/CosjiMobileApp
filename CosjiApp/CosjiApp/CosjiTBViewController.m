//
//  CosjiTBViewController.m
//  可及网
//
//  Created by Darsky on 13-8-23.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiTBViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CosjiWebViewController.h"
#import "MobileProbe.h"
#import "CosjiItemListViewController.h"
#import "CosjiServerHelper.h"
#import "SVProgressHUD.h"
#import "CosjiItemFanliDetailViewController.h"
#import "CosjiLoginViewController.h"

@interface CosjiTBViewController ()
{
    UIImageView *searchFieldBG;
    UILabel *fanliTongdaoLabel;
    UIButton *exitBtn;
    UIView *TBbackGround;
    int preSelected;
}
@end

@implementation CosjiTBViewController
@synthesize tableView,customNavBar;
@synthesize searchField,taoBtn,tmallBtn,juBtn;

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
    [MobileProbe pageBeginWithName:@"返利通道"];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [MobileProbe pageEndWithName:@"返利通道"];
    [self.searchField resignFirstResponder];
}
-(void)loadView
{
    UIView *primary=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    primary.backgroundColor=[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:100];
    self.view=primary;
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 7.0)
    {
        self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 65, 320, [UIScreen mainScreen].bounds.size.height-65-49)];
        self.customNavBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
        self.customNavBar.backgroundColor=[UIColor colorWithRed:225.0/255.0 green:47.0/255.0 blue:50.0/255.0 alpha:100];
        self.automaticallyAdjustsScrollViewInsets=NO;
        UILabel *blogoLabel=[[UILabel alloc] initWithFrame:CGRectMake(160-50, self.customNavBar.frame.size.height-38, 100, 25)];
        blogoLabel.text=@"返利通道";
        blogoLabel.textColor=[UIColor whiteColor];
        blogoLabel.textAlignment=NSTextAlignmentCenter;
        blogoLabel.backgroundColor=[UIColor clearColor];
        blogoLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:20];
        [self.customNavBar addSubview:blogoLabel];
    }
    else
    {
        self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 45, 320, [UIScreen mainScreen].bounds.size.height-45-20-49)];
        self.customNavBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
        self.customNavBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
        UIImageView *blogoImage=[[UIImageView alloc] initWithFrame:CGRectMake(160-155/4,self.customNavBar.frame.size.height-34, 155/2, 40/2)];
        blogoImage.image=[UIImage imageNamed:@"淘宝返利"];
        [self.customNavBar addSubview:blogoImage];
    }
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.backgroundView=nil;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
    UIButton *moreBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame=CGRectMake(284, self.customNavBar.frame.size.height-33, 23, 21);
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"更多列表"] forState:UIControlStateNormal];
    [moreBtn addTarget:self  action:@selector(presentAllItemsTable) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavBar addSubview:moreBtn];
    [self.view addSubview:self.customNavBar];
    UIImageView *llogoImage=[[UIImageView alloc] initWithFrame:CGRectMake(6,self.customNavBar.frame.size.height-39,156/2, 65/2)];
    llogoImage.image=[UIImage imageNamed:@"工具栏背景-标语"];
    [self.customNavBar addSubview:llogoImage];




    
    }
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden=YES;
    subjectsArray=[[NSMutableArray alloc] initWithCapacity:0];
    self.searchField=[[UITextField alloc] initWithFrame:CGRectMake(22+56/2, 20, 260, 35)];
    self.searchField.delegate=self;
    self.searchField.borderStyle=UITextBorderStyleNone;
    self.searchField.returnKeyType=UIReturnKeySearch;
    self.searchField.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.searchField.textAlignment=NSTextAlignmentLeft;
    self.searchField.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    self.searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.searchField.backgroundColor=[UIColor clearColor];
    self.searchField.font=[UIFont fontWithName:@"Arial" size:16];
    self.searchField.placeholder=@"粘贴商品全名或输入关键字，拿返利";
    [self.searchField addTarget:self action:@selector(searchItemFrom:) forControlEvents:UIControlEventEditingDidEndOnExit];
    TBbackGround=[[UIView alloc] initWithFrame:CGRectMake(10, 70, 300, 120)];
    TBbackGround.backgroundColor=[UIColor whiteColor];
    UIImageView *tbflxuxian=[[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 550/2, 2)];
    [tbflxuxian setImage:[UIImage imageNamed:@"淘宝返利标题虚线"]];
    [TBbackGround addSubview:tbflxuxian];
    fanliTongdaoLabel=[[UILabel alloc] initWithFrame:CGRectMake(300/2-120/2, 10, 120, 20)];
    fanliTongdaoLabel.backgroundColor=[UIColor whiteColor];
    fanliTongdaoLabel.textAlignment=NSTextAlignmentCenter;
    fanliTongdaoLabel.textColor=[UIColor darkGrayColor];
    fanliTongdaoLabel.text=@"返利通道";
    fanliTongdaoLabel.font=[UIFont fontWithName:@"Arial" size:14];
    self.taoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.taoBtn.frame=CGRectMake(30, 35, 60, 60);
    self.taoBtn.tag=0;
    [self.taoBtn addTarget:self action:@selector(presentStoreBrowseViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.taoBtn setBackgroundImage:[UIImage imageNamed:@"淘宝返利_淘宝"] forState:UIControlStateNormal];
    [self.taoBtn setTitle:@"淘宝" forState:UIControlStateNormal];
    [self.taoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.taoBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:12];
    [self.taoBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 1, -80, 0)];

    self.tmallBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.tmallBtn.frame=CGRectMake(120, 35, 60, 60);
    self.tmallBtn.tag=1;
    [self.tmallBtn addTarget:self action:@selector(presentStoreBrowseViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.tmallBtn setBackgroundImage:[UIImage imageNamed:@"淘宝返利_天猫"] forState:UIControlStateNormal];
    [self.tmallBtn setTitle:@"天猫" forState:UIControlStateNormal];
    [self.tmallBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.tmallBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:12];
    [self.tmallBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 1, -80, 0)];
    self.juBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.juBtn.frame=CGRectMake(210,35, 60, 60);
    self.juBtn.tag=2;
    [self.juBtn addTarget:self action:@selector(presentStoreBrowseViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.juBtn setBackgroundImage:[UIImage imageNamed:@"淘宝返利_聚划算"] forState:UIControlStateNormal];
    [self.juBtn setTitle:@"聚划算" forState:UIControlStateNormal];
    [self.juBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.juBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:12];
    [self.juBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 1, -80, 0)];
    
    [TBbackGround addSubview:fanliTongdaoLabel];
    [TBbackGround addSubview:self.taoBtn];
    [TBbackGround addSubview:self.tmallBtn];
    [TBbackGround addSubview:self.juBtn];
    searchFieldBG=[[UIImageView alloc] initWithFrame:CGRectMake(320/2-598/4, 15, 598/2, 86/2)];
    [searchFieldBG setImage:[UIImage imageNamed:@"淘宝返利搜索框"]];
    searchFieldBG.userInteractionEnabled=YES;
    UIImageView *imgv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"搜索框放大镜"]];
    imgv.frame=CGRectMake(8, searchFieldBG.frame.size.height/2-57/4, 56/2, 57/2);
    [searchFieldBG addSubview:imgv];
    self.webViewController=[[CosjiWebViewController alloc] init];
    exitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.frame=CGRectMake(0,110,320,[UIScreen mainScreen].bounds.size.height-45-20-49-110);
    [exitBtn addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:exitBtn];
    exitBtn.hidden=YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [SVProgressHUD showWithStatus:@"正在载入..."];
    self.navigationController.navigationBarHidden=YES;
    self.tabBarController.tabBar.hidden=NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

    if ([subjectsArray count]==0)
    {
        CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
        NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:@"/taobao/category/"]];
        if ([tmpDic objectForKey:@"body"]!=nil)
        {
                NSDictionary *subjectsListDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
                for (int x=1; x<=7; x++) {
                    [subjectsArray addObject:[subjectsListDic objectForKey:[NSString stringWithFormat:@"%d",x]]];
                }
                NSLog(@"get Store %d",[subjectsArray count]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [self.tableView reloadData];
                });
                
        }else
        {
            [SVProgressHUD dismiss];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"服务器无法连接，请稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
        }
    }else
    {
        
    }
    });
    [SVProgressHUD dismiss];
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1+[subjectsArray count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    float height;
    switch (indexPath.section) {
        case 0:
        {
            height=190.0;
        }
            break;
        default:
        {
            height=205.0;
        }
            break;
    }
    return height;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section>0) {
        UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
        headerView.backgroundColor=[UIColor clearColor];
        return headerView;
    }else
    {
        UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        headerView.backgroundColor=[UIColor clearColor];
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height;
    switch (section)
    {
        case 0:
        {
            height=0;
        }
            break;
        default:
        {
            height=10;
        }
    break;
    
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MyCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    // cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >=7.0)
    {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    switch (indexPath.section) {
        case 0:
        {
 
            [cell addSubview:searchFieldBG];
            [cell addSubview:self.searchField];
            
            [cell addSubview:TBbackGround];
            
        }
            break;
            default:
        {
           NSDictionary *subjectDic=[NSDictionary dictionaryWithDictionary:[subjectsArray objectAtIndex:indexPath.section-1]];
            
            NSArray *subjectItemsArray=[NSArray arrayWithArray:[subjectDic objectForKey:@"child"]];
            NSLog(@"subjectItems is %d",[subjectItemsArray count]);
            UIView *backGround=[[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 205)];
            backGround.backgroundColor=[UIColor whiteColor];
            UIImageView *tbflxuxian=[[UIImageView alloc] initWithFrame:CGRectMake(12.5, 12, 550/2, 2)];
            [tbflxuxian setImage:[UIImage imageNamed:@"淘宝返利标题虚线"]];
            [backGround addSubview:tbflxuxian];
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(300/2-60/2, 0, 60, 30)];
            label.text=[NSString stringWithFormat:@"%@",[subjectDic objectForKey:@"name"]];
            label.font=[UIFont fontWithName:@"Arial" size:14];
            label.backgroundColor=[UIColor whiteColor];
            label.textColor=[UIColor darkGrayColor];
            label.textAlignment=NSTextAlignmentCenter;
            [backGround addSubview:label];
            for (int x=0; x<=7; x++) {
                if (x<=3) {
                    NSDictionary *itemDic=[NSDictionary dictionaryWithDictionary:[subjectItemsArray objectAtIndex:x]];
                    UIButton *itemButton=[UIButton buttonWithType:UIButtonTypeCustom];
                    itemButton.frame=CGRectMake(12+x*72, 30, 60, 60);
                    [itemButton setTitle:[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"name"]] forState:UIControlStateNormal];
                    [itemButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                    NSString *imageUrl=[NSString stringWithFormat:@"http://%@",[itemDic objectForKey:@"imgUrl"]];
                    imageUrl=[imageUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    NSLog(@"imageUrl is %@",imageUrl);
                    UILabel *itemLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 65, 60, 15)];
                    itemLabel.text=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"name"]];
                    itemLabel.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.8];
                    itemLabel.textAlignment=NSTextAlignmentCenter;
                    itemLabel.font=[UIFont fontWithName:@"Arial" size:12];
                    [itemButton addSubview:itemLabel];
                    [itemButton addTarget:self action:@selector(getItemListViewController:) forControlEvents:UIControlEventTouchUpInside];
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
                                       NSString *filename = [dirName stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"name"]]];
                                       if (![[NSFileManager defaultManager] fileExistsAtPath:filename])
                                       {
                                           NSData * data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl]options:NSDataReadingMappedIfSafe error:nil];
                                           UIImage * cacheimage = [[UIImage alloc] initWithData:data];
                                           [UIImageJPEGRepresentation(cacheimage, 0.5) writeToFile:filename atomically:YES];
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               NSData *imageData=[NSData dataWithContentsOfFile:filename];
                                               [itemButton setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                                           });
                                       }else
                                       {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               NSData *imageData=[NSData dataWithContentsOfFile:filename];
                                               [itemButton setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                                           });
                                       }
                                   });
                    //缓存图片
                    [backGround addSubview:itemButton];
                }else
                {
                    NSDictionary *itemDic=[NSDictionary dictionaryWithDictionary:[subjectItemsArray objectAtIndex:x]];
                    UIButton *itemButton=[UIButton buttonWithType:UIButtonTypeCustom];
                    itemButton.frame=CGRectMake(12+(x-4)*72, 120, 60, 60);
                    [itemButton setTitle:[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"name"]] forState:UIControlStateNormal];
                    [itemButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                    NSString *imageUrl=[NSString stringWithFormat:@"http://%@",[itemDic objectForKey:@"imgUrl"]];
                    imageUrl=[imageUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    UILabel *itemLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 65, 60, 15)];
                    itemLabel.text=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"name"]];
                    itemLabel.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.8];
                    itemLabel.textAlignment=NSTextAlignmentCenter;
                    itemLabel.font=[UIFont fontWithName:@"Arial" size:12];
                    [itemButton addSubview:itemLabel];
                    [itemButton addTarget:self action:@selector(getItemListViewController:) forControlEvents:UIControlEventTouchUpInside];
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
                                       NSString *filename = [dirName stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"name"]]];
                                       if (![[NSFileManager defaultManager] fileExistsAtPath:filename])
                                       {
                                           NSData * data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                                           UIImage * cacheimage = [[UIImage alloc] initWithData:data];
                                           [UIImageJPEGRepresentation(cacheimage, 0.5) writeToFile:filename atomically:YES];
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               NSData *imageData=[NSData dataWithContentsOfFile:filename];
                                               [itemButton setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                                           });
                                       }else
                                       {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               NSData *imageData=[NSData dataWithContentsOfFile:filename];
                                               [itemButton setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                                           });
                                       }
                                   });
                    //缓存图片
                    [backGround addSubview:itemButton];
                }
            }
            [cell addSubview:backGround];
            
        }
            break;
        }
    
    return cell;
}
-(void)presentStoreBrowseViewController:(id)sender
{
    NSLog(@"%d",[sender tag]);
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"havelogined"])
    {
        [self openWebView:[sender tag]];
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"登录获取返利" delegate:self cancelButtonTitle:@"跳过" otherButtonTitles:@"登陆",nil];
        alert.tag=[sender tag];
        [alert show];
    }
}

-(void)openWebView:(int)target
{
    switch (target) {
        case 0:
        {
            NSURL *url =[NSURL URLWithString:@"http://m.taobao.com"];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            CosjiWebViewController *storeWebViewController=[[CosjiWebViewController alloc] init];
            
            UINavigationController *tmpNav=[[UINavigationController alloc] initWithRootViewController:storeWebViewController];
            tmpNav.navigationBarHidden=YES;
            [self presentViewController:tmpNav animated:YES completion:nil];
            [storeWebViewController setThisWebViewWithName:request name:@"已进入淘宝网"];
        }
            break;
        case 1:
        {
            NSURL *url =[NSURL URLWithString:@"http://m.tmall.com"];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            CosjiWebViewController *storeWebViewController=[[CosjiWebViewController alloc] init];
            
            UINavigationController *tmpNav=[[UINavigationController alloc] initWithRootViewController:storeWebViewController];
            tmpNav.navigationBarHidden=YES;
            [self presentViewController:tmpNav animated:YES completion:nil];
            [storeWebViewController setThisWebViewWithName:request name:@"已进入天猫"];
            
        }
            break;
        case 2:
        {
            NSURL *url =[NSURL URLWithString:@"http://ju.m.taobao.com"];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            CosjiWebViewController *storeWebViewController=[[CosjiWebViewController alloc] init];
            
            UINavigationController *tmpNav=[[UINavigationController alloc] initWithRootViewController:storeWebViewController];
            tmpNav.navigationBarHidden=YES;
            [self presentViewController:tmpNav animated:YES completion:nil];
            [storeWebViewController setThisWebViewWithName:request name:@"已进入聚划算"];
        }
            break;
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        switch (buttonIndex) {
            case 0:
            {
                [self openWebView:alertView.tag];
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

-(void)presentAllItemsTable
{
    NSURL *url =[NSURL URLWithString:@"http://m.taobao.com/channel/act/sale/quanbuleimu.html"];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    
    CosjiWebViewController *storeWebViewController=[[CosjiWebViewController alloc] init];
    
    UINavigationController *tmpNav=[[UINavigationController alloc] initWithRootViewController:storeWebViewController];
    tmpNav.navigationBarHidden=YES;
    [self presentViewController:tmpNav animated:YES completion:nil];
    [storeWebViewController setThisWebViewWithName:request name:@"更多商品"];

}
void subjectItemImage( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
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
-(void)searchItemFrom:(UITextField*)textField
{
    [textField resignFirstResponder];
    //下面执行webView的操作
    exitBtn.hidden=YES;
    if (textField!=nil&&![textField.text isEqualToString:@""])
    {
        NSLog(@"开始搜索");
        if ([self isPureInt:searchField.text])
        {
            CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
            NSString *num_iid=[NSString stringWithFormat:@"%@",searchField.text];
            NSDictionary *infoDic=[serverHelper getItemFromTop:num_iid];
            if (infoDic==nil)
            {
                [SVProgressHUD showErrorWithStatus:@"搜索不到该商品或该商品没有返利" duration:6];
            }else
            {
                CosjiItemFanliDetailViewController *fanliDetailVC=[CosjiItemFanliDetailViewController shareCosjiItemFanliDetailViewController];
                
                [self presentViewController:fanliDetailVC animated:YES completion:nil];
                [fanliDetailVC loadItemInfoWithDic:infoDic];
            }

        }else
        {
            NSDictionary *resultDic=[CosjiUrlFilter filterUrl:searchField.text];
            if (resultDic == nil)
            {
                return;
            }
            NSNumber *resultNumber=[resultDic objectForKey:@"UrlType"];
            NSLog(@"%@",[resultDic objectForKey:@"UrlType"]);
            switch ([resultNumber intValue]) {
                case 0:
                {
                    NSLog(@"//普通链接");
                    CosjiWebViewController *storeWebViewController=[[CosjiWebViewController alloc] init];
                    
                    UINavigationController *tmpNav=[[UINavigationController alloc] initWithRootViewController:storeWebViewController];
                    tmpNav.navigationBarHidden=YES;
                    [self presentViewController:tmpNav animated:YES completion:nil];
                    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"url"]]];
                    [storeWebViewController setThisWebViewWithName:[NSURLRequest requestWithURL:url] name:@"浏览"];

                }
                    break;
                case 1://混合链接
                {
                    NSLog(@"//混合链接");
                    CosjiWebViewController *storeWebViewController=[[CosjiWebViewController alloc] init];
                    
                    UINavigationController *tmpNav=[[UINavigationController alloc] initWithRootViewController:storeWebViewController];
                    tmpNav.navigationBarHidden=YES;
                    [self presentViewController:tmpNav animated:YES completion:nil];
                    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"url"]]];
                    [storeWebViewController setThisWebViewWithName:[NSURLRequest requestWithURL:url] name:@"浏览"];
                }
                    break;
                case 2://特别链接（带有淘宝推广的链接）
                {
                    NSLog(@"//特别链接");

                    [self presentFanliDetailVCWithNumID:[resultDic objectForKey:@"num_iid"]];
                }
                    break;
                case 3://淘宝商品链接
                {
                    NSLog(@"//淘宝链接");

                    [self presentFanliDetailVCWithNumID:[resultDic objectForKey:@"num_iid"]];

                }
                    break;
                case 4://天猫商品链接
                {
                    NSLog(@"//天猫链接");

                    [self presentFanliDetailVCWithNumID:[resultDic objectForKey:@"num_iid"]];

                }
                    break;
                case 5:
                {
                    NSLog(@"//纯文本");
                    [self presentItemList:[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"String"]]];
                }
                    break;
                case 6:
                {
                    [self presentFanliDetailVCWithNumID:[resultDic objectForKey:@"num_iid"]];
                }
                    break;
            }
            
        }
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入您想要搜索的商品或查询的网址" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}
-(void)getItemListViewController:(id)sender
{
    UIButton *senderBtn=(UIButton*)sender;
    NSLog(@"get");
    [self presentItemList:[NSString stringWithFormat:@"%@",senderBtn.titleLabel.text]];

}
-(void)hideKeyBoard
{
    exitBtn.hidden=YES;
    [self.searchField resignFirstResponder];
}
-(void)presentItemList:(NSString*)keyword
{
    CosjiItemListViewController *itemsListViewController=[[CosjiItemListViewController alloc] init];
    UINavigationController *itemsListNavCon=[[UINavigationController alloc] initWithRootViewController:itemsListViewController];
    [self presentViewController:itemsListNavCon animated:YES completion:nil];
    [itemsListViewController loadInfoWith:[NSString stringWithFormat:@"%@",keyword] atPage:1];
}
-(void)presentFanliDetailVCWithNumID:(NSString*)num_id
{
    NSLog(@"this num_id is %@",num_id);
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
- (void)textFieldDidBeginEditing:(UITextField *)textField           // became first responder
{
    [textField.window makeKeyAndVisible];
    NSLog(@"显示");
    exitBtn.hidden=NO;
}
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setCustomNavBar:nil];
    [super viewDidUnload];
}
@end
