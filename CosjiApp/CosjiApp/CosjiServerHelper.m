//
//  CosjiServerHelper.m
//  CosjiApp
//
//  Created by Darsky on 13-9-27.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiServerHelper.h"
#import "JSONKit.h"
#import "Reachability.h"

#define login @"http://192.168.1.110"
#define shouye @"/mall/getAll"
#define httpAdd @"http://rest.cosjii.com"
#define demoURL @"/slide/acquire/?num=5"
#define allItems @"/taobao/category/"

@implementation CosjiServerHelper
static CosjiServerHelper *shareCosjiServerHelper=nil;

+(CosjiServerHelper*)shareCosjiServerHelper
{
    if (shareCosjiServerHelper == nil) {
        shareCosjiServerHelper = [[super allocWithZone:NULL] init];
    }
    return shareCosjiServerHelper;
}

-(void)jsonTest
{
    NSString *urlString =[NSString stringWithFormat:@"%@%@",httpAdd,demoURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&urlResponse
                                                             error:&error];
    NSMutableString *string=[[NSMutableString alloc] initWithData:responseData
                                                         encoding:NSUTF8StringEncoding];
    NSString *jsonString=[string stringByReplacingOccurrencesOfString:@"ok"
                                                           withString:@""];
   // NSLog(@"jsonTest Result is :%@",jsonString);
    NSMutableDictionary *tmpDic =[jsonString objectFromJSONString];
    if (tmpDic==nil) {
        NSLog(@"json error");
    }
}
-(NSDictionary*)getJsonDictionary:(NSString*)orderString
{
    if ([self connectedToNetwork]) {
        NSString *urlString =[NSString stringWithFormat:@"%@%@",httpAdd,orderString];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[self getEncodedString:urlString]]];
        [request setHTTPMethod:@"GET"];
        NSHTTPURLResponse* urlResponse = nil;
        NSError *error = [[NSError alloc] init];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&urlResponse
                                                                 error:&error];
        NSMutableString *string=[[NSMutableString alloc] initWithData:responseData
                                                             encoding:NSUTF8StringEncoding];
        NSString *jsonString=[string stringByReplacingOccurrencesOfString:@"ok"
                                                               withString:@""];
       // NSLog(@"jsonString is %@",jsonString);
        NSDictionary *tmpDic =[jsonString objectFromJSONString];
        if (tmpDic==nil) {
            NSLog(@"json error!!!!:%@",jsonString);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

            return nil;
        }else{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            return tmpDic;
        }
    }else
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        return nil;
    }
}

- (NSArray*)getItemsFromTopByKeyWord:(NSString*)keyword atPage:(int)pageNO
{
    if ([self connectedToNetwork])
    {
        return nil;
    }
    else
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        return nil;
    }
}
-(NSDictionary*)getItemFromTop:(NSString*)numiids
{
    if ([self connectedToNetwork])
    {
        
        return nil;

    }
    else
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        return nil;
    }
}
-(NSString*)getClick_urlFromTop:(NSString*)numiids
{
    if ([self connectedToNetwork])
    {
        return nil;
    }else
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        return nil;
    }

}
-(int)getSearchItemType:(NSString*)searchItem
{
    if ([searchItem rangeOfString:@"http://"].location!=NSNotFound)
    {
        return 0;
    }else
    {
        if ([self isPureInt:searchItem])
        {
            return 1;
        }else
            return 2;
    }
}
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
-(BOOL)quickLogin
{
    if ([self connectedToNetwork])
    {
        NSLog(@"开始自动快速");
        NSDictionary *loginDic=[[NSUserDefaults standardUserDefaults] objectForKey:@"loginDic"];
        if (loginDic!=nil) {
            NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary: [self getJsonDictionary:[NSString stringWithFormat:@"/user/login/?account=%@&password=%@",[loginDic objectForKey:@"loginName"],[loginDic objectForKey:@"loginPWD"]]]];
            if (tmpDic!=nil)
            {
                NSDictionary *headDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"head"]];
                if ([[headDic objectForKey:@"msg"] isEqualToString:@"success"])
                {
                    NSDictionary *idDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
                    
                    NSDictionary *userInfo=[NSDictionary dictionaryWithDictionary:[self getJsonDictionary:[NSString stringWithFormat:@"/user/profile/?id=%@",[idDic objectForKey:@"userId"]]]];
                    NSLog(@"成功，更新本地用户信息%@",userInfo);
                    [[NSUserDefaults standardUserDefaults] setObject:userInfo
                                                              forKey:@"userInfo"];
                    [[NSUserDefaults standardUserDefaults] setBool:YES
                                                            forKey:@"havelogined"];
                    [[NSUserDefaults standardUserDefaults] setBool:YES
                                                            forKey:@"quickLogin"];
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    return YES;
                }else
                {
                    [[NSUserDefaults standardUserDefaults] setBool:NO
                                                            forKey:@"havelogined"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    return NO;
                }
            }else
            {
                [[NSUserDefaults standardUserDefaults] setBool:NO
                                                        forKey:@"havelogined"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                return NO;
                
            }
            
        }else
        {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            return NO;
        }
    }else
    {
        NSLog(@"错误,本地用户信息为空");
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        return NO;
    }
}

- (BOOL) connectedToNetwork
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    BOOL isReachability=NO;
    Reachability *reachability=[Reachability reachabilityForInternetConnection];
    switch ([reachability currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
        {
            isReachability=NO;
        }
            break;
        case ReachableViaWWAN:
            // 使用3G网络
        {
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"low"]) {
                [[NSUserDefaults standardUserDefaults] setBool:YES
                                                        forKey:@"lowMode"];
            }
            isReachability=YES;
        }
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
        {
            isReachability=YES;
        }
            break;
    }
    return isReachability;
}
-(NSString*)getEncodedString:(NSString*)urlString
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)urlString,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

@end
