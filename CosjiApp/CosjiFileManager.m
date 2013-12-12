//
//  CosjiFileManager.m
//  CosjiApp
//
//  Created by Darsky on 13-12-9.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiFileManager.h"

@implementation CosjiFileManager
static CosjiFileManager *shareCosjiFileManager=nil;
+(CosjiFileManager*)shareCosjiFileManager
{
    if (shareCosjiFileManager == nil) {
        shareCosjiFileManager = [[super allocWithZone:NULL] init];
    }
    return shareCosjiFileManager;
}
+(void)quickCleanCacheFile
{
    [[CosjiFileManager shareCosjiFileManager] cleanCachePath];
}
-(void)cleanCachePath
{
    [CosjiFileManager shareCosjiFileManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    BOOL isDir = YES;
    NSString *dirName=[cachePath stringByAppendingPathComponent:@"cacheImages"];
    NSError *error;
    if ([[NSFileManager defaultManager] fileExistsAtPath:dirName isDirectory:&isDir])
    {
        [[NSFileManager defaultManager] removeItemAtPath:dirName error:&error];
    }
}
@end
