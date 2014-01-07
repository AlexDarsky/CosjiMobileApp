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
#import "CosjiItemListViewController.h"


#define kAppKey             @"21428060"
#define kAppSecret          @"dda4af6d892e2024c26cd621b05dd2d0"
#define kAppRedirectURI     @"http://cosjii.com"

@interface CosjiSpecialActivityViewController ()
{
    UIView *searchView;
    UITextField *searchField;
    BOOL searchViewShowing;
}

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
    [searchField resignFirstResponder];
}
-(void)loadView
{
    UIView *primary=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    primary.backgroundColor=[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:100];
    self.view=primary;
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 45, 320, [UIScreen mainScreen].bounds.size.height-45-49-20) style:UITableViewStylePlain];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.backgroundView=nil;
    [self.view addSubview:self.tableView];
    self.CustomNav=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    self.CustomNav.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
    UIButton *searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame=CGRectMake(self.CustomNav.frame.size.width-40, self.CustomNav.frame.size.height/2-82/4, 64/2, 82/2);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"工具栏背景-搜索"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(showSearchView) forControlEvents:UIControlEventTouchDown];
    searchBtn.hidden=YES;
    [self.CustomNav addSubview:searchBtn];
    searchView=[[UIView alloc] initWithFrame:self.CustomNav.frame];
    searchView.backgroundColor=[UIColor whiteColor];
    searchField=[[UITextField alloc] initWithFrame:CGRectMake(10, 0, 300, 35)];
    searchField.borderStyle=UITextBorderStyleNone;
    searchField.returnKeyType=UIReturnKeySearch;
    searchField.textAlignment=UITextAlignmentCenter;
    searchField.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    searchField.backgroundColor=[UIColor clearColor];
    searchField.font=[UIFont fontWithName:@"Arial" size:18];
    searchField.placeholder=@"输入商品名称或网址查询商品";
    searchField.textAlignment=UITextAlignmentCenter;
    [searchView addSubview:searchField];
    [searchField addTarget:self action:@selector(searchItemFrom:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:searchView];
    searchViewShowing=NO;
    [self.view addSubview:self.CustomNav];
    UIImageView *llogoImage=[[UIImageView alloc] initWithFrame:CGRectMake(14, 6, 156/2, 65/2)];
    llogoImage.image=[UIImage imageNamed:@"工具栏背景-标语"];
    [self.CustomNav addSubview:llogoImage];
    UIImageView *blogoImage=[[UIImageView alloc] initWithFrame:CGRectMake(160-155/4,13, 155/2, 40/2)];
    blogoImage.image=[UIImage imageNamed:@"折扣优惠"];
    [self.CustomNav addSubview:blogoImage];

    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=NO;
    [SVProgressHUD showWithStatus:@"正在加载..."];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"saveMode"] isEqualToString:@"YES"])
    {
        isSaveMode=YES;
    }else
        isSaveMode=NO;
    if ([itemsArray count]==0)
    {
        currentPage=1;
        CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
        //[serverHelper jsonTest];
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
    return 190;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // static NSString *cellIdentifier = @"MyCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    // cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier]
    UIFont *nameFont= [UIFont fontWithName:@"Arial" size:12];
    UIFont *font = [UIFont fontWithName:@"Arial" size:15];
    
    for (int x=0; x<2; x++)
    {
        if (indexPath.row*2+x<[itemsArray count])
        {
            NSDictionary *leftItemDic=[NSDictionary dictionaryWithDictionary:[itemsArray objectAtIndex:indexPath.section*2+x]];
            UIButton *leftItemBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            leftItemBtn.frame=CGRectMake(12.5+x*155,4, 144, 128);
            leftItemBtn.tag=indexPath.section*2+x;
            NSString *itemLefturl=[NSString stringWithFormat:@"%@",[leftItemDic objectForKey:@"imgUrl"]];
            itemLefturl=[itemLefturl stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            if (isSaveMode) {
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
                                   NSString *filename = [dirName stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[leftItemDic objectForKey:@"id"]]];
                                   if (![[NSFileManager defaultManager] fileExistsAtPath:filename])
                                   {
                                       NSLog(@"download cacheImage %@",filename);
                                       NSData * data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:itemLefturl]];
                                       UIImage * cacheimage = [[UIImage alloc] initWithData:data];
                                       [UIImageJPEGRepresentation(cacheimage, 1.0) writeToFile:filename atomically:YES];
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           NSData *imageData=[NSData dataWithContentsOfFile:filename];
                                           [leftItemBtn setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                                       });
                                   }else
                                   {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           NSLog(@"load cacheImage %@",filename);
                                           NSData *imageData=[NSData dataWithContentsOfFile:filename];
                                           [leftItemBtn setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                                       });
                                   }
                               });

            }else
            {
                ItemImageFromURL( [NSURL URLWithString:itemLefturl], ^( UIImage * image )
                                 {
                                     [leftItemBtn setBackgroundImage:image forState:UIControlStateNormal];
                                 },
                                 ^(void){
                                 });
            }
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
            UILabel *itemLeftPrice=[[UILabel alloc] initWithFrame:CGRectMake(12.5+155*x, 132,144, 23.5)];
            [itemLeftPrice setFont:font];
            itemLeftPrice.backgroundColor=[UIColor redColor];
            [itemLeftPrice setTextColor:[UIColor whiteColor]];
            [itemLeftPrice setText:[NSString stringWithFormat:@"￥%@       有返利",[leftItemDic objectForKey:@"promotion"]]];
            UILabel *itemLeftName=[[UILabel alloc] initWithFrame:CGRectMake(12.5+155*x, 157, 140, 28)];
            [itemLeftName setText:[leftItemDic objectForKey:@"name"]];
            [itemLeftName setFont:nameFont];
            itemLeftName.numberOfLines=0;
            itemLeftName.backgroundColor=[UIColor clearColor];
            [cell addSubview:itemLeftName];
            [cell addSubview:itemLeftPrice];

        }
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
    [self.navigationController pushViewController:storeBrowseViewController animated:YES ];
    [storeBrowseViewController.webView loadRequest:request];
    [storeBrowseViewController.storeName setText:[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"name"]]];

}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"%f %f",scrollView.contentOffset.y,scrollView.contentSize.height - scrollView.frame.size.height);
    if (scrollView.contentOffset.y>=(scrollView.contentSize.height - scrollView.frame.size.height)+100&&scrollView.contentOffset.y>0)
    {
        [SVProgressHUD showWithStatus:@"正在载入..."];
        [self performSelector:@selector(doneLoadingTableViewData) withObject:Nil afterDelay:2.0];
    }
    
}
- (void) loadDataBegin

