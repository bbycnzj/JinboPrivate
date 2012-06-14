//
//  AppInfo.h
//  JinboPrivate
//
//  Created by Jinbo He on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppInfo : NSObject {

    NSString *appName;
    NSString *appUUID;
}

@property(nonatomic, retain) NSString *appName;
@property(nonatomic, retain) NSString *appUUID;

@end
