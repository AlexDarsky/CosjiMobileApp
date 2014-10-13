//
//  CosjiUrlFilter.m
//  CosjiApp
//
//  Created by Darsky on 14-1-17.
//  Copyright (c) 2014年 Cosji. All rights reserved.
//

#import "CosjiUrlFilter.h"

@implementation CosjiUrlFilter
/*
 
 */

+ (CosjiUrlFilter*)sharedCosjiUrlFilter {
    static dispatch_once_t once;
    static CosjiUrlFilter *sharedCosjiUrlFilter;
    dispatch_once(&once, ^ { sharedCosjiUrlFilter = [[CosjiUrlFilter alloc] init]; });
    return sharedCosjiUrlFilter;
}

+(NSDictionary*)filterUrl:(NSString*)urlString
{
    
    return [[CosjiUrlFilter sharedCosjiUrlFilter] filterThisUrl:urlString];
}
-(NSDictionary*)filterThisUrl:(NSString*)targetUrl
{
    NSMutableDictionary *resultDic=[NSMutableDictionary dictionaryWithCapacity:0];
    switch ([self judgeUrl:targetUrl]) {
//        case CosjiUrlNormalType://普通链接
//        {
//            NSLog(@"封装普通字典");
//            [resultDic setObject:[NSNumber numberWithInt:0] forKey:@"UrlType"];
//            [resultDic setObject:targetUrl forKey:@"url"];
//        }
//            break;
//        case CosjiUrlMixType://混合链接
//        {
//            NSLog(@"封装mix字典");
//
//          //  [resultDic setObject:[NSNumber numberWithInt:1] forKey:@"UrlType"];
//           // [resultDic setObject:[self dealWithMixUrl:targetUrl] forKey:@"url"];
//            
//            [resultDic setObject:[NSNumber numberWithInt:4] forKey:@"UrlType"];
//            [resultDic setObject:[self dealWithMixUrl:targetUrl] forKey:@"num_iid"];
//        }
//            break;
//        case CosjiUrlTaoBaoType://淘宝商品链接
//        {
//            NSLog(@"封装taobao字典");
//
//            [resultDic setObject:[NSNumber numberWithInt:3] forKey:@"UrlType"];
//            [resultDic setObject:[self dealWithCosjiUrlTaoBaoType:targetUrl] forKey:@"num_iid"];
//        }
//            break;
//        case CosjiUrlTmallType://天猫商品链接
//        {
//            [resultDic setObject:[NSNumber numberWithInt:4] forKey:@"UrlType"];
//            [resultDic setObject:[self dealWithCosjiUrlTmallType:targetUrl] forKey:@"num_iid"];
//            NSLog(@"封装tmall字典 %@",resultDic);
//        }
//            break;
//        case CosjiUrlSpecialTopType://特别链接（带有淘宝推广的链接）
//        {
//            NSLog(@"封装sepcall字典");
//
//            [resultDic setObject:[NSNumber numberWithInt:2] forKey:@"UrlType"];
//            [resultDic setObject:[self dealWithCosjiUrlSpecialTopType:targetUrl] forKey:@"num_iid"];
//        }
//            break;
        case CosjiStringType:
        {
            NSLog(@"封装string字典");
            [resultDic setObject:[NSNumber numberWithInt:5] forKey:@"UrlType"];
            if ([[targetUrl substringFromIndex:targetUrl.length-1] isEqualToString:@" "])
            {
                [resultDic setObject:[targetUrl substringToIndex:targetUrl.length-1] forKey:@"String"];
            }else
                [resultDic setObject:targetUrl forKey:@"String"];
        }
            break;
//         case CosjiTBShortUrl:
//        {
//            [resultDic setObject:[NSNumber numberWithInt:6] forKey:@"UrlType"];
//            [resultDic setObject:[self dealWithTBShortUrl:targetUrl] forKey:@"num_iid"];
//        }
//            break;
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"亲，只能搜索商品名称进行返利哦~"
                                                           delegate:nil
                                                  cancelButtonTitle:@"好的"
                                                  otherButtonTitles: nil];
            [alert show];
            resultDic=nil;
        }
            break;
    }
    return resultDic;
}

-(int)judgeUrl:(NSString*)targetUrl
{
      if ([targetUrl rangeOfString:@"cloud-jump.html?"].location!=NSNotFound)
      {
          NSLog(@"这是特别链接");
          return CosjiUrlSpecialTopType;
      }else if (([targetUrl rangeOfString:@"item.htm?id="].location!=NSNotFound&&[targetUrl rangeOfString:@"m.taobao.com"].location!=NSNotFound)||([targetUrl rangeOfString:@"detail.htm?id="].location!=NSNotFound&&[targetUrl rangeOfString:@"m.taobao.com"].location!=NSNotFound))
      {
          NSLog(@"这是淘宝链接");

          return CosjiUrlTaoBaoType;
      }else if ([targetUrl rangeOfString:@"m.tmall.com/i"].location!=NSNotFound||[targetUrl rangeOfString:@"detail.tmall.com"].location!=NSNotFound)
      {
          NSLog(@"这是天猫链接");
          return CosjiUrlTmallType;
      }else if ([self thisStringHaveChinese:targetUrl])
      {
          NSLog(@"这是混合链接");
          return CosjiUrlMixType;
      }else if ([self isPureString:targetUrl])
      {
          NSLog(@"这是文本");
              return CosjiStringType;
      }else if ([targetUrl rangeOfString:@"http://tb.cn/"].location!=NSNotFound)
      {
          NSLog(@"这是淘宝短连接");
          return CosjiTBShortUrl;
      }else
          return CosjiUrlNormalType;
}

