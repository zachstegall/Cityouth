//
//  AskForRideDelegate.h
//  FBC Youth
//
//  Created by Zach Stegall on 3/3/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//
//
//  This delegate is invoked when an administrator has
//  successfully submitted a message for a bus ride
//  notification to be sent out.
//
//  Wall View Controller holds responsibility for this protocol.

#import <Foundation/Foundation.h>

@protocol AskForRideDelegate <NSObject>
-(void)didFinishSendingRideQuestion:(NSString *)message;
@end
