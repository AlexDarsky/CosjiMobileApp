//
//  CosjiSettingViewController.h
//  CosjiApp
//
//  Created by Darsky on 13-10-5.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CosjiSettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *itemArray;
    UIImageView *grayImageView;
    UIButton *saveBtn;
}
@property (strong,nonatomic)UITableView *myTableView;
@property (strong)id settingDelegate;
@end
