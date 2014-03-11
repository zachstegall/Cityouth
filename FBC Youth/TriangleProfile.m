//
//  TriangleProfile.m
//  FBC Youth
//
//  Created by Zach Stegall on 2/16/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//

#import "TriangleProfile.h"

@implementation TriangleProfile

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = UIColorFromRGB(0x222222);
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    // Top half 222222 for background
    CGContextRef topTX = UIGraphicsGetCurrentContext();
    CGContextBeginPath(topTX);
    CGContextMoveToPoint(topTX, CGRectGetMinX(rect), CGRectGetMinY(rect)); // top left
    CGContextAddLineToPoint(topTX, CGRectGetMinX(rect), CGRectGetMidY(rect)); // mid left
    CGContextAddLineToPoint(topTX, CGRectGetMaxX(rect), CGRectGetMidY(rect)); // mid right
    CGContextAddLineToPoint(topTX, CGRectGetMaxX(rect), CGRectGetMinY(rect)); // top right
    CGContextClosePath(topTX);
    
    CGContextSetRGBFillColor(topTX, (34.0f/255.0f), (34.0f/255.0f), (34.0f/255.0f), 1);
    CGContextFillPath(topTX);
    
    // Bottom half White for background
    CGContextRef bottomTX = UIGraphicsGetCurrentContext();
    CGContextBeginPath(bottomTX);
    CGContextMoveToPoint(bottomTX, CGRectGetMinX(rect), CGRectGetMidY(rect)); // mid left
    CGContextAddLineToPoint(bottomTX, CGRectGetMinX(rect), CGRectGetMaxY(rect)); // bottom left
    CGContextAddLineToPoint(bottomTX, CGRectGetMaxX(rect), CGRectGetMaxY(rect)); // bottom right
    CGContextAddLineToPoint(bottomTX, CGRectGetMaxX(rect), CGRectGetMidY(rect)); // mid right
    CGContextClosePath(bottomTX);
    
    CGContextSetRGBFillColor(bottomTX, 1, 1, 1, 1);
    CGContextFillPath(bottomTX);
    
    // White Triangle
    CGContextRef whiteTX = UIGraphicsGetCurrentContext();
    CGContextBeginPath(whiteTX);
    CGContextMoveToPoint(whiteTX, CGRectGetMinX(rect), CGRectGetMinY(rect)); // top left
    CGContextAddLineToPoint(whiteTX, CGRectGetMidX(rect), CGRectGetMaxY(rect)); // mid bottom
    CGContextAddLineToPoint(whiteTX, CGRectGetMaxX(rect), CGRectGetMinY(rect)); // top right
    CGContextClosePath(whiteTX);

    CGContextSetRGBFillColor(whiteTX, 1, 1, 1, 1);
    CGContextFillPath(whiteTX);
    
    // 222222 Triangle
    CGContextRef blackTX = UIGraphicsGetCurrentContext();
    CGContextBeginPath(blackTX);
    CGContextMoveToPoint(blackTX, CGRectGetMinX(rect) + 5.0f, CGRectGetMinY(rect) + 2.5f); // top left
    CGContextAddLineToPoint(blackTX, CGRectGetMidX(rect), CGRectGetMaxY(rect) - 5.0f); // mid bottom
    CGContextAddLineToPoint(blackTX, CGRectGetMaxX(rect) - 5.0f, CGRectGetMinY(rect) + 2.5f); // top right
    CGContextClosePath(blackTX);
    
    CGContextSetRGBFillColor(blackTX, (34.0f/255.0f), (34.0f/255.0f), (34.0f/255.0f), 1);
    CGContextFillPath(blackTX);
}


@end
