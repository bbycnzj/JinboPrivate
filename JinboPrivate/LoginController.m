//
//  LoginController.m
//  JinboPrivate
//
//  Created by Jinbo He on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginController.h"

@interface LoginController ()

@end

@implementation LoginController

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

    _password = [[NSMutableString alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
     
    [_password release];
    _password =nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)doSelectBtn:(id)sender
{
    UIButton *btn = sender;
    
    [_password appendString:[btn titleForState:UIControlStateNormal]];
}

- (IBAction)doLogin:(id)sender
{
    if ([_password isEqualToString:@"102925"]) {
        [self dismissModalViewControllerAnimated:YES];
    }
    
    [_password setString:@""];
}

@end
