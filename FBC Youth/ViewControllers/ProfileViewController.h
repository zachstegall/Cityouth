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

@interface ProfileViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

// Objects
@property (nonatomic) MenuViewController *MenuViewC;
@property (nonatomic) Profile *editorsInfo;
@property (nonatomic) Profile *tempProfileYouthView;
@property (nonatomic) NSMutableDictionary *youthData;
@property (nonatomic) NSArray *sectionHeaders;

// Controls
@property (nonatomic) UILabel *firstName;
@property (nonatomic) UITableView *youthProfileInfo;
@property (nonatomic) UIImageView *profileImgView;
@property (nonatomic) UIBarButtonItem *listButton;
@property (nonatomic) UIBarButtonItem *editButton;
@property (nonatomic) UIBarButtonItem *doneButton;
@property (nonatomic) UIBarButtonItem *backButton;
@property (nonatomic) UIButton *page;
@property (nonatomic) UIButton *info;
@property (nonatomic) UITableView *tableViewAccount;
@property (nonatomic) UITextField *firstNameAccount;
@property (nonatomic) UITextField *lastNameAccount;
//@property (nonatomic) UITextField *password;
//@property (nonatomic) UITextField *retypePassword;

// Protocols
@property (weak, nonatomic) id <ToggleDelegate> delegate;
@property (weak, nonatomic) id <EditTableDelegate> tableDelegate;

// Public Methods
- (void)viewerSettings:(NSMutableDictionary *)selectedProfile;
- (void)editorSettings;
- (void)dishOutProfileData:(NSMutableDictionary *)data;
- (void)dishOutProfileDataCache:(NSMutableDictionary *)data;

@end
