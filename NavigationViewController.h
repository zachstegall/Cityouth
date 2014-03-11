//
//  NavigationViewController.h
//  FBC Youth
//
//  Created by Zach Stegall on 2/11/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationViewController : UINavigationController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UITableView *allYouthTable;

@property (nonatomic, strong) NSMutableArray *namesArray;

@end
