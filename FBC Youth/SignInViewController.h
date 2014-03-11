//
//  SignInViewController.h
//  FBC Youth
//
//  Created by Zach Stegall on 2/8/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//
//
//  This View Controller was created solely for signing in
//  purposes. There is a good chance that every user will
//  only see this view once.

#import <UIKit/UIKit.h>
#import "SignedInDelegate.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface SignInViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

// Controls
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UITableView *tableViewLogIn;
@property (strong, nonatomic) UIButton *signInBtn;
@property (strong, nonatomic) UITextField *firstName;
@property (strong, nonatomic) UITextField *lastName;
@property (strong, nonatomic) UITextField *key;

// Protocols
@property (weak, nonatomic) id <SignedInDelegate> delegate;

// Public Methods
- (NSString *)createUUID;

@end
