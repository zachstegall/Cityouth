//
//  NavigationController.m
//  FBC Youth
//
//  Created by Zach Stegall on 2/15/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//

#import "NavigationController.h"
#import "TalkController.h"

#import <SAMCache/SAMCache.h>

@interface NavigationController ()
{
    NSInteger toggle;
}

@end

@implementation NavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        toggle = 0;
        [self SignInViewControllerAllocation];
        
        [self setNeedsStatusBarAppearanceUpdate];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"signkey"] != nil &&
            [[NSUserDefaults standardUserDefaults] objectForKey:@"first"] != nil &&
            [[NSUserDefaults standardUserDefaults] objectForKey:@"last"] != nil &&
            [[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"] != nil) {
            [self HomeViewControllerAllocation];
            [self ProfileViewControllerAllocation];
            [self WallViewControllerAllocation];
            [self PopViewControllerAllocation];
            [self pushViewController:_HomeViewC animated:YES];
        }
        else
            [self pushViewController:_SignInViewC animated:YES];
    }
    return self;
}

-(void)finishInit
{
    if (!_HomeViewC)
        [self HomeViewControllerAllocation];
    
    if (!_ProfileViewC)
        [self ProfileViewControllerAllocation];
    
    if (!_WallViewC)
        [self WallViewControllerAllocation];
    
    if (!_PopViewC)
        [self PopViewControllerAllocation];
}

#pragma mark - NavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.successView = [[SuccessView alloc] initWithFrame:CGRectMake(self.view.center.x - 50.0f, self.view.center.y - 50.0f, 80.0f, 80.0f)];
}

-(void)SignInViewControllerAllocation
{
    _SignInViewC = [[SignInViewController alloc] initWithNibName:nil bundle:nil];
    [_SignInViewC setDelegate:self];
}

-(void)HomeViewControllerAllocation
{
    _HomeViewC = [[HomeViewController alloc] initWithNibName:nil bundle:nil];
    [_HomeViewC setDelegate:self];
    [_HomeViewC setReloadDelegate:self];
    [_HomeViewC.MenuViewC setDelegate:self];
}

-(void)ProfileViewControllerAllocation
{
    _ProfileViewC = [[ProfileViewController alloc] initWithNibName:nil bundle:nil];
    [_ProfileViewC editorSettings];
    [_ProfileViewC setDelegate:self];
    [_ProfileViewC setTableDelegate:self];
    [_ProfileViewC.MenuViewC setDelegate:self];
}

-(void)WallViewControllerAllocation
{
    _WallViewC = [[WallViewController alloc] initWithNibName:nil bundle:nil];
    [_WallViewC setDelegate:self];
    [_WallViewC setTableDelegate:self];
    [_WallViewC setReloadDelegate:self];
    [_WallViewC setPushRideDelegate:self];
    [_WallViewC.MenuViewC setDelegate:self];
}

-(void)PopViewControllerAllocation
{
    _PopViewC = [[PopupViewController alloc] initWithNibName:nil bundle:nil];
    _PopViewC.view.tag = 17;
    [_PopViewC setDelegate:self];
}

#pragma mark - Orientation and Style

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Resulting Methods from Received Pushes

-(void)busRide
{
    [_PopViewC.view setUserInteractionEnabled:YES];
    [_PopViewC.checkNo setUserInteractionEnabled:YES];
    [_PopViewC.checkYes setUserInteractionEnabled:YES];
    [self.topViewController.view addSubview:_PopViewC.view];
}

-(void)newWallPostInBack
{
    [self loadData];
    if (self.topViewController != _WallViewC)
        [self pushViewController:_WallViewC animated:NO];
}

-(void)newWallPostInFore
{
    [self loadData];
    if (self.topViewController != _WallViewC) {
        [_ProfileViewC.MenuViewC newWallPostDot];
        [_HomeViewC.MenuViewC newWallPostDot];
    }
}

#pragma mark - Protocols

