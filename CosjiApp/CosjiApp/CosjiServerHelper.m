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

#define login @"http://192.168.1.110"
#define shouye @"/mall/getAll"
#define httpAdd @"http://rest.cosjii.com"
#define demoURL @"/registry/status"
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
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSMutableString *string=[[NSMutableString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSString *jsonString=[string stringByReplacingOccurrencesOfString:@"ok" withString:@""];
    NSLog(@"jsonTest Result is :%@",jsonString);
    NSMutableDictionary *tmpDic =[jsonString objectFromJSONString];
  //  NSLog(jsonString);
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
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        NSMutableString *string=[[NSMutableString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSString *jsonString=[string stringByReplacingOccurrencesOfString:@"ok" withString:@""];
        NSLog(@"jsonString is %@",jsonString);
        NSDictionary *tmpDic =[jsonString objectFromJSONString];
        if (tmpDic==nil) {
            NSLog(@"json error!!!!:%@",jsonString);
            return nil;
        }else{
            NSLog(@"%@",jsonString);
            return tmpDic;
        }
    }else
    {
        return nil;
    }
}
- (NSArray*)getItemsFromTopByKeyWord:(NSString*)keyword atPage:(int)pageNO
{
    NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
    NSDictionary *infoDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
    NSString *uid =[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"userId"]];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"taobao.tbk.items.get" forKey:@"method"];
    [params setObject:@"num_iid,title,price,volume,pic_url,item_url,click_url" forKey:@"fields"];
    [params setObject:@"1" forKey:@"start_price"];
    [params setObject:[NSString stringWithFormat:@"%d",pageNO] forKey:@"page_no"];
    [params setObject:keyword forKey:@"keyword"];
    [params setObject:@"20" forKey:@"page_size"];
    [params setObject:@"100" forKey:@"start_commissionRate"];
    [params setObject:@"5000" forKey:@"end_commissionRate"];
    TopIOSClient *iosClient = [TopIOSClient getIOSClientByAppKey:CosjiAppKey];
    TopApiResponse * response = [iosClient tql:@"GET" params:params userId:uid];
    NSDictionary *responeDic =[[response content]  objectFromJSONString];
    NSDictionary *respone_getDIC=[responeDic objectForKey:@"tbk_items_get_response"];
    NSDictionary *tbk_items_IDC=[respone_getDIC objectForKey:@"tbk_items"];
    NSLog(@"%@",tbk_items_IDC);
    return [NSArray arrayWithArray:[tbk_items_IDC objectForKey:@"tbk_item"]];
}
-(NSDictionary*)getItemFromTop:(NSString*)numiids
{
    NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
    NSDictionary *infoDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
    NSString *uid =[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"userId"]];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"taobao.tbk.items.detail.get" forKey:@"method"];
    [params setObject:numiids  forKey:@"num_iids"];
    [params setObject:@"num_iid,title,price,volume,pic_url,item_url,click_url" forKey:@"fields"];
    TopIOSClient *iosClient = [TopIOSClient getIOSClientByAppKey:CosjiAppKey];
    TopApiResponse * response = [iosClient tql:@"GET" params:params userId:uid];
    NSDictionary *responeDic =[[response content]  objectFromJSONString];
    NSDictionary *respone_getDIC=[responeDic objectForKey:@"tbk_items_detail_get_response"];
    NSDictionary *tbk_items_DIC=[respone_getDIC objectForKey:@"tbk_items"];
    NSDictionary *tbk_item_DIC=[[NSArray arrayWithArray:[tbk_items_DIC objectForKey:@"tbk_item"]]lastObject];
    if (tbk_item_DIC!=nil)
    {
        NSLog(@"responeDic is %@",tbk_item_DIC);
        return tbk_item_DIC;
    }else
    return nil;
}
-(NSString*)getClick_urlFromTop:(NSString*)numiids
{
    NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
    NSDictionary *infoDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
    
    NSString *uid =[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"userId"]];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    [params setObject:@"taobao.tbk.mobile.items.convert" forKey:@"method"];
    [params setObject:@"click_url" forKey:@"fields"];
    [params setObject:numiids forKey:@"num_iids"];
    [params setObject:uid forKey:@"outer_code"];

    TopIOSClient *iosClient = [TopIOSClient getIOSClientByAppKey:CosjiAppKey];
    TopApiResponse * response = [iosClient tql:@"GET" params:params userId:uid];
    NSDictionary *responeDic =[[response content]  objectFromJSONString];
    NSDictionary *respone_getDIC=[responeDic objectForKey:@"tbk_mobile_items_convert_response"];
    NSDictionary *tbk_items_DIC=[respone_getDIC objectForKey:@"tbk_items"];
    NSDictionary *tbk_item_DIC=[[NSArray arrayWithArray:[tbk_items_DIC objectForKey:@"tbk_item"]]lastObject];
   // NSLog(@"%@",[NSString stringWithFormat:@"%@",[[NSArray arrayWithArray:[tbk_items_DIC objectForKey:@"tbk_item"]]lastObject]]);
    
    NSLog(@"click_url is %@",[tbk_item_DIC objectForKey:@"click_url"]);
    return [tbk_item_DIC objectForKey:@"click_url"];
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
    NSDictionary *loginDic=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginDic"]];
    NSDictionary *tmpDic=[NSDictionary dictionaryWithDictionary: [self getJsonDictionary:[NSString stringWithFormat:@"/user/login/?account=%@&password=%@",[loginDic objectForKey:@"loginName"],[loginDic objectForKey:@"loginPWD"]]]];
    if (tmpDic!=nil)
    {
            NSDictionary *headDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"head"]];
            if ([[headDic objectForKey:@"msg"] isEqualToString:@"success"])
            {
                NSDictionary *idDic=[NSDictionary dictionaryWithDictionary:[tmpDic objectForKey:@"body"]];
                
                NSDictionary *userInfo=[NSDictionary dictionaryWithDictionary:[self getJsonDictionary:[NSString stringWithFormat:@"/user/profile/?id=%@",[idDic objectForKey:@"userId"]]]];
                [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"userInfo"];
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"logined"];
                return YES;
            }else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"logined"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
                return NO;
            }
    }else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"logined"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
        return NO;

    }
}
- (BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
	
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
	
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags)
    {
        NSLog(@"Error. Could not recover network reachability flags");
        return NO;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
	
    
	NSURL *testURL = [NSURL URLWithString:@"http://www.baidu.com/"];
	NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
	NSURLConnection *testConnection = [[NSURLConnection alloc] initWithRequest:testRequest delegate:self];
    return ((isReachable && !needsConnection) || nonWiFi) ? (testConnection ? YES : NO) : NO;
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
