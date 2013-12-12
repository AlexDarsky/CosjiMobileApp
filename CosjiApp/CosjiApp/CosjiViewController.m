//
//  CosjiViewController.m
//  CosjiApp
//
//  Created by AlexZhu on 13-7-11.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiViewController.h"
#import "StoreKit/StoreKit.h"
#import "CosjiMP3Player.h"
#import "MobileProbe.h"
#import "CosjiServerHelper.h"
#import "CosjiLoginViewController.h"
#import "SVProgressHUD.h"
#import "CosjiGuideViewController.h"


#define kAppKey             @"21428060"
#define kAppSecret          @"dda4af6d892e2024c26cd621b05dd2d0"
#define kAppRedirectURI     @"http://cosjii.com"

@interface CosjiViewController ()
{
    UILabel *qq;
    UIButton *qiandaoBtn;
}
@end

@implementation CosjiViewController
@synthesize userIds;
static UINavigationController* nc;

-(void)loadView
{
    UIView *primaryView=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    primaryView.backgroundColor=[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:100];
    self.view=primaryView;
    self.CustomHeadView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    self.CustomHeadView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
    [self.view addSubview:self.CustomHeadView];
    UIImageView *llogoImage=[[UIImageView alloc] initWithFrame:CGRectMake(14, 8, 156/2, 65/2)];
    llogoImage.image=[UIImage imageNamed:@"工具栏背景-标语"];
    [self.CustomHeadView addSubview:llogoImage];
    UIImageView *blogoImage=[[UIImageView alloc] initWithFrame:CGRectMake(129,13, 126/2, 42/2)];
    blogoImage.image=[UIImage imageNamed:@"工具栏背景-logo"];
    [self.CustomHeadView addSubview:blogoImage];
    self.mainTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 48, 320, [UIScreen mainScreen].bounds.size.height-48-49)];
    self.mainTableView.delegate=self;
    self.mainTableView.dataSource=self;
    self.mainTableView.backgroundColor=[UIColor clearColor];
    self.mainTableView.backgroundView=nil;
    [self.mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.mainTableView];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    topListArray=[[NSMutableArray alloc] initWithObjects:@"ggtu",@"tbly", nil];
    storeListArray=[[NSMutableArray alloc] initWithCapacity:0];
    brandListArray=[[NSMutableArray alloc] initWithCapacity:0];
    page=[[UIPageControl alloc] initWithFrame:CGRectMake(141, 110, 38,36)];
    //page.center=CGPointMake(160, 126);
    sv=[[UIScrollView alloc] initWithFrame:CGRectMake(10, 5, 300, 130)];
    sv.delegate=self;
    sv.showsHorizontalScrollIndicator=NO;
    sv.backgroundColor=[UIColor clearColor];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target: self selector: @selector(handleTimer:)  userInfo:nil  repeats: YES];
    [self AdImg:topListArray];
    [self setCurrentPage:page.currentPage];
    self.storeBrowseViewController=[[CosjiWebViewController alloc] initWithNibName:@"CosjiWebViewController" bundle:nil];
    self.navigationController.navigationBarHidden=YES;
    selectSection=99;
}
-(void)viewDidAppear:(BOOL)animated
{
    [MobileProbe pageBeginWithName:@"首页"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [SVProgressHUD showWithStatus:@"正在载入。。。"];
    self.tabBarController.tabBar.hidden=NO;
    if ([storeListArray count]==0)
    {
        CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
        NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:@"/mall/hot/"]];
        
        if ([tmpDic objectForKey:@"body"]!=nil)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                storeListArray=[NSMutableArray arrayWithArray:[tmpDic objectForKey:@"body"]];
                NSLog(@"get Store %d",[storeListArray count]);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mainTableView reloadData];
                    });
               
            });
        }else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"服务器无法连接，请稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
        }
    }else
    {

    }
    [SVProgressHUD dismiss];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    page.currentPage=scrollView.contentOffset.x/320;
    [self setCurrentPage:page.currentPage];
}
- (void) handleTimer: (NSTimer *) timer
{
    if (TimeNum % 5 == 0 ) {
        //Tend 默认值为No
        if (!Tend) {
            NSLog(@"curretn page is %d",page.currentPage);
            page.currentPage++;
            if (page.currentPage==page.numberOfPages-1) {
                Tend=YES;
            }
        }else{
            NSLog(@"curretn page is %d",page.currentPage);
            page.currentPage--;
            if (page.currentPage==0) {
                Tend=NO;
            }
        }
        
        [UIView animateWithDuration:0.7 //速度0.7秒
                         animations:^{//修改坐标
                             sv.contentOffset = CGPointMake(page.currentPage*320,0);
                         }];
        
        
    }
    TimeNum ++;
}
- (void) setCurrentPage:(NSInteger)secondPage {
    
    for (NSUInteger subviewIndex = 0; subviewIndex < [page.subviews count]; subviewIndex++) {
        UIImageView* subview = [page.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 6;
        size.width = 6;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     size.width,size.height)];
        
        if (subviewIndex == secondPage) [subview setImage:[UIImage imageNamed:@"首页-焦点图-动态"]];
        else [subview setImage:[UIImage imageNamed:@"首页-焦点图-默认"]];
        
    }
}
-(void)AdImg:(NSMutableArray*)arr{
    [sv setContentSize:CGSizeMake(310*[arr count], 130)];
    page.numberOfPages=[arr count];
    
    for ( int i=0; i<[topListArray count]; i++) {
        
        UIButton *img=[[UIButton alloc]initWithFrame:CGRectMake(320*i, 0, 300, 130)];
        [img addTarget:self action:@selector(Action:) forControlEvents:UIControlEventTouchUpInside];
        img.tag=i;
        [sv addSubview:img];
        [img setImage:[UIImage imageNamed:[topListArray objectAtIndex:i]] forState:UIControlStateNormal];
    }
    
}
-(void)Action:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    switch (btn.tag) {
        case 0:
        {
            NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://s.click.taobao.com/t?e=zGU34CA7K%2BPkqB05%2Bm7rfGGjlY60oHcc7bkKOQYnIZl9roglx55ogY7XuIFA0XBbk%2Fzm7aeOZ3PlyybISkbOM7EtEdqHK%2B3%2B2VdLKXhDskZ4%2Fp2dh4NGvuCXRstUW1YAfVUjzoW0F55hwbLHDGosDrPX%2FGtVj28pHoIIzbTeYkfNwFLQ7ML46dUp2gxPHRwH7gFin%2BDZsAILX5h9mGLjjAhRlA%3D%3D"]];
            [self presentViewController:self.storeBrowseViewController animated:YES completion:nil];
            [self.storeBrowseViewController.webView loadRequest:request];
            [self.storeBrowseViewController.storeName setText:@"底价抢大牌"];

       }
            break;
        case 1:
        {
            NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://s.click.taobao.com/t?e=zGU34CA7K%2BPkqB05%2Bm7rfGKas1PIKp0U37pZuBotzOg7OjY%2F2R0Ke3HHzv2kJZUH%2FehqodvBvxouiCPW7UkqmIn4pk08catp7aU2wpqfONSeQJM%3D&pid=mm_26039255_0_0"]];
            [self presentViewController:self.storeBrowseViewController animated:YES completion:nil];
            [self.storeBrowseViewController.webView loadRequest:request];
            [self.storeBrowseViewController.storeName setText:@"淘宝旅行"];
        }
            break;
    }
}
void TopImageFromURL( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
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

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int number = 0;
    switch (section) {
        case 0:
        {
            number=1;
        }
            break;
        case 1:
        {
            number=1;
        }
            break;
        case 2:
        {
            if ([storeListArray count]==0)
            {
                number=0;
            }else
            {
                number=5;
            }
        }
            break;
    }
    return number;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    float height;
    switch (indexPath.section) {
        case 0:
        {
            height=140.0;
        }
            break;
        case 1:
        {
            height=102.0;
        }
            break;
        case 2:
        {
            height=82.0;
        }
            break;
    }
    return height;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
        headerView.backgroundColor=[UIColor clearColor];
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 96, 35)];
        label.text=@"热门商城推荐";
        label.font=[UIFont fontWithName:@"Arial" size:14];
        label.backgroundColor=[UIColor clearColor];
        label.textColor=[UIColor darkGrayColor];
        [headerView addSubview:label];
        UIButton *moreButton=[UIButton buttonWithType:UIButtonTypeCustom];
        moreButton.frame=CGRectMake(272, 0, 38, 35);
        [moreButton setBackgroundImage:[UIImage imageNamed:@"首页-更多"] forState:UIControlStateNormal];
        [headerView addSubview:moreButton];
        return headerView;
    }else
        return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        return 35;
    }else
        return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // static NSString *cellIdentifier = @"MyCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    // cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    switch (indexPath.section) {
        case 0:
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell addSubview:sv];
            [cell addSubview:page];
        }
            break;
        case 1:
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            if (qiandaoBtn==nil) {
                qiandaoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
                qiandaoBtn.frame=CGRectMake(10, 0, 218/2, 25);
                [qiandaoBtn addTarget:self action:@selector(qiandaoServer:) forControlEvents:UIControlEventTouchUpInside];
                [qiandaoBtn setBackgroundColor:[UIColor whiteColor]];
                [qiandaoBtn setTitle:@"      签到赚线" forState:UIControlStateNormal];
                qiandaoBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:12];
                [qiandaoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                qq=[[UILabel alloc] initWithFrame:CGRectMake(30, -15, 30, 30)];
                qq.backgroundColor=[UIColor clearColor];
                qq.text=@"+15";
                qq.textColor=[UIColor redColor];
                qq.adjustsFontSizeToFitWidth=YES;
                qq.alpha=0.0;
                UIImageView *qiandaoImage=[[UIImageView alloc] initWithFrame:CGRectMake(5, 4, 18, 17)];
                [qiandaoImage setImage:[UIImage imageNamed:@"首页-签到"]];
                qiandaoImage.userInteractionEnabled=YES;
                [qiandaoBtn addSubview:qiandaoImage];
                [qiandaoBtn addSubview:qq];
            }
            [cell addSubview:qiandaoBtn];
            UIButton *helperBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            helperBtn.frame=CGRectMake(10, 32, 218/2, 120/2);
            [helperBtn addTarget:self action:@selector(presentStoreBrowseViewController:) forControlEvents:UIControlEventTouchUpInside];
            [helperBtn setImage:[UIImage imageNamed:@"返利教程图片"] forState:UIControlStateNormal];
            helperBtn.tag=0;
            [cell addSubview:helperBtn];
            UIButton *juhuasuanBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            juhuasuanBtn.frame=CGRectMake(125, 0, 176/2, 183/2);
            [juhuasuanBtn addTarget:self action:@selector(presentStoreBrowseViewController:) forControlEvents:UIControlEventTouchUpInside];
            [juhuasuanBtn setImage:[UIImage imageNamed:@"首页聚划算"] forState:UIControlStateNormal];
            juhuasuanBtn.tag=1;
            [cell addSubview:juhuasuanBtn];
            UIButton *tmallBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            tmallBtn.frame=CGRectMake(130+180/2, 0, 176/2, 183/2);
            [tmallBtn addTarget:self action:@selector(presentStoreBrowseViewController:) forControlEvents:UIControlEventTouchUpInside];
            [tmallBtn setImage:[UIImage imageNamed:@"首页天猫"] forState:UIControlStateNormal];
            tmallBtn.tag=2;
            [cell addSubview:tmallBtn];

        }
            break;
        case 2:
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            //商城左
            NSDictionary *storeDic1=[NSDictionary dictionaryWithDictionary:[storeListArray objectAtIndex:indexPath.row*3]];
            UIView *btnView1=[[UIView alloc] initWithFrame:CGRectMake(10, 0, 95, 55)];
            btnView1.backgroundColor=[UIColor whiteColor];
            UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
            button1.frame=CGRectMake(0,5, 95, 50);
            button1.tag=indexPath.row*3;
            NSString *imageUrl1=[NSString stringWithFormat:@"%@",[storeDic1 objectForKey:@"logo"]];
            imageUrl1=[imageUrl1 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            if ([imageUrl1 rangeOfString:@"http://www.Cosji.com/"].location==NSNotFound) {
                imageUrl1=[NSString stringWithFormat:@"http://www.Cosji.com/%@",imageUrl1];
            }
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
             NSString *filename = [dirName stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[storeDic1 objectForKey:@"id"]]];
             if (![[NSFileManager defaultManager] fileExistsAtPath:filename])
             {
                 NSLog(@"download cacheImage %@",filename);
                 NSData * data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl1]];
                 UIImage * cacheimage = [[UIImage alloc] initWithData:data];
                 [UIImageJPEGRepresentation(cacheimage, 1.0) writeToFile:filename atomically:YES];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     NSData *imageData=[NSData dataWithContentsOfFile:filename];
                     [button1 setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                 });
             }else
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     NSLog(@"load cacheImage %@",filename);
                     NSData *imageData=[NSData dataWithContentsOfFile:filename];
                     [button1 setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                 });
             }
             });
            //缓存图片

            [button1 addTarget:self action:@selector(opRemenshangcheng:) forControlEvents:UIControlEventTouchUpInside];
            [btnView1 addSubview:button1];
            [cell addSubview:btnView1];
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 55, 95, 20)];
            label.adjustsFontSizeToFitWidth=YES;
            label.backgroundColor=[UIColor lightTextColor];
            label.text=[NSString stringWithFormat:@"最高返利%@",[storeDic1 objectForKey:@"profit" ]];
            [btnView1 addSubview:label];
            
            //商城中
            NSDictionary *storeDic2=[NSDictionary dictionaryWithDictionary:[storeListArray objectAtIndex:indexPath.row*3+1]];
            UIView *btnView2=[[UIView alloc] initWithFrame:CGRectMake(112.5, 0, 95, 55)];
            btnView2.backgroundColor=[UIColor whiteColor];
            UIButton *button2=[UIButton buttonWithType:UIButtonTypeCustom];
            button2.frame=CGRectMake(0, 5, 95, 50);
            button2.tag=indexPath.row*3+1;
            NSString *imageUrl2=[NSString stringWithFormat:@"%@",[storeDic2 objectForKey:@"logo"]];
            imageUrl2=[imageUrl2 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            if ([imageUrl2 rangeOfString:@"http://www.Cosji.com/"].location==NSNotFound) {
                imageUrl2=[NSString stringWithFormat:@"http://www.Cosji.com/%@",imageUrl2];
            }

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
                               NSString *filename = [dirName stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[storeDic2 objectForKey:@"id"]]];
                               if (![[NSFileManager defaultManager] fileExistsAtPath:filename])
                               {
                                   NSLog(@"download cacheImage %@",filename);
                                   NSData * data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl2]];
                                   UIImage * cacheimage = [[UIImage alloc] initWithData:data];
                                   [UIImageJPEGRepresentation(cacheimage, 1.0) writeToFile:filename atomically:YES];
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSData *imageData=[NSData dataWithContentsOfFile:filename];
                                       [button2 setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                                   });
                               }else
                               {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSLog(@"load cacheImage %@",filename);
                                       NSData *imageData=[NSData dataWithContentsOfFile:filename];
                                       [button2 setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                                   });
                               }
                           });
            //缓存图片
            [button2 addTarget:self action:@selector(opRemenshangcheng:) forControlEvents:UIControlEventTouchUpInside];
            UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(0, 55, 95, 20)];
            label2.adjustsFontSizeToFitWidth=YES;
            label2.backgroundColor=[UIColor lightTextColor];
            label2.text=[NSString stringWithFormat:@"最高返利%@",[storeDic2 objectForKey:@"profit" ]];
            [btnView2 addSubview:button2];
            [btnView2 addSubview:label2];
            //商城右
            NSDictionary *storeDic3=[NSDictionary dictionaryWithDictionary:[storeListArray objectAtIndex:indexPath.row*3+2]];
            UIView *btnView3=[[UIView alloc] initWithFrame:CGRectMake(215, 0, 95, 55)];
            btnView3.backgroundColor=[UIColor whiteColor];

            UIButton *button3=[UIButton buttonWithType:UIButtonTypeCustom];
            button3.frame=CGRectMake(0, 0, 95, 50);
            button3.tag=indexPath.row*3+2;
            NSString *imageUrl3=[NSString stringWithFormat:@"%@",[storeDic3 objectForKey:@"logo"]];
            imageUrl3=[imageUrl3 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            if ([imageUrl3 rangeOfString:@"http://www.Cosji.com/"].location==NSNotFound) {
                imageUrl3=[NSString stringWithFormat:@"http://www.Cosji.com/%@",imageUrl3];
            }
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
                               NSString *filename = [dirName stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[storeDic3 objectForKey:@"id"]]];
                               if (![[NSFileManager defaultManager] fileExistsAtPath:filename])
                               {
                                   NSLog(@"download cacheImage %@",filename);
                                   NSData * data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl3]];
                                   UIImage * cacheimage = [[UIImage alloc] initWithData:data];
                                   [UIImageJPEGRepresentation(cacheimage, 1.0) writeToFile:filename atomically:YES];
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSData *imageData=[NSData dataWithContentsOfFile:filename];
                                       [button3 setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                                   });
                               }else
                               {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSLog(@"load cacheImage %@",filename);
                                       NSData *imageData=[NSData dataWithContentsOfFile:filename];
                                       [button3 setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                                   });
                               }
                           });
            //缓存图片
            UILabel *label3=[[UILabel alloc] initWithFrame:CGRectMake(0, 55, 95, 20)];
            label3.adjustsFontSizeToFitWidth=YES;
            label3.backgroundColor=[UIColor lightTextColor];
            label3.text=[NSString stringWithFormat:@"最高返利%@",[storeDic3 objectForKey:@"profit" ]];
            label.font=label2.font=label3.font=[UIFont fontWithName:@"Arial Hebrew" size:12];
            label.textAlignment=label2.textAlignment=label3.textAlignment=UITextAlignmentCenter;
            [btnView3 addSubview:button3];
            [btnView3 addSubview:label3];
            [button3 addTarget:self action:@selector(opRemenshangcheng:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btnView2];
            [cell addSubview:btnView3];
        
        }
            break;
    }
    return cell;
}
    
