//
//  NavigationDelegate.h
//  FBC Youth
//
//  Created by Zach Stegall on 2/15/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//
//
//  This delegate is invoked when the user selects a View
//  from the MenuView. This delegate allows us to keep
//  the push and pop power within the Navigation Controller.
//
//  Navigation Controller holds responsibility for this protocol.

#import <Foundation/Foundation.h>

@protocol NavigationDelegate <NSObject>
- (void)didSelectViewController:(UIView *)fromView andView:(NSInteger)viewNum;
@end
