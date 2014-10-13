//
//  CosjiServerHelper.m
//  CosjiApp
//
//  Created by Darsky on 13-9-27.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiServerHelper.h"
#import "JSONKit.h"
#import "TopIOSClient.h"
#import "TopAttachment.h"
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
        NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
        NSLog(@"userInfo is %@",tmpDic);
        NSDictionary *infoDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
        NSString *uid =[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"userId"]];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:@"taobao.tbk.items.get"
                   forKey:@"method"];
        [params setObject:@"num_iid,title,price,volume,pic_url,item_url,click_url"
                   forKey:@"fields"];
        [params setObject:@"1"
                   forKey:@"start_price"];
        [params setObject:[NSString stringWithFormat:@"%d",pageNO]
                   forKey:@"page_no"];
        [params setObject:keyword
                   forKey:@"keyword"];
        [params setObject:@"20"
                   forKey:@"page_size"];
        [params setObject:@"1000"
                   forKey:@"start_commissionRate"];
        [params setObject:@"5000"
                   forKey:@"end_commissionRate"];
        TopIOSClient *iosClient = [TopIOSClient getIOSClientByAppKey:CosjiAppKey];
        TopApiResponse * response = [iosClient tql:@"GET" params:params userId:uid];
        NSDictionary *responeDic =[[response content]  objectFromJSONString];
        NSDictionary *respone_getDIC=[responeDic objectForKey:@"tbk_items_get_response"];
        NSDictionary *tbk_items_IDC=[respone_getDIC objectForKey:@"tbk_items"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"%@",[tbk_items_IDC objectForKey:@"tbk_item"]);
        if ([[tbk_items_IDC objectForKey:@"tbk_item"] isKindOfClass:[NSArray class]])
        {
            return [tbk_items_IDC objectForKey:@"tbk_item"];
        }
        else
        return nil;
    }
    else{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        return nil;
    }
}
-(NSDictionary*)getItemFromTop:(NSString*)numiids
{
    if ([self connectedToNetwork])
    {
        
        NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
        NSDictionary *infoDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
        NSString *uid =[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"userId"]];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:@"taobao.tbk.items.detail.get"
                   forKey:@"method"];
        [params setObject:numiids
                   forKey:@"num_iids"];
        [params setObject:@"num_iid,title,price,volume,pic_url,item_url,click_url"
                   forKey:@"fields"];
        TopIOSClient *iosClient = [TopIOSClient getIOSClientByAppKey:CosjiAppKey];
        TopApiResponse * response = [iosClient tql:@"GET"
                                            params:params
                                            userId:uid];
        NSDictionary *responeDic =[[response content]  objectFromJSONString];
        NSDictionary *respone_getDIC=[responeDic objectForKey:@"tbk_items_detail_get_response"];
        NSDictionary *tbk_items_DIC=[respone_getDIC objectForKey:@"tbk_items"];
        NSDictionary *tbk_item_DIC=[[NSArray arrayWithArray:[tbk_items_DIC objectForKey:@"tbk_item"]] lastObject];
        if (tbk_item_DIC!=nil)
        {
            NSLog(@"responeDic is %@",tbk_item_DIC);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            return tbk_item_DIC;
        }else
        {
            NSLog(@"没有返利");
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

            return nil;
        }
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
        
        NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
        NSDictionary *infoDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
        
        NSString *uid =[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"userId"]];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        
        [params setObject:@"taobao.tbk.mobile.items.convert"
                   forKey:@"method"];
        [params setObject:@"click_url"
                   forKey:@"fields"];
        [params setObject:numiids
                   forKey:@"num_iids"];
        [params setObject:uid
                   forKey:@"outer_code"];
        [params setObject:@"1"
                   forKey:@"refer_type"];
        // [params setValue:@"http://www.cosji.com" forKey:@"callbackurl"];
        
        NSLog(@"输入参数%@",params);
        TopIOSClient *iosClient = [TopIOSClient getIOSClientByAppKey:CosjiAppKey];
        TopApiResponse * response = [iosClient tql:@"GET"
                                            params:params
                                            userId:uid];
        NSDictionary *responeDic =[[response content]  objectFromJSONString];
        NSDictionary *respone_getDIC=[responeDic objectForKey:@"tbk_mobile_items_convert_response"];
        NSDictionary *tbk_items_DIC=[respone_getDIC objectForKey:@"tbk_items"];
        NSDictionary *tbk_item_DIC=[[NSArray arrayWithArray:[tbk_items_DIC objectForKey:@"tbk_item"]]lastObject];
        // NSLog(@"%@",[NSString stringWithFormat:@"%@",[[NSArray arrayWithArray:[tbk_items_DIC objectForKey:@"tbk_item"]]lastObject]]);
        if([tbk_item_DIC objectForKey:@"click_url"]==nil)
        {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            return nil;
        }else
        {
            NSLog(@"click_url is %@",[tbk_item_DIC objectForKey:@"click_url"]);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            return [tbk_item_DIC objectForKey:@"click_url"];
        }
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
