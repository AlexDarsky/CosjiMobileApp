//
//  CosjiTBViewController.h
//  可及网
//
//  Created by Darsky on 13-8-23.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CosjiWebViewController.h"

@interface CosjiTBViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *subjectsArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *customNavBar;
@property (strong,nonatomic) UITextField *searchField;
@property (strong,nonatomic) UIButton *taoBtn;
@property (strong,nonatomic) UIButton *tmallBtn;
@property (strong,nonatomic) UIButton *juBtn;
@property (strong,nonatomic) CosjiWebViewController *storeBrowseViewController;


@end
