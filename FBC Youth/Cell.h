//
//  Cell.h
//  FBC Youth
//
//  Created by Zach Stegall on 1/15/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//
//
//  This cell object is used by MenuViewController. 

#import <UIKit/UIKit.h>
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//#define ServerApiURL @"http://198.58.106.245/youth/"

@interface Cell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *name;

@end
