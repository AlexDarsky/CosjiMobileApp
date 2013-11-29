//
//  CosjiFanLiListViewController.h
//  CosjiApp
//
//  Created by Darsky on 13-10-28.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CosjiFanLiListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *itemsArray;
    int currentPage;
}
@property (strong, nonatomic)  UITableView *listTableView;
@property (strong, nonatomic)  UIView *customNarBar;
@property (strong, nonatomic)  UILabel *fanliTitle;
@property (strong, nonatomic)  UISegmentedControl *segmentCon;
@property (nonatomic,strong) NSString *userID;

@end