-(void)qiandaoServer:(id)sender
{
    NSLog(@"qiandao");
    qq.alpha = 0.0f;
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:2];
    qq.alpha = 1.0f;
    CGFloat translation = -10;
    qq.transform = CGAffineTransformMakeTranslation(0, translation);
    [UIView commitAnimations];
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:2.5];
    qq.alpha = 0.0f;
    [qiandaoBtn setTitle:@"       已签到" forState:UIControlStateNormal];
    qiandaoBtn.userInteractionEnabled=NO;
    [UIView commitAnimations];
    qq.transform = CGAffineTransformMakeTranslation(0, 0);
    

}

-(void)opRemenshangcheng:(id)sender
{
    selectedIndex=[sender tag];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"]isEqualToString:@"YES"]) {
        NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[storeListArray objectAtIndex:selectedIndex]];
        NSString *storeUrl=[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"url"]];
        NSURL *url =[NSURL URLWithString:[storeUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        [self presentViewController:self.storeBrowseViewController animated:YES completion:nil];
        [self.storeBrowseViewController.webView loadRequest:request];
        [self.storeBrowseViewController.storeName setText:[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"name"]]];

    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"登录获取返利" delegate:self cancelButtonTitle:@"跳过" otherButtonTitles:@"登陆",nil];
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:{
            NSLog(@"case 0");
            NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[storeListArray objectAtIndex:selectedIndex]];
            NSString *storeUrl=[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"yiqifaurl"]];
            NSLog(@"%@",[storeUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""]);

            NSURL *url =[NSURL URLWithString:[storeUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            [self presentViewController:self.storeBrowseViewController animated:YES completion:nil];
            [self.storeBrowseViewController.webView loadRequest:request];
            [self.storeBrowseViewController.storeName setText:[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"name"]]];
        }
            break;
            
        case 1:
        {
            NSLog(@"case 1");
            CosjiLoginViewController *loginViewController=[CosjiLoginViewController shareCosjiLoginViewController];
            [self presentViewController:loginViewController animated:YES completion:nil];
                       
        }
            break;
            
    }

}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:{
            NSLog(@"case 0");
            NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[storeListArray objectAtIndex:selectedIndex]];
            NSString *storeUrl=[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"yiqifaurl"]];
            NSLog(@"%@",[storeUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""]);
            NSURL *url =[NSURL URLWithString:[storeUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            [self presentViewController:self.storeBrowseViewController animated:YES completion:nil];
            [self.storeBrowseViewController.webView loadRequest:request];
            [self.storeBrowseViewController.storeName setText:[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"name"]]];
            
        }
            break;
            
        case 1:
        {
            CosjiLoginViewController *loginViewController=[CosjiLoginViewController shareCosjiLoginViewController];
            [self presentViewController:loginViewController animated:YES completion:nil];
            NSLog(@"case 1");
        }
            break;
    }
}
-(void)presentStoreBrowseViewController:(id)sender
{
    NSLog(@"%d",[sender tag]);
    switch ([sender tag]) {
        case 0:
        {
            CosjiGuideViewController *guideViewController=[CosjiGuideViewController shareCosjiGuideViewController];
            [self presentViewController:guideViewController animated:YES completion:nil];
        }
            break;
        case 1:
        {
            NSURL *url =[NSURL URLWithString:@"http://ju.m.taobao.com"];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            [self presentViewController:self.storeBrowseViewController animated:YES completion:nil];
            
            //   [self.navigationController pushViewController:self.storeBrowseViewController animated:YES];
            [self.storeBrowseViewController.webView loadRequest:request];
            [self.storeBrowseViewController.storeName setText:@"已进入聚划算"];
        }
            break;
        case 2:
        {
            NSURL *url =[NSURL URLWithString:@"http://m.tmall.com"];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            [self presentViewController:self.storeBrowseViewController animated:YES completion:nil];
            //  [self.navigationController pushViewController:self.storeBrowseViewController animated:YES];
            [self.storeBrowseViewController.webView loadRequest:request];
            [self.storeBrowseViewController.storeName setText:@"已进入天猫"];
        }
            break;
    }
}

-(void)closeAuthView{
    [nc dismissModalViewControllerAnimated:YES];
    nc = nil;
}
- (IBAction)exitKeyboard:(id)sender {
    [sender resignFirstResponder];
}
- (void)viewDidUnload {
    [self setCustomHeadView:nil];
    [super viewDidUnload];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [MobileProbe pageEndWithName:@"首页"];
}
@end
