//
//  CosjiTBViewController.m
//  可及网
//
//  Created by Darsky on 13-8-23.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiTBViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CosjiNewWebViewController.h"
#import "MobClick.h"
#import "CosjiItemListViewController.h"
#import "CosjiServerHelper.h"
#import "SVProgressHUD.h"
#import "CosjiItemFanliDetailViewController.h"
#import "CosjiLoginViewController.h"

@interface CosjiTBViewController ()
{
    UIImageView *searchFieldBG;
    int preSelected;
    UIImageView *_fanli_alert2;
    UIButton    *_showFanliButton;
    UIScrollView *_contentScrollView;
}
@end

@implementation CosjiTBViewController
@synthesize customNavBar;
@synthesize searchField;

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
    [MobClick beginLogPageView:@"返利通道"];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"返利通道"];
    [self.searchField resignFirstResponder];
}
-(void)loadView
{
    UIView *primary=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    primary.backgroundColor=[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:100];
    self.view=primary;
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 7.0)
    {

        self.customNavBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
        self.customNavBar.backgroundColor=[UIColor colorWithRed:225.0/255.0 green:47.0/255.0 blue:50.0/255.0 alpha:100];
        self.automaticallyAdjustsScrollViewInsets=NO;
        UILabel *blogoLabel=[[UILabel alloc] initWithFrame:CGRectMake(160-50, self.customNavBar.frame.size.height-38, 100, 25)];
        blogoLabel.text=@"返利通道";
        blogoLabel.textColor=[UIColor whiteColor];
        blogoLabel.textAlignment=NSTextAlignmentCenter;
        blogoLabel.backgroundColor=[UIColor clearColor];
        blogoLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:20];
        [self.customNavBar addSubview:blogoLabel];
          }
    else
    {
        
        self.customNavBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
        self.customNavBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
        UILabel *blogoLabel=[[UILabel alloc] initWithFrame:CGRectMake(160-50, self.customNavBar.frame.size.height-38, 100, 25)];
        blogoLabel.text=@"返利通道";
        blogoLabel.textColor=[UIColor whiteColor];
        blogoLabel.textAlignment=NSTextAlignmentCenter;
        blogoLabel.backgroundColor=[UIColor clearColor];
        blogoLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:20];
        [self.customNavBar addSubview:blogoLabel];
    }

    [self.view addSubview:self.customNavBar];
    UIImageView *llogoImage=[[UIImageView alloc] initWithFrame:CGRectMake(6,self.customNavBar.frame.size.height-39,156/2, 65/2)];
    llogoImage.image=[UIImage imageNamed:@"工具栏背景-标语"];
    [self.customNavBar addSubview:llogoImage];




    
    }
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden=YES;
    
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                       self.customNavBar.frame.size.height,
                                                                       self.view.frame.size.width,
                                                                        self.view.frame.size.height-self.customNavBar.frame.size.height)];
    [_contentScrollView setBackgroundColor:[UIColor clearColor]];
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_contentScrollView];
    [_contentScrollView setContentSize:CGSizeMake(_contentScrollView.frame.size.width, self.view.frame.size.height+50)];
    
    
    self.searchField=[[UITextField alloc] initWithFrame:CGRectMake(35, 43/2-35/2, 260, 35)];
    self.searchField.delegate=self;
    self.searchField.borderStyle=UITextBorderStyleNone;
    self.searchField.returnKeyType=UIReturnKeySearch;
    self.searchField.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.searchField.textAlignment=NSTextAlignmentLeft;
    self.searchField.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    self.searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.searchField.backgroundColor=[UIColor clearColor];
    self.searchField.font=[UIFont fontWithName:@"Arial" size:16];
    self.searchField.placeholder=@"粘贴商品全名或输入关键字，拿返利";
    [self.searchField addTarget:self action:@selector(searchItemFrom:) forControlEvents:UIControlEventEditingDidEndOnExit];
    searchFieldBG=[[UIImageView alloc] initWithFrame:CGRectMake(320/2-598/4, 15, 598/2, 86/2)];
    [searchFieldBG setImage:[UIImage imageNamed:@"淘宝返利搜索框"]];
    searchFieldBG.userInteractionEnabled=YES;
    UIImageView *imgv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"搜索框放大镜"]];
    imgv.frame=CGRectMake(8, searchFieldBG.frame.size.height/2-57/4, 56/2, 57/2);
    [searchFieldBG addSubview:imgv];
    [searchFieldBG addSubview:self.searchField];
    
    [_contentScrollView addSubview:searchFieldBG];
    self.webViewController=[[CosjiWebViewController alloc] init];
    
    
    UIView *fanli_alertView = [[UIView alloc] initWithFrame:CGRectMake(0, searchFieldBG.frame.size.height+searchFieldBG.frame.origin.y+20, self.view.frame.size.width, self.view.frame.size.height-self.customNavBar.frame.size.height-searchFieldBG.frame.size.height-20)];
    fanli_alertView.backgroundColor = [UIColor whiteColor];
    [_contentScrollView addSubview:fanli_alertView];
    
    UIImageView *fanli_alert1 = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                            0,
                                                                              320,
                                                                              278/2)];
    [fanli_alert1 setImage:[UIImage imageNamed:@"fanli_alert02"]];
    [fanli_alertView addSubview:fanli_alert1];
    
    _showFanliButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _showFanliButton.frame = CGRectMake(self.view.frame.size.width/2-210/2,
                                        fanli_alert1.frame.size.height+fanli_alert1.frame.origin.y,
                                        210,
                                        30);
    [_showFanliButton setTitle:@"小贴士：如何复制商品标题>" forState:UIControlStateNormal];
    [_showFanliButton setTitle:@"知道了！>" forState:UIControlStateSelected];
    [_showFanliButton setBackgroundColor:[UIColor clearColor]];
    [_showFanliButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _showFanliButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_showFanliButton addTarget:self
                         action:@selector(didShowFanliButtonTouch:)
               forControlEvents:UIControlEventTouchUpInside];
    [fanli_alertView addSubview:_showFanliButton];
    
    _fanli_alert2 = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                  _showFanliButton.frame.origin.y+_showFanliButton.frame.size.height,
                                                                  320,
                                                                  515/2)];
    [_fanli_alert2 setImage:[UIImage imageNamed:@"fanli_alert01"]];
    [fanli_alertView addSubview:_fanli_alert2];
    _fanli_alert2.hidden = YES;
    
    [self initHotWordView];
    
    UITapGestureRecognizer *tapGesturer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(closeKeyBoard)];
    tapGesturer.delegate = self;
    [_contentScrollView addGestureRecognizer:tapGesturer];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    self.tabBarController.tabBar.hidden=NO;

}

