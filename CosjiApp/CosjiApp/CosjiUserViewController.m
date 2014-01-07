//
//  CosjiUserViewController.m
//  CosjiApp
//
//  Created by Darsky on 13-7-14.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiUserViewController.h"
#import "CosjiMP3Player.h"
#import "MobileProbe.h"
#import "CosjiServerHelper.h"
#import "CosjiLoginViewController.h"
#import "CosjiSettingViewController.h"
#import "CosjiWebViewController.h"
#import "SVProgressHUD.h"
#import "CosjiAccountSettingViewController.h"
#define userid @"390184"
#define kAppKey             @"21428060"
#define kAppSecret          @"dda4af6d892e2024c26cd621b05dd2d0"
#define kAppRedirectURI     @"http://cosjii.com"

@interface CosjiUserViewController ()
{
    UIViewController *currentMainController;
    BOOL backViewShowing;
    CGFloat translateFloat;
    UILabel *welcomeTitle;
    UILabel *bananceTitle;
    UILabel *jifenTitle;
    UILabel *jifenbaoTitle;
    UIButton *loginBtn;
    UIButton *registerBtn;
    UIImageView * userImageBoard;
    UILabel *qq;
}
@property (strong,nonatomic)UIViewController *backViewController;
@end

@implementation CosjiUserViewController
static CosjiUserViewController *CosjiUserRootController;
@synthesize customNavBar,userInfoView,tableView,userName,vipImage,balanceLabel,scoreLabel,jifenbaoLabel,userHeadImage;
@synthesize MainBoard,settingViewController,fanliListViewController;

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
    [MobileProbe pageBeginWithName:@"我的可及"];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [MobileProbe pageEndWithName:@"我的可及"];
}
-(void)loadView
{
    UIView *primaryView=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    primaryView.backgroundColor=[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:100];
    primaryView.backgroundColor=[UIColor whiteColor];
    self.view=primaryView;


}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CosjiUserRootController=self;
    backViewShowing=NO;
    self.settingViewController=[[CosjiSettingViewController alloc] init];
    self.settingViewController.settingDelegate=self;
    self.fanliListViewController=[[CosjiFanLiListViewController alloc] init];
    [self addChildViewController:self.settingViewController];
    [self.view addSubview: self.settingViewController.view];
    [self prepareMainBoard];
    self.customNavBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    self.customNavBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
    UIImageView *llogoImage=[[UIImageView alloc] initWithFrame:CGRectMake(14, 6, 156/2, 65/2)];
    llogoImage.image=[UIImage imageNamed:@"工具栏背景-标语"];
    [self.customNavBar addSubview:llogoImage];
    UIImageView *blogoImage=[[UIImageView alloc] initWithFrame:CGRectMake(160-155/4,13, 155/2, 40/2)];
    blogoImage.image=[UIImage imageNamed:@"我的可及"];
    [self.customNavBar addSubview:blogoImage];
    UIButton *settingBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame=CGRectMake(285, 45/2-40/4, 60/2, 40/2);
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"系统设置"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(showOrHideBackView:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavBar addSubview:settingBtn];
    [self.MainBoard addSubview:self.customNavBar];
}
-(void)prepareMainBoard
{
    self.MainBoard=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-49)];
    [self.MainBoard setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:100]];
    self.userInfoView=[[UIView alloc] initWithFrame:CGRectMake(0, 45, 320, 140)];
    self.userInfoView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"我的可及-背景"]];
    self.userName=[[UILabel alloc] initWithFrame:CGRectMake(88, 20, 120, 12)];
    self.userName.backgroundColor=[UIColor clearColor];
    self.userName.textColor=[UIColor whiteColor];
    self.userName.font=[UIFont fontWithName:@"Arial" size:14];
    [self.userInfoView addSubview:self.userName];
    self.vipImage=[UIButton buttonWithType:UIButtonTypeCustom];
    self.vipImage.frame=CGRectMake(205, 20, 28, 12);
    [self.vipImage setBackgroundImage:[UIImage imageNamed:@"vip"] forState:UIControlStateNormal];
    self.vipImage.userInteractionEnabled=NO;
    [self.vipImage.titleLabel setFont:[UIFont fontWithName:@"Arial" size:9]];
    [self.vipImage setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, -2.5, 0)];
    [self.userInfoView addSubview:self.vipImage];
    bananceTitle=[[UILabel alloc] initWithFrame:CGRectMake(88, 40, 42, 21)];
    bananceTitle.backgroundColor=[UIColor clearColor];
    bananceTitle.textColor=[UIColor whiteColor];
    bananceTitle.text=@"余额";
    bananceTitle.font=[UIFont fontWithName:@"Arial" size:17];
    [self.userInfoView addSubview:bananceTitle];
    self.balanceLabel=[[UILabel alloc] initWithFrame:CGRectMake(138,40, 65, 21)];
    self.balanceLabel.backgroundColor=[UIColor blackColor];
    self.balanceLabel.textColor=[UIColor whiteColor];
    self.balanceLabel.textAlignment=NSTextAlignmentCenter;
    self.balanceLabel.adjustsFontSizeToFitWidth=YES;
    self.balanceLabel.font=[UIFont fontWithName:@"Arial" size:17];
    [self.userInfoView addSubview:self.balanceLabel];
    jifenTitle=[[UILabel alloc] initWithFrame:CGRectMake(88, 70, 30, 14)];
    jifenTitle.backgroundColor=[UIColor clearColor];
    jifenTitle.textColor=[UIColor whiteColor];
    jifenTitle.font=[UIFont fontWithName:@"Arial" size:14];
    jifenTitle.text=@"积分";
    [self.userInfoView addSubview:jifenTitle];
    self.scoreLabel=[[UILabel alloc] initWithFrame:CGRectMake(126, 69, 48, 14)];
    self.scoreLabel.backgroundColor=[UIColor clearColor];
    self.scoreLabel.textColor=[UIColor yellowColor];
    self.scoreLabel.font=[UIFont fontWithName:@"Arial" size:12];
    [self.userInfoView addSubview:self.scoreLabel];
    jifenbaoTitle=[[UILabel alloc] initWithFrame:CGRectMake(171, 70, 50, 14)];
    jifenbaoTitle.backgroundColor=[UIColor clearColor];
    jifenbaoTitle.textColor=[UIColor whiteColor];
    jifenbaoTitle.font=[UIFont fontWithName:@"Arial" size:14];
    jifenbaoTitle.text=@"集分宝";
    [self.userInfoView addSubview:jifenbaoTitle];
    self.jifenbaoLabel=[[UILabel alloc] initWithFrame:CGRectMake(220, 69, 100, 14)];
    self.jifenbaoLabel.backgroundColor=[UIColor clearColor];
    self.jifenbaoLabel.textColor=[UIColor yellowColor];
    self.jifenbaoLabel.font=[UIFont fontWithName:@"Arial" size:12];
    [self.userInfoView addSubview:self.jifenbaoLabel];
    self.tixianBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.tixianBtn.frame=CGRectMake(0, self.userInfoView.frame.size.height-98/2, 100, 98/2);
    [self.tixianBtn setTitle:@"申请提现" forState:UIControlStateNormal];
    [self.tixianBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
    self.tixianBtn.tag=0;
    [self.tixianBtn addTarget:self action:@selector(tixianAction:) forControlEvents:UIControlEventTouchDown];
    [self.userInfoView addSubview:self.tixianBtn];
    self.tijifenbaoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.tijifenbaoBtn.frame=CGRectMake(100, self.userInfoView.frame.size.height-98/2, 120, 98/2);
    [self.tijifenbaoBtn setTitle:@"申请集分宝提现" forState:UIControlStateNormal];
    [self.tijifenbaoBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
    self.tijifenbaoBtn.tag=1;
    [self.tijifenbaoBtn addTarget:self action:@selector(tixianAction:) forControlEvents:UIControlEventTouchDown];

    [self.userInfoView addSubview:self.tijifenbaoBtn];
    self.qiandaoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.qiandaoBtn.frame=CGRectMake(220, self.userInfoView.frame.size.height-98/2, 100, 98/2);
    [self.qiandaoBtn setTitle:@"签到赚现" forState:UIControlStateNormal];
    [self.qiandaoBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
    self.qiandaoBtn.tag=2   ;
    [self.qiandaoBtn addTarget:self action:@selector(tixianAction:) forControlEvents:UIControlEventTouchDown];
    [self.userInfoView addSubview:self.qiandaoBtn];
    if (qq==nil) {
        qq=[[UILabel alloc] initWithFrame:CGRectMake(30, -15, 30, 30)];
        qq.backgroundColor=[UIColor clearColor];
        qq.text=@"+15";
        qq.textColor=[UIColor orangeColor];
        qq.adjustsFontSizeToFitWidth=YES;
        qq.alpha=0.0;
        [self.qiandaoBtn addSubview:qq];
    }

    self.tixianBtn.titleLabel.font=self.tijifenbaoBtn.titleLabel.font=self.qiandaoBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:14];
    self.tixianLineView=[[UIView alloc] initWithFrame:CGRectMake(0,  self.userInfoView.frame.size.height-98/2-1, 320, 1)];
    [self.tixianLineView setBackgroundColor:[UIColor colorWithRed:248.0/255.0 green:241.0/255.0 blue:213.0/255.0 alpha:0.1]];
    [self.userInfoView addSubview:self.tixianLineView];
    [self.MainBoard addSubview:self.userInfoView];
    welcomeTitle=[[UILabel alloc] initWithFrame:CGRectMake(320/2-226/2, 96/2+35, 226, 48/2)];
    welcomeTitle.text=@"欢迎来到可及网";
    welcomeTitle.textAlignment=NSTextAlignmentCenter;
    welcomeTitle.textColor=[UIColor whiteColor];
    welcomeTitle.font=[UIFont fontWithName:@"Arial" size:20];
    welcomeTitle.backgroundColor=[UIColor clearColor];
    [self.MainBoard addSubview:welcomeTitle];
    loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame=CGRectMake(157/2, 96/2+37/2+48/2+35, 64, 48/2);
   //[loginBtn setBackgroundColor:[UIColor redColor]];
    [loginBtn setTitle:@"点击登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    loginBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:16];
    [loginBtn addTarget:self action:@selector(toLogin) forControlEvents:UIControlEventTouchUpInside];
    registerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame=CGRectMake(160+35/2, 96/2+37/2+48/2+35, 64, 48/2);
  //[registerBtn setBackgroundColor:[UIColor redColor]];
    [registerBtn setTitle:@"免费注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    registerBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:16];
    [registerBtn addTarget:self action:@selector(toRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.MainBoard addSubview:loginBtn];
    [self.MainBoard addSubview:registerBtn];
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(5, 190, 310, [UIScreen mainScreen].bounds.size.height-49-200) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.backgroundView=nil;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.scrollEnabled=NO;
    [self.MainBoard addSubview:self.tableView];
    [self.view addSubview:self.MainBoard];
}


-(void)hideUserInfoView:(BOOL)isHide
{
    if (isHide) {
        self.userName.hidden=self.vipImage.hidden=bananceTitle.hidden=self.balanceLabel.hidden=self.jifenbaoLabel.hidden=jifenbaoTitle.hidden=jifenTitle.hidden=self.scoreLabel.hidden=self.tixianBtn.hidden=self.tijifenbaoBtn.hidden=self.qiandaoBtn.hidden=self.tixianLineView.hidden=self.userHeadImage.hidden=userImageBoard.hidden=YES;
        loginBtn.hidden=registerBtn.hidden=welcomeTitle.hidden=NO;
        
    }else
    {
        self.userName.hidden=self.vipImage.hidden=bananceTitle.hidden=self.balanceLabel.hidden=self.jifenbaoLabel.hidden=jifenbaoTitle.hidden=jifenTitle.hidden=self.scoreLabel.hidden=self.tixianBtn.hidden=self.tijifenbaoBtn.hidden=self.qiandaoBtn.hidden=self.tixianLineView.hidden=self.userHeadImage.hidden=userImageBoard.hidden=NO;
        loginBtn.hidden=registerBtn.hidden=welcomeTitle.hidden=YES;
    }

}
-(void)viewWillAppear:(BOOL)animated
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"] isEqualToString:@"YES"]) {
        [self hideUserInfoView:NO];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.qiandaoBtn.enabled==YES)
        {
            
            CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
            if ([serverHelper quickLogin])
            {
                NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:@"/registry/status"]];
                NSDictionary *statusDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
                NSString *statusString=[NSString stringWithFormat:@"%@",[statusDic objectForKey:@"status"]];
                if ([statusString isEqualToString:@"0"]) {
                    NSLog(@"qiandao enabled");
                    self.qiandaoBtn.enabled=YES;
                }else
                {
                    NSLog(@"qiandao unenabled");
                    self.qiandaoBtn.enabled=NO;
                }
                
            }else
            {
                self.qiandaoBtn.enabled=YES;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
        NSDictionary *infoDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
        self.userName.text=[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"username"]];
        NSLog(@"userName length is%d",self.userName.text.length);
        self.userName.frame=CGRectMake(self.userName.frame.origin.x, self.userName.frame.origin.y,self.userName.text.length*8, self.userName.frame.size.height);
        self.balanceLabel.text=[NSString stringWithFormat:@"%@元",[infoDic objectForKey:@"balance"]];
        self.scoreLabel.text=[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"score"]];
        self.jifenbaoLabel.text=[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"jifenbao"]];
        NSString *urlString=[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"avatar"]];
        urlString=[urlString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        if (self.userHeadImage==nil) {
            self.userHeadImage=[[UIImageView alloc] init];
            self.userHeadImage.frame = CGRectMake(13.f, 12.f, 70, 70);
            self.userHeadImage.layer.masksToBounds = YES;
            self.userHeadImage.layer.cornerRadius = 35;
            HeadImageFromURL([NSURL URLWithString:urlString], ^( UIImage * image )
                             {
                                 [self.userHeadImage setImage:image];
                             }, ^(void){
                                 [self.userHeadImage setImage:[UIImage imageNamed:@"我的可及-默认"]];
            });
            if (userImageBoard==nil) {
                userImageBoard = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的可及-人像框"]];
                userImageBoard.frame = CGRectMake(10.f, 10.f, 76, 76);
                [self.userInfoView addSubview:userImageBoard];
            }
            [self.userInfoView addSubview:self.userHeadImage];
        }else
        {
            
        }
        NSString *vip=[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"level"]];
        if ([vip intValue]==0) {
            self.vipImage.hidden=YES;
        }else
        {
            self.vipImage.frame=CGRectMake(self.userName.frame.size.width+self.userName.frame.origin.x, self.vipImage.frame.origin.y, self.vipImage.frame.size.width, self.vipImage.frame.size.height);
            self.vipImage.hidden=NO;
            [self.vipImage setTitle:[NSString stringWithFormat:@"%d",[vip intValue]] forState:UIControlStateNormal];
        }
            if (self.qiandaoBtn.enabled==NO)
            {
                [self.qiandaoBtn setTitle:@"已签到" forState:UIControlStateNormal];
            }
            });

                 });
    }else
    {
        [self hideUserInfoView:YES];
    }
}
#pragma mark tableviewmethod
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 41;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // static NSString *cellIdentifier = @"MyCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    switch (indexPath.row) {
        case 0:
        {
            UIImageView *imageIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的订单"]];
            imageIcon.frame=CGRectMake(20, 10, 25, 25);
            UILabel *functionLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 10, 80, 20)];
            functionLabel.text=@"我的订单";
            functionLabel.backgroundColor=[UIColor clearColor];
            [cell addSubview:imageIcon];
            [cell addSubview:functionLabel];
        }
            break;
        case 1:
        {
            UIImageView *imageIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"账户明细"]];
            imageIcon.frame=CGRectMake(20, 10, 25, 25);
            UILabel *functionLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 10, 80, 25)];
            functionLabel.text=@"账户明细";
            functionLabel.backgroundColor=[UIColor clearColor];
            [cell addSubview:imageIcon];
            [cell addSubview:functionLabel];
        }
            break;
        case 2:
        {
            UIImageView *imageIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"信息"]];
            imageIcon.frame=CGRectMake(20, 10, 25, 25);
            UILabel *functionLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 10, 80, 25)];
            functionLabel.text=@"站内信息";
            functionLabel.backgroundColor=[UIColor clearColor];
            [cell addSubview:imageIcon];
            [cell addSubview:functionLabel];
        }
            break;
        case 3:
        {
            UIImageView *imageIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"账户设置"]];
            imageIcon.frame=CGRectMake(20, 10, 25, 25);
            UILabel *functionLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 10, 80, 25)];
            functionLabel.text=@"账户设置";
            functionLabel.backgroundColor=[UIColor clearColor];
            [cell addSubview:imageIcon];
            [cell addSubview:functionLabel];
        }
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"]isEqualToString:@"YES"])
    {
    
    switch (indexPath.row) {
        case 0:
        {
            [self presentViewController:self.fanliListViewController animated:YES completion:nil];
        }
            break;
        case 1:
        {
            if (self.accountViewController==nil) {
                self.accountViewController=[[CosjiAccountViewController alloc] init];
            }
            [self presentViewController:self.accountViewController animated:YES completion:nil];
        }
            break;
        case 2:
        {
            [self toMessageViewController:0];
        }
            break;
        case 3:
        {
            if (self.accountSettingViewController==nil) {
                self.accountSettingViewController=[[CosjiAccountSettingViewController alloc] init];
            }
            [self presentViewController:self.accountSettingViewController animated:YES completion:nil];
        }
            break;
    }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，登录获取返利信息哟" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登陆",nil];
        [alert show];
    }
}
-(void)toMessageViewController:(int)order
{
    if (backViewShowing==YES) {
        [self showOrHideBackView:nil];
    }
    if (self.messageViewController==nil)
    {
        self.messageViewController=[[CosjiMessageViewController alloc] init];
    }
    [self presentViewController:self.messageViewController animated:YES completion:nil];
    [self.messageViewController loadFanLiListByOrder:order];
}
#pragma mark otherMethod
-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}
void HeadImageFromURL( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
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
- (IBAction)showOrHideBackView:(id)sender
{
    if (backViewShowing==NO) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        CGFloat translation = -280;
        self.MainBoard.transform = CGAffineTransformMakeTranslation(translation, 0);
        [UIView commitAnimations];
        backViewShowing=YES;
    }else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        CGFloat translation = 0;
        self.MainBoard.transform = CGAffineTransformMakeTranslation(translation, 0);
        [UIView commitAnimations];
        backViewShowing=NO;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)toLogin
{
    CosjiLoginViewController *loginViewController=[CosjiLoginViewController shareCosjiLoginViewController];
    [self presentViewController:loginViewController animated:YES completion:nil];
}

