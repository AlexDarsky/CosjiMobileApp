//
//  CosjiAccountSettingViewController.m
//  CosjiApp
//
//  Created by Darsky on 13-12-17.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiAccountSettingViewController.h"

@interface CosjiAccountSettingViewController ()
{
    //个人信息
    UIView *personView;

    UITextField *passwordField;

    UITextField *qqField;

    UITextField *emailField;

    UITextField *phoneField;
    //密码修改
    UIView *passwordView;

    UITextField *oldPWDField;

    UITextField *newPWDField;

    UITextField *confirmPWDFied;
    //财务管理
    UIView *zhifubaoView;

    UITextField *zhifubaoPWDField;

    UITextField *realNameField;

    UITextField *zhifubaoField;
    
    UIButton *submitBtn;
    
}

@end

@implementation CosjiAccountSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)loadView
{
    [super loadView];
    UIView *primaryView=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [primaryView setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:100]];
    self.view=primaryView;
    self.customNarBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    self.customNarBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
    self.settingTitle=[[UILabel alloc] initWithFrame:CGRectMake(90, 0, 140, 40)];
    self.settingTitle.backgroundColor=[UIColor clearColor];
    self.settingTitle.textColor=[UIColor whiteColor];
    self.settingTitle.textAlignment=NSTextAlignmentCenter;
    [self.customNarBar addSubview:self.settingTitle];
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(11, 12, 60/2, 41/2);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self  action:@selector(exitThisView:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNarBar addSubview:backBtn];
    [self.view addSubview:self.customNarBar];
    [self.view setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:100]];
    self.segmentCon=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"个人信息",@"密码修改",@"财务管理", nil]];
    self.segmentCon.frame=CGRectMake(-10, 45, 340, 29);
    self.segmentCon.multipleTouchEnabled=NO;
    [self.segmentCon addTarget:self action:@selector(layoutBySegmentControl:) forControlEvents:UIControlEventValueChanged];
    [self.segmentCon setSelectedSegmentIndex:0];
    settingMode=self.segmentCon.selectedSegmentIndex;
    [self.view addSubview:self.segmentCon];
    submitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame=CGRectMake(self.view.frame.size.width/2-582/4, self.view.frame.size.height-69, 582/2, 69/2);
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"按钮_登录"] forState:UIControlStateNormal];
    [submitBtn setTitle:@"保存信息" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:submitBtn];
    [self initSettingViews];
    [self layoutBySegmentControl:self.segmentCon];
}

