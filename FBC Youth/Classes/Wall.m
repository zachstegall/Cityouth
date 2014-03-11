//
//  Wall.m
//  FBC Youth
//
//  Created by Zach Stegall on 2/24/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//

#import "Wall.h"

@implementation Wall

-(id)init
{
    self = [super init];
    if (self) {
        _message = @"";
        _icon = @"";
        _datestamp = [NSDate date];
    }
    return self;
}

@end
