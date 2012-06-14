//
//  ViewController.h
//  JinboPrivate
//
//  Created by Jinbo He on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray  *_appLists;
    NSArray         *_appSearchLists;
    NSMutableArray  *_fileMoves;
    
    BOOL _isAppList;
    
    IBOutlet UITableView *_table;
    IBOutlet UITextField *_textUUID;
    IBOutlet UISearchBar *_searchBar;
    
	UISearchDisplayController *_searchController;
}

- (IBAction)doBianli:(id)sender;
- (IBAction)doFileList:(id)sender;
- (IBAction)doMoveFile:(id)sender;
- (IBAction)doRemoveFile:(id)sender;
@end
