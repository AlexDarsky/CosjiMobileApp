//
//  CosjiUrlFilter.h
//  CosjiApp
//
//  Created by Darsky on 14-1-17.
//  Copyright (c) 2014年 Cosji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CosjiUrlFilter : NSObject
typedef NS_ENUM(NSUInteger, CosjiUrlType) {
    CosjiUrlNormalType  = 0,
    CosjiUrlMixType  = 1,
    CosjiUrlSpecialTopType= 2,
    CosjiUrlTaoBaoType=3,
    CosjiUrlTmallType=4,
    CosjiStringType=5,
    CosjiTBShortUrl=6
};

+(NSDictionary*)filterUrl:(NSString*)shortUrl;
@end
