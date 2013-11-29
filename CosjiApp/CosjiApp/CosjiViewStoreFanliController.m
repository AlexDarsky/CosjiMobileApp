//
//  CosjiViewStoreFanliController.m
//  CosjiApp
//
//  Created by Darsky on 13-7-14.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiViewStoreFanliController.h"

@interface CosjiViewStoreFanliController ()

@end

@implementation CosjiViewStoreFanliController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    storeListArray=[[NSMutableArray alloc] initWithObjects:@"jingdongLogo.png",@"jumeiLogo.jpg",@"weipinhuiLogo.png",@"lefengLogo.png",@"nuomiLogo.jpg",@"mengbashaLogo.jpg",@"yamaxunLogo.jpg",@"yihaodianLogo.png", nil];

}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%f",ceil([storeListArray count]/3));
    return 3;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // static NSString *cellIdentifier = @"MyCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    // cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    int rowNumber=indexPath.row*3;
    if (rowNumber<[storeListArray count]-1) {
                NSLog(@"cellSet");
                UIButton *img1=[[UIButton alloc]initWithFrame:CGRectMake(10, 15, 87, 30)];
                [img1 addTarget:self action:@selector(Action) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:img1];
                [img1 setImage:[UIImage imageNamed:[storeListArray objectAtIndex:rowNumber]] forState:UIControlStateNormal];
    }
    if (rowNumber+1<[storeListArray count]-1) {
                NSLog(@"cellSet");
                UIButton *img2=[[UIButton alloc]initWithFrame:CGRectMake(116.5, 15, 87, 30)];
                [img2 addTarget:self action:@selector(Action) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:img2];
                [img2 setImage:[UIImage imageNamed:[storeListArray objectAtIndex:rowNumber+1]] forState:UIControlStateNormal];
                
    }
    if (rowNumber+2<[storeListArray count]-1)
    {
                NSLog(@"cellSet");
                UIButton *img3=[[UIButton alloc]initWithFrame:CGRectMake(223, 15, 87, 30)];
                [img3 addTarget:self action:@selector(Action) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:img3];
                [img3 setImage:[UIImage imageNamed:[storeListArray objectAtIndex:rowNumber+2]] forState:UIControlStateNormal];
    }
    return cell;
}
- (void)Action
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"消息" message:@"页面以后会跳转" delegate:nil cancelButtonTitle:@"坑爹" otherButtonTitles: nil];
    [alert show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
