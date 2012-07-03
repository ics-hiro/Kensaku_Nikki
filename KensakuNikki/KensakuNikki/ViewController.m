//
//  ViewController.m
//  KensakuNikki
//
//  Created by Hiroyuki Watanabe on 12/05/19.
//  Copyright (c) 2012年 Keio University. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"

@interface ViewController ()

@property (retain, nonatomic) UITableView *tableView;

@end

@implementation ViewController
{
    @private
    UITextField *tf;
    NSMutableArray *wArray;
    NSMutableArray *tArray;
    
    NSMutableArray *dateSection;
    
    NSString *iData;
}
@synthesize tableView = _tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 背景
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    // 検索窓
    tf =
    [[[UITextField alloc] initWithFrame:CGRectMake(35, 65, 250, 30)] autorelease];
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.returnKeyType = UIReturnKeySearch;
    tf.placeholder = @"検索";
    tf.clearButtonMode = UITextFieldViewModeAlways;
    [tf addTarget:self action:@selector(hoge:)
 forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:tf];
	
    
    // TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, 320, 365) style:UITableViewStyleGrouped] ;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    
    
    
    // 日別でTableViewのセクションを構成するための配列dateSection 重複をのぞくdistinctを使用
    NSArray*    paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString*   dir   = [paths objectAtIndex:0];
    FMDatabase* db    = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:@"searchLog.sqlite"]];
    
    
    dateSection = [[NSMutableArray alloc] init ];
    
    
    
    [db open];
    
    FMResultSet* fResult = [db executeQuery:@"select distinct date from words order by id desc"];
    while ([fResult next]) {
        iData = [fResult stringForColumn:@"date"];
        [dateSection addObject:iData];
        
    }
    
    [db close];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tf resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dateSection.count;
}

//--------------セクションタイトル----------------
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    for (int i = 0; i < [dateSection count]; i++) {
        if (section == i) {
            NSString *str = [[NSString alloc] initWithFormat:@"%@ 検索履歴",[dateSection objectAtIndex:i]];
            return str;
        }
    }
    
    return 0;
}
//--------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray*    paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString*   dir   = [paths objectAtIndex:0];
    FMDatabase* db    = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:@"searchLog.sqlite"]];
    wArray = [[NSMutableArray alloc] init ];
    [db open];
    for (int i = 0; i < [dateSection count]; i++) {
        if (section == i) {
            FMResultSet* fResult = [db executeQuery:@"select * from words where date = ?",[dateSection objectAtIndex:i]];
            while ([fResult next]) {
                iData = [fResult stringForColumn:@"words"];
                [wArray addObject:iData];
            }
            return [wArray count];
        }
    }
    [db close];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }
    
    wArray = [[NSMutableArray alloc] init ];
    
    NSArray*    paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString*   dir   = [paths objectAtIndex:0];
    FMDatabase* db    = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:@"searchLog.sqlite"]];
    [db open];
    
    for (int i = 0; i < [dateSection count]; i++) {
        if (indexPath.section == i) {
            FMResultSet *fResult = [db executeQuery:@"select * from words where date = ? order by id desc",[dateSection objectAtIndex:i]];
            while ([fResult next]) {
                iData = [fResult stringForColumn:@"words"];
                [wArray addObject:iData];
                
            }
            cell.textLabel.text = [wArray objectAtIndex:indexPath.row];
        }
    }
    
    [db close];   
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    wArray = [[NSMutableArray alloc] init ];
    
    NSArray*    paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString*   dir   = [paths objectAtIndex:0];
    FMDatabase* db    = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:@"searchLog.sqlite"]];
    [db open];
    
    for (int i = 0; i < [dateSection count]; i++) {
        if (indexPath.section == i) {
            FMResultSet *fResult = [db executeQuery:@"select * from words where date = ? order by id desc",[dateSection objectAtIndex:i]];
            while ([fResult next]) {
                iData = [fResult stringForColumn:@"words"];
                [wArray addObject:iData];
            }
            for (int m = 0; m < [wArray count]; m++) {
                if (indexPath.row == m) {
                    WebViewController *dialog = [[WebViewController alloc] init];
                    dialog.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                    dialog.encoded_word = [NSString stringWithString:[Util urlencode:[wArray objectAtIndex:m]]];
                    [self presentModalViewController:dialog animated:YES];
                }
            }
        }
    }
    
    [db close];
}

-(void)hoge:(UITextField*)textfield{
    
    
    NSArray*    paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString*   dir   = [paths objectAtIndex:0];
    FMDatabase* db    = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:@"searchLog.sqlite"]];
    
    NSString *strWords = [[NSString alloc] initWithFormat:@"%@",tf.text];
    
    NSDate *today = [NSDate date];
    NSLocale *locale_ja = [[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"] autorelease];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc]init] autorelease];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setLocale:locale_ja];
    NSString *strTime = [[NSString alloc] initWithFormat:@"%@",[formatter stringFromDate:today]];
    
    [db open];
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS words (id INTEGER PRIMARY KEY AUTOINCREMENT,words TEXT,date TEXT)"];
    [db beginTransaction];
    [db executeUpdate:@"INSERT INTO words (words,date) VALUES (?,?)",strWords,strTime];
    [db commit];
    [db close];
    
    
    WebViewController *dialog = [[[WebViewController alloc] init] autorelease];
    dialog.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    dialog.encoded_word = [NSString stringWithString:[Util urlencode:strWords]];
    [self presentModalViewController:dialog animated:YES];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [_tableView release];
    [dateSection release];
    [super dealloc];
}

@end
