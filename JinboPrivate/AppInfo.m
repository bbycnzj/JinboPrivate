//
//  AppInfo.m
//  JinboPrivate
//
//  Created by Jinbo He on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppInfo.h"

@implementation AppInfo

@synthesize appName,appUUID;

- (BOOL)compareSelector:(AppInfo *)info
{
    return [self.appName localizedCaseInsensitiveCompare:info.appName];
}

@end