-(void)presentStoreBrowseViewController:(id)sender
{
    NSLog(@"%d",[sender tag]);
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"havelogined"])
    {
        [self openWebView:[sender tag]];
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"登录获取返利" delegate:self cancelButtonTitle:@"跳过" otherButtonTitles:@"登陆",nil];
        alert.tag=[sender tag];
        [alert show];
    }
}

-(void)openWebView:(int)target
{
    switch (target) {
        case 0:
        {
            NSURL *url =[NSURL URLWithString:@"http://m.taobao.com"];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            CosjiWebViewController *storeWebViewController=[[CosjiWebViewController alloc] init];
            
            UINavigationController *tmpNav=[[UINavigationController alloc] initWithRootViewController:storeWebViewController];
            tmpNav.navigationBarHidden=YES;
            [self presentViewController:tmpNav animated:YES completion:nil];
            [storeWebViewController setThisWebViewWithName:request name:@"已进入淘宝网"];
        }
            break;
        case 1:
        {
            NSURL *url =[NSURL URLWithString:@"http://m.tmall.com"];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            CosjiWebViewController *storeWebViewController=[[CosjiWebViewController alloc] init];
            
            UINavigationController *tmpNav=[[UINavigationController alloc] initWithRootViewController:storeWebViewController];
            tmpNav.navigationBarHidden=YES;
            [self presentViewController:tmpNav animated:YES completion:nil];
            [storeWebViewController setThisWebViewWithName:request name:@"已进入天猫"];
            
        }
            break;
        case 2:
        {
            NSURL *url =[NSURL URLWithString:@"http://ju.m.taobao.com"];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            CosjiWebViewController *storeWebViewController=[[CosjiWebViewController alloc] init];
            
            UINavigationController *tmpNav=[[UINavigationController alloc] initWithRootViewController:storeWebViewController];
            tmpNav.navigationBarHidden=YES;
            [self presentViewController:tmpNav animated:YES completion:nil];
            [storeWebViewController setThisWebViewWithName:request name:@"已进入聚划算"];
        }
            break;
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 110)
    {
        if (buttonIndex == 1)
        {
            CosjiLoginViewController *loginViewController=[CosjiLoginViewController shareCosjiLoginViewController];
            [self presentViewController:loginViewController animated:YES completion:nil];
        }
        return;
    }
        switch (buttonIndex) {
            case 0:
            {
                [self openWebView:alertView.tag];
            }
                break;
            case 1:
            {
                CosjiLoginViewController *loginViewController=[CosjiLoginViewController shareCosjiLoginViewController];
                [self presentViewController:loginViewController animated:YES completion:nil];
                
            }
                break;
        }
}