{
    
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
    
}
- (void)doneLoadingTableViewData{
    NSLog(@"===加载完数据");
    NSLog(@"%d",currentPage);
    CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
    currentPage+=1;
    
    NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:[NSString stringWithFormat:@"/product/ship/?page=%d&&num=16",currentPage]]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *recordDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
        NSArray *loadArray=[[NSArray alloc] initWithArray:[recordDic objectForKey:@"record"]];
        if ([loadArray count]>0) {
            prePoint=CGPointMake(0,self.tableView.contentSize.height);
            NSLog(@"load Store %d",[itemsArray count]);
            [itemsArray addObjectsFromArray:loadArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self performSelector:@selector(startContentOffset:) withObject:nil afterDelay:0.5];
                
            });
        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                currentPage-=1;
            });
        }
    });
    [SVProgressHUD dismiss];
}
-(void)startContentOffset:(CGPoint)point
{
    [self.tableView setContentOffset:prePoint animated:YES];
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
                CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
                NSURL *url =[NSURL URLWithString:[serverHelper getClick_urlFromTop:num_iid]];
                if (url==nil)
                {
                    [SVProgressHUD showErrorWithStatus:@"搜索不到该商品或该商品没有返利" duration:3];
                }else
                {
                    NSURLRequest *request =[NSURLRequest requestWithURL:url];
                    NSLog(@"request is %@",request);
                    CosjiWebViewController *webViewController=[CosjiWebViewController shareCosjiWebViewController];
                    [self.navigationController pushViewController:webViewController animated:YES ];
                    [webViewController.webView loadRequest:request];
                    [webViewController.storeName setText:[NSString stringWithFormat:@"搜索商品"]];
                }
            }
                break;
            case 1:
            {
                NSLog(@"这个是ID");
                CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
                NSURL *url =[NSURL URLWithString:[serverHelper getClick_urlFromTop:searchField.text]];
                if (url==nil)
                {
                    [SVProgressHUD showErrorWithStatus:@"搜索不到该商品或该商品没有返利" duration:3];
                }else
                {
                    NSURLRequest *request =[NSURLRequest requestWithURL:url];
                    NSLog(@"request is %@",request);
                    CosjiWebViewController *webViewController=[CosjiWebViewController shareCosjiWebViewController];
                    [self.navigationController pushViewController:webViewController animated:YES];
                    [webViewController.webView loadRequest:request];
                    [webViewController.storeName setText:[NSString stringWithFormat:@"搜索商品"]];
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