-(BOOL)thisStringHaveChinese:(NSString *)string
{
    NSString *targetString=[string stringByReplacingOccurrencesOfString:@" " withString:@""];
    int length = [targetString length];
    int chinesenumber=0;
    int englishnumber=0;
    for (int i=0; i<length; ++i)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [targetString substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3)
        {
            chinesenumber++;
        }else
            englishnumber++;
    }
    if (chinesenumber>0&&englishnumber>0&&[targetString rangeOfString:@"http://"].location!=NSNotFound) {
        return YES;
    }else
        return NO;
}
-(NSString*)dealWithMixUrl:(NSString*)mixUrl
{
    int location=[[NSString stringWithFormat:@"%@",mixUrl] rangeOfString:@"http://"].location;
    
    NSString *filtedUrl=[[NSString stringWithFormat:@"%@",mixUrl] substringWithRange:NSMakeRange(location,mixUrl.length-location)];
    NSLog(@"filtedUrl is%@",filtedUrl);
    NSURL *url = [NSURL URLWithString:filtedUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: nil];
    // 取得所有的请求的头
    NSDictionary *dictionary = [response allHeaderFields];
    // 取得http状态码
    NSLog(@"%d",[response statusCode]);
    NSString *itemIDstring=[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"At_Itemid"]];
    return itemIDstring;
}
-(NSString*)dealWithTBShortUrl:(NSString*)TBShortUrl
{
    NSURL *url = [NSURL URLWithString:TBShortUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: nil];
    // 取得所有的请求的头
    NSDictionary *dictionary = [response allHeaderFields];
    // 取得http状态码
    NSLog(@"%d",[response statusCode]);
    NSString *itemIDstring=[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"At_Itemid"]];
    return itemIDstring;
}

-(NSString*)dealWithCosjiUrlTaoBaoType:(NSString*)normalUrl
{
    if ([normalUrl rangeOfString:@"item.htm?id="].location!=NSNotFound&&[normalUrl rangeOfString:@"taobao.com"].location!=NSNotFound)
    {
        NSLog(@"A");
        int location=[[NSString stringWithFormat:@"%@",normalUrl] rangeOfString:@"item.htm?id="].location;
        NSString *num_iid=[[NSString stringWithFormat:@"%@",normalUrl] substringWithRange:NSMakeRange(location+12, 11)];
        return num_iid;
    }else
        if ([normalUrl rangeOfString:@"item.taobao.com"].location!=NSNotFound)
        {
            int location=[[NSString stringWithFormat:@"%@",normalUrl] rangeOfString:@"&id="].location;
            NSString *num_iid=[[NSString stringWithFormat:@"%@",normalUrl] substringWithRange:NSMakeRange(location+4, 11)];
            return num_iid;
        }else
            if ([normalUrl rangeOfString:@"m.taobao.com/awp"].location!=NSNotFound) {
                int location=[[NSString stringWithFormat:@"%@",normalUrl] rangeOfString:@"?id="].location;
                NSString *num_iid=[[NSString stringWithFormat:@"%@",normalUrl] substringWithRange:NSMakeRange(location+4, 11)];
                return num_iid;
            }
            return nil;
}
-(NSString*)dealWithCosjiUrlTmallType:(NSString*)targetUrl
{
    if ([targetUrl rangeOfString:@"m.tmall.com/i"].location!=NSNotFound)
    {
        int location=[[NSString stringWithFormat:@"%@",targetUrl] rangeOfString:@"m.tmall.com/i"].location;
        NSString *num_iid=[[NSString stringWithFormat:@"%@",targetUrl] substringWithRange:NSMakeRange(location+13, 11)];
        return num_iid;
    }else
        if ([targetUrl rangeOfString:@"detail.tmall.com"].location!=NSNotFound)
        {
            int location=[[NSString stringWithFormat:@"%@",targetUrl] rangeOfString:@"id="].location;
            NSString *num_iid=[[NSString stringWithFormat:@"%@",targetUrl] substringWithRange:NSMakeRange(location+3, 11)];
            return num_iid;
        }else
            return nil;
}
-(NSString*)dealWithCosjiUrlSpecialTopType:(NSString*)targetUrl
{
    if ([targetUrl rangeOfString:@"cloud-jump.html?"].location!=NSNotFound) {
        int location=[[NSString stringWithFormat:@"%@",targetUrl] rangeOfString:@"itemId="].location;
        NSString *num_iid=[[NSString stringWithFormat:@"%@",targetUrl] substringWithRange:NSMakeRange(location+7, 11)];
        return num_iid;
    }else
        return nil;
}
- (BOOL)isPureString:(NSString*)string{
    if ([string rangeOfString:@"http://"].location==NSNotFound)
        return YES;
    else
        return NO;
}
@end
