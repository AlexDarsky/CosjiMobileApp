//
//  CosjiServerHelper.h
//  CosjiApp
//
//  Created by Darsky on 13-9-27.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CosjiServerHelper : NSObject

+(CosjiServerHelper*)shareCosjiServerHelper;
-(void)jsonTest;
-(NSDictionary*)getJsonDictionary:(NSString*)orderString;
@end
