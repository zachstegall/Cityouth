//
//  SignInViewController.m
//  FBC Youth
//
//  Created by Zach Stegall on 2/8/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//

#import "SignInViewController.h"
#import "HomeViewController.h"
#import "AFHTTPRequestOperationManager.h"

#define ServerApiURL @"http://198.58.106.245/youth/testindex.php"

@interface SignInViewController ()
{
    CGFloat centerX;
    CGFloat centerY;
}
@end

@implementation SignInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        centerX = [UIScreen mainScreen].bounds.size.width/2;
        centerY = [UIScreen mainScreen].bounds.size.height/2;
    }
    return self;
}

#pragma mark - SignInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self imageViewAllocation];
    [self signInButtonAllocation];
    [self tableViewLogInAllocation];
    [self inputAllocation];
    [self hideFields];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.view.backgroundColor = UIColorFromRGB(0x222222);
    
    [self performSelector:@selector(fadeInLabelsAndTextFields) withObject:nil afterDelay:1.0f];
    
}

-(void)imageViewAllocation
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(centerX, centerY, 222.0f, 250.0f)];
    _imageView.image = [UIImage imageNamed:@"Lightbulboff.png"];
    _imageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    [self.view addSubview:_imageView];
    
    [UIView animateWithDuration:2.0f delay:0.5f usingSpringWithDamping:0.5f initialSpringVelocity:0.25f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        _imageView.center = CGPointMake(centerX, 100.0f);
    } completion:^(BOOL finished){
        //NSLog(@"Done!");
        _imageView.image = [UIImage imageNamed:@"Lightbulbon.png"];
    }];
}

-(void)signInButtonAllocation
{
    _signInBtn = [[UIButton alloc] initWithFrame:CGRectMake(20.0f, [UIScreen mainScreen].bounds.size.height - 70.0f, 280.0f, 43.0f)];
    [_signInBtn setTitle:@"sign in" forState:UIControlStateNormal];
    _signInBtn.titleLabel.font = [UIFont fontWithName:@"Avenir" size:22.0f];
    _signInBtn.titleLabel.textColor = [UIColor whiteColor];
    _signInBtn.backgroundColor = UIColorFromRGB(0x414141);
    _signInBtn.layer.cornerRadius = 3;
    _signInBtn.clipsToBounds = YES;
    [_signInBtn addTarget:self action:@selector(signInClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_signInBtn];
}

-(void)tableViewLogInAllocation
{
    _tableViewLogIn = [[UITableView alloc] initWithFrame:CGRectMake(20.0f, _signInBtn.frame.origin.y - 138.0f, 280.0f, 130.0f) style:UITableViewStylePlain];
    [_tableViewLogIn setDelegate:self];
    [_tableViewLogIn setDataSource:self];
    _tableViewLogIn.scrollEnabled = NO;
    _tableViewLogIn.layer.cornerRadius = 3;
    _tableViewLogIn.clipsToBounds = YES;
    [_tableViewLogIn setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:_tableViewLogIn];
}

-(void)inputAllocation
{
    _firstName = [[UITextField alloc] initWithFrame:CGRectMake(5, 2, 275, 40)];
    _firstName.font = [UIFont fontWithName:@"Avenir" size:22.0f];
    _firstName.clearButtonMode = UITextFieldViewModeAlways;
    [_firstName setDelegate:self];
    _lastName = [[UITextField alloc] initWithFrame:CGRectMake(5, 2, 275, 40)];
    _lastName.font = [UIFont fontWithName:@"Avenir" size:22.0f];
    _lastName.clearButtonMode = UITextFieldViewModeAlways;
    [_lastName setDelegate:self];
    _key = [[UITextField alloc] initWithFrame:CGRectMake(5, 2, 275, 40)];
    _key.font = [UIFont fontWithName:@"Avenir" size:22.0f];
    _key.clearButtonMode = UITextFieldViewModeAlways;
    [_key setDelegate:self];
}

#pragma mark - Sign In Actions

- (void)signInClick:(id)sender
{
    if ([_key.text isEqualToString:@"MVyouthFBC"] || [_key.text isEqualToString:@"MVadminFBC1819"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"y" forKey:@"actualtoken"];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"] == NULL) {
            [[NSUserDefaults standardUserDefaults] setObject:[self createUUID] forKey:@"UUID"];
            [[NSUserDefaults standardUserDefaults] setObject:@"n" forKey:@"actualtoken"];
        }
        [[NSUserDefaults standardUserDefaults] setObject:_firstName.text forKey:@"first"];
        [[NSUserDefaults standardUserDefaults] setObject:_lastName.text forKey:@"last"];
        [[NSUserDefaults standardUserDefaults] setObject:_key.text forKey:@"signkey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params = @{@"first": _firstName.text,
                                 @"last": _lastName.text,
                                 @"signkey": _key.text,
                                 @"actualtoken": [[NSUserDefaults standardUserDefaults] objectForKey:@"actualtoken"],
                                 @"d_token": [[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"]};
        [manager POST:ServerApiURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // Navigation Controller is responsible for this delegate
            [self.delegate didFinishSigningIn];
        } failure:^(AFHTTPRequestOperation *operation, NSError *errxor) {
            //NSLog(@"Error: %@", error);
            [self clearFields];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The login feature is unavailable. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.frame = CGRectMake(50.0f, 50.0f, [UIScreen mainScreen].bounds.size.width - 100.0f, 150.0f);
            [alert show];
        }];
        
    } else {
        NSIndexPath *pathKey = [NSIndexPath indexPathForItem:2 inSection:0];
        [_tableViewLogIn cellForRowAtIndexPath:pathKey].backgroundColor = UIColorFromRGB(0xFFA9A9);
        _key.placeholder = @"key is incorrect";
    }
}

-(void)clearFields
{
    _firstName.text = @"";
    _lastName.text = @"";
    _key.text = @"";
    _key.placeholder = @"key";
    NSIndexPath *pathKey = [NSIndexPath indexPathForItem:2 inSection:0];
    [_tableViewLogIn cellForRowAtIndexPath:pathKey].backgroundColor = [UIColor whiteColor];
}

// Creates a temporary unique identifier for the device
// until the user decides to register for pushes
-(NSString *)createUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef str = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)str;
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
            _firstName.placeholder = @"first";
            [cell addSubview:_firstName];
            break;
        case 1:
            _lastName.placeholder = @"last";
            [cell addSubview:_lastName];
            break;
        case 2:
            _key.placeholder = @"key";
            [cell addSubview:_key];
            break;
        default:
            break;
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UITableViewDelegate

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self lowerFields];
    return [textField resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self raiseFields];
}

