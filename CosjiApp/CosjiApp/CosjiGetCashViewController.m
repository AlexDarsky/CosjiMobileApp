//
//  CosjiGetCashViewController.m
//  CosjiApp
//
//  Created by Darsky on 13-12-10.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiGetCashViewController.h"

@interface CosjiGetCashViewController ()
{
    UILabel *avilibaleCashLabel;
    UITextField *requestCashField;
    UITextField *zhifubaoIDField;
    UITextField *payeeNameField;
    UITextField *phoneNumberField;
    UITextField *passwordField;
    
}

@end

@implementation CosjiGetCashViewController


- (void)loadView
{
    [super loadView];
    UIView *primaryView=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [primaryView setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:100]];
    self.view=primaryView;
    self.customNavBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    self.customNavBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(90, 0, 140, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.text=@"提现申请";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [self.customNavBar addSubview:titleLabel];
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(11, 12, 60/2, 41/2);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self  action:@selector(dismisThisViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavBar addSubview:backBtn];
    [self.view addSubview:self.customNavBar];
    //可提现金额
    UILabel *avilibaleCashTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 170/2, 232/2, 82/2)];
    avilibaleCashTitle.text=@"可提现金额：";
    avilibaleCashTitle.textAlignment=NSTextAlignmentRight;
    avilibaleCashTitle.backgroundColor=[UIColor clearColor];
    [self.view addSubview:avilibaleCashTitle];
    avilibaleCashLabel=[[UILabel alloc] initWithFrame:CGRectMake(avilibaleCashTitle.frame.size.width, avilibaleCashTitle.frame.origin.y, avilibaleCashTitle.frame.size.width, avilibaleCashTitle.frame.size.height)];
    avilibaleCashLabel.backgroundColor=[UIColor clearColor];
    avilibaleCashLabel.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:avilibaleCashLabel];
    avilibaleCashLabel.font=avilibaleCashTitle.font=[UIFont fontWithName:@"Arial" size:14];
    //申请提现金额
    UILabel *requestCashTitle=[[UILabel alloc] initWithFrame:CGRectMake(0,avilibaleCashTitle.frame.origin.y+avilibaleCashTitle.frame.size.height+13, avilibaleCashTitle.frame.size.width, avilibaleCashTitle.frame.size.height)];
    requestCashTitle.backgroundColor=[UIColor clearColor];
    requestCashTitle.textAlignment=NSTextAlignmentRight;
    requestCashTitle.font=[UIFont fontWithName:@"Arial" size:14];
    requestCashTitle.text=@"申请提现金额：";
    [self.view addSubview:requestCashTitle];
    requestCashField=[[UITextField alloc] initWithFrame:CGRectMake(requestCashTitle.frame.size.width, requestCashTitle.frame.origin.y, 386/2, 86/2)];
    requestCashField.backgroundColor=[UIColor clearColor];
    requestCashField.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    requestCashField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [requestCashField setBackground:[UIImage imageNamed:@"登陆页-登陆框-动态"]];
    [requestCashField setDisabledBackground:[UIImage imageNamed:@"登陆页-登陆框-默认"]];
    [self.view addSubview:requestCashField];
    requestCashField.font=requestCashTitle.font=[UIFont fontWithName:@"Arial" size:14];
    //支付宝账号
    UILabel *zhifubaoIDtitle=[[UILabel alloc] initWithFrame:CGRectMake(0,requestCashTitle.frame.origin.y+requestCashTitle.frame.size.height+13, requestCashTitle.frame.size.width, requestCashTitle.frame.size.height)];
    zhifubaoIDtitle.backgroundColor=[UIColor clearColor];
    zhifubaoIDtitle.textAlignment=NSTextAlignmentRight;
    zhifubaoIDtitle.font=[UIFont fontWithName:@"Arial" size:14];
    zhifubaoIDtitle.text=@"支付宝账号：";
    [self.view addSubview:zhifubaoIDtitle];
    zhifubaoIDField=[[UITextField alloc] initWithFrame:CGRectMake(zhifubaoIDtitle.frame.size.width, zhifubaoIDtitle.frame.origin.y, 386/2, 86/2)];
    zhifubaoIDField.backgroundColor=[UIColor clearColor];
    zhifubaoIDField.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    zhifubaoIDField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [zhifubaoIDField setBackground:[UIImage imageNamed:@"登陆页-登陆框-动态"]];
    [zhifubaoIDField setDisabledBackground:[UIImage imageNamed:@"登陆页-登陆框-默认"]];
    [self.view addSubview:zhifubaoIDField];
    zhifubaoIDField.font=zhifubaoIDtitle.font=[UIFont fontWithName:@"Arial" size:14];
    //收款人姓名
    UILabel *payeeNameTitle=[[UILabel alloc] initWithFrame:CGRectMake(0,zhifubaoIDtitle.frame.origin.y+zhifubaoIDtitle.frame.size.height+13, zhifubaoIDtitle.frame.size.width, zhifubaoIDtitle.frame.size.height)];
    payeeNameTitle.backgroundColor=[UIColor clearColor];
    payeeNameTitle.textAlignment=NSTextAlignmentRight;
    payeeNameTitle.font=[UIFont fontWithName:@"Arial" size:14];
    payeeNameTitle.text=@"收款人姓名：";
    [self.view addSubview:payeeNameTitle];
    payeeNameField=[[UITextField alloc] initWithFrame:CGRectMake(payeeNameTitle.frame.size.width, payeeNameTitle.frame.origin.y, 386/2, 86/2)];
    payeeNameField.backgroundColor=[UIColor clearColor];
    payeeNameField.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    payeeNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [payeeNameField setBackground:[UIImage imageNamed:@"登陆页-登陆框-动态"]];
    [payeeNameField setDisabledBackground:[UIImage imageNamed:@"登陆页-登陆框-默认"]];
    [self.view addSubview:payeeNameField];
    payeeNameField.font=payeeNameTitle.font=[UIFont fontWithName:@"Arial" size:14];
    //手机号码
    UILabel *phoneNumberTitle=[[UILabel alloc] initWithFrame:CGRectMake(0,payeeNameTitle.frame.origin.y+payeeNameTitle.frame.size.height+13, payeeNameTitle.frame.size.width, payeeNameTitle.frame.size.height)];
    phoneNumberTitle.backgroundColor=[UIColor clearColor];
    phoneNumberTitle.textAlignment=NSTextAlignmentRight;
    phoneNumberTitle.font=[UIFont fontWithName:@"Arial" size:14];
    phoneNumberTitle.text=@"手机号码：";
    [self.view addSubview:phoneNumberTitle];
    phoneNumberField=[[UITextField alloc] initWithFrame:CGRectMake(phoneNumberTitle.frame.size.width, phoneNumberTitle.frame.origin.y, 386/2, 86/2)];
    phoneNumberField.backgroundColor=[UIColor clearColor];
    phoneNumberField.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    phoneNumberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [phoneNumberField setBackground:[UIImage imageNamed:@"登陆页-登陆框-动态"]];
    [phoneNumberField setDisabledBackground:[UIImage imageNamed:@"登陆页-登陆框-默认"]];
    [self.view addSubview:phoneNumberField];
    phoneNumberField.font=phoneNumberTitle.font=[UIFont fontWithName:@"Arial" size:14];
    //本站登录密码
    UILabel *passwordTitle=[[UILabel alloc] initWithFrame:CGRectMake(0,phoneNumberTitle.frame.origin.y+phoneNumberTitle.frame.size.height+13, phoneNumberTitle.frame.size.width, phoneNumberTitle.frame.size.height)];
    passwordTitle.backgroundColor=[UIColor clearColor];
    passwordTitle.textAlignment=NSTextAlignmentRight;
    passwordTitle.font=[UIFont fontWithName:@"Arial" size:14];
    passwordTitle.text=@"本站登录密码：";
    [self.view addSubview:passwordTitle];
    passwordField=[[UITextField alloc] initWithFrame:CGRectMake(passwordTitle.frame.size.width, passwordTitle.frame.origin.y, 386/2, 86/2)];
    passwordField.backgroundColor=[UIColor clearColor];
    passwordField.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [passwordField setBackground:[UIImage imageNamed:@"登陆页-登陆框-动态"]];
    [passwordField setDisabledBackground:[UIImage imageNamed:@"登陆页-登陆框-默认"]];
    passwordField.secureTextEntry=YES;
    [self.view addSubview:passwordField];
    passwordField.font=passwordTitle.font=[UIFont fontWithName:@"Arial" size:14];
    
    UIButton *getCashBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    getCashBtn.frame=CGRectMake(160-582/4, [UIScreen mainScreen].bounds.size.height-161/2-69/2, 582/2, 69/2);
    [getCashBtn setBackgroundImage:[UIImage imageNamed:@"按钮_登录"] forState:UIControlStateNormal];
    [getCashBtn setTitle:@"马上提现" forState:UIControlStateNormal];
    [getCashBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:getCashBtn];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
    NSDictionary *infoDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
    avilibaleCashLabel.text=[NSString stringWithFormat:@"%@元",[infoDic objectForKey:@"balance"]];
}
- (void)dismisThisViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
