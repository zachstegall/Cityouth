//
//  RideDelegate.h
//  FBC Youth
//
//  Created by Zach Stegall on 2/15/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//
//
//  This delegate is invoked when a user (youth) has
//  replied to a Ride question.
//
//  Navigation Controller holds responsibility for this protocol.

#import <Foundation/Foundation.h>

@protocol RideDelegate <NSObject>
- (void)didFinishAnsweringRide:(NSString *)location item:(NSString *)answer;
@end
