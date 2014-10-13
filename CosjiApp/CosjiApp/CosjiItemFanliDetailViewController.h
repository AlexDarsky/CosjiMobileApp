//
//  CosjiItemFanliDetailViewController.h
//  CosjiApp
//
//  Created by Darsky on 14-1-2.
//  Copyright (c) 2014年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CosjiItemFanliDetailViewController : UIViewController<UIAlertViewDelegate,UIWebViewDelegate>
@property (strong,nonatomic)NSString *clickURLString;
+(CosjiItemFanliDetailViewController*)shareCosjiItemFanliDetailViewController;
-(void)loadItemInfoWithDic:(NSDictionary*)itemDic;
-(void)loadZheMainItemInfoWithDic:(NSDictionary*)itemDic;
@end
