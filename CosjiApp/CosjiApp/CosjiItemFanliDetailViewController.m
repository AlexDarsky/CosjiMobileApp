//
//  CosjiItemFanliDetailViewController.m
//  CosjiApp
//
//  Created by Darsky on 14-1-2.
//  Copyright (c) 2014年 Cosji. All rights reserved.
//

#import "CosjiItemFanliDetailViewController.h"
#import "CosjiWebViewController.h"

@interface CosjiItemFanliDetailViewController ()
{
    UILabel *nameLabel;
    UIImageView *itemImageView;
    UILabel *priceLabel;
    
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
    UIView *primary=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    primary.backgroundColor=[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:100];
    self.view=primary;
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
    tishiLabel.text=@"根据淘宝最新规则，查询返利将不显示返利比例，且跳转到淘宝客户端购买，但返利任正常发放，具体金额以到账时为准。";
    [self.view addSubview:tishiLabel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}
-(void)loadItemInfoWithDic:(NSDictionary*)itemDic
{
    nameLabel.text=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"title"]];
    priceLabel.text=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"price"]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"pic_url"]];
        NSString *storeUrl=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"num_iid"]];
        CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
        self.clickURLString=[NSString stringWithFormat:@"%@",[serverHelper getClick_urlFromTop:storeUrl]];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)gotoFanli
{
    CosjiWebViewController *webViewController=[CosjiWebViewController shareCosjiWebViewController];
    NSURL *url =[NSURL  URLWithString:self.clickURLString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.navigationController pushViewController:webViewController animated:YES];
    [webViewController.webView loadRequest:request];
    [webViewController.storeName setText:[NSString stringWithFormat:@"%@",nameLabel.text]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
