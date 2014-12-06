//
//  CosjiTBViewController.m
//  可及网
//
//  Created by Darsky on 13-8-23.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiTBViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CosjiNewWebViewController.h"
#import "MobileProbe.h"
#import "CosjiItemListViewController.h"
#import "CosjiServerHelper.h"
#import "SVProgressHUD.h"
#import "CosjiItemFanliDetailViewController.h"
#import "CosjiLoginViewController.h"

@interface CosjiTBViewController ()
{
    UIImageView *searchFieldBG;
    UIButton *exitBtn;
    int preSelected;
}
@end

@implementation CosjiTBViewController
@synthesize customNavBar;
@synthesize searchField;

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
        
        self.customNavBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
        self.customNavBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
        UILabel *blogoLabel=[[UILabel alloc] initWithFrame:CGRectMake(160-50, self.customNavBar.frame.size.height-38, 100, 25)];
        blogoLabel.text=@"返利通道";
        blogoLabel.textColor=[UIColor whiteColor];
        blogoLabel.textAlignment=NSTextAlignmentCenter;
        blogoLabel.backgroundColor=[UIColor clearColor];
        blogoLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:20];
        [self.customNavBar addSubview:blogoLabel];
    }

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
    self.searchField=[[UITextField alloc] initWithFrame:CGRectMake(35, 43/2-35/2, 260, 35)];
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
    searchFieldBG=[[UIImageView alloc] initWithFrame:CGRectMake(320/2-598/4, self.customNavBar.frame.size.height+ 15, 598/2, 86/2)];
    [searchFieldBG setImage:[UIImage imageNamed:@"淘宝返利搜索框"]];
    searchFieldBG.userInteractionEnabled=YES;
    UIImageView *imgv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"搜索框放大镜"]];
    imgv.frame=CGRectMake(8, searchFieldBG.frame.size.height/2-57/4, 56/2, 57/2);
    [searchFieldBG addSubview:imgv];
    [searchFieldBG addSubview:self.searchField];
    
    [self.view addSubview:searchFieldBG];
    self.webViewController=[[CosjiWebViewController alloc] init];
    exitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.frame=CGRectMake(0,110,320,[UIScreen mainScreen].bounds.size.height-45-20-49-110);
    [exitBtn addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:exitBtn];
    exitBtn.hidden=YES;
    
    _hotWordView = [[UIView alloc] initWithFrame:CGRectMake(0, searchFieldBG.frame.size.height+searchFieldBG.frame.origin.y+20, self.view.frame.size.width, self.view.frame.size.height-self.customNavBar.frame.size.height-searchFieldBG.frame.size.height-20)];
    _hotWordView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_hotWordView];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    self.tabBarController.tabBar.hidden=NO;

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
    if (alertView.tag == 110)
    {
        if (buttonIndex == 1)
        {
            CosjiLoginViewController *loginViewController=[CosjiLoginViewController shareCosjiLoginViewController];
            [self presentViewController:loginViewController animated:YES completion:nil];
        }
        return;
    }
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
        [self showFanliDetailWebView:textField.text];
//        if ([self isPureInt:searchField.text])
//        {
//            CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
//            NSString *num_iid=[NSString stringWithFormat:@"%@",searchField.text];
//            NSDictionary *infoDic=[serverHelper getItemFromTop:num_iid];
//            if (infoDic==nil)
//            {
//                [SVProgressHUD showErrorWithStatus:@"搜索不到该商品或该商品没有返利" duration:6];
//            }else
//            {
//                CosjiItemFanliDetailViewController *fanliDetailVC=[CosjiItemFanliDetailViewController shareCosjiItemFanliDetailViewController];
//                
//                [self presentViewController:fanliDetailVC animated:YES completion:nil];
//                [fanliDetailVC loadItemInfoWithDic:infoDic];
//            }
//
//        }else
//        {
//            NSDictionary *resultDic=[CosjiUrlFilter filterUrl:searchField.text];
//            if (resultDic == nil)
//            {
//                return;
//            }
//            NSNumber *resultNumber=[resultDic objectForKey:@"UrlType"];
//            NSLog(@"%@",[resultDic objectForKey:@"UrlType"]);
//            switch ([resultNumber intValue]) {
//                case 0:
//                {
//                    NSLog(@"//普通链接");
//                    CosjiWebViewController *storeWebViewController=[[CosjiWebViewController alloc] init];
//                    
//                    UINavigationController *tmpNav=[[UINavigationController alloc] initWithRootViewController:storeWebViewController];
//                    tmpNav.navigationBarHidden=YES;
//                    [self presentViewController:tmpNav animated:YES completion:nil];
//                    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"url"]]];
//                    [storeWebViewController setThisWebViewWithName:[NSURLRequest requestWithURL:url] name:@"浏览"];
//
//                }
//                    break;
//                case 1://混合链接
//                {
//                    NSLog(@"//混合链接");
//                    CosjiWebViewController *storeWebViewController=[[CosjiWebViewController alloc] init];
//                    
//                    UINavigationController *tmpNav=[[UINavigationController alloc] initWithRootViewController:storeWebViewController];
//                    tmpNav.navigationBarHidden=YES;
//                    [self presentViewController:tmpNav animated:YES completion:nil];
//                    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"url"]]];
//                    [storeWebViewController setThisWebViewWithName:[NSURLRequest requestWithURL:url] name:@"浏览"];
//                }
//                    break;
//                case 2://特别链接（带有淘宝推广的链接）
//                {
//                    NSLog(@"//特别链接");
//
//                    [self presentFanliDetailVCWithNumID:[resultDic objectForKey:@"num_iid"]];
//                }
//                    break;
//                case 3://淘宝商品链接
//                {
//                    NSLog(@"//淘宝链接");
//
//                    [self presentFanliDetailVCWithNumID:[resultDic objectForKey:@"num_iid"]];
//
//                }
//                    break;
//                case 4://天猫商品链接
//                {
//                    NSLog(@"//天猫链接");
//
//                    [self presentFanliDetailVCWithNumID:[resultDic objectForKey:@"num_iid"]];
//
//                }
//                    break;
//                case 5:
//                {
//                    NSLog(@"//纯文本");
//                    [self presentItemList:[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"String"]]];
//                }
//                    break;
//                case 6:
//                {
//                    [self presentFanliDetailVCWithNumID:[resultDic objectForKey:@"num_iid"]];
//                }
//                    break;
//            }
//            
//        }
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

- (NSString *)URLEncodedString:(NSString*)target{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)target,
                                                                           NULL,
                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8));
    return result;
}


- (void)viewDidUnload {
    [self setCustomNavBar:nil];
    [super viewDidUnload];
}
@end
