//
//  AllYouthCell.m
//  FBC Youth
//
//  Created by Zach Stegall on 2/17/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//

#import "AllYouthCell.h"

@implementation AllYouthCell

-(void)setName:(UILabel *)name
{
    _name = name;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _name = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 8.0f, [UIScreen mainScreen].bounds.size.width - 50.0f, 34.0f)];
        _name.font = [UIFont fontWithName:@"Avenir" size:21];
        _name.backgroundColor = [UIColor clearColor];
        [self addSubview:_name];
        
        self.backgroundColor = [UIColor clearColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleDefault];
    }
    return self;
}

@end
