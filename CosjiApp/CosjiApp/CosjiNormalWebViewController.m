//
//  CosjiWebViewController.m
//  CosjiApp
//
//  Created by Darsky on 13-7-27.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiNormalWebViewController.h"
#import "CosjiItemFanliDetailViewController.h"
#import "CosjiUrlFilter.h"
#import <QuartzCore/QuartzCore.h>

@interface CosjiNormalWebViewController ()

@end

@implementation CosjiNormalWebViewController
@synthesize customNavBar,storeName,webView;


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
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
   // NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]];
    //[self.webView loadRequest:request];
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
- (void)viewDidUnload {
    [self setWebView:nil];
    [self setCustomNavBar:nil];
    [super viewDidUnload];
}
@end
