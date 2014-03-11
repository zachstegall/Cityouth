//
//  AppDelegate.h
//  FBC Youth
//
//  Created by Zach Stegall on 1/14/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInViewController.h"
#import "NavigationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SignInViewController *sVC;
@property (strong, nonatomic) NavigationController *navController;

@property NSString *adminKey;
@property NSString *youthKey;

@end
