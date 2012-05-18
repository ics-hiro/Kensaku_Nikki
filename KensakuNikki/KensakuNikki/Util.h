//
//  Util.h
//  KensakuNikki
//
//  Created by Hiroyuki Watanabe on 12/05/19.
//  Copyright (c) 2012年 Keio University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject {
    
}
+ (NSString *)urlencode:(NSString *)text;
+ (NSString *)urldecode:(NSString *)text;
@end
