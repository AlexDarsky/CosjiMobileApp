//
//  CosjiWebViewController.m
//  CosjiApp
//
//  Created by Darsky on 13-7-27.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiWebViewController.h"
#import "CosjiItemFanliDetailViewController.h"
#import "CosjiUrlFilter.h"
#import <QuartzCore/QuartzCore.h>

@interface CosjiWebViewController ()

@end

@implementation CosjiWebViewController
@synthesize customNavBar,storeName,webView;
static CosjiWebViewController *shareCosjiWebViewController = nil;
+(CosjiWebViewController*)shareCosjiWebViewController
{
    
    if (shareCosjiWebViewController == nil) {
        shareCosjiWebViewController = [[super allocWithZone:NULL] init];
    }
    return shareCosjiWebViewController;
}

-(void)loadView
{
    [super loadView];
    UIView *primaryView=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view=primaryView;
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version < 7.0)
    {
        self.customNavBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
        self.customNavBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
        if (self.webView==nil) {
            self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 43, 320, [UIScreen mainScreen].bounds.size.height-49-20)];
            self.webView.delegate=self;
        }
        
        self.storeName=[[UILabel alloc] initWithFrame:CGRectMake(40, self.customNavBar.frame.size.height/2-40/2, 280, 40)];
        backBtn.frame=CGRectMake(11,self.customNavBar.frame.size.height/2-80/4, 100/2, 80/2);
    }else
    {
        self.customNavBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
        self.customNavBar.backgroundColor=[UIColor colorWithRed:225.0/255.0 green:47.0/255.0 blue:50.0/255.0 alpha:100];
        if (self.webView==nil) {
            self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 65, 320, [UIScreen mainScreen].bounds.size.height-65)];
            self.webView.delegate=self;
        }
        self.storeName=[[UILabel alloc] initWithFrame:CGRectMake(40, self.customNavBar.frame.size.height/2-40/4, 280, 40)];
        backBtn.frame=CGRectMake(11,self.customNavBar.frame.size.height/2-80/8, 100/2, 80/2);
    }

    [self.customNavBar layer].shadowPath =[UIBezierPath bezierPathWithRect:customNavBar.bounds].CGPath;
    self.customNavBar.layer.shadowColor=[[UIColor blackColor] CGColor];
    self.customNavBar.layer.shadowOffset=CGSizeMake(0,0);
    self.customNavBar.layer.shadowRadius=10.0;
    self.customNavBar.layer.shadowOpacity=1.0;
    self.storeName.backgroundColor=[UIColor clearColor];
    self.storeName.textColor=[UIColor whiteColor];
    self.storeName.text=@"浏览";
    [self.customNavBar addSubview:self.storeName];

    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.customNavBar addSubview:backBtn];
    [self.view addSubview:self.customNavBar];
    [self.view addSubview:webView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden=YES;
}
-(void)setThisWebViewWithName:(NSURLRequest*)url name:(NSString*)name
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version < 7.0)
    {
        if (self.webView==nil) {
            self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 43, 320, [UIScreen mainScreen].bounds.size.height-49-20)];
            self.webView.delegate=self;
        }
    }else
    {

        if (self.webView==nil) {
            self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 65, 320, [UIScreen mainScreen].bounds.size.height-65)];
            self.webView.delegate=self;
        }
    }
    [self.webView loadRequest:url];
    if (self.storeName==nil) {
        self.storeName=[[UILabel alloc] initWithFrame:CGRectMake(40, 2, 280, 40)];
        self.storeName.backgroundColor=[UIColor clearColor];
        self.storeName.textColor=[UIColor whiteColor];
        [self.customNavBar addSubview:self.storeName];
    }
    self.storeName.text=[NSString stringWithFormat:@"%@",name];

    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    self.tabBarController.tabBar.hidden=YES;
}

-(void)loadViewURL:(NSString*)urlString
{
    
}
-(void)setTabBarHidden:(BOOL)is
{
    
}

