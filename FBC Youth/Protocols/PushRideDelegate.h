//
//  PushRideDelegate.h
//  FBC Youth
//
//  Created by Zach Stegall on 3/3/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//
//
//  This delegate is invoked to complete the notification for a
//  bus ride message.
//
//  Navigation Controller holds responsibility for this protocol.

#import <Foundation/Foundation.h>

@protocol PushRideDelegate <NSObject>
-(void)didWantToSendRideQuestion:(NSString *)message;
@end
