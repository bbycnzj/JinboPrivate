//
//  ViewController.m
//  JinboPrivate
//
//  Created by Jinbo He on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RootController.h"
#import "AppInfo.h"

@interface RootController ()

@end

@implementation RootController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _appLists = [[NSMutableArray alloc] init];
    _fileMoves = [[NSMutableArray alloc] init];
    _table.delegate = self;
    _table.dataSource = self;
    
    NSString *libPath =[NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
    libPath = [libPath stringByAppendingPathComponent:@"config.dict"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:libPath];
    
    _textUUID.text = [[dict allKeys] objectAtIndex:0];
    
    _searchController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
	_searchController.searchResultsDataSource = self;
	_searchController.searchResultsDelegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSString *)getAppName:(NSString *)path uuid:(NSString *)uuid
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *appPath = [path stringByAppendingPathComponent:uuid];
    NSArray *contents = [fm contentsOfDirectoryAtPath:appPath error:nil];
    for (NSString *name in contents) {
        
        if ([name hasSuffix:@".app"]) {
            return name;
        }
    }
    
    return nil;
}

- (IBAction)doBianli:(id)sender
{
    _isAppList = YES;
    [_appLists removeAllObjects];
    
    NSString *path = @"/var/mobile/Applications/";
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *arrUUIDs = [fm contentsOfDirectoryAtPath:path error:nil];
    
    for (NSString *uuid in arrUUIDs) {
        AppInfo *info = [[AppInfo alloc] init];
        
        info.appUUID = uuid;
        info.appName = [self getAppName:path uuid:uuid];
        
        [_appLists addObject:info];
        [info release];
    }
    
    [_appLists sortUsingSelector:@selector(compareSelector:)];
    [_table reloadData];
}

- (IBAction)doFileList:(id)sender
{
    _isAppList = NO;
    [_appLists removeAllObjects];
    
    NSString *path = NSHomeDirectory();
    NSFileManager *fm = [NSFileManager defaultManager];
    path = [path stringByAppendingPathComponent:@"Documents"];
    NSArray *fileLists = [fm contentsOfDirectoryAtPath:path error:nil];
    
    for (NSString *name in fileLists) {
        AppInfo *info = [[AppInfo alloc] init];
        
        info.appUUID = nil;
        info.appName = name;
        
        [_appLists addObject:info];
        [info release];
    }
    
    [_appLists sortUsingSelector:@selector(compareSelector:)];
    [_table reloadData];
}

- (IBAction)doMoveFile:(id)sender
{
    NSString *path = NSHomeDirectory();
    NSString *toPath = @"/var/mobile/Applications/";
    NSFileManager *fm = [NSFileManager defaultManager];
    
    toPath = [toPath stringByAppendingPathComponent:_textUUID.text];
    toPath = [toPath stringByAppendingPathComponent:@"Documents"];
    path = [path stringByAppendingPathComponent:@"Documents"];
    
    
    if (!_isAppList) {
        
        for (NSString *file in _fileMoves) {
            NSString *filePath = path;
            NSString *toFilePath = toPath;

            filePath = [filePath stringByAppendingPathComponent:file];
            toFilePath = [toFilePath stringByAppendingPathComponent:file];
            
            [fm moveItemAtPath:filePath toPath:toFilePath error:nil];

        }
        
        NSDictionary *dict = [NSDictionary dictionaryWithObject:_fileMoves forKey:_textUUID.text];
        NSString *libPath =[NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
        libPath = [libPath stringByAppendingPathComponent:@"config.dict"];
        [dict writeToFile:libPath atomically:YES];
    }
    
    [self doFileList:nil];
}

- (IBAction)doRemoveFile:(id)sender
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *libPath =[NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
    libPath = [libPath stringByAppendingPathComponent:@"config.dict"];

    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:libPath];
    
    _textUUID.text = [[dict allKeys] objectAtIndex:0];
    
    [_fileMoves release];
    _fileMoves = [[dict objectForKey:_textUUID.text] retain];
    
    NSString *path = NSHomeDirectory();
    NSString *toPath = @"/var/mobile/Applications/";
    
    toPath = [toPath stringByAppendingPathComponent:_textUUID.text];
    toPath = [toPath stringByAppendingPathComponent:@"Documents"];
    path = [path stringByAppendingPathComponent:@"Documents"];
    for (NSString *file in _fileMoves) {
        NSString *filePath = path;
        NSString *toFilePath = toPath;
        
        filePath = [filePath stringByAppendingPathComponent:file];
        toFilePath = [toFilePath stringByAppendingPathComponent:file];
        
        [fm moveItemAtPath:toFilePath toPath:filePath error:nil];
    }
    
    [_fileMoves removeAllObjects];
    dict = [NSDictionary dictionaryWithObject:_fileMoves forKey:_textUUID.text];
    [dict writeToFile:libPath atomically:YES];
    
    [self doFileList:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _searchController.searchResultsTableView) {
        
        [_appSearchLists release];
        _appSearchLists = nil;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.appName contains[cd] %@", _searchBar.text];
 
        _appSearchLists = [[_appLists filteredArrayUsingPredicate:predicate] retain];
        
        return _appSearchLists.count;
    }
    return _appLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    AppInfo *info = [_appLists objectAtIndex:indexPath.row];
    if (tableView == _searchController.searchResultsTableView) {
        info = [_appSearchLists objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = info.appName;
    cell.detailTextLabel.text = info.appUUID;
    
    return cell;
}

 
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppInfo *info = [_appLists objectAtIndex:indexPath.row];
    if (tableView == _searchController.searchResultsTableView) {
        info = [_appSearchLists objectAtIndex:indexPath.row];
    }
    
    if (_isAppList) {
        
        _textUUID.text = info.appUUID;
    }
    else {
        
        [_fileMoves addObject:info.appName];
    }
}

@end
