//
//  Cell.m
//  FBC Youth
//
//  Created by Zach Stegall on 1/15/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//
//
//  

#import "Cell.h"

@implementation Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _name = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 8.0f, 100.0f, 34.0f)];
        _name.font = [UIFont fontWithName:@"Verdana" size:21.0f];
        _name.backgroundColor = [UIColor clearColor];
        _name.textColor = [UIColor whiteColor];
        [self addSubview:_name];
        
        self.backgroundColor = UIColorFromRGB(0xF7941E);
        [self setSelectionStyle:UITableViewCellSelectionStyleDefault];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
