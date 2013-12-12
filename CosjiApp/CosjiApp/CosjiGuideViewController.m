//
//  CosjiGuideViewController.m
//  CosjiApp
//
//  Created by Darsky on 13-12-6.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiGuideViewController.h"
#import "IntroControll.h"

@interface CosjiGuideViewController ()
{
    IntroControll *introControll;
}

@end

@implementation CosjiGuideViewController
static CosjiGuideViewController *shareCosjiGuideViewController = nil;

+(CosjiGuideViewController*)shareCosjiGuideViewController
{
    
    if (shareCosjiGuideViewController == nil) {
        shareCosjiGuideViewController = [[super allocWithZone:NULL] init];
    }
    return shareCosjiGuideViewController;
}
-(void)loadView
{
    [super loadView];
    UIView *primaryView=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view=primaryView;
    

}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    IntroModel *model1 = [[IntroModel alloc] initWithTitle:nil description:nil image:@"tab1.jpg"];
    
    IntroModel *model2 = [[IntroModel alloc] initWithTitle:nil description:nil image:@"tab2"];
    
    IntroModel *model3 = [[IntroModel alloc] initWithTitle:nil description:nil image:@"tab3.jpg"];
    IntroModel *model4 = [[IntroModel alloc] initWithTitle:nil description:nil image:@"tab4.jpg"];
    introControll=[[IntroControll alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) pages:@[model1, model2, model3,model4]];
    [self.view addSubview:introControll];
    UIButton *exitBtn=[[UIButton alloc] initWithFrame:CGRectMake(160-640/3/2, [UIScreen mainScreen].bounds.size.height-100, 640/3, 98/3)];
    [exitBtn setBackgroundImage:[UIImage imageNamed:@"工具栏背景"] forState:UIControlStateNormal];
    [exitBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [introControll addSubview:exitBtn];
    /*
    self.guideScrollView=[[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSArray *guideImageArray=[NSArray arrayWithObjects:@"tab1.jpg",@"tab2",@"tab3.jpg",@"tab4.jpg", nil];
    for (int x=0; x<[guideImageArray count]; x++)
    {
        UIImageView *guideImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[guideImageArray objectAtIndex:x]]]];
        guideImageView.frame=CGRectMake([UIScreen mainScreen].bounds.size.width*x,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [self.guideScrollView addSubview:guideImageView];
        if (x==[guideImageArray count]-1)
        {
            UIButton *exitBtn=[[UIButton alloc] initWithFrame:CGRectMake(160-640/3/2, [UIScreen mainScreen].bounds.size.height-100, 640/3, 98/3)];
            [exitBtn setBackgroundImage:[UIImage imageNamed:@"工具栏背景"] forState:UIControlStateNormal];
            [exitBtn setTitle:@"我知道了" forState:UIControlStateNormal];
            [exitBtn addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
            [guideImageView addSubview:exitBtn];
            guideImageView.userInteractionEnabled=YES;
        }
    }
    [self.guideScrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width*[guideImageArray count], [UIScreen mainScreen].bounds.size.height)];
    self.guideScrollView.delegate=self;
    [self.view addSubview:self.guideScrollView];
     */
}
-(void)exit
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
