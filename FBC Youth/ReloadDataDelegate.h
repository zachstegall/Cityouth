//
//  ReloadDataDelegate.h
//  FBC Youth
//
//  Created by Zach Stegall on 2/27/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//
//
//  This delegate is invoked when a user has decided to
//  refresh the current data in the application.
//
//  Navigation Controller holds responsibility for this protocol.

#import <Foundation/Foundation.h>

@protocol ReloadDataDelegate <NSObject>
-(void)didRequestReload;
@end
