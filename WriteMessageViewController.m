//
//  WriteMessageViewController.m
//  FBC Youth
//
//  Created by Zach Stegall on 2/24/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//

#import "WriteMessageViewController.h"

@interface WriteMessageViewController ()

@end

@implementation WriteMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self controlInitialization];
    }
    return self;
}

#pragma mark - WriteMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGFloat padding = 320.0f;
    
    self.view.frame = CGRectMake(10.0f, 84.0f, [UIScreen mainScreen].bounds.size.width - 20.0f, [UIScreen mainScreen].bounds.size.height - padding);
    self.view.opaque = YES;
    self.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0f, (self.view.frame.size.height/2.0f) + 84.0f);
    self.view.layer.cornerRadius = 10;
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = UIColorFromRGB(0x222222);
}

-(void)controlInitialization
{
    [self messageViewAllocation];
    [self newsButtonAllocation];
    [self thoughtButtonAllocation];
    [self iloveyouButtonAllocation];
    [self busRideButtonAllocation];
}

-(void)messageViewAllocation
{
    _messageView = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, self.view.frame.size.width - 20.0f, self.view.frame.size.height - 50.0f)];
    _messageView.font = [UIFont fontWithName:@"Verdana" size:16.0f];
    _messageView.opaque = NO;
    _messageView.backgroundColor = [UIColor clearColor];
    _messageView.textColor = [UIColor whiteColor];
    [self.view addSubview:_messageView];
}

-(void)newsButtonAllocation
{
    _newsButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - 30.0f, self.view.frame.size.width/4, 30.0f)];
    
    UITapGestureRecognizer *newsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newsLifted:)];
    [_newsButton addGestureRecognizer:newsTap];
    
    [_newsButton setTitle:@"news" forState:UIControlStateNormal];
    _newsButton.titleLabel.font = [UIFont fontWithName:@"Verdana" size:16.0f];
    _newsButton.backgroundColor = UIColorFromRGB(0x222222);
    _newsButton.clipsToBounds = YES;
    [_newsButton setTitleColor:UIColorFromRGB(0xF7941E) forState:UIControlStateNormal];
    [_newsButton addTarget:self action:@selector(newsPressed:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_newsButton];
}

-(void)thoughtButtonAllocation
{
    _thoughtButton = [[UIButton alloc] initWithFrame:CGRectMake(_newsButton.frame.origin.x + _newsButton.frame.size.width, self.view.frame.size.height - 30.0f, self.view.frame.size.width/4, 30.0f)];
    
    UITapGestureRecognizer *thoughtTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thoughtLifted:)];
    [_thoughtButton addGestureRecognizer:thoughtTap];

    [_thoughtButton setTitle:@"thought" forState:UIControlStateNormal];
    _thoughtButton.titleLabel.font = [UIFont fontWithName:@"Verdana" size:16.0f];
    _thoughtButton.backgroundColor = UIColorFromRGB(0x222222);
    _thoughtButton.clipsToBounds = YES;
    [_thoughtButton setTitleColor:UIColorFromRGB(0xF7941E) forState:UIControlStateNormal];
    [_thoughtButton addTarget:self action:@selector(thoughtPressed:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_thoughtButton];
}

-(void)iloveyouButtonAllocation
{
    _iloveyouButton = [[UIButton alloc] initWithFrame:CGRectMake(_thoughtButton.frame.origin.x + _thoughtButton.frame.size.width, self.view.frame.size.height - 30.0f, self.view.frame.size.width/4, 30.0f)];
    
    UITapGestureRecognizer *iloveyouTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iloveyouLifted:)];
    [_iloveyouButton addGestureRecognizer:iloveyouTap];
    
    [_iloveyouButton setTitle:@"iloveyou" forState:UIControlStateNormal];
    _iloveyouButton.titleLabel.font = [UIFont fontWithName:@"Verdana" size:16.0f];
    _iloveyouButton.backgroundColor = UIColorFromRGB(0x222222);
    _iloveyouButton.clipsToBounds = YES;
    [_iloveyouButton setTitleColor:UIColorFromRGB(0xF7941E) forState:UIControlStateNormal];
    [_iloveyouButton addTarget:self action:@selector(iloveyouPressed:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_iloveyouButton];
}

-(void)busRideButtonAllocation
{
    _busRideButton = [[UIButton alloc] initWithFrame:CGRectMake(_iloveyouButton.frame.origin.x + _iloveyouButton.frame.size.width, self.view.frame.size.height - 30.0f, self.view.frame.size.width/4, 30.0f)];
    
    UITapGestureRecognizer *busRideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(busRideLifted:)];
    [_busRideButton addGestureRecognizer:busRideTap];
    
    [_busRideButton setTitle:@"busride" forState:UIControlStateNormal];
    _busRideButton.titleLabel.font = [UIFont fontWithName:@"Verdana" size:16.0f];
    _busRideButton.backgroundColor = UIColorFromRGB(0x222222);
    _busRideButton.clipsToBounds = YES;
    [_busRideButton setTitleColor:UIColorFromRGB(0xF7941E) forState:UIControlStateNormal];
    [_busRideButton addTarget:self action:@selector(busRidePressed:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_busRideButton];
}

#pragma mark - User Interaction

-(void)newsPressed:(id)sender
{
    _newsButton.titleLabel.textColor = [UIColor clearColor];
}

-(void)thoughtPressed:(id)sender
{
    _thoughtButton.titleLabel.textColor = [UIColor clearColor];
}

-(void)iloveyouPressed:(id)sender
{
    _iloveyouButton.titleLabel.textColor = [UIColor clearColor];
}

-(void)busRidePressed:(id)sender
{
    _busRideButton.titleLabel.textColor = [UIColor clearColor];
}

-(void)newsLifted:(id)sender
{
    _newsButton.titleLabel.textColor = UIColorFromRGB(0xF7941E);
    
    [self.delegate didFinishWritingPost:_messageView.text type:_newsButton.titleLabel.text];
    _messageView.text = @"";
}

-(void)thoughtLifted:(id)sender
{
    _thoughtButton.titleLabel.textColor = UIColorFromRGB(0xF7941E);
    
    [self.delegate didFinishWritingPost:_messageView.text type:_thoughtButton.titleLabel.text];
    _messageView.text = @"";
}

-(void)iloveyouLifted:(id)sender
{
    _iloveyouButton.titleLabel.textColor = UIColorFromRGB(0xF7941E);
    
    [self.delegate didFinishWritingPost:_messageView.text type:_iloveyouButton.titleLabel.text];
    _messageView.text = @"";
}

-(void)busRideLifted:(id)sender
{
    _busRideButton.titleLabel.textColor = UIColorFromRGB(0xF7941E);
    
    [self.rideDelegate didFinishSendingRideQuestion:_messageView.text];
    _messageView.text = @"";
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
