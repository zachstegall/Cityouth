//
//  ImageScale.m
//  FBC Youth
//
//  Created by Zach Stegall on 4/3/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//

#import "ImageScale.h"

@implementation ImageScale

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
