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

@interface CosjiTBViewController ()

@end

@implementation CosjiTBViewController
@synthesize tableView,customNavBar,storeBrowseViewController;
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
    [MobileProbe pageBeginWithName:@"淘宝返利"];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [MobileProbe pageEndWithName:@"淘宝返利"];
    [self.searchField resignFirstResponder];
}
-(void)loadView
{
    UIView *primary=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    primary.backgroundColor=[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:100];
    self.view=primary;
    self.customNavBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    self.customNavBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
    UIButton *moreBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame=CGRectMake(282, 14, 23, 21);
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"更多列表"] forState:UIControlStateNormal];
    [moreBtn addTarget:self  action:@selector(presentAllItemsTable) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavBar addSubview:moreBtn];
    [self.view addSubview:self.customNavBar];
    UIImageView *llogoImage=[[UIImageView alloc] initWithFrame:CGRectMake(14, 6,156/2, 65/2)];
    llogoImage.image=[UIImage imageNamed:@"工具栏背景-标语"];
    [self.customNavBar addSubview:llogoImage];
    UIImageView *blogoImage=[[UIImageView alloc] initWithFrame:CGRectMake(160-155/4,13, 155/2, 40/2)];
    blogoImage.image=[UIImage imageNamed:@"淘宝返利"];
    [self.customNavBar addSubview:blogoImage];
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 45, 320, [UIScreen mainScreen].bounds.size.height-45-20-49)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.backgroundView=nil;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
    
    }
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden=YES;
    subjectsArray=[[NSMutableArray alloc] initWithCapacity:0];
    self.searchField=[[UITextField alloc] initWithFrame:CGRectMake(20+56/2, 20, 265, 35)];
    self.searchField.borderStyle=UITextBorderStyleNone;
    self.searchField.returnKeyType=UIReturnKeySearch;
    self.searchField.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.searchField.textAlignment=UITextAlignmentLeft;
    self.searchField.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    self.searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.searchField.backgroundColor=[UIColor clearColor];
    self.searchField.font=[UIFont fontWithName:@"Arial" size:16];
    self.searchField.placeholder=@"输入商品名称/网址/ID,查询返利";
    [self.searchField addTarget:self action:@selector(searchItemFrom:) forControlEvents:UIControlEventEditingDidEndOnExit];


    self.taoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.taoBtn.frame=CGRectMake(16.5, 15, 53, 31);
    self.taoBtn.tag=0;
    [self.taoBtn addTarget:self action:@selector(presentStoreBrowseViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.taoBtn setBackgroundImage:[UIImage imageNamed:@"淘宝返利-淘宝网"] forState:UIControlStateNormal];

    self.tmallBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.tmallBtn.frame=CGRectMake(16.5, 15, 53, 31);
    self.tmallBtn.tag=1;
    [self.tmallBtn addTarget:self action:@selector(presentStoreBrowseViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.tmallBtn setBackgroundImage:[UIImage imageNamed:@"淘宝返利-天猫网"] forState:UIControlStateNormal];
    self.juBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.juBtn.frame=CGRectMake(16.5, 15, 53, 31);
    self.juBtn.tag=2;
    [self.juBtn addTarget:self action:@selector(presentStoreBrowseViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.juBtn setBackgroundImage:[UIImage imageNamed:@"淘宝返利-聚划算"] forState:UIControlStateNormal];
    self.storeBrowseViewController=[[CosjiWebViewController alloc] initWithNibName:@"CosjiWebViewController" bundle:nil];
    
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
            height=147.0;
        }
            break;
        default:
        {
            height=150.0;
        }
            break;
    }
    return height;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section>0) {
        UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        headerView.backgroundColor=[UIColor clearColor];
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 96, 30)];
        NSDictionary *subjectDic=[NSDictionary dictionaryWithDictionary:[subjectsArray objectAtIndex:section-1]];
        
        label.text=[NSString stringWithFormat:@"%@",[subjectDic objectForKey:@"name"]];
        label.font=[UIFont fontWithName:@"Arial" size:14];
        label.backgroundColor=[UIColor clearColor];
        label.textColor=[UIColor darkGrayColor];
        [headerView addSubview:label];
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
    switch (section) {
        case 0:
        {
            height=0;
        }
            break;
        default:
        {
            height=30;
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
    
    
    switch (indexPath.section) {
        case 0:
        {
            UIView *taoBtnView=[[UIView alloc] initWithFrame:CGRectMake(10, 70, 90, 64)];
            taoBtnView.backgroundColor=[UIColor whiteColor];
            UILabel *taoBtnLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 49, 90, 15)];
            taoBtnLabel.text=[NSString stringWithFormat:@"淘宝"];
            taoBtnLabel.textAlignment=UITextAlignmentCenter;
            
            UIView *tmallBtnView=[[UIView alloc] initWithFrame:CGRectMake(115, 70, 90, 64)];
            tmallBtnView.backgroundColor=[UIColor whiteColor];
            UILabel *tmallBtnLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 49, 90, 15)];
            tmallBtnLabel.text=[NSString stringWithFormat:@"天猫"];
            tmallBtnLabel.textAlignment=UITextAlignmentCenter;
            
            UIView *juBtnView=[[UIView alloc] initWithFrame:CGRectMake(220, 70, 90, 64)];
            juBtnView.backgroundColor=[UIColor whiteColor];
            UILabel *juBtnLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 49, 90, 15)];
            juBtnLabel.text=[NSString stringWithFormat:@"聚划算"];
            juBtnLabel.textAlignment=UITextAlignmentCenter;
            UIImageView *lineSpretor1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"淘宝返利-投影分割线-2"]];
            lineSpretor1.frame=CGRectMake(0, 58, 320, 4.5);
            [cell addSubview:lineSpretor1];
            UIImageView *lineSpretor2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"淘宝返利-投影分割线-1"]];
            lineSpretor2.frame=CGRectMake(0, 135, 320, 4.5);
            taoBtnLabel.backgroundColor=tmallBtnLabel.backgroundColor=juBtnLabel.backgroundColor=[UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:80];
            taoBtnLabel.font=tmallBtnLabel.font=juBtnLabel.font=[UIFont fontWithName:@"Arial" size:12];
            [cell addSubview:lineSpretor2];
            [taoBtnView addSubview:self.taoBtn];
            [taoBtnView addSubview:taoBtnLabel];
            [tmallBtnView addSubview:self.tmallBtn];
            [tmallBtnView addSubview:tmallBtnLabel];
            [juBtnView addSubview:self.juBtn];
            [juBtnView addSubview:juBtnLabel];
            UIImageView *searchFieldBG=[[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 300, 45)];
            [searchFieldBG setImage:[UIImage imageNamed:@"淘宝返利-搜索框"]];
            searchFieldBG.userInteractionEnabled=YES;
            UIImageView *imgv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"搜索框放大镜"]];
            imgv.frame=CGRectMake(6, searchFieldBG.frame.size.height/2-57/4, 56/2, 57/2);
            [searchFieldBG addSubview:imgv];
            [cell addSubview:searchFieldBG];
            [cell addSubview:self.searchField];
            [cell addSubview:taoBtnView];
            [cell addSubview:tmallBtnView];
            [cell addSubview:juBtnView];
            
        }
            break;
            default:
        {
           NSDictionary *subjectDic=[NSDictionary dictionaryWithDictionary:[subjectsArray objectAtIndex:indexPath.section-1]];
            NSArray *subjectItemsArray=[NSArray arrayWithArray:[subjectDic objectForKey:@"child"]];
            NSLog(@"subjectItems is %d",[subjectItemsArray count]);
            for (int x=0; x<=7; x++) {
                if (x<=3) {
                    NSDictionary *itemDic=[NSDictionary dictionaryWithDictionary:[subjectItemsArray objectAtIndex:x]];
                    UIButton *itemButton=[UIButton buttonWithType:UIButtonTypeCustom];
                    itemButton.frame=CGRectMake(10+x*80, 10, 60, 60);
                    [itemButton setTitle:[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"name"]] forState:UIControlStateNormal];
                    [itemButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                    NSString *imageUrl=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"imgUrl"]];
                    imageUrl=[imageUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    UILabel *itemLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 45, 60, 15)];
                    itemLabel.text=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"name"]];
                    itemLabel.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.8];
                    itemLabel.textAlignment=UITextAlignmentCenter;
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
                                           NSLog(@"download cacheImage %@",filename);
                                           NSData * data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl]options:NSDataReadingMappedIfSafe error:nil];
                                           UIImage * cacheimage = [[UIImage alloc] initWithData:data];
                                           [UIImageJPEGRepresentation(cacheimage, 1.0) writeToFile:filename atomically:YES];
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               NSData *imageData=[NSData dataWithContentsOfFile:filename];
                                               [itemButton setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                                           });
                                       }else
                                       {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               NSLog(@"load cacheImage %@",filename);
                                               NSData *imageData=[NSData dataWithContentsOfFile:filename];
                                               [itemButton setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                                           });
                                       }
                                   });
                    //缓存图片
                    [cell addSubview:itemButton];
                }else
                {
                    NSDictionary *itemDic=[NSDictionary dictionaryWithDictionary:[subjectItemsArray objectAtIndex:x]];
                    UIButton *itemButton=[UIButton buttonWithType:UIButtonTypeCustom];
                    itemButton.frame=CGRectMake(10+(x-4)*80, 80, 60, 60);
                    [itemButton setTitle:[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"name"]] forState:UIControlStateNormal];
                    [itemButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                    NSString *imageUrl=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"imgUrl"]];
                    imageUrl=[imageUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    UILabel *itemLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 45, 60, 15)];
                    itemLabel.text=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"name"]];
                    itemLabel.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.8];
                    itemLabel.textAlignment=UITextAlignmentCenter;
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
                                           NSLog(@"download cacheImage %@",filename);
                                           NSData * data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                                           UIImage * cacheimage = [[UIImage alloc] initWithData:data];
                                           [UIImageJPEGRepresentation(cacheimage, 1.0) writeToFile:filename atomically:YES];
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               NSData *imageData=[NSData dataWithContentsOfFile:filename];
                                               [itemButton setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                                           });
                                       }else
                                       {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               NSLog(@"load cacheImage %@",filename);
                                               NSData *imageData=[NSData dataWithContentsOfFile:filename];
                                               [itemButton setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                                           });
                                       }
                                   });
                    //缓存图片
                    [cell addSubview:itemButton];
                }
            }
            UIImageView *lineSpretor1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"淘宝返利-投影分割线-2"]];
            lineSpretor1.frame=CGRectMake(0, 145, 320, 5);
            [cell addSubview:lineSpretor1];
            
        }
            break;
        }
    
    return cell;
}
-(void)presentStoreBrowseViewController:(id)sender
{
    NSLog(@"%d",[sender tag]);
    switch ([sender tag]) {
        case 0:
        {
            NSURL *url =[NSURL URLWithString:@"http://m.taobao.com"];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
        //    [self presentViewController:self.storeBrowseViewController animated:YES completion:nil];
            [self.navigationController pushViewController:self.storeBrowseViewController animated:YES];
            [self.storeBrowseViewController.webView loadRequest:request];
            [self.storeBrowseViewController.storeName setText:@"已进入淘宝网"];
        }
            break;
        case 1:
        {
            NSURL *url =[NSURL URLWithString:@"http://m.tmall.com"];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
          //  [self presentViewController:self.storeBrowseViewController animated:YES completion:nil];
            [self.navigationController pushViewController:self.storeBrowseViewController animated:YES];
            [self.storeBrowseViewController.webView loadRequest:request];
            [self.storeBrowseViewController.storeName setText:@"已进入天猫"];
        }
            break;
        case 2:
        {
            NSURL *url =[NSURL URLWithString:@"http://ju.m.taobao.com"];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
         //   [self presentViewController:self.storeBrowseViewController animated:YES completion:nil];
           [self.navigationController pushViewController:self.storeBrowseViewController animated:YES];
            [self.storeBrowseViewController.webView loadRequest:request];
            [self.storeBrowseViewController.storeName setText:@"已进入聚划算"];
        }
            break;
    }
}
-(void)presentAllItemsTable
{
    
    NSURL *url =[NSURL URLWithString:@"http://m.taobao.com/channel/act/sale/quanbuleimu.html"];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self presentViewController:self.storeBrowseViewController animated:YES completion:nil];
    
    //   [self.navigationController pushViewController:self.storeBrowseViewController animated:YES];
    [self.storeBrowseViewController.webView loadRequest:request];
    [self.storeBrowseViewController.storeName setText:@"更多商品"];

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
                break;
            case 1:
            {
                NSLog(@"这个是ID");
                NSString *num_iid=[NSString stringWithFormat:@"%@",searchField.text];
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
                break;
            case 2:
            {
                    [self presentItemList:[NSString stringWithFormat:@"%@",self.searchField.text]];
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
-(void)getItemListViewController:(id)sender
{
    UIButton *senderBtn=(UIButton*)sender;
    NSLog(@"get");
//    CosjiItemListViewController *itemsListViewController=[CosjiItemListViewController shareCosjiItemListViewController];
//    [self presentViewController:itemsListViewController animated:YES completion:nil];
//    [itemsListViewController loadInfoWith:[NSString stringWithFormat:@"%@",senderBtn.titleLabel.text] atPage:1];
    [self presentItemList:[NSString stringWithFormat:@"%@",senderBtn.titleLabel.text]];

}
-(void)presentItemList:(NSString*)keyword
{
    CosjiItemListViewController *itemsListViewController=[CosjiItemListViewController shareCosjiItemListViewController];
    [self presentViewController:itemsListViewController animated:YES completion:nil];
    [itemsListViewController loadInfoWith:keyword atPage:1];
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
