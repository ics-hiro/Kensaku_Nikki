//
//  Util.m
//  testhiro
//
//  Created by Hiroyuki Watanabe on 12/03/29.
//  Copyright (c) 2012年 Keio University. All rights reserved.
//

#import "Util.h"

@implementation Util
//encode

+ (NSString *)urlencode:(NSString *)text
{
    CFStringRef strRef = CFURLCreateStringByAddingPercentEscapes(
                                                                 
                                                                 NULL,
                                                                 
                                                                 (CFStringRef)text,
                                                                 
                                                                 NULL,
                                                                 
                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]~",
                                                                 
                                                                 kCFStringEncodingUTF8);
    
    NSString * str = [NSString stringWithString:(NSString *)strRef];
    
    CFRelease(strRef);
    
    return str;
    
}

// decode

+ (NSString *)urldecode:(NSString *)text

{
    
    CFStringRef strRef = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                                 
                                                                                 NULL,
                                                                                 
                                                                                 (CFStringRef) text,
                                                                                 
                                                                                 CFSTR(""),
                                                                                 
                                                                                 kCFStringEncodingUTF8);
    
    NSString * str = [NSString stringWithString:(NSString *)strRef];
    
    CFRelease(strRef);
    
    return str;
    
}


@end
