//
//  MenuViewController.h
//  FBC Youth
//
//  Created by Zach Stegall on 2/15/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//
//
//  This View Controller was created to give users a menu
//  list of views to visit.

#import <UIKit/UIKit.h>
#import "NavigationDelegate.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

// Objects
@property (nonatomic, strong) NSMutableArray *namesArray;
@property (nonatomic, strong) NSArray *menuItems;

// Controls
@property (nonatomic, strong) UITableView *menu;
@property (nonatomic, strong) UIImageView *dotView;

// Delegates
@property (weak, nonatomic) id <NavigationDelegate> delegate;

// Public Methods
-(void)newWallPostDot;
-(void)viewedNewWallPost;

@end
