//
//  CosjiWelcomeViewController.h
//  CosjiApp
//
//  Created by Darsky on 14-1-3.
//  Copyright (c) 2014年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CosjiWelcomeViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UIScrollView *welceomSV;
    UIPageControl *page;
    NSMutableArray *topListArray;

}

@end