- (void)back:(id)sender
{
  //  [self.navigationController popToRootViewControllerAnimated:YES];
    int index=[[self.navigationController viewControllers]indexOfObject:self];
    if (index==0)
    {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-1]animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"havelogined"])
    {
        NSString *urlString=[NSString stringWithFormat:@"%@",self.webView.request.URL];
        if ([urlString rangeOfString:@"cloud-jump.html?"].location!=NSNotFound)
        {
            CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
            int location=[[NSString stringWithFormat:@"%@",urlString] rangeOfString:@"itemId="].location;
            NSString *num_iid=[[NSString stringWithFormat:@"%@",urlString] substringWithRange:NSMakeRange(location+7, 11)];
            NSDictionary *infoDic=[serverHelper getItemFromTop:num_iid];
            if (infoDic==nil)
            {
                [SVProgressHUD showErrorWithStatus:@"搜索不到该商品或该商品没有返利" duration:3];
            }else
            {
                NSLog(@"infoDic is%@",infoDic);
                CosjiItemFanliDetailViewController *fanliDetailVC=[[CosjiItemFanliDetailViewController alloc] init];
                [self.navigationController pushViewController:fanliDetailVC animated:NO];
                [fanliDetailVC loadItemInfoWithDic:infoDic];
        //      [self.view addSubview:fanliDetailVC.view];
            }
            return NO;
            
        }else
        {
            NSString *schemeString=[NSString stringWithFormat:@"%@",self.webView.request.URL.scheme];
            if ([schemeString isEqualToString:@"http"]) {
                NSString *urlString=[NSString stringWithFormat:@"%@",request.mainDocumentURL.relativePath];
                NSLog(@"now the Request is %@",urlString);
                if ([[NSString stringWithFormat:@"%@",urlString] rangeOfString:@"/item.htm"].location!=NSNotFound)
                {
                    return YES;
                }else if([self isNumIID:urlString])
                {
                    int startlocation=[[NSString stringWithFormat:@"%@",urlString] rangeOfString:@"/i"].location;
                    int endLocation=[[NSString stringWithFormat:@"%@",urlString] rangeOfString:@".htm"].location;
                    NSString *num_iid=[[NSString stringWithFormat:@"%@",urlString] substringWithRange:NSMakeRange(startlocation+2, endLocation-2)];
                    CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
                    NSDictionary *infoDic=[serverHelper getItemFromTop:num_iid];
                    if (infoDic==nil)
                    {
                        [SVProgressHUD showErrorWithStatus:@"搜索不到该商品或该商品没有返利" duration:3];
                    }else
                    {
                        NSLog(@"infoDic is%@",infoDic);
                        CosjiItemFanliDetailViewController *fanliDetailVC=[CosjiItemFanliDetailViewController shareCosjiItemFanliDetailViewController];
                        
                        [self presentViewController:fanliDetailVC animated:YES completion:nil];
                        [fanliDetailVC loadItemInfoWithDic:infoDic];
                    }
                    return NO;
                }else
                    return YES;
            }else
                return YES;
        }
        
    }
    else
        return YES;
}

- (void)startTiaozhuan:(UIWebView *)webView
{
        NSString *urlString=[NSString stringWithFormat:@"%@",self.webView.request.URL];
        NSLog(@"now the Request is %@",urlString);
        if ([urlString rangeOfString:@"cloud-jump.html?"].location!=NSNotFound) {
            CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
            int location=[[NSString stringWithFormat:@"%@",urlString] rangeOfString:@"itemId="].location;
            NSString *num_iid=[[NSString stringWithFormat:@"%@",urlString] substringWithRange:NSMakeRange(location+7, 11)];
            NSDictionary *infoDic=[serverHelper getItemFromTop:num_iid];
            if (infoDic==nil)
            {
                [SVProgressHUD showErrorWithStatus:@"搜索不到该商品或该商品没有返利" duration:3];
            }else
            {
                NSLog(@"infoDic is%@",infoDic);
                CosjiItemFanliDetailViewController *fanliDetailVC=[CosjiItemFanliDetailViewController shareCosjiItemFanliDetailViewController];
                
                [self.navigationController pushViewController:fanliDetailVC animated:YES];
                [fanliDetailVC loadItemInfoWithDic:infoDic];
                NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.backString]];
                NSURLRequest *request =[NSURLRequest requestWithURL:url];
                NSLog(@"will load %@",self.backString);
                [self.webView loadRequest:request];
            }
        }
}

-(BOOL)isNumIID:(NSString*)urlString
{
    if ([[NSString stringWithFormat:@"%@",urlString] rangeOfString:@"/i"].location<=0) {
        NSLog(@"这是");
        int startlocation=[[NSString stringWithFormat:@"%@",urlString] rangeOfString:@"/i"].location;
        int endLocation=[[NSString stringWithFormat:@"%@",urlString] rangeOfString:@".htm"].location;
        NSString *num_iid=[[NSString stringWithFormat:@"%@",urlString] substringWithRange:NSMakeRange(startlocation+2, endLocation-2)];
        NSLog(@"num_iid is %@",num_iid);
        if ([self isPureInt:num_iid]) {
            return YES;
        }else
            return NO;
    }else
        return NO;
}
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
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
        CosjiItemFanliDetailViewController *fanliDetailVC=[[CosjiItemFanliDetailViewController alloc] init];
        [self presentViewController:fanliDetailVC animated:YES completion:nil];
        [fanliDetailVC loadItemInfoWithDic:infoDic];
    }
    
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [self setCustomNavBar:nil];
    [super viewDidUnload];
}
@end
