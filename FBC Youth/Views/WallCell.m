//
//  WallCell.m
//  FBC Youth
//
//  Created by Zach Stegall on 2/17/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//

#import "WallCell.h"

@implementation WallCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _message = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, 12.5f, [UIScreen mainScreen].bounds.size.width - 50.0f, 34.0f)];
        _message.font = [UIFont fontWithName:@"Verdana" size:14];
        _message.textColor = [UIColor whiteColor];
        _message.backgroundColor = [UIColor clearColor];
        [self addSubview:_message];
        
        _icon = [[UIImageView alloc] init];
        [self addSubview:_icon];
        
        self.backgroundColor = [UIColor clearColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleDefault];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
