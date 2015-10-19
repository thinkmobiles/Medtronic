//
//  Utils.m
//  homer
//
//  Created by Hanna Dutkiewicz on 11-03-21.
//  Copyright 2011 Looksoft Sp. z o. o. All rights reserved.
//

#import "Utils.h"
#import "JSON.h"
#import <CommonCrypto/CommonDigest.h>

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@implementation Utils


+ (NSDictionary *) getJSONFromData: (NSData *) data{
	
		NSString * jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSDictionary * dictionary = [[NSDictionary alloc] initWithDictionary:[jsonStr JSONValue]] ;
		
		if ([[dictionary allValues] count] == 0) { 
			@throw [NSException exceptionWithName:@"wrong json" reason:@"" userInfo:nil];
		}
		
		return dictionary;
}

+ (NSDictionary *) getJSONFromString: (NSString *) jsonStr{
	
    NSDictionary * dictionary = [[NSDictionary alloc] initWithDictionary:[jsonStr JSONValue]] ;
    
    if ([[dictionary allValues] count] == 0) { 
        @throw [NSException exceptionWithName:@"wrong json" reason:@"" userInfo:nil];
    }
    
    return dictionary;
}


+ (BOOL)        getBoolFromDict: (NSDictionary *) dict forKey:(NSString *) key withDefValue: (BOOL) defValue{
    NSString * boo = [dict objectForKey: key];
    if (boo == nil || (NSNull*)boo == [NSNull null]) {
        return defValue;
    }
    return ([boo intValue] == 1);
}

+ (int)         getIntFromDict: (NSDictionary *) dict forKey:(NSString *) key withDefValue: (int) defValue{
    NSString * str = [dict objectForKey: key];
    if (str == nil  || (NSNull*)str == [NSNull null]) {
        return defValue;
    }
    return [str intValue];
}

+ (double)         getDoubleFromDict: (NSDictionary *) dict forKey:(NSString *) key withDefValue: (double) defValue{
    NSString * str = [dict objectForKey: key];
    if (str == nil  || (NSNull*)str == [NSNull null]) {
        return defValue;
    }
    return [str doubleValue];
}

+ (NSString *)  getStringFromDict: (NSDictionary *) dict forKey:(NSString *) key withDefValue: (NSString *) defValue{
    NSString * str = [dict objectForKey: key];
    if (str == nil  || (NSNull*)str == [NSNull null]) {
        return defValue;
    }
    return str;
}

+ (BOOL)        getBoolFromDict: (NSDictionary *) dict forKey:(NSString *) key{
    return [self getBoolFromDict:dict forKey:key withDefValue:NO];
}

+ (int)         getIntFromDict: (NSDictionary *) dict forKey:(NSString *) key{
    return [self getIntFromDict:dict forKey:key withDefValue:-1];
}

+ (double)getDoubleFromDict:(NSDictionary *)dict forKey:(NSString *)key{
    return [self getDoubleFromDict:dict forKey:key withDefValue:0];
}

+ (NSString *)  getStringFromDict: (NSDictionary *) dict forKey:(NSString *) key{
    return [self getStringFromDict:dict forKey:key withDefValue: @""];
}

+ (NSString *) getStringFromInt: (int) theInt{
    return [[NSString alloc] initWithFormat:@"%d", theInt];
}

+ (NSString *) getStringFromBool: (BOOL) theBool{
    return (theBool ? @"1" : @"0");
}

+ (NSString *) getStringFromTime: (int) s{
    float h = s/3600.0f;
    if (h == 1) {
        return @"1 godzina";
    }
    else if(h == 2 || h == 3 || h == 4 || h == 22 || h == 23){
        return [NSString stringWithFormat:@"%d godziny", (int)h] ;
    }
    else if(h < 24){
        return [NSString stringWithFormat:@"%d godzin", (int)h];
    }
    
    float d = h/24.0f;
    
    if (d == 1) {
        return @"1 dzień";
    }
    else {
        return [NSString stringWithFormat:@"%d dni", (int)d];
    }
}

