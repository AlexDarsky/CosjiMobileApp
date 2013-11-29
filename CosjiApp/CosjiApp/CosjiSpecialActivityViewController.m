//
//  CosjiSpecialActivityViewController.m
//  CosjiApp
//
//  Created by Darsky on 13-7-14.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiSpecialActivityViewController.h"

#import "MobileProbe.h"
#import "CosjiServerHelper.h"
#import "CosjiWebViewController.h"
#import "SVProgressHUD.h"


#define kAppKey             @"21428060"
#define kAppSecret          @"dda4af6d892e2024c26cd621b05dd2d0"
#define kAppRedirectURI     @"http://cosjii.com"

@interface CosjiSpecialActivityViewController ()

@end

@implementation CosjiSpecialActivityViewController
@synthesize tableView,CustomNav;

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
    [MobileProbe pageBeginWithName:@"九元购"];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [MobileProbe pageEndWithName:@"九元购"];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=NO;
    [SVProgressHUD showWithStatus:@"正在加载。。。"];
    if ([itemsArray count]==0)
    {
        currentPage=1;
        CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
     //   [serverHelper jsonTest];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:@"/product/ship/?page=1&&num=16"]];
        if (tmpDic!=nil)
        {
                NSDictionary *recordDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
                itemsArray=[NSMutableArray arrayWithArray:[recordDic objectForKey:@"record"]];
                NSLog(@"get Store %d",[itemsArray count]);
                dispatch_async(dispatch_get_main_queue(), ^{
                   [self.tableView reloadData];
                });
                
        }else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"服务器无法连接，请稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
        }
        });

    }else
    {
        
    }
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    itemsArray=[[NSMutableArray alloc] initWithCapacity:0];
    self.CustomNav.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];

    
    
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([itemsArray count]%2!=0) {
        return [itemsArray count]/2+1;
    }else
        return [itemsArray count]/2;
   }

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // static NSString *cellIdentifier = @"MyCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    // cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier]
    UIFont *nameFont= [UIFont fontWithName:@"Arial" size:12];
    UIFont *font = [UIFont fontWithName:@"Arial" size:15];

    //左
    NSDictionary *leftItemDic=[NSDictionary dictionaryWithDictionary:[itemsArray objectAtIndex:indexPath.section*2]];
    UIButton *leftItemBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftItemBtn.frame=CGRectMake(12.5,4, 144, 128);
    leftItemBtn.tag=indexPath.section*2;
    NSString *itemLefturl=[NSString stringWithFormat:@"%@",[leftItemDic objectForKey:@"imgUrl"]];
    itemLefturl=[itemLefturl stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    ItemImageFromURL( [NSURL URLWithString:itemLefturl], ^( UIImage * image )
    {
        [leftItemBtn setBackgroundImage:image forState:UIControlStateNormal];
    },
    ^(void){
    });
    [leftItemBtn addTarget:self action:@selector(qiangGou:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:leftItemBtn];
    NSString *freightString=[NSString stringWithFormat:@"%@",[leftItemDic objectForKey:@"freight"]];
    if ([freightString intValue]>0)
    {
        UILabel *freightLabel=[[UILabel alloc] initWithFrame:CGRectMake(124, 0, 20, 20)];
        freightLabel.backgroundColor=[UIColor redColor];
        freightLabel.textColor=[UIColor whiteColor];
        freightLabel.text=[NSString stringWithFormat:@"包邮"];
        freightLabel.textAlignment=NSTextAlignmentCenter;
        freightLabel.font=[UIFont fontWithName:@"Arial" size:9];
        [leftItemBtn addSubview:freightLabel];
    }
    UILabel *itemLeftPrice=[[UILabel alloc] initWithFrame:CGRectMake(12.5, 132,144, 28.5)];
    [itemLeftPrice setFont:font];
    itemLeftPrice.backgroundColor=[UIColor redColor];
    [itemLeftPrice setTextColor:[UIColor whiteColor]];
    [itemLeftPrice setText:[NSString stringWithFormat:@"￥%@   有返利",[leftItemDic objectForKey:@"promotion"]]];
    UILabel *itemLeftName=[[UILabel alloc] initWithFrame:CGRectMake(12.5, 162, 140, 14)];
    [itemLeftName setText:[leftItemDic objectForKey:@"name"]];
    [itemLeftName setFont:nameFont];
    itemLeftName.backgroundColor=[UIColor clearColor];
    [cell addSubview:itemLeftName];
    [cell addSubview:itemLeftPrice];
    //右
    if ([itemsArray count]-1>=indexPath.section*2+1) {
        NSDictionary *rightItemDic=[NSDictionary dictionaryWithDictionary:[itemsArray objectAtIndex:indexPath.section*2+1]];
        UIButton *rightItemBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        rightItemBtn.frame=CGRectMake(167.5,4, 144, 128);
        rightItemBtn.tag=indexPath.section*2+1;
        NSString *itemRightrurl=[NSString stringWithFormat:@"%@",[rightItemDic objectForKey:@"imgUrl"]];
        itemRightrurl=[itemRightrurl stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        ItemImageFromURL( [NSURL URLWithString:itemRightrurl], ^( UIImage * image )
                         {
                             [rightItemBtn setBackgroundImage:image forState:UIControlStateNormal];
                         }, ^(void){
                         });
        NSString *freight2String=[NSString stringWithFormat:@"%@",[rightItemDic objectForKey:@"freight"]];
        if ([freight2String intValue]>0)
        {
            UILabel *freight2Label=[[UILabel alloc] initWithFrame:CGRectMake(124, 0, 20, 20)];
            freight2Label.backgroundColor=[UIColor redColor];
            freight2Label.textColor=[UIColor whiteColor];
            freight2Label.text=[NSString stringWithFormat:@"包邮"];
            freight2Label.textAlignment=NSTextAlignmentCenter;
            freight2Label.font=[UIFont fontWithName:@"Arial" size:9];
            [rightItemBtn addSubview:freight2Label];
        }

        UILabel *itemRightName=[[UILabel alloc] initWithFrame:CGRectMake(12.5+155, 162, 140, 14)];
        [itemRightName setText:[rightItemDic objectForKey:@"name"]];
        [itemRightName setFont:nameFont];
        itemRightName.backgroundColor=[UIColor clearColor];
        [cell addSubview:rightItemBtn];
        [cell addSubview:itemRightName];
        UILabel *itemRightPrice=[[UILabel alloc] initWithFrame:CGRectMake(12.5+155, 132, 144, 28.5)];
        // UIFont *font = [UIFont fontWithName:@"Arial" size:20];
        [itemRightPrice setFont:font];
        itemRightPrice.backgroundColor=[UIColor redColor];
        [itemRightPrice setTextColor:[UIColor whiteColor]];
        [itemRightPrice setText:[NSString stringWithFormat:@"￥%@   有返利",[rightItemDic objectForKey:@"promotion"]]];
        [rightItemBtn addTarget:self action:@selector(qiangGou:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:itemRightPrice];
    }
       return cell;
}
void ItemImageFromURL( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
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
-(void)qiangGou:(id)sender
{
    NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[itemsArray objectAtIndex:[sender tag]]];
    NSString *storeUrl=[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"address"]];
    NSURL *url =[NSURL URLWithString:[storeUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    CosjiWebViewController *storeBrowseViewController=[CosjiWebViewController shareCosjiWebViewController];
    [self presentViewController:storeBrowseViewController animated:YES completion:nil];
    [storeBrowseViewController.webView loadRequest:request];
    [storeBrowseViewController.storeName setText:[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"name"]]];

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
    NSLog(@"===加载完数据");
    //   [self.tableView refreshFinished];
    NSLog(@"%d",currentPage);
    CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
    currentPage+=1;
    NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:[NSString stringWithFormat:@"/product/ship/?page=%d&&num=16",currentPage]]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *recordDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
        NSArray *loadArray=[[NSArray alloc] initWithArray:[recordDic objectForKey:@"record"]];
        if ([loadArray count]>0) {
            NSLog(@"load Store %d",[itemsArray count]);
            [itemsArray addObjectsFromArray:loadArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                /*
                 [self.NewsTableView beginUpdates];
                 [self.NewsTableView reloadData];
                 [self.NewsTableView endUpdates];
                 */
                [SVProgressHUD dismiss];
                CGPoint point=CGPointMake(0,self.tableView.contentSize.height-self.tableView.frame.size.height);
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
    [SVProgressHUD dismiss];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setCustomNav:nil];
    [super viewDidUnload];
}
@end
