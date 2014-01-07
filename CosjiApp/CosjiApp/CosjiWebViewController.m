//
//  CosjiWebViewController.m
//  CosjiApp
//
//  Created by Darsky on 13-7-27.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiWebViewController.h"
#import "CosjiItemFanliDetailViewController.h"
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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)loadView
{
    UIView *primaryView=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view=primaryView;
    self.customNavBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
    self.customNavBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
    [self.customNavBar layer].shadowPath =[UIBezierPath bezierPathWithRect:customNavBar.bounds].CGPath;
    self.customNavBar.layer.shadowColor=[[UIColor blackColor] CGColor];
    self.customNavBar.layer.shadowOffset=CGSizeMake(0,0);
    self.customNavBar.layer.shadowRadius=10.0;
    self.customNavBar.layer.shadowOpacity=1.0;
    [self.view addSubview:self.customNavBar];
    self.storeName=[[UILabel alloc] initWithFrame:CGRectMake(40, 2, 280, 40)];
    self.storeName.backgroundColor=[UIColor clearColor];
    self.storeName.textColor=[UIColor whiteColor];
    [self.customNavBar addSubview:self.storeName];
    self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 43, 320, [UIScreen mainScreen].bounds.size.height-49-20)];
    self.webView.delegate=self;
    [self.view addSubview:webView];
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(11, 2.5, 100/2, 80/2);
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.customNavBar addSubview:backBtn];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden=YES;
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
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]];
    [self.webView loadRequest:request];
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
  //  [self dismissViewControllerAnimated:YES completion:nil];
    int index=[[self.navigationController viewControllers]indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-1]animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *urlString=[NSString stringWithFormat:@"%@",self.webView.request.URL];
    NSLog(@"now the Request is %@",urlString);
    
    if ([urlString rangeOfString:@"com/i"].location!=NSNotFound) {
        NSLog(@"找到了");
        [self.webView stopLoading];
        CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
        int location=[[NSString stringWithFormat:@"%@",urlString] rangeOfString:@"com/i"].location;
        NSString *num_iid=[[NSString stringWithFormat:@"%@",urlString] substringWithRange:NSMakeRange(location+5, 11)];
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
}
- (void)viewDidUnload {
    [self setStoreName:nil];
    [self setWebView:nil];
    [self setCustomNavBar:nil];
    [super viewDidUnload];
}
@end
