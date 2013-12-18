//
//  CosjiSpecialActivityViewController.h
//  CosjiApp
//
//  Created by Darsky on 13-7-14.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CosjiSpecialActivityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *itemsArray;
    int currentPage;
    CGPoint prePoint;

}
@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic)  UIView *CustomNav;

@end
