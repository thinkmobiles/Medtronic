//
//  Utils.h
//  homer
//
//  Created by Hanna Dutkiewicz on 11-03-21.
//  Copyright 2011 Looksoft Sp. z o. o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/**
 Class with global useful methods.
*/
@interface Utils : NSObject {
}

+ (NSDictionary *) getJSONFromString: (NSString *) jsonStr;

/**
 Creates and returns a JSON dictionary from data.
*/
+ (NSDictionary *) getJSONFromData: (NSData *) data;

/**
 Return BOOL from dictionary for a specific key.
 If there is no object for that key, returns defValue.
*/
+ (BOOL)        getBoolFromDict: (NSDictionary *) dict forKey:(NSString *) key withDefValue: (BOOL) defValue;

/**
 Return int from dictionary for a specific key.
 If there is no object for that key, returns defValue.
 */
+ (int)         getIntFromDict: (NSDictionary *) dict forKey:(NSString *) key withDefValue: (int) defValue;

+ (double)         getDoubleFromDict: (NSDictionary *) dict forKey:(NSString *) key withDefValue: (double) defValue;

/**
 Return NSString from dictionary for a specific key.
 If there is no object for that key, returns defValue.
 */
+ (NSString *)  getStringFromDict: (NSDictionary *) dict forKey:(NSString *) key withDefValue: (NSString *) defValue;

/**
 Return BOOL from dictionary for a specific key.
 If there is no object for that key, returns NO.
 */
+ (BOOL)        getBoolFromDict: (NSDictionary *) dict forKey:(NSString *) key;

/**
 Return int from dictionary for a specific key.
 If there is no object for that key, returns -1.
 */
+ (int)         getIntFromDict: (NSDictionary *) dict forKey:(NSString *) key;

+ (double)         getDoubleFromDict: (NSDictionary *) dict forKey:(NSString *) key;

/**
 Return NSString from dictionary for a specific key.
 If there is no object for that key, returns an empty string.
 */
+ (NSString *)  getStringFromDict: (NSDictionary *) dict forKey:(NSString *) key;

/**
 Return string representation of a BOOL ('0' == NO, '1' == YES)
 */
+ (NSString *) getStringFromBool: (BOOL) theBool;

/**
 Return string representation of an int.
 */
+ (NSString *) getStringFromInt: (int) theInt;

/**
 Return string representation of time (in ms).
 */
+ (NSString *) getStringFromTime: (int) s;

/**
 Return int representation of time string.
 */
+ (int) getTimeFromString: (NSString *) str;

/**
 Check if a string is representing a regular expression.
 */
+ (BOOL) checkRegularExpression: (NSString *) reg forString: (NSString *) str;

/**
 Check if an email is valid.
 */
+ (BOOL) validateEmail: (NSString *) str;

/**
 Check if a domain is valid.
 */
+ (BOOL) validateDomain: (NSString *) str;

/**
 Trims whitespaces from the beginning and the and of a string.
 */
+ (NSString *) trimWhitespaces: (NSString *) str;

/**
 Check if a word is valid.
 */
+ (BOOL) validateWord: (NSString *) str;

/**
 Check if an IP is valid.
 */
+ (BOOL) validateIP: (NSString *) str;

/**
 Check if an IPv6 is valid.
 */
+ (BOOL) validateIPv6: (NSString *) str;

/**
 Check if an URL is valid.
 */
+ (BOOL) validateURL: (NSString *) str;

/**
 Check if a dir is valid.
 */
+ (BOOL) validateDir: (NSString *) str;

+ (NSString *) textFromFile: (NSString *) fileStr;
+ (NSData *) dataFromFile: (NSString *) fileStr;

+ (NSString *) uppercaseSentence: (NSString *) str;

+ (NSString *) sha1: (NSString *) str;

+ (void) addVersionNumberToView: (UIView *) view;

+ (BOOL) textField: (UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string withMaximumLimit: (int) limit;

+ (BOOL) isiPhone5;

@end
