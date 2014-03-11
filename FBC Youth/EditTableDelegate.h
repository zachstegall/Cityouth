//
//  EditTableDelegate.h
//  FBC Youth
//
//  Created by Zach Stegall on 2/27/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//
//
//  This delegate is invoked when an administrator has updated
//  the Wall View with a new post or when a user has updated their
//  profile.
//
//  Navigation Controller holds responsibility for this protocol.

#import <Foundation/Foundation.h>

@protocol EditTableDelegate <NSObject>
- (void)didEditForTable:(NSArray *)items;
@end
