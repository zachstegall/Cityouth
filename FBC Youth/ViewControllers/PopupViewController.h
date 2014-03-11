//
//  PopupViewController.h
//  FBC Youth
//
//  Created by Zach Stegall on 2/14/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//
//
//  This View Controller was created to give youth a way
//  to answer Bus Ride invitations.

#import <UIKit/UIKit.h>
#import "RideDelegate.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface PopupViewController : UIViewController<UITextFieldDelegate>

// Controls
@property (strong, nonatomic) IBOutlet UIImageView *checkNo;
@property (strong, nonatomic) IBOutlet UIImageView *checkYes;
@property (strong, nonatomic) IBOutlet UITextField *location;
@property (strong, nonatomic) IBOutlet UIButton *send;

// Delegates
@property (weak, nonatomic) id <RideDelegate> delegate;

// User Interaction
- (IBAction)sendPressed:(UIButton *)sender;

@end
