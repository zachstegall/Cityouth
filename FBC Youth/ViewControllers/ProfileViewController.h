//
//  ProfileViewController.h
//  FBC Youth
//
//  Created by Zach Stegall on 2/15/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//
//
//  This View Controller was created to give each user a profile.
//  It can be viewed by others and edited by the correct user.

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "ToggleDelegate.h"
#import "EditTableDelegate.h"
#import "Profile.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ProfileViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate>

// Objects
@property (nonatomic, strong) MenuViewController *MenuViewC;
@property (nonatomic, strong) Profile *editorsInfo;
@property (nonatomic, strong) Profile *tempProfileYouthView;
@property (nonatomic, strong) NSMutableDictionary *youthData;
@property (nonatomic, strong) NSArray *sectionHeaders;

// Controls
@property (nonatomic, strong) UITextField *name;
@property (nonatomic, strong) UITableView *youthProfileInfo;
@property (strong, nonatomic) UIBarButtonItem *listButton;
@property (strong, nonatomic) UIBarButtonItem *editButton;
@property (strong, nonatomic) UIBarButtonItem *doneButton;
@property (strong, nonatomic) UIBarButtonItem *backButton;

// Protocols
@property (weak, nonatomic) id <ToggleDelegate> delegate;
@property (weak, nonatomic) id <EditTableDelegate> tableDelegate;

// Public Methods
- (void)viewerSettings:(NSMutableDictionary *)selectedProfile;
- (void)editorSettings;
-(void)dishOutProfileData:(NSMutableDictionary *)data;

@end
