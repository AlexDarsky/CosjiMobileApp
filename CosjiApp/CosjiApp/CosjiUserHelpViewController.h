//
//  CosjiUserHelpViewController.h
//  CosjiApp
//
//  Created by Darsky on 13-10-15.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CosjiUserHelpViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *itemsArray;
    int currentID;
    int selectedSection;
}
+(CosjiUserHelpViewController *)shareCosjiUserHelpViewController;

@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic)  UIView *customNavBar;
@property (strong, nonatomic)  UILabel *titleLabel;
-(void)setUserHelpFor:(int)requestID;

@end
