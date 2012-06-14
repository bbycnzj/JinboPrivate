//
//  AppDelegate.m
//  JinboPrivate
//
//  Created by Jinbo He on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "RootController.h"
#import "LoginController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[RootController alloc] initWithNibName:@"RootController" bundle:nil] autorelease];
    self.window.rootViewController = self.viewController;
    
    [self.window makeKeyAndVisible];
    
    [self applicationWillEnterForeground:application];
    
    return YES;
}

- (void)showLogin
{
    LoginController *login = [[LoginController alloc] init];
    
    login.modalPresentationStyle = UIModalPresentationFormSheet;
    login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.viewController presentModalViewController:login animated:YES];
    [login release];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if ([self.viewController.modalViewController class] == [LoginController class]) {
        return;
    }
    [self performSelector:@selector(showLogin) withObject:nil afterDelay:0.0];
}

@end
