//
//  NameLocation.m
//  FBC Youth
//
//  Created by Zach Stegall on 3/3/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//

#import "NameLocation.h"

@implementation NameLocation

-(id)init
{
    self = [super init];
    if (self) {
        _name = @"";
        _location = @"";
    }
    
    return self;
}

-(void)setNameAndLocation:(NSString *)name loc:(NSString *)location
{
    if (name != (id)[NSNull null])
        _name = name;
    
    if (location != (id)[NSNull null])
        _location = location;
}

@end