// MenuViewController is the caller
//   -- selects new viewcontroller and hides menu
-(void)didSelectViewController:(UIView *)fromView andView:(NSInteger)viewNum
{
    switch (viewNum) {
        case 0:
            if (fromView != _HomeViewC.view) {
                [self popToViewController:_HomeViewC animated:NO];
            }
            break;
        case 1:
            if (fromView == _HomeViewC.view)
                [self pushViewController:_ProfileViewC animated:NO];
            else if (fromView == _WallViewC.view)
                [self popToViewController:_ProfileViewC animated:NO];
            break;
        case 2:
            if (fromView == _HomeViewC.view) {
                [self pushViewController:_ProfileViewC animated:NO];
                [self pushViewController:_WallViewC animated:NO];
            } else if (fromView == _ProfileViewC.view) {
                [self pushViewController:_WallViewC animated:NO];
            }
            [_ProfileViewC.MenuViewC viewedNewWallPost];
            [_HomeViewC.MenuViewC viewedNewWallPost];
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        _HomeViewC.MenuViewC.view.center = CGPointMake(_HomeViewC.MenuViewC.view.center.x, _HomeViewC.MenuViewC.view.center.y - 202.0f);
    }];
    [UIView animateWithDuration:0.5f animations:^{
        _ProfileViewC.MenuViewC.view.center = CGPointMake(_ProfileViewC.MenuViewC.view.center.x, _ProfileViewC.MenuViewC.view.center.y - 202.0f);
    }];
    [UIView animateWithDuration:0.5f animations:^{
        _WallViewC.MenuViewC.view.center = CGPointMake(_WallViewC.MenuViewC.view.center.x, _WallViewC.MenuViewC.view.center.y - 202.0f);
    }];
    toggle = 0;
}

// HomeViewC, ProfileViewC, or WallViewC could be the caller
//    -- toggles the menu
-(void)didToggle
{
    if (toggle == 0) {
        [UIView animateWithDuration:0.5f animations:^{
            _HomeViewC.MenuViewC.view.center = CGPointMake(_HomeViewC.MenuViewC.view.center.x, _HomeViewC.MenuViewC.view.center.y + 202.0f);
        }];
        [UIView animateWithDuration:0.5f animations:^{
            _ProfileViewC.MenuViewC.view.center = CGPointMake(_ProfileViewC.MenuViewC.view.center.x, _ProfileViewC.MenuViewC.view.center.y + 202.0f);
        }];
        [UIView animateWithDuration:0.5f animations:^{
            _WallViewC.MenuViewC.view.center = CGPointMake(_WallViewC.MenuViewC.view.center.x, _WallViewC.MenuViewC.view.center.y + 202.0f);
        }];
    } else {
        [UIView animateWithDuration:0.5f animations:^{
            _HomeViewC.MenuViewC.view.center = CGPointMake(_HomeViewC.MenuViewC.view.center.x, _HomeViewC.MenuViewC.view.center.y - 202.0f);
        }];
        [UIView animateWithDuration:0.5f animations:^{
            _ProfileViewC.MenuViewC.view.center = CGPointMake(_ProfileViewC.MenuViewC.view.center.x, _ProfileViewC.MenuViewC.view.center.y - 202.0f);
        }];
        [UIView animateWithDuration:0.5f animations:^{
            _WallViewC.MenuViewC.view.center = CGPointMake(_WallViewC.MenuViewC.view.center.x, _WallViewC.MenuViewC.view.center.y - 202.0f);
        }];
    }
    
    toggle = (toggle + 1) % 2;
}

// HomeViewC or WallViewC could be the caller
-(void)didRequestReload
{
    [self loadData];
}

// SignViewC will be the caller
-(void)didFinishSigningIn
{
    [self finishInit];
    [self loadData];
    [self.navigationController setViewControllers:[NSArray arrayWithObject:self.HomeViewC] animated:YES];
    [self pushViewController:self.HomeViewC animated:YES];
}

// WallViewC will be the caller
//    -- prepares pushes to all youth for bus ride invitations
-(void)didWantToSendRideQuestion:(NSString *)message
{
    [self pushNotification:@"Bus Ride" text:message];
}

// ProfileViewC or WallViewC could be the caller
//    -- inserts into wall table in DB for wall posts
//       or updates tokens_tbl in DB for profile
-(void)didEditForTable: (NSArray *)items
{
    [TalkController editedDataForTable:self editItems:items];
}

