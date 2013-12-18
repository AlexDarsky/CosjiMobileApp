//
//  CosjiItemListViewController.m
//  CosjiApp
//
//  Created by Darsky on 13-10-6.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiItemListViewController.h"
#import "CosjiServerHelper.h"
#import "CosjiWebViewController.h"
#import "SVProgressHUD.h"

@interface CosjiItemListViewController ()

@end

@implementation CosjiItemListViewController
static CosjiItemListViewController* shareCosjiItemListViewController;
@synthesize customNavBar,titleLabel,tableView;
+(CosjiItemListViewController*)shareCosjiItemListViewController
{
    if (shareCosjiItemListViewController == nil) {
        shareCosjiItemListViewController = [[super allocWithZone:NULL] init];
    }
    return shareCosjiItemListViewController;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        itemsArray=[[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}
-(void)loadView
{
    UIView *primary=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    primary.backgroundColor=[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:100];
    self.view=primary;
    self.customNavBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    self.customNavBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
    self.titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(32, 11, 200, 21)];
    self.titleLabel.backgroundColor=[UIColor clearColor];
    self.titleLabel.textColor=[UIColor whiteColor];
    [self.customNavBar addSubview:self.titleLabel];
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(11, 12,60/2, 41/2);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self  action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavBar addSubview:backBtn];
    [self.view addSubview:self.customNavBar];
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 45, 320, [UIScreen mainScreen].bounds.size.height-45-20)];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.tableView.backgroundView=nil;
    [self.view addSubview:self.tableView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];

}

-(void)loadInfoWith:(NSString*)textString atPage:(int)pageNumber
{
    [SVProgressHUD showWithStatus:@"正在载入..."];
    if ([itemsArray count]>0) {
        [itemsArray removeAllObjects];
        [self.tableView reloadData];
    }
    self.titleLabel.text=[NSString stringWithFormat:@"%@",textString];
    currentPage=1;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
    
    NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:[NSString stringWithFormat:@"/taobao/search/?keyword=%@&num=10&page=%d",textString,currentPage]]];
    if (tmpDic!=nil)
    {

        NSDictionary *recordDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
        itemsArray=[NSMutableArray arrayWithArray:[recordDic objectForKey:@"record"]];
        NSLog(@"get Store %d",[itemsArray count]);
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
        });
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [itemsArray count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // static NSString *cellIdentifier = @"MyCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    // cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSDictionary *itemDic=[NSDictionary dictionaryWithDictionary:[itemsArray objectAtIndex:indexPath.row]];
    UIImageView *itemImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"imgUrl"]];
    imageUrl=[imageUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    ItemImageDownloadURL([NSURL URLWithString:imageUrl], ^( UIImage * image )
                    {
                        [itemImageView setImage:image ];
                    }, ^(void){
                    });
    [cell addSubview:itemImageView];
    UIWebView *nameWebView=[[UIWebView alloc] initWithFrame:CGRectMake(110, 10, 180, 50)];
    NSString *htmlString = [NSString stringWithFormat:@"<html>"
                          "<head> "
                          "<style type=\"text/css\"> "
                          "body {font-size: %f;; color: %@;}"
                          "a{color:#ccc}"
                          "</style>"
                          "</head>"
                          "<body><p>%@</p></body>"
                          "</html>", 11.0, @"#000",[itemDic objectForKey:@"name"]];
    [nameWebView loadHTMLString:htmlString baseURL:nil];
    [nameWebView setBackgroundColor:[UIColor clearColor]];
    [nameWebView setOpaque:NO];
    nameWebView.scrollView.scrollEnabled=NO;
    UILabel *priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(120, 60, 60, 20)];
    priceLabel.text=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"price"]];
    priceLabel.textColor=[UIColor redColor];
    UILabel *saveLabel=[[UILabel alloc] initWithFrame:CGRectMake(200, 60, 80, 20)];
    saveLabel.text=[NSString stringWithFormat:@"可返利"];
    saveLabel.backgroundColor=[UIColor redColor];
    saveLabel.textColor=[UIColor whiteColor];
    saveLabel.textAlignment=NSTextAlignmentCenter;
    saveLabel.adjustsFontSizeToFitWidth=YES;
    UILabel *sellLabel=[[UILabel alloc] initWithFrame:CGRectMake(120, 80, 180, 20)];
    sellLabel.text=[NSString stringWithFormat:@"最近售出%@件",[itemDic objectForKey:@"sell"]];
    sellLabel.font=[UIFont fontWithName:@"Arial" size:13];
    priceLabel.backgroundColor=sellLabel.backgroundColor=[UIColor clearColor];
    [cell addSubview:nameWebView];
    [cell addSubview:priceLabel];
    [cell addSubview:saveLabel];
    [cell addSubview:sellLabel];
     return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[itemsArray objectAtIndex:indexPath.row]];
    NSString *storeUrl=[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"url"]];
    NSURL *url =[NSURL URLWithString:[storeUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    CosjiWebViewController *webViewController=[CosjiWebViewController shareCosjiWebViewController];
    [self presentViewController:webViewController animated:YES completion:nil];
    [webViewController.webView loadRequest:request];
    [webViewController.storeName setText:[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"name"]]];
    
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"%f %f",scrollView.contentOffset.y,scrollView.contentSize.height - scrollView.frame.size.height);
    if(scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height))&&scrollView.contentOffset.y>0)
        
    {
        [self loadDataBegin];
    }
    
}
- (void) loadDataBegin

{
    
    [SVProgressHUD showWithStatus:@"正在加载"];
    //  [self doneLoadingTableViewData];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
    
}
- (void)doneLoadingTableViewData{
    if ([itemsArray count]>0) {
        
    NSLog(@"===加载完数据");
    NSLog(@"%d",currentPage);
    CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
    currentPage+=1;
    NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:[NSString stringWithFormat:@"/taobao/search/?keyword=%@&num=10&page=%d",self.titleLabel.text,currentPage]]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *recordDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
        NSArray *loadArray=[[NSArray alloc] initWithArray:[recordDic objectForKey:@"record"]];
        if ([loadArray count]>0) {
            NSLog(@"load Store %d",[itemsArray count]);
            [itemsArray addObjectsFromArray:loadArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
                CGPoint point=CGPointMake(0,120*10*(currentPage-1));
                [self.tableView setContentOffset:point animated:YES];
            });
                  }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                currentPage-=1;
                [SVProgressHUD dismiss];

            });

        }

        
    });
    }
}
void ItemImageDownloadURL( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
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
- (void)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCustomNavBar:nil];
    [self setTitleLabel:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
