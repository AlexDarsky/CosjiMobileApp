//
//  CosjiMessageViewController.h
//  CosjiApp
//
//  Created by Darsky on 13-12-12.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CosjiMessagCell.h"

@interface CosjiMessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *itemsArray;
    NSMutableArray *selectedArray;
    int currentPage;
    int messageMode;
}
@property (strong, nonatomic)  UITableView *listTableView;
@property (strong, nonatomic)  UIView *customNarBar;
@property (strong, nonatomic) UIView *buttomToolBar;
@property (strong, nonatomic)  UISegmentedControl *segmentCon;
@property (nonatomic,strong) NSString *userID;

-(void)loadFanLiListByOrder:(int)order;
@end
