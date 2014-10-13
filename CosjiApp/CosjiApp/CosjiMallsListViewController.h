//
//  CosjiMallsListViewController.h
//  CosjiApp
//
//  Created by Darsky on 13-12-17.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CosjiWebViewController.h"
@interface CosjiMallsListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *storeListArray;
    int currentPage;
    int selectedIndex;
    CGPoint prePoint;
}
@property (strong,nonatomic)  UITableView *mainTableView;
@property (strong, nonatomic)UIView *CustomHeadView;
@property (strong,nonatomic) UINavigationController *storeBrowse;
@property (strong,nonatomic) CosjiWebViewController *webViewController;
@end
