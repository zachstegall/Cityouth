//
//  ToggleDelegate.h
//  FBC Youth
//
//  Created by Zach Stegall on 2/16/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//
//
//  This delegate is invoked when the list uibarbuttonitem
//  is pressed. It gives control to Navigation Controller
//  to raise or lower the MenuView for all View Controller.
//  It makes transitions with the MenuView very smooth.
//
//  Navigation Controller holds responsibility for this protocol.

#import <Foundation/Foundation.h>

@protocol ToggleDelegate <NSObject>
- (void)didToggle;
@end
