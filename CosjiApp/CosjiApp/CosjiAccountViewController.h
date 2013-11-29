//
//  CosjiAccountViewController.h
//  CosjiApp
//
//  Created by Darsky on 13-11-28.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
@interface CosjiAccountViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *itemsArray;
    int currentPage;
    int totalCount;
    int accountModel;
}
@property (strong,nonatomic)UISegmentedControl *segmentedControl;
@property (strong,nonatomic)UITableView *myTableView;
@property (strong, nonatomic)UIView *customNavBar;
@property (strong,nonatomic)UISegmentedControl *accountModelSC;
@end