-(void)initSettingViews
{
    //初始化个人信息
    personView=[[UIView alloc] initWithFrame:CGRectMake(0, self.segmentCon.frame.origin.y+self.segmentCon.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.customNarBar.frame.size.height-self.segmentCon.frame.size.height-submitBtn.frame.size.height)];
    
    passwordField=[[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3, 86/2, 400/2, 86/2)];
    passwordField.secureTextEntry=YES;
    [personView addSubview:passwordField];
    UIFont *font=[UIFont fontWithName:@"Arial" size:16];
    UILabel *passwordTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, 86/2, self.view.frame.size.width-passwordField.frame.size.width, 86/2)];
    passwordTitle.text=@"本站登录密码";
    passwordTitle.backgroundColor=[UIColor clearColor];
    [personView addSubview:passwordTitle];
    
    qqField=[[UITextField alloc] initWithFrame:CGRectMake(passwordField.frame.origin.x, passwordField.frame.origin.y+passwordField.frame.size.height+20, passwordField.frame.size.width, passwordField.frame.size.height)];
    [personView addSubview:qqField];
    UILabel *qqTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, qqField.frame.origin.y, passwordTitle.frame.size.width, passwordTitle.frame.size.height)];
    qqTitle.text=@"QQ号码";
    qqTitle.backgroundColor=[UIColor clearColor];
    [personView addSubview:qqTitle];
    
    emailField=[[UITextField alloc] initWithFrame:CGRectMake(passwordField.frame.origin.x, qqField.frame.origin.y+qqField.frame.size.height+20, passwordField.frame.size.width, passwordField.frame.size.height)];
    [personView addSubview:emailField];
    UILabel *emailTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, emailField.frame.origin.y, passwordTitle.frame.size.width, passwordTitle.frame.size.height)];
    emailTitle.text=@"电子邮箱";
    emailTitle.backgroundColor=[UIColor clearColor];
    [personView addSubview:emailTitle];
    
    phoneField=[[UITextField alloc] initWithFrame:CGRectMake(passwordField.frame.origin.x, emailField.frame.origin.y+emailField.frame.size.height+20, passwordField.frame.size.width, passwordField.frame.size.height)];
    [personView addSubview:phoneField];
    UILabel *phoneTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, phoneField.frame.origin.y, passwordTitle.frame.size.width, passwordTitle.frame.size.height)];
    phoneTitle.text=@"手机号码";
    phoneTitle.backgroundColor=[UIColor clearColor];
    [personView addSubview:phoneTitle];
    passwordField.background=qqField.background=emailField.background=phoneField.background=[UIImage imageNamed:@"登陆页-登陆框-默认"];
    [self.view addSubview:personView];
    
    //初始化密码修改
    passwordView=[[UIView alloc] initWithFrame:personView.frame];
    
    oldPWDField=[[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3, 86/2, 400/2, 86/2)];
    oldPWDField.secureTextEntry=YES;
    [passwordView addSubview:oldPWDField];
    UILabel *oldPWDTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, 86/2, self.view.frame.size.width-oldPWDField.frame.size.width, 86/2)];
    oldPWDTitle.text=@"旧密码";
    oldPWDTitle.backgroundColor=[UIColor clearColor];
    [passwordView addSubview:oldPWDTitle];
    
    newPWDField=[[UITextField alloc] initWithFrame:CGRectMake(oldPWDField.frame.origin.x, oldPWDField.frame.origin.y+oldPWDField.frame.size.height+20, oldPWDField.frame.size.width, oldPWDField.frame.size.height)];
    [passwordView addSubview:newPWDField];
    UILabel *newPWDTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, newPWDField.frame.origin.y, oldPWDTitle.frame.size.width, oldPWDTitle.frame.size.height)];
    newPWDTitle.text=@"新密码";
    newPWDTitle.backgroundColor=[UIColor clearColor];
    [passwordView addSubview:newPWDTitle];
    
    confirmPWDFied=[[UITextField alloc] initWithFrame:CGRectMake(oldPWDField.frame.origin.x, newPWDField.frame.origin.y+newPWDField.frame.size.height+20, oldPWDField.frame.size.width, oldPWDField.frame.size.height)];
    [passwordView addSubview:confirmPWDFied];
    UILabel *confirmPWDTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, emailField.frame.origin.y, oldPWDTitle.frame.size.width, oldPWDTitle.frame.size.height)];
    confirmPWDTitle.text=@"确认密码";
    confirmPWDTitle.backgroundColor=[UIColor clearColor];
    [passwordView addSubview:confirmPWDTitle];
    oldPWDField.background=newPWDField.background=confirmPWDFied.background=[UIImage imageNamed:@"登陆页-登陆框-默认"];
    [self.view addSubview:passwordView];

    //初始化财务管理
    zhifubaoView=[[UIView alloc] initWithFrame:personView.frame];
    
    zhifubaoPWDField=[[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3, 86/2, 400/2, 86/2)];
    zhifubaoPWDField.secureTextEntry=YES;
    [zhifubaoView addSubview:zhifubaoPWDField];
    UILabel *zhifubaoPWDTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, 86/2, self.view.frame.size.width-zhifubaoPWDField.frame.size.width, 86/2)];
    zhifubaoPWDTitle.text=@"登录密码";
    zhifubaoPWDTitle.backgroundColor=[UIColor clearColor];
    [zhifubaoView addSubview:zhifubaoPWDTitle];
    
    realNameField=[[UITextField alloc] initWithFrame:CGRectMake(zhifubaoPWDField.frame.origin.x, zhifubaoPWDField.frame.origin.y+zhifubaoPWDField.frame.size.height+20, zhifubaoPWDField.frame.size.width, zhifubaoPWDField.frame.size.height)];
    [zhifubaoView addSubview:realNameField];
    UILabel *realNameTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, realNameField.frame.origin.y, oldPWDTitle.frame.size.width, oldPWDTitle.frame.size.height)];
    realNameTitle.text=@"真实姓名";
    realNameTitle.backgroundColor=[UIColor clearColor];
    [zhifubaoView addSubview:realNameTitle];
    
    zhifubaoField=[[UITextField alloc] initWithFrame:CGRectMake(zhifubaoPWDField.frame.origin.x, realNameField.frame.origin.y+realNameField.frame.size.height+20, zhifubaoPWDField.frame.size.width, zhifubaoPWDField.frame.size.height)];
    [zhifubaoView addSubview:zhifubaoField];
    UILabel *zhifubaoTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, zhifubaoField.frame.origin.y, oldPWDTitle.frame.size.width, oldPWDTitle.frame.size.height)];
    zhifubaoTitle.text=@"支付宝账号";
    zhifubaoTitle.backgroundColor=[UIColor clearColor];
    [zhifubaoView addSubview:zhifubaoTitle];
    zhifubaoPWDField.background=realNameField.background=zhifubaoField.background=[UIImage imageNamed:@"登陆页-登陆框-默认"];
    [self.view addSubview:zhifubaoView];
    personView.backgroundColor=passwordView.backgroundColor=zhifubaoView.backgroundColor=[UIColor clearColor];
}
-(void)layoutBySegmentControl:(UISegmentedControl *)Seg
{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    settingMode=Index;
    switch (settingMode) {
        case 0:
        {
            personView.hidden=NO;
            passwordView.hidden=zhifubaoView.hidden=YES;

        }
            break;
        case 1:
        {
            passwordView.hidden=NO;
            personView.hidden=zhifubaoView.hidden=YES;

        }
            break;
        case 2:
        {
            zhifubaoView.hidden=NO;
            personView.hidden=passwordView.hidden=YES;

        }
            break;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)exitThisView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
