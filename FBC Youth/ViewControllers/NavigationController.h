//
//  NavigationController.h
//  FBC Youth
//
//  Created by Zach Stegall on 2/15/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//
//
//  This Controller handles most protocols and also distributes
//  view controllers whenever the user asks for them.

#import <UIKit/UIKit.h>
#import "SignInViewController.h"
#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "WallViewController.h"
#import "NavigationDelegate.h"
#import "ToggleDelegate.h"
#import "EditTableDelegate.h"
#import "ReloadDataDelegate.h"
#import "SignedInDelegate.h"
#import "RideDelegate.h"
#import "PushRideDelegate.h"
#import "AFHTTPRequestOperationManager.h"

#define ServerApiURL @"http://198.58.106.245/youth/index.php"
#define ServerNotificationApiURL @"http://198.58.106.245/youth/sendnotifications.php"

@interface NavigationController : UINavigationController<NavigationDelegate, ToggleDelegate, EditTableDelegate, ReloadDataDelegate, SignedInDelegate, RideDelegate, PushRideDelegate>

// Objects
@property (nonatomic, strong) SignInViewController *SignInViewC;
@property (nonatomic, strong) HomeViewController *HomeViewC;
@property (nonatomic, strong) ProfileViewController *ProfileViewC;
@property (nonatomic, strong) WallViewController *WallViewC;
@property (nonatomic, strong) PopupViewController *PopViewC;

// Controls
@property (nonatomic, strong) NSMutableArray *viewCtrlsArray;
@property (nonatomic, strong) NSMutableDictionary *youthData;
@property (nonatomic, strong) NSMutableDictionary *wallData;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

// Public Methods
-(void)loadData;
-(void)pushNotification:(NSString *)type text:(NSString *)message;
-(void)busRide;
-(void)newWallPostInBack;
-(void)newWallPostInFore;

@end
