//
//  WallPostDelegate.h
//  FBC Youth
//
//  Created by Zach Stegall on 2/27/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//
//
//  This delegate is invoked when an administrator has
//  completed a post or a bus ride invitation and decided
//  to submit.
//
//  Wall View Controller holds responsibility for this protocol.

#import <Foundation/Foundation.h>

@protocol WallPostDelegate <NSObject>
- (void)didFinishWritingPost:(NSString *)message type:(NSString *)icon;
@end
