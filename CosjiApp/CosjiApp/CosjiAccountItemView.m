//
//  CosjiAccountItemView.m
//  CosjiApp
//
//  Created by Darsky on 13-11-28.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiAccountItemView.h"

@implementation CosjiAccountItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame withInfo:(NSDictionary*)infoDic forModel:(int)accountModel;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization cod
        if (accountModel==0) {
            self.timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width, self.frame.size.height/4)];
            self.timeLabel.textColor=[UIColor lightGrayColor];
            self.timeLabel.font=[UIFont fontWithName:@"Arial" size:11];
            self.timeLabel.text=[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"time"]];
            
            self.contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, self.frame.size.height/4, self.frame.size.width-10, self.frame.size.height/2)];
            self.contentLabel.numberOfLines=0;
            self.contentLabel.textColor=[UIColor blackColor];
            self.contentLabel.font=[UIFont fontWithName:@"Arial" size:14];
            self.contentLabel.text=[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"content"]];
            
            self.eventLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, self.frame.size.height-self.frame.size.height/4, self.frame.size.width, self.frame.size.height/4)];
            self.eventLabel.textColor=[UIColor lightGrayColor];
            self.eventLabel.font=[UIFont fontWithName:@"Arial" size:11];
            self.eventLabel.text=[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"event"]];
            self.timeLabel.backgroundColor=self.contentLabel.backgroundColor=self.eventLabel.backgroundColor=[UIColor clearColor];
            [self addSubview:self.timeLabel];
            [self addSubview:self.contentLabel];
            [self addSubview:self.eventLabel];
        }else
        {
            self.timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width, self.frame.size.height/4)];
            self.timeLabel.textColor=[UIColor lightGrayColor];
            self.timeLabel.font=[UIFont fontWithName:@"Arial" size:11];
            self.timeLabel.text=[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"time"]];
            
            self.contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, self.frame.size.height/4, self.frame.size.width-10, self.frame.size.height/2)];
            self.contentLabel.numberOfLines=0;
            self.contentLabel.textColor=[UIColor blackColor];
            self.contentLabel.font=[UIFont fontWithName:@"Arial" size:14];
            self.contentLabel.text=[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"tool"]];
            
            self.eventLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, self.frame.size.height-self.frame.size.height/4, self.frame.size.width, self.frame.size.height/4)];
            self.eventLabel.textColor=[UIColor lightGrayColor];
            self.eventLabel.font=[UIFont fontWithName:@"Arial" size:11];
            self.eventLabel.text=[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"status"]];
            self.timeLabel.backgroundColor=self.contentLabel.backgroundColor=self.eventLabel.backgroundColor=[UIColor clearColor];
            [self addSubview:self.timeLabel];
            [self addSubview:self.contentLabel];
            [self addSubview:self.eventLabel];
        }
        

    }
    return self;
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
