//
//  CosjiItemFanliDetailViewController.m
//  CosjiApp
//
//  Created by Darsky on 14-1-2.
//  Copyright (c) 2014年 Cosji. All rights reserved.
//

#import "CosjiItemFanliDetailViewController.h"
#import "CosjiWebViewController.h"
#import "TopIOSClient.h"
#import "TopAppService.h"
#import <sys/sysctl.h>
@interface CosjiItemFanliDetailViewController ()
{
    UILabel *nameLabel;
    UIImageView *itemImageView;
    UILabel *priceLabel;
    UIWebView *_webView;
}

@end

@implementation CosjiItemFanliDetailViewController
static CosjiItemFanliDetailViewController* shareCosjiItemFanliDetailViewController=nil;


+(CosjiItemFanliDetailViewController*)shareCosjiItemFanliDetailViewController
{
    if (shareCosjiItemFanliDetailViewController == nil) {
        shareCosjiItemFanliDetailViewController = [[super allocWithZone:NULL] init];
    }
    return shareCosjiItemFanliDetailViewController;
}
-(void)loadView
{
    [super loadView];
    UIView *primary=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    primary.backgroundColor=[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:100];
    self.view=primary;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    float version=[[[UIDevice currentDevice]systemVersion]floatValue];
    if (version<7.0) {
        NSLog(@"《7.0");
        UIView *customNavBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
        customNavBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
        UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(32, 11, 200, 21)];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.text=@"商品详情";
        [customNavBar addSubview:titleLabel];
        UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame=CGRectMake(11, 2.5, 100/2, 80/2);
        [backBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [backBtn addTarget:self  action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [customNavBar addSubview:backBtn];
        [self.view addSubview:customNavBar];
        itemImageView=[[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-490/4, customNavBar.frame.size.height+22/2, 490/2, 490/2)];
        
    }else
    {
        NSLog(@">7.0");
        UIView *customNavBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
        customNavBar.backgroundColor=[UIColor colorWithRed:225.0/255.0 green:47.0/255.0 blue:50.0/255.0 alpha:100];
        UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(32, 31, 200, 21)];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.text=@"商品详情";
        [customNavBar addSubview:titleLabel];
        UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame=CGRectMake(11, 22.5, 100/2, 80/2);
        [backBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [backBtn addTarget:self  action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [customNavBar addSubview:backBtn];
        [self.view addSubview:customNavBar];
        itemImageView=[[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-490/4, customNavBar.frame.size.height+22/2, 490/2, 490/2)];
    }
    
    [itemImageView setImage:[UIImage imageNamed:@"imageLoading"]];
    [self.view addSubview:itemImageView];
    nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, itemImageView.frame.origin.y+itemImageView.frame.size.height+5/2, 300, 50)];
    nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.numberOfLines=0;
    nameLabel.font=[UIFont fontWithName:@"Arial" size:13];
    [self.view addSubview:nameLabel];
    
    UILabel *priceTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, nameLabel.frame.origin.y+nameLabel.frame.size.height+5/2, 50, 30/2)];
    priceTitle.font=[UIFont fontWithName:@"Arial" size:15];
    priceTitle.backgroundColor=[UIColor clearColor];
    priceTitle.text=@"原价：";
    [self.view addSubview:priceTitle];
    priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, priceTitle.frame.origin.y-2, 60, 20)];
    priceLabel.textColor=[UIColor redColor];
    priceLabel.font=priceTitle.font;
    priceLabel.textAlignment=NSTextAlignmentLeft;
    priceLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:priceLabel];
    UILabel *fanliLabel=[[UILabel alloc] initWithFrame:CGRectMake(priceTitle.frame.origin.x, priceTitle.frame.origin.y+priceTitle.frame.size.height+5/2, 50, 20)];
    fanliLabel.text=@"返利:";
    fanliLabel.backgroundColor=[UIColor clearColor];
    fanliLabel.font=priceLabel.font;
    [self.view addSubview:fanliLabel];
    UIImageView *fanliImageView=[[UIImageView alloc] initWithFrame:CGRectMake(fanliLabel.frame.origin.x+fanliLabel.frame.size.width-6, fanliLabel.frame.origin.y, 121/2, 35/2)];
    [fanliImageView setImage:[UIImage imageNamed:@"youfanli"]];
    [self.view addSubview:fanliImageView];
    UIButton *goFanliBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    goFanliBtn.frame=CGRectMake(160, priceTitle.frame.origin.y, 296/2, 79/2);
    [goFanliBtn setBackgroundImage:[UIImage imageNamed:@"quouwu"] forState:UIControlStateNormal];
    [goFanliBtn addTarget:self action:@selector(gotoFanli) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:goFanliBtn];
    UIImageView *lineImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, goFanliBtn.frame.origin.y+goFanliBtn.frame.size.height+10/2, 585/2, 3/2)];
    [lineImageView setImage:[UIImage imageNamed:@"xuxian"]];
    [self.view addSubview:lineImageView];
    UILabel *tishiTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, lineImageView.frame.origin.y+6/2, 100/2, 30/2)];
    tishiTitle.text=@"温馨提示";
    tishiTitle.font=[UIFont fontWithName:@"Arial" size:12];
    tishiTitle.backgroundColor=[UIColor clearColor];
    [self.view addSubview:tishiTitle];
    UILabel *tishiLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, tishiTitle.frame.origin.y+tishiTitle.frame.size.height+5/2, 300, 30)];
    tishiLabel.textColor=[UIColor lightGrayColor];
    tishiLabel.font=[UIFont fontWithName:@"Arial" size:11];
    tishiLabel.numberOfLines=0;
    tishiLabel.backgroundColor=[UIColor clearColor];
    tishiLabel.text=@"根据淘宝最新规则，查询返利将不显示返利比例，且跳转到淘宝客户端购买，但返利仍正常发放，具体金额以到账时为准。";
    [self.view addSubview:tishiLabel];
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 45, 320, [UIScreen mainScreen].bounds.size.height-45-20)];
    [self.view addSubview:_webView];
    _webView.delegate=self;
    _webView.hidden=YES;

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [itemImageView setImage:[UIImage imageNamed:@"imageLoading"]];
    itemImageView.frame=CGRectMake([UIScreen mainScreen].bounds.size.width/2-490/4,itemImageView.frame.origin.y, 490/2, 490/2);
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [SVProgressHUD dismiss];
}
-(void)loadItemInfoWithDic:(NSDictionary*)itemDic
{
    nameLabel.text=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"title"]];
    priceLabel.text=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"price"]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"pic_url"]];
        NSString *storeUrl=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"num_iid"]];
        CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
        self.clickURLString=[NSString stringWithFormat:@"%@&sche=cosji802627559",[serverHelper getClick_urlFromTop:storeUrl]];
        if (self.clickURLString==nil) {
        }
        itemImageView.frame=CGRectMake([UIScreen mainScreen].bounds.size.width/2-490/4,itemImageView.frame.origin.y, 490/2, 490/2);
        ItemFanliImageFromURL([NSURL URLWithString:imageUrl], ^( UIImage * image )
                              {

                                  [itemImageView setImage:image ];
                                  
                              }, ^(void){
                              });
    });
}

