//
//  Profile.m
//  FBC Youth
//
//  Created by Zach Stegall on 2/24/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//

#import "Profile.h"

@implementation Profile

-(id)init
{
    self = [super init];
    if (self) {
        _firstName = @"";
        _lastName = @"";
        _deviceToken = @"";
        _signKey = @"";
        _excitedAbout = @"";
        _objective = @"";
        _versequote = @"";
        _location = @"";
    }
    return self;
}

-(void)setObjectFromDictionary:(NSDictionary *)dict
{
    if ([dict objectForKey:@"firstname"] != (id)[NSNull null])
        _firstName = [dict objectForKey:@"firstname"];
    
    if ([dict objectForKey:@"lastname"] != (id)[NSNull null])
        _lastName = [dict objectForKey:@"lastname"];
    
    if ([dict objectForKey:@"device_token"] != (id)[NSNull null])
        _deviceToken = [dict objectForKey:@"device_token"];
    
    if ([dict objectForKey:@"signkey"] != (id)[NSNull null])
        _signKey = [dict objectForKey:@"signkey"];
    
    if ([dict objectForKey:@"excitedabout"] != (id)[NSNull null])
        _excitedAbout = [dict objectForKey:@"excitedabout"];
    
    if ([dict objectForKey:@"objective"] != (id)[NSNull null])
        _objective = [dict objectForKey:@"objective"];
    
    if ([dict objectForKey:@"versequote"] != (id)[NSNull null])
        _versequote = [dict objectForKey:@"versequote"];
    
    if ([dict objectForKey:@"location" ] != (id)[NSNull null])
        _location = [dict objectForKey:@"location"];
}

@end
