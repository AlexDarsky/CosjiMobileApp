//
//  CosjiSpecialActivityViewController.h
//  CosjiApp
//
//  Created by Darsky on 13-7-14.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CosjiWebViewController.h"

@interface CosjiSpecialActivityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *itemsArray;
    int currentPage;
    CGPoint prePoint;
    BOOL isSaveMode;

}
@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic)  UIView *CustomNav;
@property (strong, nonatomic) UINavigationController *itemBrose;
@property (strong,nonatomic) CosjiWebViewController *webViewController;

@end