#pragma mark - Manipulate Fields

- (void)fadeInLabelsAndTextFields
{
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        _signInBtn.alpha = 0.8f;
        _tableViewLogIn.alpha = 1.0f;
        _firstName.alpha = 1.0f;
        _lastName.alpha = 1.0f;
        _key.alpha = 1.0f;
    }completion:^(BOOL finished){
        
    }];
}

- (void)hideFields
{
    _signInBtn.alpha = 0.0f;
    _tableViewLogIn.alpha = 0.0f;
    _firstName.alpha = 0.0f;
    _lastName.alpha = 0.0f;
    _key.alpha = 0.0f;
}

// Raise just above the keyboard
-(void)raiseFields
{
    if (_imageView.image == [UIImage imageNamed:@"Lightbulbon.png"]) {
        [UIView animateWithDuration:0.15f animations:^{
            //_imageView.center = CGPointMake(160.0f, 97.0f);
            _tableViewLogIn.center = CGPointMake(centerX, _tableViewLogIn.center.y - 150.0f);
            CGFloat scaleX = _tableViewLogIn.frame.origin.y/(125.0f/111.0f);
            _imageView.frame = CGRectMake(centerX - (scaleX/2), 0, scaleX, _tableViewLogIn.frame.origin.y);
            _imageView.image = [UIImage imageNamed:@"Lightbulbdim.png"];
        }];
    }
}

-(void)lowerFields
{
    if (_imageView.image == [UIImage imageNamed:@"Lightbulbdim.png"]) {
        [UIView animateWithDuration:0.15f animations:^{
            _tableViewLogIn.center = CGPointMake(centerX, _signInBtn.frame.origin.y - 73.0f);
            _imageView.frame = CGRectMake(centerX - 111.0f, -25.0f, 222.0f, 250.0f);
            _imageView.image = [UIImage imageNamed:@"Lightbulbon.png"];
        }];
    }
}

#pragma mark - Keyboard Control

-(void)dismissKeyboard
{
    [_firstName resignFirstResponder];
    [_lastName resignFirstResponder];
    [_key resignFirstResponder];
    [self lowerFields];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
