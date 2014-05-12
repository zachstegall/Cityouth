//
//  ImageScale.h
//  FBC Youth
//
//  Created by Zach Stegall on 4/3/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageScale : NSObject

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

@end
