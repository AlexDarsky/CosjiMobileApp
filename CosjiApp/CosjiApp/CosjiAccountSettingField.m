//
//  CosjiAccountSettingField.m
//  CosjiApp
//
//  Created by Darsky on 14-1-3.
//  Copyright (c) 2014年 Cosji. All rights reserved.
//

#import "CosjiAccountSettingField.h"

@implementation CosjiAccountSettingField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 5, 0);
}
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 5, 0);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
