//
//  CosjiViewController.h
//  CosjiApp
//
//  Created by AlexZhu on 13-7-11.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "StoreKit/SKProductsRequest.h"
#import "CosjiNewWebViewController.h"
#import "CosjiMallsListViewController.h"
#import "CosjiUrlFilter.h"

@interface CosjiViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UITextFieldDelegate>
{
    UIScrollView *sv;
    UIPageControl *page;
    NSMutableArray *topListArray;
    NSMutableArray *storeListArray;
    NSMutableArray *brandListArray;
    int selectedSection;
    int selectSection;
    int TimeNum;
    int selectedIndex;
    BOOL Tend;
}

@property (strong,nonatomic)  UITableView *mainTableView;
@property (strong, nonatomic)UIView *CustomHeadView;
@property (copy,nonatomic) NSMutableArray * userIds;
@property (strong,nonatomic) UINavigationController *storeBrowse;
@property (strong,nonatomic) CosjiWebViewController *webViewController;
@property (strong,nonatomic) UINavigationController *itemsListNavCon;
@property (strong,nonatomic) CosjiMallsListViewController *mallsListViewController;

- (IBAction)exitKeyboard:(id)sender;
-(void)detailRemoteNotification:(NSDictionary*)infoDic;
@end
