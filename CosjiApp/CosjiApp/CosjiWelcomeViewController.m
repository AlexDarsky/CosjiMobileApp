//
//  CosjiWelcomeViewController.m
//  CosjiApp
//
//  Created by Darsky on 14-1-3.
//  Copyright (c) 2014年 Cosji. All rights reserved.
//

#import "CosjiWelcomeViewController.h"

@interface CosjiWelcomeViewController ()

@end

@implementation CosjiWelcomeViewController

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
    [super loadView];
    UIView *primaryView=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    primaryView.backgroundColor=[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:100];
    self.view=primaryView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    topListArray=[[NSMutableArray alloc] initWithObjects:@"引导页1",@"引导页2",@"引导页3",@"引导页4", nil];
    page=[[UIPageControl alloc] initWithFrame:CGRectMake(141,  [UIScreen mainScreen].bounds.size.height-50, 38,36)];
    //page.center=CGPointMake(160, 126);
    welceomSV=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    welceomSV.delegate=self;
    welceomSV.pagingEnabled = YES;

    welceomSV.showsHorizontalScrollIndicator=NO;
    welceomSV.backgroundColor=[UIColor clearColor];
    [self AdImg:topListArray];
    [self.view addSubview:page];

}
- (void) setCurrentPage:(NSInteger)secondPage {
    
    for (NSUInteger subviewIndex = 0; subviewIndex < [page.subviews count]; subviewIndex++) {
       // float version = [[[UIDevice currentDevice] systemVersion] floatValue];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        UIImageView* subview = [page.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 6;
        size.width = 6;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     size.width,size.height)];
        if (subviewIndex == secondPage)
            [subview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"引导页动态"]]];
        else [subview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"引导页默认"]]];
        
#else
        UIImageView* subview = [page.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 6;
        size.width = 6;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     size.width,size.height)];
        if (subviewIndex == secondPage)
            [subview setImage:[UIImage imageNamed:@"首页-焦点图-动态"]];
        else [subview setImage:[UIImage imageNamed:@"首页-焦点图-默认"]];
#endif
    }
}
-(void)AdImg:(NSMutableArray*)arr{
    [welceomSV setContentSize:CGSizeMake(320*[arr count], [UIScreen mainScreen].bounds.size.height)];
    page.numberOfPages=[arr count];
    
    for ( int i=0; i<[topListArray count]; i++) {
        
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(320*i, 0, 320, [UIScreen mainScreen].bounds.size.height)];
        [welceomSV addSubview:img];
        if ([UIScreen mainScreen].bounds.size.height>480)
        {
            [img setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_4",[topListArray objectAtIndex:i]]]];
        }else
            [img setImage:[UIImage imageNamed:[topListArray objectAtIndex:i]]];
        if (i==[topListArray count]-1)
        {
            UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            backBtn.frame=CGRectMake(160-300/4, [UIScreen mainScreen].bounds.size.height-110, 300/2, 70/2);
            [backBtn setBackgroundColor:[UIColor redColor]];
            [backBtn setTitle:@"立即体验" forState:UIControlStateNormal];
            [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchDown];
            [img addSubview:backBtn];
            img.userInteractionEnabled=YES;

        }
    }
    [self.view addSubview:welceomSV];
}
- (void)back:(id)sender
{
    //  [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunch"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    page.currentPage=scrollView.contentOffset.x/320;
    [self setCurrentPage:page.currentPage];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;   // called on finger up as we are moving
{
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [welceomSV scrollRectToVisible:CGRectMake(page.currentPage*320,0,320,[UIScreen mainScreen].bounds.size.height) animated:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
