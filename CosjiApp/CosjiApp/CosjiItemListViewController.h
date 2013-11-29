//
//  CosjiItemListViewController.h
//  CosjiApp
//
//  Created by Darsky on 13-10-6.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CosjiItemListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *itemsArray;
    int currentPage;
}
@property (weak, nonatomic) IBOutlet UIView *customNavBar;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
+(CosjiItemListViewController*)shareCosjiItemListViewController;
-(void)loadInfoWith:(NSString*)textString atPage:(int)pageNumber;
@end
