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
#import "PopupViewController.h"
#import "SuccessView.h"
#import "NavigationDelegate.h"
#import "ToggleDelegate.h"
#import "EditTableDelegate.h"
#import "ReloadDataDelegate.h"
#import "SignedInDelegate.h"
#import "RideDelegate.h"
#import "PushRideDelegate.h"

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
@property (nonatomic) SuccessView *successView;
//@property (nonatomic, strong) UIActivityIndicatorView *spinner;

// Public Methods
- (void)loadData;
- (void)editedForTableComplete: (BOOL)success items:(NSArray *)items;
- (void)answeredRideComplete: (BOOL)success answer:(NSString *)answer;
- (void)pushNotification:(NSString *)type text:(NSString *)message;
- (void)busRide;
- (void)newWallPostInBack;
- (void)newWallPostInFore;

@end
