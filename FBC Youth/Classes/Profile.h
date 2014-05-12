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

@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *deviceToken;
@property (nonatomic) NSString *signKey;
@property (nonatomic) NSString *excitedAbout;
@property (nonatomic) NSString *objective;
@property (nonatomic) NSString *versequote;
@property (nonatomic) NSString *location;
@property (nonatomic) NSString *imagepath;
//@property (nonatomic) UIImage *profileImage;

- (void)setObjectFromDictionary:(NSMutableDictionary *)dict;

@end
