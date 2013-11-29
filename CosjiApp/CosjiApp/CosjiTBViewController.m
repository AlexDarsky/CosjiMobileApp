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
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden=YES;
    subjectsArray=[[NSMutableArray alloc] initWithCapacity:0];
    self.customNavBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
    self.searchField=[[UITextField alloc] initWithFrame:CGRectMake(0, 10, 300, 35)];
    self.searchField.borderStyle=UITextBorderStyleNone;
    self.searchField.returnKeyType=UIReturnKeyDone;
    self.searchField.textAlignment=UITextAlignmentCenter;
    self.searchField.backgroundColor=[UIColor clearColor];
    self.searchField.font=[UIFont fontWithName:@"Arial Hebrew" size:18];
    self.searchField.placeholder=@"输入商品名称或网址查询返利";
    self.searchField.textAlignment=UITextAlignmentCenter;
    [self.searchField addTarget:self action:@selector(searchItemFrom:) forControlEvents:UIControlEventEditingDidEndOnExit];
    UIImageView *imgv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"淘宝返利-搜索框放大镜"]];
    imgv.frame=CGRectMake(2, 0, 16, 21);
    [self.searchField addSubview:imgv];

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
    [SVProgressHUD showWithStatus:@"正在载入。。。"];
    self.navigationController.navigationBarHidden=YES;
    self.tabBarController.tabBar.hidden=NO;
    if ([subjectsArray count]==0)
    {
        CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
        NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:@"/taobao/category/"]];
        if ([tmpDic objectForKey:@"body"]!=nil)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSDictionary *subjectsListDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
                for (int x=1; x<=7; x++) {
                    [subjectsArray addObject:[subjectsListDic objectForKey:[NSString stringWithFormat:@"%d",x]]];
                }
                NSLog(@"get Store %d",[subjectsArray count]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [self.tableView reloadData];
                });
                
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
            UILabel *taoBtnLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 49, 70, 15)];
            taoBtnLabel.text=[NSString stringWithFormat:@"淘宝"];
            taoBtnLabel.textAlignment=UITextAlignmentCenter;
            
            UIView *tmallBtnView=[[UIView alloc] initWithFrame:CGRectMake(115, 70, 90, 64)];
            tmallBtnView.backgroundColor=[UIColor whiteColor];
            UILabel *tmallBtnLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 49, 70, 15)];
            tmallBtnLabel.text=[NSString stringWithFormat:@"天猫"];
            tmallBtnLabel.textAlignment=UITextAlignmentCenter;
            
            UIView *juBtnView=[[UIView alloc] initWithFrame:CGRectMake(220, 70, 90, 64)];
            juBtnView.backgroundColor=[UIColor whiteColor];
            UILabel *juBtnLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 49, 70, 15)];
            juBtnLabel.text=[NSString stringWithFormat:@"聚划算"];
            juBtnLabel.textAlignment=UITextAlignmentCenter;
            UIImageView *lineSpretor1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"淘宝返利-投影分割线-2"]];
            lineSpretor1.frame=CGRectMake(0, 63, 320, 4.5);
            [cell addSubview:lineSpretor1];
            UIImageView *lineSpretor2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"淘宝返利-投影分割线-1"]];
            lineSpretor2.frame=CGRectMake(0, 135, 320, 4.5);
            taoBtnLabel.backgroundColor=tmallBtnLabel.backgroundColor=juBtnLabel.backgroundColor=[UIColor lightGrayColor];

            [cell addSubview:lineSpretor2];
            [taoBtnView addSubview:self.taoBtn];
            [taoBtnView addSubview:taoBtnLabel];
            [tmallBtnView addSubview:self.tmallBtn];
            [tmallBtnView addSubview:tmallBtnLabel];
            [juBtnView addSubview:self.juBtn];
            [juBtnView addSubview:juBtnLabel];
            UIImageView *searchFieldBG=[[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 300, 45)];
            [searchFieldBG setImage:[UIImage imageNamed:@"淘宝返利-搜索框"]];
            searchFieldBG.userInteractionEnabled=YES;
            [searchFieldBG addSubview:self.searchField];
            [cell addSubview:searchFieldBG];
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
                    NSString *imageUrl=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"imgUrl"]];
                    imageUrl=[imageUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    UILabel *itemLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 45, 60, 15)];
                    itemLabel.text=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"name"]];
                    itemLabel.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.8];
                    itemLabel.textAlignment=UITextAlignmentCenter;
                    itemLabel.font=[UIFont fontWithName:@"Arial" size:12];
                    [itemButton addSubview:itemLabel];
                    [itemButton addTarget:self action:@selector(getItemListViewController:) forControlEvents:UIControlEventTouchUpInside];
                    subjectItemImage([NSURL URLWithString:imageUrl], ^( UIImage * image )
                                    {
                                        [itemButton setImage:image forState:UIControlStateNormal];
                                    }, ^(void){
                                    });
                    [cell addSubview:itemButton];
                }else
                {
                    NSDictionary *itemDic=[NSDictionary dictionaryWithDictionary:[subjectItemsArray objectAtIndex:x]];
                    UIButton *itemButton=[UIButton buttonWithType:UIButtonTypeCustom];
                    itemButton.frame=CGRectMake(10+(x-4)*80, 80, 60, 60);
                    [itemButton setTitle:[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"name"]] forState:UIControlStateNormal];
                    NSString *imageUrl=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"imgUrl"]];
                    imageUrl=[imageUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    UILabel *itemLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 45, 60, 15)];
                    itemLabel.text=[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"name"]];
                    itemLabel.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.8];
                    itemLabel.textAlignment=UITextAlignmentCenter;
                    itemLabel.font=[UIFont fontWithName:@"Arial" size:12];
                    [itemButton addSubview:itemLabel];
                    [itemButton addTarget:self action:@selector(getItemListViewController:) forControlEvents:UIControlEventTouchUpInside];
                    subjectItemImage([NSURL URLWithString:imageUrl], ^( UIImage * image )
                                     {
                                         [itemButton setImage:image forState:UIControlStateNormal];
                                     }, ^(void){
                                     });
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
            [self presentViewController:self.storeBrowseViewController animated:YES completion:nil];

     //       [self.navigationController pushViewController:self.storeBrowseViewController animated:YES];
            [self.storeBrowseViewController.webView loadRequest:request];
            [self.storeBrowseViewController.storeName setText:@"已进入淘宝网"];
        }
            break;
        case 1:
        {
            NSURL *url =[NSURL URLWithString:@"http://m.tmall.com"];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            [self presentViewController:self.storeBrowseViewController animated:YES completion:nil];
          //  [self.navigationController pushViewController:self.storeBrowseViewController animated:YES];
            [self.storeBrowseViewController.webView loadRequest:request];
            [self.storeBrowseViewController.storeName setText:@"已进入天猫"];
        }
            break;
        case 2:
        {
            NSURL *url =[NSURL URLWithString:@"http://ju.m.taobao.com"];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            [self presentViewController:self.storeBrowseViewController animated:YES completion:nil];

         //   [self.navigationController pushViewController:self.storeBrowseViewController animated:YES];
            [self.storeBrowseViewController.webView loadRequest:request];
            [self.storeBrowseViewController.storeName setText:@"已进入聚划算"];
        }
            break;
    }
}
-(IBAction)presentAllItemsTable
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
    if (textField!=nil)
    {
        NSLog(@"开始搜索");
        CosjiItemListViewController *itemsListViewController=[CosjiItemListViewController shareCosjiItemListViewController];
        [self presentViewController:itemsListViewController animated:YES completion:nil];
        [itemsListViewController loadInfoWith:[NSString stringWithFormat:@"%@",self.searchField.text] atPage:1];
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
    CosjiItemListViewController *itemsListViewController=[CosjiItemListViewController shareCosjiItemListViewController];
    [self presentViewController:itemsListViewController animated:YES completion:nil];
    [itemsListViewController loadInfoWith:[NSString stringWithFormat:@"%@",senderBtn.titleLabel.text] atPage:1];
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