+ (int) getTimeFromString: (NSString *) str{
    int s = 0;
    if ([str hasSuffix: @"godzina"]) {
        return 3600;
    }
    else if([str hasSuffix: @"godziny"]){
        s = [[str substringToIndex: [str length]-7] intValue];
        return s*3600;
    }
    else if([str hasSuffix: @"godzin"]){
        s = [[str substringToIndex: [str length]-6] intValue];
        return s*3600;
    }
    else if([str hasSuffix:@"dzień"]){
        //s = [[str substringToIndex: [str length]-5] intValue];
        return 3600*24;
    }
    else{
        s = [[str substringToIndex: [str length]-3] intValue];
        return s*3600*24;
    }
}

+ (BOOL) checkRegularExpression: (NSString *) reg forString: (NSString *) str{
    NSError * error = nil;
    NSRegularExpression * exp = [NSRegularExpression regularExpressionWithPattern: reg options:NSRegularExpressionSearch error:&error];
    if (error) {
        return NO;
    }
    
    NSRange range = [exp rangeOfFirstMatchInString: str options:0 range: NSMakeRange(0, [str length])];   
    if (range.length != str.length) {
        return NO;
    }
    return YES;
}

+ (BOOL) validateEmail: (NSString *) str{
    return [self checkRegularExpression: @"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]" forString: str];
}

+ (BOOL) validateDomain:(NSString *)str{
    return [self checkRegularExpression: @"^[a-zA-Z0-9_.-]+.[a-zA-Z]" forString:str];
}

+ (NSString *) trimWhitespaces: (NSString *) str{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (BOOL) validateWord: (NSString *) str{
    return [self checkRegularExpression: @"^[a-zA-Z0-9]" forString:str];
}

+ (BOOL) validateIP: (NSString *) str{
    return [self checkRegularExpression: @"^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$" forString:str];
}

+ (BOOL) validateIPv6: (NSString *) str{
    return [self checkRegularExpression: @"^:?([a-fA-F0-9]{1,4}(:|.)?){0,8}(:|::)?([a-fA-F0-9]{1,4}(:|.)?){0,8}$" forString:str];
}

+ (BOOL)validateURL:(NSString *)str{
    return YES;
    //return [self checkRegularExpression: @"(^(http|https|ftp)://[a-zA-Z0-9_-.]+.[a-zA-Z]{2,6})|([a-zA-Z0-9_-.]+.[a-zA-Z]{2,6})" forString:str];
}

+ (BOOL) validateDir: (NSString *) str{
    return [self checkRegularExpression: @"\[a-zA-Z0-9_-.]" forString:str];
}

+ (NSString *) textFromFile: (NSString *) fileStr{
    NSString *filePath = [[NSBundle mainBundle] pathForResource: fileStr ofType:@"txt"];
    NSError * error = nil;
    NSString * str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error: &error];
    return str;
}

+ (NSData *) dataFromFile: (NSString *) fileStr{
    NSString *filePath = [[NSBundle mainBundle] pathForResource: fileStr ofType:@"txt"];
    NSData * data = [NSData dataWithContentsOfFile: filePath];
    return data;
}

+ (NSString *)uppercaseSentence:(NSString *)str{
     return [str stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[str  substringToIndex:1] capitalizedString]];
}

+ (NSString *)sha1:(NSString *)str{
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+ (void)addVersionNumberToView: (UIView *) view{
    NSString *appVersionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(2, 20, 200, 20)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText: appVersionNumber];
    [label setFont: [UIFont boldSystemFontOfSize:12.0]];
    [label setTextColor: [UIColor blackColor]];
    [view addSubview: label];
    [view bringSubviewToFront: label];
}

+ (BOOL) textField: (UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string withMaximumLimit: (int) limit{
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > limit) ? NO : YES;
}

+ (BOOL) isiPhone5{
    return [UIScreen mainScreen].bounds.size.height > 480;
}

@end
