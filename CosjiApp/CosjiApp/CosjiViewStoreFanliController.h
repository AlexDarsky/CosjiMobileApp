//
//  CosjiViewStoreFanliController.h
//  CosjiApp
//
//  Created by Darsky on 13-7-14.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CosjiViewStoreFanliController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
        NSMutableArray *storeListArray;
}
@property (nonatomic,strong) IBOutlet   UITableView *tableView;
@end
