//
//  ViewController.h
//  KensakuNikki
//
//  Created by Hiroyuki Watanabe on 12/05/19.
//  Copyright (c) 2012年 Keio University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Util.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    UITextField *tf;
    UITableView *_tableView;
    NSMutableArray *wArray;
    NSMutableArray *tArray;
    
    NSMutableArray *dateSection;
}

@property (retain, nonatomic) UITableView *tableView;
@property (nonatomic,retain) NSString *iData;
@end
