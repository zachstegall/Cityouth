//
//  HomeViewController.h
//  FBC Youth
//
//  Created by Zach Stegall on 2/11/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//
//
//  This View Controller will display the names of all of
//  the users. For administrators, the locations for the
//  youth will also be available. Each users profile can
//  be accessed upon selection of their name in the cell.

#import <UIKit/UIKit.h>
#import "PopupViewController.h"
#import "ProfileViewController.h"
#import "MenuViewController.h"
#import "ToggleDelegate.h"
#import "ReloadDataDelegate.h"
#import "NameLocation.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface HomeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

// Objects
@property (nonatomic, strong) PopupViewController *PopViewC;
@property (nonatomic, strong) MenuViewController *MenuViewC;
@property (nonatomic, strong) NSMutableDictionary *youthData;
@property (nonatomic, strong) NSMutableArray *namesArray;
@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSMutableArray *colorsForNames;

// Controls
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UITableView *allYouthTable;
@property (nonatomic, strong) UITableView *menu;
@property (nonatomic, strong) UIView *menuView;

// Protocols
@property (weak, nonatomic) id <ToggleDelegate> delegate;
@property (weak, nonatomic) id <ReloadDataDelegate> reloadDelegate;

// Public Methods
-(void)dishOutHomeData:(NSMutableDictionary *)data;

@end
