//
//  WallViewController.h
//  FBC Youth
//
//  Created by Zach Stegall on 2/17/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//
//
//  This View Controller was created to display the output
//  of wall posts. Any news, thoughts, iloveyous by the
//  adminstrators can be posted here. Also, bus ride
//  invitations can be sent from here.

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "ToggleDelegate.h"
#import "Wall.h"
#import "WriteMessageViewController.h"
#import "ZSWallTableView.h"

#import "WallPostDelegate.h"
#import "AskForRideDelegate.h"
#import "EditTableDelegate.h"
#import "ReloadDataDelegate.h"
#import "PushRideDelegate.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface WallViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, WallPostDelegate, AskForRideDelegate>

// Objects
@property (nonatomic, strong) WriteMessageViewController *WriteMessageViewC;
@property (nonatomic, strong) MenuViewController *MenuViewC;
@property (nonatomic, strong) NSMutableArray *wallData;

// Controls
@property (nonatomic, strong) ZSWallTableView *wallOfPosts;

// Delegates
@property (weak, nonatomic) id <ToggleDelegate> delegate;
@property (weak, nonatomic) id <EditTableDelegate> tableDelegate;
@property (weak, nonatomic) id <ReloadDataDelegate> reloadDelegate;
@property (weak, nonatomic) id <PushRideDelegate> pushRideDelegate;

// Public Methods
-(void)dishOutWallData:(NSMutableDictionary *)data;

@end
