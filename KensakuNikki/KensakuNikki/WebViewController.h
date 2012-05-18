//
//  WebViewController.h
//  Cooclen
//
//  Created by Hiroyuki Watanabe on 12/04/07.
//  Copyright (c) 2012年 Keio University. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *wv;
@property (nonatomic,retain) NSString *eleData;
- (IBAction)toHome:(id)sender;

@end
