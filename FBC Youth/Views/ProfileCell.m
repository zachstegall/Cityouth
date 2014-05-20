//
//  ProfileCell.m
//  FBC Youth
//
//  Created by Zach Stegall on 2/17/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//

#import "ProfileCell.h"

@implementation ProfileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _textView = [[UITextView alloc] init];
        _textView.editable = NO;
        _textView.font = [UIFont fontWithName:@"Avenir" size:18.0f];
        _textView.textColor = [UIColor whiteColor];
        _textView.scrollEnabled = NO;
        _textView.returnKeyType = UIReturnKeyDone;
        self.textView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
