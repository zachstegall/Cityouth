//
//  SignedInDelegate.h
//  FBC Youth
//
//  Created by Zach Stegall on 2/28/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//
//
//  This delegate is invoked when a user has successfully
//  completed a sign in.
//
//  Navigation Controller holds responsibility for this protocol.

#import <Foundation/Foundation.h>

@protocol SignedInDelegate <NSObject>
-(void)didFinishSigningIn;
@end
