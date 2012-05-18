//
//  Util.h
//  testhiro
//
//  Created by Hiroyuki Watanabe on 12/03/29.
//  Copyright (c) 2012年 Keio University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject {
    
}
+ (NSString *)urlencode:(NSString *)text;
+ (NSString *)urldecode:(NSString *)text;
@end
