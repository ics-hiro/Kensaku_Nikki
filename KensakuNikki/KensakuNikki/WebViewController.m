//
//  WebViewController.m
//  KensakuNikki
//
//  Created by Hiroyuki Watanabe on 12/05/19.
//  Copyright (c) 2012年 Keio University. All rights reserved.
//

#import "WebViewController.h"
#import "ViewController.h"


@interface WebViewController ()

@end

@implementation WebViewController
@synthesize wv;
@synthesize eleData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *urlStr = [[NSString alloc] initWithFormat:@"http://www.google.co.jp/search?q=%@",eleData];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.wv loadRequest:request];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setWv:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)toHome:(id)sender {
    ViewController *dialog = [[ViewController alloc] init];
    dialog.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:dialog animated:YES];
}


- (void)dealloc {
    [super dealloc];
}
@end
