//
//  ProfileCell.h
//  FBC Youth
//
//  Created by Zach Stegall on 2/17/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//
//
//  This cell object is used by ProfileViewController to
//  allow editing text in each cell.

#import <UIKit/UIKit.h>
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ProfileCell : UITableViewCell<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textView;

@end
