//
//  CosjiTimerView.m
//  CosjiTimer
//
//  Created by Darsky on 14-2-8.
//  Copyright (c) 2014年 Darsky. All rights reserved.
//

#import "CosjiTimerView.h"

@implementation CosjiTimerView
{
    UILabel *hourLabel;
    int hour;
    UILabel *minuteLabel;
    int minute;
    UILabel *secondeLabel;
    int seconde;
    NSTimer *timerManager;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"计时器背景"]];
        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(98/2, 77, 200, 42/2)];
        titleLabel.text=@"本场结束仅剩        :       :";
        titleLabel.backgroundColor=[UIColor clearColor];
        hourLabel=[[UILabel alloc] initWithFrame:CGRectMake(160, 77, 52/2, 42/2)];
        minuteLabel=[[UILabel alloc] initWithFrame:CGRectMake(hourLabel.frame.origin.x+hourLabel.frame.size.width+12,77, 52/2, 42/2)];
        secondeLabel=[[UILabel alloc] initWithFrame:CGRectMake(minuteLabel.frame.origin.x+minuteLabel.frame.size.width+11, 77, 52/2, 42/2)];
        hourLabel.backgroundColor=minuteLabel.backgroundColor=secondeLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"倒计时背景"]];
        hour=minute=seconde=0;
        hourLabel.text=minuteLabel.text=secondeLabel.text=@"00";
        hourLabel.textAlignment=minuteLabel.textAlignment=secondeLabel.textAlignment=NSTextAlignmentCenter;
        hourLabel.textColor=minuteLabel.textColor=secondeLabel.textColor=titleLabel.textColor=[UIColor colorWithRed:146.0/255.0 green:107.0/255.0 blue:39.0/255.0 alpha:100];
        [self addSubview:hourLabel];
        [self addSubview:minuteLabel];
        [self addSubview:secondeLabel];
        [self addSubview:titleLabel];
        [self initTimer];
    }
    return self;
}
-(void)initTimer
{
    if ([timerManager isValid]) {
        [timerManager invalidate];
    }
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH"];
    date = [formatter stringFromDate:[NSDate date]];
    hour=[date intValue];
    if (hour>=10)
    {
        NSLog(@"大于10点钟");
        NSDateFormatter *formatterCompare=[[NSDateFormatter alloc] init];
        [formatterCompare setDateFormat:@"yyyy-MM-dd"];
        NSString *todayDate=[formatterCompare stringFromDate:[NSDate date]];
        NSLog(@"today Date is%@",todayDate);
        NSArray *currentDate=[todayDate componentsSeparatedByString:@"-"];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setHour:10];
        [components setDay:[[currentDate objectAtIndex:2]intValue] +1];
        [components setMonth:[[currentDate objectAtIndex:1] intValue]];
        [components setYear:[[currentDate objectAtIndex:0] intValue]];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *targetDate= [gregorian dateFromComponents:components];
        NSTimeInterval interval = [targetDate timeIntervalSinceNow];
        int thour = (int)(interval/3600);
        int tminute = (int)(interval - thour*3600)/60;
        int tsecond = interval - thour*3600 - tminute*60;
        hour=thour;
        if (hour<10) {
            hourLabel.text=[NSString stringWithFormat:@"0%d",hour];
        }else
        hourLabel.text=[NSString stringWithFormat:@"%d",thour];
        
        minute=tminute;
        if (minute<10) {
            minuteLabel.text=[NSString stringWithFormat:@"0%d",minute];
        }else
        minuteLabel.text=[NSString stringWithFormat:@"%d",minute];

        seconde=tsecond;
        if (seconde<10) {
            secondeLabel.text=[NSString stringWithFormat:@"0%d",seconde];
        }else
        secondeLabel.text=[NSString stringWithFormat:@"%d",seconde];

        timerManager=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(TimerRecord) userInfo:nil repeats:YES];
    }else
    {
        NSLog(@"小于10点钟");
        NSDateFormatter *formatterCompare=[[NSDateFormatter alloc] init];
        [formatterCompare setDateFormat:@"yyyy-MM-dd"];
        NSString *todayDate=[formatterCompare stringFromDate:[NSDate date]];
        NSArray *currentDate=[todayDate componentsSeparatedByString:@"-"];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setHour:10];
        [components setDay:[[currentDate objectAtIndex:2]intValue]];
        [components setMonth:[[currentDate objectAtIndex:1] intValue]];
        [components setYear:[[currentDate objectAtIndex:0] intValue]];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *targetDate= [gregorian dateFromComponents:components];
        NSTimeInterval interval = [targetDate timeIntervalSinceNow];
        int thour = (int)(interval/3600);
        int tminute = (int)(interval - thour*3600)/60;
        int tsecond = interval - thour*3600 - tminute*60;
        hourLabel.text=[NSString stringWithFormat:@"%d",thour];
        hour=thour;
        if (hour<10) {
            hourLabel.text=[NSString stringWithFormat:@"0%d",hour];
        }else
            hourLabel.text=[NSString stringWithFormat:@"%d",thour];
        
        minute=tminute;
        if (minute<10) {
            minuteLabel.text=[NSString stringWithFormat:@"0%d",minute];
        }else
            minuteLabel.text=[NSString stringWithFormat:@"%d",minute];
        
        seconde=tsecond;
        if (seconde<10) {
            secondeLabel.text=[NSString stringWithFormat:@"0%d",seconde];
        }else
            secondeLabel.text=[NSString stringWithFormat:@"%d",seconde];
        
        timerManager=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(TimerRecord) userInfo:nil repeats:YES];
    }
}
-(void)TimerRecord
{
    seconde--;
    if (seconde<10&&seconde>0) {
        secondeLabel.text=[NSString stringWithFormat:@"0%d",seconde];
    }else if (seconde==0) {
        seconde=60;
        secondeLabel.text=[NSString stringWithFormat:@"00"];
        minute--;
        if (minute<10&&minute>=0) {
            minuteLabel.text=[NSString stringWithFormat:@"0%d",minute];
        }else if (minute==60||minute<0)
        {
            minute=59;
            minuteLabel.text=[NSString stringWithFormat:@"%d",minute];
            hour--;
            if (hour<10&&hour>=0) {
                hourLabel.text=[NSString stringWithFormat:@"0%d",hour];
            }else if (hour<0)
            {
                [self initTimer];
            }else
                hourLabel.text=[NSString stringWithFormat:@"%d",hour];
        }else
            minuteLabel.text=[NSString stringWithFormat:@"%d",minute];
        }else
            secondeLabel.text=[NSString stringWithFormat:@"%d",seconde];
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
