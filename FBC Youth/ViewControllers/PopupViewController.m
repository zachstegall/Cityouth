//
//  PopupViewController.m
//  FBC Youth
//
//  Created by Zach Stegall on 2/14/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//

#import "PopupViewController.h"

@interface PopupViewController ()

@end

@implementation PopupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - PopupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _location.hidden = YES;
    _send.hidden = YES;
    _checkNo.image = [UIImage imageNamed:@"CheckNo.png"];
    _checkYes.image = [UIImage imageNamed:@"CheckYes.png"];
    
    UITapGestureRecognizer *sendTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendLifted:)];
    [_send addGestureRecognizer:sendTap];
    
    self.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    self.view.layer.cornerRadius = 10;
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = UIColorFromRGB(0x222222);
}

#pragma mark - UITextFieldDelegates

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 100) ? NO : YES;
}

#pragma mark - User Interaction

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == _checkNo) {
        _checkNo.image = [UIImage imageNamed:@"CheckNoPressed.png"];
    } else if ([touch view] == _checkYes) {
        _checkYes.image = [UIImage imageNamed:@"CheckYesPressed.png"];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == _checkNo) {
        _checkNo.image = [UIImage imageNamed:@"CheckNo.png"];
        [self.delegate didFinishAnsweringRide:@"NO RIDE" item:@"n"];
    } else if ([touch view] == _checkYes) {
        [self yesClicked];
    }
}

-(void)yesClicked
{
    [UIView animateWithDuration:0.25f animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 118.0f, self.view.frame.size.width, self.view.frame.size.height + 98.0f);
    } completion:^(BOOL finished){
        _location.hidden = NO;
        _send.hidden = NO;
    }];
    
    [_checkYes setUserInteractionEnabled:NO];
}

- (IBAction)sendPressed:(UIButton *)sender
{
    _send.titleLabel.textColor = [UIColor clearColor];
}

-(void)sendLifted:(id)sender
{
    _send.titleLabel.textColor = UIColorFromRGB(0x222222);
    _checkYes.image = [UIImage imageNamed:@"CheckYes.png"];
    [self.delegate didFinishAnsweringRide:_location.text item:@"y"];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
