//
//  CosjiAccountSettingViewController.m
//  CosjiApp
//
//  Created by Darsky on 13-12-17.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiAccountSettingViewController.h"
#import "CosjiAccountSettingField.h"

@interface CosjiAccountSettingViewController ()
{
    //个人信息
    UIView *personView;

    CosjiAccountSettingField *passwordField;

    CosjiAccountSettingField *qqField;

    //UITextField *emailField;
    CosjiAccountSettingField *emailField;


    CosjiAccountSettingField *phoneField;
    //密码修改
    UIView *passwordView;

    CosjiAccountSettingField *oldPWDField;

    CosjiAccountSettingField *newPWDField;

    CosjiAccountSettingField *confirmPWDFied;
    //财务管理
    UIView *zhifubaoView;

    CosjiAccountSettingField *zhifubaoPWDField;

    CosjiAccountSettingField *realNameField;

    CosjiAccountSettingField *zhifubaoField;
    
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
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.segmentCon=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"个人信息",@"密码修改",@"财务管理", nil]];
    if ([[[UIDevice currentDevice] systemVersion]floatValue]<7.0)
    {
        self.customNarBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
        self.customNarBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"工具栏背景"]];
        self.settingTitle=[[UILabel alloc] initWithFrame:CGRectMake(90, 2.5, 140, 40)];
        backBtn.frame=CGRectMake(11, 2.5, 100/2, 80/2);
        self.segmentCon.frame=CGRectMake(-10, 45, 340, 29);
    }else
    {
        self.customNarBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
        self.customNarBar.backgroundColor=[UIColor colorWithRed:225.0/255.0 green:47.0/255.0 blue:50.0/255.0 alpha:100];
        self.settingTitle=[[UILabel alloc] initWithFrame:CGRectMake(90, 22.5, 140, 40)];
        backBtn.frame=CGRectMake(11, 22.5, 100/2, 80/2);
        self.segmentCon.frame=CGRectMake(-10, 65, 340, 29);

    }

    self.settingTitle.backgroundColor=[UIColor clearColor];
    self.settingTitle.textColor=[UIColor whiteColor];
    self.settingTitle.text=@"账户设置";
    self.settingTitle.font=[UIFont fontWithName:@"Arial" size:18];
    self.settingTitle.textAlignment=NSTextAlignmentCenter;
    [self.customNarBar addSubview:self.settingTitle];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self  action:@selector(exitThisView:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNarBar addSubview:backBtn];
    [self.view addSubview:self.customNarBar];
    [self.view setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:100]];

    self.segmentCon.multipleTouchEnabled=NO;
    [self.segmentCon addTarget:self action:@selector(layoutBySegmentControl:) forControlEvents:UIControlEventValueChanged];
    [self.segmentCon setSelectedSegmentIndex:0];
    settingMode=self.segmentCon.selectedSegmentIndex;
    [self.view addSubview:self.segmentCon];
    submitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame=CGRectMake(self.view.frame.size.width/2-604/4, self.view.frame.size.height-95, 604/2, 92/2);
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"账户设置保存"] forState:UIControlStateNormal];
    [submitBtn setTitle:@"保存信息" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(modifiedAction) forControlEvents:UIControlEventTouchDown];
    [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:submitBtn];
    [self initSettingViews];
    [self layoutBySegmentControl:self.segmentCon];
}

