//
//  SuccessView.m
//  FBC Youth
//
//  Created by Zach Stegall on 4/14/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//

#import "SuccessView.h"

@implementation SuccessView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.check = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width/2) - 15.0f, 10.0f, 30.0f, 30.0f)];
        self.check.image = [UIImage imageNamed:@"DoneCheck"];
        [self addSubview:self.check];
        
        self.success = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
        self.success.textAlignment = NSTextAlignmentCenter;
        self.success.textColor = [UIColor whiteColor];
        self.success.text = @"Success!";
        [self addSubview:self.success];
        
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
