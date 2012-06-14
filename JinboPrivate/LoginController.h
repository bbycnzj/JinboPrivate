//
//  LoginController.h
//  JinboPrivate
//
//  Created by Jinbo He on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginController : UIViewController {
    
    NSMutableString *_password;
}

- (IBAction)doSelectBtn:(id)sender;
- (IBAction)doLogin:(id)sender;

@end
