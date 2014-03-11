//
//  Profile.h
//  FBC Youth
//
//  Created by Zach Stegall on 2/24/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//
//  This class is to hold youth profile data. All fields but
//  'actualtoken' are included in this class. We have no
//  need for it. 'firstName', 'lastName', 'excitedAbout',
//  'objective', and 'versequote' are all editable in
//  each profile.

#import <Foundation/Foundation.h>

@interface Profile : NSObject

@property NSString *firstName;
@property NSString *lastName;
@property NSString *deviceToken;
@property NSString *signKey;
@property NSString *excitedAbout;
@property NSString *objective;
@property NSString *versequote;
@property NSString *location;

- (void)setObjectFromDictionary:(NSMutableDictionary *)dict;

@end