-(void)editedForTableComplete: (BOOL)success items:(NSArray *)items
{
    if ([[items objectAtIndex:0] isEqualToString:@"insert"]) {
        
        if (success) {
            [self loadData];
            
            // Send Notification about Post
            [self pushNotification:[items objectAtIndex:2] text:[items objectAtIndex:1]];
        } else {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to post at this time. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.frame = CGRectMake(50.0f, 50.0f, [UIScreen mainScreen].bounds.size.width - 100.0f, 150.0f);
            [alert show];
        }
        
    } else if ([[items objectAtIndex:0] isEqualToString:@"delete"]) {
        
        if (success) {
            [self loadData];
        } else {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to delete post at this time. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.frame = CGRectMake(50.0f, 50.0f, [UIScreen mainScreen].bounds.size.width - 100.0f, 150.0f);
            [alert show];
        }
        
    } else if ([[items objectAtIndex:0] isEqualToString:@"update"]) {
        
        if (success) {
            [self loadData];
            
//            NSString *name = [NSString stringWithFormat:@"%@%@%@", [items objectAtIndex:1], @" ", [items objectAtIndex:2]];
//            [self pushNotification:name text:@"updated profile!"];
        } else {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to edit profile at this time. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.frame = CGRectMake(50.0f, 50.0f, [UIScreen mainScreen].bounds.size.width - 100.0f, 150.0f);
            [alert show];
        }
        
    }
}

// PopupViewC will be the caller
//    -- allows us to gather ride necessities and locations
-(void)didFinishAnsweringRide:(NSString *)location item:(NSString *)answer
{
    [TalkController answeredRide:self location:location item:answer];
}

-(void)answeredRideComplete:(BOOL)success answer:(NSString *)answer
{
    if (success) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if ([answer isEqualToString:@"y"]) {
            _PopViewC.view.frame = CGRectMake(_PopViewC.view.frame.origin.x, _PopViewC.view.frame.origin.y+118.0f, _PopViewC.view.frame.size.width,
                                              _PopViewC.view.frame.size.height - 98.0f);
        }
        [[self.topViewController.view viewWithTag:17] removeFromSuperview];
    } else {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Message was not sent. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.frame = CGRectMake(50.0f, 50.0f, [UIScreen mainScreen].bounds.size.width - 100.0f, 150.0f);
        [alert show];
    }
}

// loads all data from the tables wall and tokens_tbl from MySQL
-(void)loadData
{
    NSDictionary *prof = [[SAMCache sharedCache] objectForKey:@"data"];
    if (prof) {
        [self.HomeViewC dishOutHomeData:prof[@"0"]];
        [self.ProfileViewC dishOutProfileDataCache:prof[@"0"]];
        [self.WallViewC dishOutWallData:prof[@"1"]];
    }
    
    [TalkController loadAllData:^(NSDictionary *response) {
        if (response) {
            self.youthData = [response objectForKey:@"0"];
            self.wallData = [response objectForKey:@"1"];
            [self.HomeViewC dishOutHomeData:self.youthData];
            [self.ProfileViewC dishOutProfileData:self.youthData];
            [self.WallViewC dishOutWallData:self.wallData];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Load was unsuccessful. Please refresh." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.frame = CGRectMake(50.0f, 50.0f, [UIScreen mainScreen].bounds.size.width - 100.0f, 150.0f);
            [alert show];
        }
    }];
}

// calls sendnotification.php to send pushes
-(void)pushNotification:(NSString *)type text:(NSString *)message
{
    NSString *title = [type capitalizedString];
    message = [NSString stringWithFormat:@"%@%@%@", title, @": ", message];
    [TalkController sendPushNotification:self text:message completion:^(BOOL success) {
        if (success) {
            //[UIApplication sharedApplication].applicationIconBadgeNumber =
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [self.view addSubview:self.successView];
            [UIView animateWithDuration:1.0f delay:2.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                [self.successView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.successView removeFromSuperview];
            }];
        } else {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Notifications were not sent. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.frame = CGRectMake(50.0f, 50.0f, [UIScreen mainScreen].bounds.size.width - 100.0f, 150.0f);
            [alert show];
        }
    }];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
