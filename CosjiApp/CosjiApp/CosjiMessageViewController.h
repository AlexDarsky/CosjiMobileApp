//
//  CosjiMessageViewController.h
//  CosjiApp
//
//  Created by Darsky on 13-12-12.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CosjiMessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *itemsArray;
    int currentPage;
    int messageMode;
}
@property (strong, nonatomic)  UITableView *listTableView;
@property (strong, nonatomic)  UIView *customNarBar;
@property (strong, nonatomic)  UISegmentedControl *segmentCon;
@property (nonatomic,strong) NSString *userID;
@end