-(void)loadZheMainItemInfoWithDic:(NSDictionary*)itemDic
{
    nameLabel.text=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"title"]];
    priceLabel.text=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"price"]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"pic_url"]];
        NSString *storeUrl=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"num_iid"]];
        CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
        self.clickURLString=[NSString stringWithFormat:@"%@&sche=cosji802627559",[serverHelper getClick_urlFromTop:storeUrl]];
        if (self.clickURLString==nil) {
        }
        itemImageView.frame=CGRectMake([UIScreen mainScreen].bounds.size.width/2-306/2,itemImageView.frame.origin.y, 306, 214);
        ItemFanliImageFromURL([NSURL URLWithString:imageUrl], ^( UIImage * image )
                              {

                                  [itemImageView setImage:image ];
                              }, ^(void){
                              });
    });
}

void ItemFanliImageFromURL( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
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
-(void)backAction:(id)sender
{
    if (_webView.hidden==NO)
    {
        [UIView beginAnimations:@"oglFlip"context:nil];//动画开始
        [UIView setAnimationDuration:0.75];
        [UIView setAnimationDelegate:self];
        [UIView  setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
        _webView.hidden=YES;
        [UIView commitAnimations];
    }else
    {
        int index=[[self.navigationController viewControllers]indexOfObject:self];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
        if (index==0)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-1]animated:YES];
        }
    }
}
-(void)gotoFanli
{
    if ([self checkTaoAppinstalled])
    {
        [SVProgressHUD showWithStatus:@"正在跳转，安装最新淘宝客户端才能返利..."];
        NSURL *url =[NSURL  URLWithString:self.clickURLString];
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
        NSLog(@"正在打开链接%@",self.clickURLString);

    }else
    {
        int alerShows=[[NSUserDefaults standardUserDefaults] integerForKey:@"alertHaveShow"];
        NSLog(@"alertHaveShow %d",alerShows);
        if (alerShows>5) {
            [SVProgressHUD showWithStatus:@"正在跳转，安装最新淘宝客户端才能返利..."];
            NSURL *url =[NSURL  URLWithString:self.clickURLString];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            [_webView loadRequest:request];
            NSLog(@"正在打开链接%@",self.clickURLString);
        }else
        {
            alerShows++;
        [[NSUserDefaults standardUserDefaults] setInteger:alerShows forKey:@"alertHaveShow"];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您即将自动跳转至淘宝客户端进行支付以获取返利，若无法自动跳转请确定是否已安装淘宝最新客户端（3.1.3版本以上）" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"去购物拿返利",nil];
        alert.tag=1;
        [alert show];
        }
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
                [SVProgressHUD showWithStatus:@"正在跳转，安装最新淘宝客户端才能返利..."];
                NSURL *url =[NSURL  URLWithString:self.clickURLString];
                NSURLRequest *request =[NSURLRequest requestWithURL:url];
                [_webView loadRequest:request];
            }
                break;
        }
    }
}
-(BOOL)checkTaoAppinstalled
{
    NSArray *runningProcessesArray=[self runningProcesses];
    BOOL isstalled=NO;
    
    for (NSDictionary *app in runningProcessesArray)
    {
        if ([[app objectForKey:@"ProcessName"]isEqualToString:@"Taobao2013"]) {
            NSLog(@"找到淘宝了！！！！！");
            isstalled=YES;
        }
    }
    return isstalled;
}

