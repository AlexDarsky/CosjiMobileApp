//
//  CosjiMP3Player.h
//  CosjiApp
//
//  Created by Darsky on 13-8-23.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface CosjiMP3Player : NSObject
{
    SystemSoundID soundID;
}
-(id)initForPlayingVibrate;
-(id)initForPlayingSystemSoundEffectWith:(NSString *)resourceName ofType:(NSString *)type;
-(id)initForPlayingSoundEffectWith:(NSString *)filename;
-(void)play;

@end
