//
//  WriteMessageViewController.h
//  FBC Youth
//
//  Created by Zach Stegall on 2/24/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//
//
//  This View Controller was created to give administrators
//  the ability to write a message for a new wall post or
//  the message to be delivered along with a bus ride
//  invitation.

#import <UIKit/UIKit.h>
#import "WallPostDelegate.h"
#import "AskForRideDelegate.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface WriteMessageViewController : UIViewController

// Controls
@property (strong, nonatomic) UITextView *messageView;
@property (strong, nonatomic) UIButton *newsButton;
@property (strong, nonatomic) UIButton *thoughtButton;
@property (strong, nonatomic) UIButton *iloveyouButton;
@property (strong, nonatomic) UIButton *busRideButton;

// Delegates
@property (weak, nonatomic) id <WallPostDelegate> delegate;
@property (weak, nonatomic) id <AskForRideDelegate> rideDelegate;

@end
