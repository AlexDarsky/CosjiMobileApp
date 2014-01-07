//
//  CosjiLoginViewController.m
//  CosjiApp
//
//  Created by Darsky on 13-10-4.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiLoginViewController.h"
#import "CosjiServerHelper.h"
#import "CosjiWebViewController.h"
#import "SVProgressHUD.h"
#define testID @"zhuweimingyanha"
#define testPWD @"83266295"
#define userID @"394280"


@interface CosjiLoginViewController ()
{
    UIButton *loginBrn;
    UIImageView *userNameBG;
    UIImageView *passwordBG;
}

@end

@implementation CosjiLoginViewController
@synthesize userName,passWord,rememberBtn;

static CosjiLoginViewController *shareCosjiLoginViewController = nil;

+(CosjiLoginViewController*)shareCosjiLoginViewController
{
    
    if (shareCosjiLoginViewController == nil) {
        shareCosjiLoginViewController = [[super allocWithZone:NULL] init];
    }
    return shareCosjiLoginViewController;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization




    }
    return self;
}
-(void)loadView
{
    UIView *primaryView=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    primaryView.backgroundColor=[UIColor colorWithRed:241.0/255.0 green:233/255.0 blue:230/255.0 alpha:100.0];
    self.view=primaryView;
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(11, 2.5, 100/2, 80/2);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    UIImageView *cosjiLogo=[[UIImageView alloc] initWithFrame:CGRectMake(20, 54, 261/2, 81/2)];
    cosjiLogo.image=[UIImage imageNamed:@"登陆页-logo"];
    [self.view addSubview:cosjiLogo];
    //用户名输入框
    userNameBG=[[UIImageView alloc] initWithFrame:CGRectMake(160-582/4, 124, 582/2, 86/2)];
    [userNameBG setImage:[UIImage imageNamed:@"登陆页-登陆框-默认"]];
    
    self.userName=[[UITextField alloc] initWithFrame:CGRectMake(160-582/4+33, 124, 582/2-33, 86/2)];
    self.userName.textAlignment=NSTextAlignmentLeft;
    self.userName.placeholder=[NSString stringWithFormat:@"用户名/邮箱/手机号"];
    self.userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.userName.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    self.userName.delegate=self;
    UIImageView *userNameIcon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 16, 20)];
    userNameIcon.image=[UIImage imageNamed:@"登陆页-用户名"];
    [userNameBG addSubview:userNameIcon];
    [self.view addSubview:userNameBG];
    [self.view addSubview:self.userName];
    //密码框
    passwordBG=[[UIImageView alloc] initWithFrame:CGRectMake(160-582/4, 172, 582/2, 86/2)];
    [passwordBG setImage:[UIImage imageNamed:@"登陆页-登陆框-默认"]];
    self.passWord=[[UITextField alloc] initWithFrame:CGRectMake(160-582/4+33, 172, 582/2-33, 86/2)];
    self.passWord.secureTextEntry=YES;
    self.passWord.placeholder=[NSString stringWithFormat:@"点击输入密码"];
    self.passWord.returnKeyType=UIReturnKeyGo;
    self.passWord.delegate=self;
    self.passWord.textAlignment=NSTextAlignmentLeft;
    self.passWord.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passWord.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [self.passWord addTarget:self action:@selector(login:) forControlEvents:UIControlEventEditingDidEndOnExit];
    UIImageView *passWordIcon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 16, 20)];
    passWordIcon.image=[UIImage imageNamed:@"登陆页-密码"];
    [passwordBG addSubview:passWordIcon];
    [self.view addSubview:passwordBG];
    [self.view addSubview:self.passWord];
    //记住密码
    self.rememberBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.rememberBtn.frame=CGRectMake(20, 226, 21, 22);
    [self.rememberBtn setBackgroundImage:[UIImage imageNamed:@"登陆页-记住密码-默认"] forState:UIControlStateNormal];
    [self.rememberBtn setBackgroundImage:[UIImage imageNamed:@"登陆页-记住密码-动态"] forState:UIControlStateSelected];
    [self.rememberBtn setSelected:NO];
    [self.rememberBtn addTarget:self action:@selector(remember:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rememberBtn];
    UILabel *rememberLabel=[[UILabel alloc] initWithFrame:CGRectMake(49, 226, 120, 21)];
    rememberLabel.backgroundColor=[UIColor clearColor];
    rememberLabel.text=@"记住密码";
    rememberLabel.textColor=[UIColor redColor];
    [self.view addSubview:rememberLabel];
    
    loginBrn=[UIButton buttonWithType:UIButtonTypeCustom];
    loginBrn.frame=CGRectMake(160-291/2, 257, 582/2, 69/2);
    [loginBrn setBackgroundImage:[UIImage imageNamed:@"按钮_登录"] forState:UIControlStateNormal];
    [loginBrn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBrn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginBrn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBrn];
    
    
    UILabel *registerLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 300, 100, 21)];
    registerLabel.backgroundColor=[UIColor clearColor];
    registerLabel.font=[UIFont fontWithName:@"Arial" size:15];
    registerLabel.text=@"还没有账号,";
    [self.view addSubview:registerLabel];
    self.registerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.registerBtn.frame=CGRectMake(85, 299, 100, 25);
    [self.registerBtn setTitle:@"注册账号" forState:UIControlStateNormal];
    [self.registerBtn.titleLabel setFont:[UIFont fontWithName:@"Arial" size:15]];
    [self.registerBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.registerBtn addTarget:self action:@selector(regitsterAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerBtn];
    
    UILabel *forgetLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 325, 100, 21)];
    forgetLabel.backgroundColor=[UIColor clearColor];
    forgetLabel.font=[UIFont fontWithName:@"Arial" size:15];
    forgetLabel.text=@"忘记密码,";
    [self.view addSubview:forgetLabel];
    self.forgetBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.forgetBtn.frame=CGRectMake(70, 324, 100, 25);
    [self.forgetBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [self.forgetBtn.titleLabel setFont:[UIFont fontWithName:@"Arial" size:15]];
    [self.forgetBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.forgetBtn addTarget:self action:@selector(forgetAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forgetBtn];
    UIImageView *loginLogo=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-186*2/3, self.view.frame.size.height-78, 186/2, 78/2)];
    [loginLogo setImage:[UIImage imageNamed:@"登陆页-标语"]];
    [self.view addSubview:loginLogo];
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"loginDic"]!=nil)
    {
        NSDictionary *loginDic=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginDic"]];
        self.userName.text=[NSString stringWithFormat:@"%@",[loginDic objectForKey:@"loginName"]];
        self.passWord.text=[NSString stringWithFormat:@"%@",[loginDic objectForKey:@"loginPWD"]];
        self.rememberBtn.selected=YES;
    }else
    {
        self.userName.text=[NSString stringWithFormat:@""];
        self.passWord.text=[NSString stringWithFormat:@""];
        self.rememberBtn.selected=NO;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.registerBtn addTarget:self action:@selector(regitsterAction) forControlEvents:UIControlEventTouchUpInside];
    [self.forgetBtn addTarget:self action:@selector(forgetAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)back:(id)sender
{
    //  [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    loginBrn.userInteractionEnabled=YES;
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField==passWord) {
        [self login:passWord];
    }
    return YES;
}
-(void)exitUserName:(UITextField*)userTextField
{
    [userTextField resignFirstResponder];
}