-(void)initSettingViews
{
    //初始化个人信息
    personView=[[UIView alloc] initWithFrame:CGRectMake(0, self.segmentCon.frame.origin.y+self.segmentCon.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.customNarBar.frame.size.height-self.segmentCon.frame.size.height-submitBtn.frame.size.height-40)];
    passwordField=[[CosjiAccountSettingField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3, 86/2-20, 400/2, 86/2)];
    passwordField.secureTextEntry=YES;
    passwordField.delegate=self;
    passwordField.textAlignment=NSTextAlignmentLeft;
    passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [personView addSubview:passwordField];
    UIFont *font=[UIFont fontWithName:@"Arial" size:16];
    UILabel *passwordTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, 86/2-20, self.view.frame.size.width-passwordField.frame.size.width, 86/2)];
    passwordTitle.text=@"本站登录密码";
    passwordTitle.font=font;
    passwordTitle.backgroundColor=[UIColor clearColor];
    [personView addSubview:passwordTitle];
    
    qqField=[[CosjiAccountSettingField alloc] initWithFrame:CGRectMake(passwordField.frame.origin.x, passwordField.frame.origin.y+passwordField.frame.size.height+20, passwordField.frame.size.width, passwordField.frame.size.height)];
    qqField.delegate=self;
    qqField.textAlignment=NSTextAlignmentLeft;
    qqField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

    [personView addSubview:qqField];
    UILabel *qqTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, qqField.frame.origin.y, passwordTitle.frame.size.width, passwordTitle.frame.size.height)];
    qqTitle.text=@"QQ号码";
    qqTitle.backgroundColor=[UIColor clearColor];
    [personView addSubview:qqTitle];
    
    emailField=[[CosjiAccountSettingField alloc] initWithFrame:CGRectMake(passwordField.frame.origin.x, qqField.frame.origin.y+qqField.frame.size.height+20, passwordField.frame.size.width, passwordField.frame.size.height)];
    emailField.delegate=self;
    emailField.textAlignment=NSTextAlignmentLeft;
    emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [personView addSubview:emailField];
    UILabel *emailTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, emailField.frame.origin.y, passwordTitle.frame.size.width, passwordTitle.frame.size.height)];
    emailTitle.text=@"电子邮箱";
    emailTitle.backgroundColor=[UIColor clearColor];
    [personView addSubview:emailTitle];
    
    phoneField=[[CosjiAccountSettingField alloc] initWithFrame:CGRectMake(passwordField.frame.origin.x, emailField.frame.origin.y+emailField.frame.size.height+20, passwordField.frame.size.width, passwordField.frame.size.height)];
    phoneField.delegate=self;
    phoneField.textAlignment=NSTextAlignmentLeft;
    phoneField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [personView addSubview:phoneField];
    UILabel *phoneTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, phoneField.frame.origin.y, passwordTitle.frame.size.width, passwordTitle.frame.size.height)];
    phoneTitle.text=@"手机号码";
    phoneTitle.backgroundColor=[UIColor clearColor];
    [personView addSubview:phoneTitle];
    passwordField.background=qqField.background=emailField.background=phoneField.background=[UIImage imageNamed:@"登陆页-登陆框-默认"];
    
    passwordField.delegate=self;
    [self.view addSubview:personView];
    
    //初始化密码修改
    passwordView=[[UIView alloc] initWithFrame:personView.frame];
    
    oldPWDField=[[CosjiAccountSettingField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3, 86/2-20, 400/2, 86/2)];
    oldPWDField.secureTextEntry=YES;
    oldPWDField.delegate=self;
    oldPWDField.textAlignment=NSTextAlignmentLeft;
    oldPWDField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [passwordView addSubview:oldPWDField];
    UILabel *oldPWDTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, 86/2-20, self.view.frame.size.width-oldPWDField.frame.size.width, 86/2)];
    oldPWDTitle.text=@"旧密码";
    oldPWDTitle.backgroundColor=[UIColor clearColor];
    [passwordView addSubview:oldPWDTitle];
    
    newPWDField=[[CosjiAccountSettingField alloc] initWithFrame:CGRectMake(oldPWDField.frame.origin.x, oldPWDField.frame.origin.y+oldPWDField.frame.size.height+20, oldPWDField.frame.size.width, oldPWDField.frame.size.height)];
    newPWDField.delegate=self;
    newPWDField.textAlignment=NSTextAlignmentLeft;
    newPWDField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [passwordView addSubview:newPWDField];
    UILabel *newPWDTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, newPWDField.frame.origin.y, oldPWDTitle.frame.size.width, oldPWDTitle.frame.size.height)];
    newPWDTitle.text=@"新密码";
    newPWDTitle.backgroundColor=[UIColor clearColor];
    [passwordView addSubview:newPWDTitle];
    
    confirmPWDFied=[[CosjiAccountSettingField alloc] initWithFrame:CGRectMake(oldPWDField.frame.origin.x, newPWDField.frame.origin.y+newPWDField.frame.size.height+20, oldPWDField.frame.size.width, oldPWDField.frame.size.height)];
    confirmPWDFied.delegate=self;
    confirmPWDFied.textAlignment=NSTextAlignmentLeft;
    confirmPWDFied.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [passwordView addSubview:confirmPWDFied];
    UILabel *confirmPWDTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, emailField.frame.origin.y, oldPWDTitle.frame.size.width, oldPWDTitle.frame.size.height)];
    confirmPWDTitle.text=@"确认密码";
    confirmPWDTitle.backgroundColor=[UIColor clearColor];
    [passwordView addSubview:confirmPWDTitle];
    oldPWDField.background=newPWDField.background=confirmPWDFied.background=[UIImage imageNamed:@"登陆页-登陆框-默认"];
    oldPWDField.delegate=self;
    [self.view addSubview:passwordView];

    //初始化财务管理
    zhifubaoView=[[UIView alloc] initWithFrame:personView.frame];
    
    zhifubaoPWDField=[[CosjiAccountSettingField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3, 86/2-20, 400/2, 86/2)];
    zhifubaoPWDField.secureTextEntry=YES;
    zhifubaoPWDField.delegate=self;
    zhifubaoPWDField.textAlignment=NSTextAlignmentLeft;
    zhifubaoPWDField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [zhifubaoView addSubview:zhifubaoPWDField];
    UILabel *zhifubaoPWDTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, 86/2-20, self.view.frame.size.width-zhifubaoPWDField.frame.size.width, 86/2)];
    zhifubaoPWDTitle.text=@"登录密码";
    zhifubaoPWDTitle.backgroundColor=[UIColor clearColor];
    [zhifubaoView addSubview:zhifubaoPWDTitle];
    
    realNameField=[[CosjiAccountSettingField alloc] initWithFrame:CGRectMake(zhifubaoPWDField.frame.origin.x, zhifubaoPWDField.frame.origin.y+zhifubaoPWDField.frame.size.height+20, zhifubaoPWDField.frame.size.width, zhifubaoPWDField.frame.size.height)];
    realNameField.delegate=self;
    realNameField.textAlignment=NSTextAlignmentLeft;
    realNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [zhifubaoView addSubview:realNameField];
    UILabel *realNameTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, realNameField.frame.origin.y, oldPWDTitle.frame.size.width, oldPWDTitle.frame.size.height)];
    realNameTitle.text=@"真实姓名";
    realNameTitle.backgroundColor=[UIColor clearColor];
    [zhifubaoView addSubview:realNameTitle];
    
    zhifubaoField=[[CosjiAccountSettingField alloc] initWithFrame:CGRectMake(zhifubaoPWDField.frame.origin.x, realNameField.frame.origin.y+realNameField.frame.size.height+20, zhifubaoPWDField.frame.size.width, zhifubaoPWDField.frame.size.height)];
    zhifubaoField.delegate=self;
    zhifubaoField.textAlignment=NSTextAlignmentLeft;
    zhifubaoField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
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
    CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
    NSInteger Index = Seg.selectedSegmentIndex;
    settingMode=Index;
    switch (settingMode) {
        case 0:
        {
            personView.hidden=NO;
            passwordView.hidden=zhifubaoView.hidden=YES;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSDictionary *tmpDic=[serverHelper getJsonDictionary:@"/user/getContact/"];
                NSDictionary *bodyDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (bodyDic!=nil)
                    {
                        [qqField setText:[NSString stringWithFormat:@"%@",[bodyDic objectForKey:@"qq"]]];
                        [emailField setText:[NSString stringWithFormat:@"%@",[bodyDic objectForKey:@"email"]]];
                        [phoneField setText:[NSString stringWithFormat:@"%@",[bodyDic objectForKey:@"mobile"]]];
                    }else
                    {
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"服务器无法连接，请稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
                        [alert show];
                    }

                });
                
            });
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
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSDictionary *tmpDic=[serverHelper getJsonDictionary:@"/account/getAlipay/"];
                NSDictionary *bodyDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (bodyDic!=nil)
                    {
                        [realNameField setText:[NSString stringWithFormat:@"%@",[bodyDic objectForKey:@"realname"]]];
                        [zhifubaoField setText:[NSString stringWithFormat:@"%@",[bodyDic objectForKey:@"alipay"]]];
                    }else
                    {
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"服务器无法连接，请稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
                        [alert show];
                    }
                });
                
            });


        }
            break;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)modifiedAction
{
    CosjiServerHelper *serverHelper=[CosjiServerHelper shareCosjiServerHelper];
    
    switch (settingMode) {
        case 0:
        {
            if (passwordField.text!=nil&&![passwordField.text isEqualToString:@""])
            {
                NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:[NSString stringWithFormat:@"/user/changeContact/?qq=%@&&mobile=%@&&email=%@",qqField.text,phoneField.text,emailField.text]]];
                NSDictionary *headDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"head"]];
                if ([[headDic objectForKey:@"msg"]isEqualToString:@"success"])
                {
                    [SVProgressHUD showSuccessWithStatus:@"修改成功" duration:1.0];
                }else
                {
                    [SVProgressHUD dismissWithError:@"修改失败" afterDelay:1.0];
                    
                }

            }else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入本站登录密码" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
                [alert show];
            }
            
        }
            break;
        
        case 1:
        {
            if (oldPWDField.text!=nil&&![oldPWDField.text isEqualToString:@""]) {
                if ([newPWDField.text isEqualToString:confirmPWDFied.text])
                {
                    NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:[NSString stringWithFormat:@"/user/changePwd/?password=%@&&newPwd=%@",oldPWDField.text,newPWDField.text]]];
                    NSDictionary *headDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"head"]];
                    if ([[headDic objectForKey:@"msg"]isEqualToString:@"success"])
                    {
                        [SVProgressHUD showSuccessWithStatus:@"修改成功" duration:1.0];
                    }else
                    {
                        [SVProgressHUD dismissWithError:@"修改失败" afterDelay:1.0];
                    }
                }else
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"密码不一致" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
                    [alert show];
                }
            }else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入旧密码" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
                [alert show];
            }
        }
            break;
        case 2:
        {
            NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[serverHelper getJsonDictionary:[NSString stringWithFormat:@"/account/changeAlipay/?password=%@&&realname=%@&&alipay=%@",zhifubaoPWDField.text,realNameField.text,zhifubaoField.text]]];
            NSDictionary *headDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"head"]];
            if ([[headDic objectForKey:@"msg"]isEqualToString:@"success"])
            {
                [SVProgressHUD showSuccessWithStatus:@"修改成功" duration:1.0];
            }else
            {
                [SVProgressHUD dismissWithError:@"修改失败" afterDelay:1.0];
                
            }
        }
            break;
    }

}
- (void)textFieldDidBeginEditing:(UITextField *)textField           // became first responder
{
    [textField setBackground:[UIImage imageNamed:@"登陆页-登陆框-动态"]];
    [textField.window makeKeyAndVisible];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField setBackground:[UIImage imageNamed:@"登陆页-登陆框-默认"]];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField             // called when 'return' key pressed. return NO to ignore.
{
    [textField setBackground:[UIImage imageNamed:@"登陆页-登陆框-默认"]];
    [textField resignFirstResponder];
    return YES;
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
