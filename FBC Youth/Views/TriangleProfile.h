//
//  TriangleProfile.h
//  FBC Youth
//
//  Created by Zach Stegall on 2/16/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//
//
//  This class was created to give the profile view a very
//  unique and indie feel. It draws a split black/white
//  background with a triangle on top.

#import <UIKit/UIKit.h>
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface TriangleProfile : UIView

@end
