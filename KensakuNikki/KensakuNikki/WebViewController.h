//
//  WebViewController.h
//  KensakuNikki
//
//  Created by Hiroyuki Watanabe on 12/05/19.
//  Copyright (c) 2012年 Keio University. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *wv;

// ViewControllerから受け渡されてくる、エンコーディング済みの検索ワード
@property (nonatomic,retain) NSString *encoded_word;

- (IBAction)toHome:(id)sender;
@end