-(void)toRegister:(id)sender
{
   // http://www.cosji.com/index.php?mod=user&act=register
    NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"http://rest.cosjii.com/user/register/"]];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    CosjiWebViewController *webViewController=[CosjiWebViewController shareCosjiWebViewController];
    [self.navigationController pushViewController:webViewController animated:YES];
    [webViewController.webView loadRequest:request];
    [webViewController.storeName setText:[NSString stringWithFormat:@"注册"]];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:{
            
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
-(void)tixianActioncancle:(UIButton*)sender
{
      [sender setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
}
-(void)tixianAction:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    switch (sender.tag) {
        case 0:
        {
            [self performSelector:@selector(tixianActioncancle:) withObject:sender afterDelay:0.3];
            if (self.getCashViewController==nil) {
                self.getCashViewController=[[CosjiGetCashViewController alloc] init];
            }
            [self presentViewController:self.getCashViewController animated:YES completion:nil];

        }
            break;
        case 1:
        {
            [self performSelector:@selector(tixianActioncancle:) withObject:sender afterDelay:0.3];

        }
            break;
        case 2:
        {
            [self performSelector:@selector(qiandaoAnimation:) withObject:sender afterDelay:0.3];


        }
            break;
    }
}
-(void)qiandaoAnimation:(UIButton*)sender
{
    if (sender.enabled==YES)
    {
        CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
        NSDictionary *signDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:@"/registry/sign"]];
        NSDictionary *headDic=[NSDictionary dictionaryWithDictionary:[signDic objectForKey:@"head"]];
        if ([[headDic objectForKey:@"msg"]isEqualToString:@"success"])
        {
            NSLog(@"qiandao");
            qq.alpha = 0.0f;
            [UIView beginAnimations:@"fadeIn" context:nil];
            [UIView setAnimationDuration:3];
            qq.alpha = 1.0f;
            CGFloat translation = -30;
            qq.transform = CGAffineTransformMakeTranslation(0, translation);
            [UIView commitAnimations];
            [UIView beginAnimations:@"fadeIn" context:nil];
            [UIView setAnimationDuration:4.5];
            qq.alpha = 0.0f;
            [UIView commitAnimations];
            qq.transform = CGAffineTransformMakeTranslation(0, 0);
            [sender setTitle:@"已签到" forState:UIControlStateNormal];
            sender.userInteractionEnabled=NO;
            [sender setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
            qq.enabled=NO;
        }else
        {
            [SVProgressHUD dismissWithError:@"签到失败" afterDelay:3.0];
        }
}
}
- (void)viewDidUnload {
    [self setCustomNavBar:nil];
    [self setUserInfoView:nil];
    [self setTableView:nil];
    [self setUserName:nil];
    [self setVipImage:nil];
    [self setBalanceLabel:nil];
    [self setScoreLabel:nil];
    [self setJifenbaoLabel:nil];
    [self setMainBoard:nil];
    [super viewDidUnload];
}
@end
