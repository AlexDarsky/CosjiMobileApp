//
//  CosjiFileManager.h
//  CosjiApp
//
//  Created by Darsky on 13-12-9.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CosjiFileManager : NSObject

+(CosjiFileManager*)shareCosjiFileManager;
+(void)quickCleanCacheFile;
-(void)cleanCachePath;
@end
