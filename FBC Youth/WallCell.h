//
//  WallCell.h
//  FBC Youth
//
//  Created by Zach Stegall on 2/17/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//
//
//  This cell object is used by WallViewController to contain
//  a left-aligned, centered icon to accommodate a post.

#import <UIKit/UIKit.h>
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface WallCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *message;
@property (strong, nonatomic) IBOutlet UIImageView *icon;

@end
