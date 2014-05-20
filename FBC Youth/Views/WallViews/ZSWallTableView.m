//
//  ZSWallTableView.m
//  Cityouth
//
//  Created by Zach Stegall on 5/15/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//

#import "ZSWallTableView.h"

@implementation ZSWallTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.separatorInset = UIEdgeInsetsZero;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}



@end