- (NSArray *)runningProcesses {
    
    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
    size_t miblen = 4;
    
    size_t size;
    int st = sysctl(mib, miblen, NULL, &size, NULL, 0);
    
    struct kinfo_proc * process = NULL;
    struct kinfo_proc * newprocess = NULL;
    
    do {
        
        size += size / 10;
        newprocess = realloc(process, size);
        
        if (!newprocess){
            
            if (process){
                free(process);
            }
            
            return nil;
        }
        
        process = newprocess;
        st = sysctl(mib, miblen, process, &size, NULL, 0);
        
    } while (st == -1 && errno == ENOMEM);
    
    if (st == 0){
        
        if (size % sizeof(struct kinfo_proc) == 0){
            int nprocess = size / sizeof(struct kinfo_proc);
            
            if (nprocess){
                
                NSMutableArray * array = [[NSMutableArray alloc] init];
                
                for (int i = nprocess - 1; i >= 0; i--){
                    
                    NSString * processID = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_pid];
                    NSString * processName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];
                    
                    NSDictionary * dict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:processID, processName, nil]
                                                                        forKeys:[NSArray arrayWithObjects:@"ProcessID", @"ProcessName", nil]];
                    [array addObject:dict];
                }
                
                free(process);
                return array;
            }
        }
    }
    
    return nil;
}
/*
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
        NSString *urlString=[NSString stringWithFormat:@"%@",request.URL];
        if ([urlString rangeOfString:@"cloud-jump.html?"].location!=NSNotFound)
        {
            return NO;
        }
    else
        return YES;
}
*/
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSString *urlString=[NSString stringWithFormat:@"%@",webView.request.URL];
    if ([urlString rangeOfString:@"cloud-jump.html?"].location!=NSNotFound)
    {
        CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
        int location=[[NSString stringWithFormat:@"%@",urlString] rangeOfString:@"itemId="].location;
        NSString *num_iid=[[NSString stringWithFormat:@"%@",urlString] substringWithRange:NSMakeRange(location+7, 11)];
        NSString *fixURL=[NSString stringWithFormat:@"%@&sche=cosji802627559",[serverHelper getClick_urlFromTop:num_iid]];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fixURL]]];
        NSLog(@"webViewDidStartLoad隐藏的webView正在请求修正的:%@",fixURL);
    }else
    NSLog(@"webViewDidStartLoad隐藏的webView正在请求:%@",urlString);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
