//
//  NameLocation.h
//  FBC Youth
//
//  Created by Zach Stegall on 3/3/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//
//  This class was created for convenience. These properties
//  allow administrators to feasibly swipe back and forth
//  between youth's name and location.

#import <Foundation/Foundation.h>

@interface NameLocation : NSObject

@property NSString *name;
@property NSString *location;

- (void)setNameAndLocation:(NSString *)name loc:(NSString *)location;

@end