-(void)login:(id)sender
{
    NSLog(@"didEndEditing");


        NSLog(@"tmpDic非空");
        [SVProgressHUD showWithStatus:@"正在登陆..."];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
        NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary: [serverHelper getJsonDictionary:[NSString stringWithFormat:@"/user/login/?account=%@&password=%@",self.userName.text,self.passWord.text]]];
            loginBrn.userInteractionEnabled=NO;
            if (tmpDic!=nil) {
                NSDictionary *headDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"head"]];
                if ([[headDic objectForKey:@"msg"] isEqualToString:@"success"])
                {
                    NSDictionary *idDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
                    
                    NSDictionary *userInfo=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:[NSString stringWithFormat:@"/user/profile/?id=%@",[idDic objectForKey:@"userId"]]]];
                    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"userInfo"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"logined"];
                    if (self.rememberBtn.selected==YES) {
                        NSDictionary *loginDic=[NSDictionary dictionaryWithObjectsAndKeys:self.userName.text,@"loginName",self.passWord.text,@"loginPWD", nil];
                        [[NSUserDefaults standardUserDefaults] setObject:loginDic forKey:@"loginDic"];
                    }else
                    {
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginDic"];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"恭喜你" message:@"登陆成功" delegate:self cancelButtonTitle:@"马上购物" otherButtonTitles: nil];
                        alert.tag=1;
                        [alert show];
                    });
                }else
                {
                    NSString *errString=[NSString stringWithFormat:@"%@",[headDic objectForKey:@"msg"]];
                    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"logined"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:errString delegate:nil cancelButtonTitle:@"重新登录" otherButtonTitles: nil];
                        [alert show];
                        loginBrn.userInteractionEnabled=YES;
                    });
                    
                    
                }
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"服务器无法连接，请稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
                    [alert show];
                    loginBrn.userInteractionEnabled=YES;

                });

                
            }
        });
    
       }
-(void)remember:(id)sender
{
    UIButton *button=(UIButton*)sender;
    if (button.selected==YES) {
        button.selected=NO;
    }else
    {
        button.selected=YES;
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField           // became first responder
{
    if (textField==userName) {
        NSLog(@"userName");

        [userNameBG setImage:[UIImage imageNamed:@"登陆页-登陆框-动态"]];
    }
    if (textField==passWord) {
        NSLog(@"passWord");
        [passwordBG setImage:[UIImage imageNamed:@"登陆页-登陆框-动态"]];

    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==userName) {
        NSLog(@"userName-");

        [userNameBG setImage:[UIImage imageNamed:@"登陆页-登陆框-默认"]];
    }
    if (textField==passWord) {
        NSLog(@"passWord-");
        [passwordBG setImage:[UIImage imageNamed:@"登陆页-登陆框-默认"]];

    }
}

-(void)regitsterAction
{
    NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"http://rest.cosjii.com/user/register/"]];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    CosjiWebViewController *webViewController=[CosjiWebViewController shareCosjiWebViewController];
    [self.navigationController pushViewController:webViewController animated:YES ];
    [webViewController.webView loadRequest:request];
    [webViewController.storeName setText:[NSString stringWithFormat:@"注册"]];
}
-(void)forgetAction
{
    NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"http://www.cosjii.com/index.php?mod=user&act=getpassword"]];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    CosjiWebViewController *webViewController=[CosjiWebViewController shareCosjiWebViewController];
    
    [self.navigationController pushViewController:webViewController animated:YES ];
    [webViewController.webView loadRequest:request];
    [webViewController.storeName setText:[NSString stringWithFormat:@"忘记密码"]];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1) {
        [self back:nil];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setUserName:nil];
    [self setPassWord:nil];
    [self setRememberBtn:nil];
    [super viewDidUnload];
}
@end