-(void)presentAllItemsTable
{
    NSURL *url =[NSURL URLWithString:@"http://m.taobao.com/channel/act/sale/quanbuleimu.html"];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    
    CosjiWebViewController *storeWebViewController=[[CosjiWebViewController alloc] init];
    
    UINavigationController *tmpNav=[[UINavigationController alloc] initWithRootViewController:storeWebViewController];
    tmpNav.navigationBarHidden=YES;
    [self presentViewController:tmpNav animated:YES completion:nil];
    [storeWebViewController setThisWebViewWithName:request name:@"更多商品"];
}

- (void)showFanliDetailWebView:(NSString*)keyWord
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"havelogined"])
    {
        NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
        NSDictionary *infoDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
        NSString *userID = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"userId"]];

        
        NSString *prepareUrlString = [NSString stringWithFormat:@"http://ai.m.taobao.com/search.html?back=true&q=%@&pid=mm_26039255_8350334_28114441&unid=%@",[self URLEncodedString:keyWord],userID];
        
        
        
        CosjiNewWebViewController *storeWebViewController=[[CosjiNewWebViewController alloc] init];
        
        UINavigationController *tmpNav=[[UINavigationController alloc] initWithRootViewController:storeWebViewController];
        tmpNav.navigationBarHidden=YES;
        [self presentViewController:tmpNav animated:YES completion:nil];
        storeWebViewController.itemName = keyWord;
        storeWebViewController.urlStirng = prepareUrlString;
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"登录获取返利" delegate:self cancelButtonTitle:@"跳过" otherButtonTitles:@"登陆",nil];
        alert.tag=110;
        [alert show];
        return;
    }

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

