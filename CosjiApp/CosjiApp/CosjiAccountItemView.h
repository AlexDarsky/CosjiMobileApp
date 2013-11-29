//
//  CosjiAccountItemView.h
//  CosjiApp
//
//  Created by Darsky on 13-11-28.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CosjiAccountItemView : UIView

@property (strong,nonatomic)UILabel *timeLabel;
@property (strong,nonatomic)UILabel *eventLabel;
@property (strong,nonatomic)UILabel *contentLabel;
- (id)initWithFrame:(CGRect)frame withInfo:(NSDictionary*)infoDic forModel:(int)accountModel;
@end
