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

@end

@implementation ViewController
@synthesize tableView = _tableView;
@synthesize iData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tf =
    [[[UITextField alloc] initWithFrame:CGRectMake(35, 65, 250, 30)] autorelease];
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.returnKeyType = UIReturnKeySearch;
    tf.placeholder = @"検索";
    tf.clearButtonMode = UITextFieldViewModeAlways;
    [tf addTarget:self action:@selector(hoge:)
 forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:tf];
	
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, 320, 365) style:UITableViewStyleGrouped] ;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
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
	// Do any additional setup after loading the view, typically from a nib.
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
            NSString *str = [[NSString alloc] initWithFormat:@"select * from words where date = '%@'",[dateSection objectAtIndex:i]];
            FMResultSet* fResult = [db executeQuery:str];
            while ([fResult next]) {
                iData = [fResult stringForColumn:@"words"];
                [wArray addObject:iData];
            }
            return [wArray count];
        }
    }
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
            NSString *str = [[NSString alloc] initWithFormat:@"select * from words where date = '%@' order by id desc",[dateSection objectAtIndex:i]];
            FMResultSet *fResult = [db executeQuery:str];
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
            NSString *str = [[NSString alloc] initWithFormat:@"select * from words where date = '%@' order by id desc",[dateSection objectAtIndex:i]];
            NSLog(@"%@",str);
            FMResultSet *fResult = [db executeQuery:str];
            while ([fResult next]) {
                iData = [fResult stringForColumn:@"words"];
                [wArray addObject:iData];
                //NSLog(@"%@",iData);
                
            }
            for (int m = 0; m < [wArray count]; m++) {
                if (indexPath.row == m) {
                    WebViewController *dialog = [[WebViewController alloc] init];
                    dialog.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                    dialog.eleData = [NSString stringWithString:[Util urlencode:[wArray objectAtIndex:m]]];
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
    
    NSString*   sqll = @"CREATE TABLE IF NOT EXISTS words (id INTEGER PRIMARY KEY AUTOINCREMENT,words TEXT,date TEXT)"; 
    
    NSDate *today = [NSDate date];
    NSLocale *locale_ja;
    locale_ja = [[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"] autorelease];
    NSDateFormatter *formatter;
    formatter = [[[NSDateFormatter alloc]init] autorelease];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    //[formatter setTimeStyle:NSDateFormatterMediumStyle];
    [formatter setLocale:locale_ja];
    NSString *strTime = [[NSString alloc] initWithFormat:@"%@",[formatter stringFromDate:today]];
    
    [db open];
    [db executeUpdate:sqll];
    [db beginTransaction];
    [db executeUpdate:@"INSERT INTO words (words,date) VALUES (?,?)",strWords,strTime];
    [db commit];
    [db close];
    
    
    WebViewController *dialog = [[[WebViewController alloc] init] autorelease];
    dialog.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    dialog.eleData = [NSString stringWithString:[Util urlencode:tf.text]];
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
    [iData release];
    [_tableView release];
    [dateSection release];
    [super dealloc];
}

@end