- (void)didShowFanliButtonTouch:(UIButton*)sender
{
    if (sender.selected)
    {
        sender.selected = NO;
        _fanli_alert2.hidden = YES;
    }
    else
    {
        sender.selected = YES;
        _fanli_alert2.hidden = NO;
    }
}
-(void)searchItemFrom:(UITextField*)textField
{
    [textField resignFirstResponder];
    //下面执行webView的操作
    if (textField!=nil&&![textField.text isEqualToString:@""])
    {
        NSLog(@"开始搜索");
        [self showFanliDetailWebView:textField.text];
//        if ([self isPureInt:searchField.text])
//        {
//            CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
//            NSString *num_iid=[NSString stringWithFormat:@"%@",searchField.text];
//            NSDictionary *infoDic=[serverHelper getItemFromTop:num_iid];
//            if (infoDic==nil)
//            {
//                [SVProgressHUD showErrorWithStatus:@"搜索不到该商品或该商品没有返利" duration:6];
//            }else
//            {
//                CosjiItemFanliDetailViewController *fanliDetailVC=[CosjiItemFanliDetailViewController shareCosjiItemFanliDetailViewController];
//                
//                [self presentViewController:fanliDetailVC animated:YES completion:nil];
//                [fanliDetailVC loadItemInfoWithDic:infoDic];
//            }
//
//        }else
//        {
//            NSDictionary *resultDic=[CosjiUrlFilter filterUrl:searchField.text];
//            if (resultDic == nil)
//            {
//                return;
//            }
//            NSNumber *resultNumber=[resultDic objectForKey:@"UrlType"];
//            NSLog(@"%@",[resultDic objectForKey:@"UrlType"]);
//            switch ([resultNumber intValue]) {
//                case 0:
//                {
//                    NSLog(@"//普通链接");
//                    CosjiWebViewController *storeWebViewController=[[CosjiWebViewController alloc] init];
//                    
//                    UINavigationController *tmpNav=[[UINavigationController alloc] initWithRootViewController:storeWebViewController];
//                    tmpNav.navigationBarHidden=YES;
//                    [self presentViewController:tmpNav animated:YES completion:nil];
//                    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"url"]]];
//                    [storeWebViewController setThisWebViewWithName:[NSURLRequest requestWithURL:url] name:@"浏览"];
//
//                }
//                    break;
//                case 1://混合链接
//                {
//                    NSLog(@"//混合链接");
//                    CosjiWebViewController *storeWebViewController=[[CosjiWebViewController alloc] init];
//                    
//                    UINavigationController *tmpNav=[[UINavigationController alloc] initWithRootViewController:storeWebViewController];
//                    tmpNav.navigationBarHidden=YES;
//                    [self presentViewController:tmpNav animated:YES completion:nil];
//                    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"url"]]];
//                    [storeWebViewController setThisWebViewWithName:[NSURLRequest requestWithURL:url] name:@"浏览"];
//                }
//                    break;
//                case 2://特别链接（带有淘宝推广的链接）
//                {
//                    NSLog(@"//特别链接");
//
//                    [self presentFanliDetailVCWithNumID:[resultDic objectForKey:@"num_iid"]];
//                }
//                    break;
//                case 3://淘宝商品链接
//                {
//                    NSLog(@"//淘宝链接");
//
//                    [self presentFanliDetailVCWithNumID:[resultDic objectForKey:@"num_iid"]];
//
//                }
//                    break;
//                case 4://天猫商品链接
//                {
//                    NSLog(@"//天猫链接");
//
//                    [self presentFanliDetailVCWithNumID:[resultDic objectForKey:@"num_iid"]];
//
//                }
//                    break;
//                case 5:
//                {
//                    NSLog(@"//纯文本");
//                    [self presentItemList:[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"String"]]];
//                }
//                    break;
//                case 6:
//                {
//                    [self presentFanliDetailVCWithNumID:[resultDic objectForKey:@"num_iid"]];
//                }
//                    break;
//            }
//            
//        }
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
    [self presentItemList:[NSString stringWithFormat:@"%@",senderBtn.titleLabel.text]];

}

#pragma mark UIGestureRecognizer Method
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

- (void)closeKeyBoard
{
    [[self findFirstResponder:self.view] resignFirstResponder];
    _hotWordView.hidden = YES;
}

- (UIView*)findFirstResponder:(UIView*)view
{
    for ( UIView *childView in view.subviews )
    {
        if ([childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder])
        {
            return childView;
        }
        UIView *result = [self findFirstResponder:childView];
        if (result) return result;
    }
    return nil;
}

-(void)presentItemList:(NSString*)keyword
{
    CosjiItemListViewController *itemsListViewController=[[CosjiItemListViewController alloc] init];
    UINavigationController *itemsListNavCon=[[UINavigationController alloc] initWithRootViewController:itemsListViewController];
    [self presentViewController:itemsListNavCon animated:YES completion:nil];
    [itemsListViewController loadInfoWith:[NSString stringWithFormat:@"%@",keyword] atPage:1];
}
-(void)presentFanliDetailVCWithNumID:(NSString*)num_id
{
    NSLog(@"this num_id is %@",num_id);
    CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
    NSDictionary *infoDic=[serverHelper getItemFromTop:num_id];
    if (infoDic==nil)
    {
        [SVProgressHUD showErrorWithStatus:@"搜索不到该商品或该商品没有返利" duration:6];
    }else
    {
        CosjiItemFanliDetailViewController *fanliDetailVC=[CosjiItemFanliDetailViewController shareCosjiItemFanliDetailViewController];
        [self presentViewController:fanliDetailVC animated:YES completion:nil];
        [fanliDetailVC loadItemInfoWithDic:infoDic];
    }

}
- (void)textFieldDidBeginEditing:(UITextField *)textField           // became first responder
{
    [textField.window makeKeyAndVisible];
    NSLog(@"显示");
    _hotWordView.hidden = NO;
}
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)URLEncodedString:(NSString*)target{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)target,
                                                                           NULL,
                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8));
    return result;
}

- (void)initHotWordView
{
    _hotWordView = [[UIView alloc] initWithFrame:CGRectMake(0, searchFieldBG.frame.size.height+searchFieldBG.frame.origin.y+20, self.view.frame.size.width, self.view.frame.size.height-self.customNavBar.frame.size.height-searchFieldBG.frame.size.height-20)];
    _hotWordView.backgroundColor = [UIColor colorWithRed:229.0/255.0
                                                   green:229.0/255.0
                                                    blue:229.0/255.0
                                                   alpha:100];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 16)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"热门搜索:";
    titleLabel.textColor = [UIColor blackColor];
    [_hotWordView addSubview:titleLabel];
    
    NSArray *hotWordArray = @[@"羽绒衣",@"保暖内衣",@"雪地靴",@"毛呢大衣",
                              @"男士外套",@"新款棉衣",@"时尚保温杯",@"秋冬童装",
                              @"时尚女包",@"马丁靴",@"新款男鞋",@"围巾",@"内衣"];
    float preLength = 0;
    for (int x = 0 ;x<hotWordArray.count ;x++)
    {
        UIButton *hotButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = hotWordArray[x];
        [hotButton setTitle:title forState:UIControlStateNormal];
        [hotButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [hotButton addTarget:self
                      action:@selector(didHotButtonTouch:)
            forControlEvents:UIControlEventTouchUpInside];
        [hotButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        NSLog(@"%d",title.length);
        if (x <= 3)
        {
            hotButton.frame = CGRectMake(preLength, 37.5, title.length*16+11.5, 16);
        }
        else if (x <= 7)
        {
            hotButton.frame = CGRectMake(preLength, 53.5+17.5, title.length*16+11.5, 16);
        }
        else
        {
            hotButton.frame = CGRectMake(preLength, 53.5+16+17.5+17.5, title.length*16+11.5, 16);
        }
        [_hotWordView addSubview:hotButton];
        if ( x == 3 ||x == 7)
        {
            preLength = 0;
        }
        else
        {
            preLength += title.length*16+11.5;
        }
        
    }
    [_contentScrollView addSubview:_hotWordView];
    _hotWordView.hidden = YES;
}

- (void)didHotButtonTouch:(UIButton*)sender
{
    [self.searchField resignFirstResponder];
    _hotWordView.hidden = YES;
    [self showFanliDetailWebView:sender.titleLabel.text];
}


- (void)viewDidUnload {
    [self setCustomNavBar:nil];
    [super viewDidUnload];
}
@end
