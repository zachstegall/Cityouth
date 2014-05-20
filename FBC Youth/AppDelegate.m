//
//  AppDelegate.m
//  FBC Youth
//
//  Created by Zach Stegall on 1/14/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//

#import "AppDelegate.h"
#import "AFHTTPRequestOperationManager.h"
#import "HomeViewController.h"

#define ServerApiURL @"http://198.58.106.245/youth/testindex.php"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // register for types of remote notifications
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeNewsstandContentAvailability|
      UIRemoteNotificationTypeBadge |
      UIRemoteNotificationTypeSound |
      UIRemoteNotificationTypeAlert)];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [[NSUserDefaults standardUserDefaults] setObject:@"MVadminFBC1819" forKey:@"signkey"];
    
    // permission keys
    _youthKey = @"MVyouthFBC";
    _adminKey = @"MVadminFBC1819";
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    _navController = [[NavigationController alloc] init];
    [_navController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    _navController.navigationBar.shadowImage = [UIImage new];
    _navController.navigationBar.translucent = YES;
    
    // only load data if we have a sign in data for the user
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"signkey"] != nil &&
        [[NSUserDefaults standardUserDefaults] objectForKey:@"first"] != nil &&
        [[NSUserDefaults standardUserDefaults] objectForKey:@"last"] != nil &&
        [[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"] != nil) {
        [_navController loadData];
    }
    
    [self.window setRootViewController:_navController];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSString *deviceTokenString = [NSString stringWithFormat:@"%@", deviceToken];
    
    NSError *error = nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"<|>| " options:0 error:&error];
    NSRange range = NSMakeRange(0, deviceTokenString.length);
    NSString *tokenCompact = [re stringByReplacingMatchesInString:deviceTokenString options:0 range:range withTemplate:@""];
    
    [[NSUserDefaults standardUserDefaults] setObject:tokenCompact forKey:@"UUID"];
    
    // Will send this request if user decides later to register
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"signkey"] != nil &&
        [[NSUserDefaults standardUserDefaults] objectForKey:@"first"] != nil &&
        [[NSUserDefaults standardUserDefaults] objectForKey:@"last"] != nil &&
        [[[NSUserDefaults standardUserDefaults] objectForKey:@"actualtoken"] isEqualToString:@"n"]) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params = @{@"first": [[NSUserDefaults standardUserDefaults] objectForKey:@"first"],
                                 @"last": [[NSUserDefaults standardUserDefaults] objectForKey:@"last"],
                                 @"signkey": [[NSUserDefaults standardUserDefaults] objectForKey:@"signkey"],
                                 @"actualtoken": @"y",
                                 @"d_token": [[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"]};
        [manager POST:ServerApiURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"JSON: %@", responseObject);
            [[NSUserDefaults standardUserDefaults] setObject:@"y" forKey:@"actualtoken"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //NSLog(@"Error: %@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to retrieve device. Register for pushes again when you have a solid connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.frame = CGRectMake(50.0f, 50.0f, [UIScreen mainScreen].bounds.size.width - 100.0f, 150.0f);
            [alert show];
        }];
    }
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // aps is the the name of the dictionary we receive from the sendnotification.php payload
    NSDictionary *temp = [userInfo objectForKey:@"aps"];
    
    // Bus ride notifications handle only for youth // not admin
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"signkey"] isEqualToString:_youthKey]) {
        if ([[[temp objectForKey:@"alert"] substringToIndex:8] isEqualToString:@"Bus Ride"])
            [_navController busRide];
    }
    
    if ([[[temp objectForKey:@"alert"] substringToIndex:4] isEqualToString:@"News"] ||
        [[[temp objectForKey:@"alert"] substringToIndex:7] isEqualToString:@"Thought"] ||
        [[[temp objectForKey:@"alert"] substringToIndex:8] isEqualToString:@"Iloveyou"]) {
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground ||
            [[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive) {
            [_navController newWallPostInBack];
        } else {
            [_navController newWallPostInFore];
            
        }
    }
    
    // Success
    completionHandler(UIBackgroundFetchResultNewData);
    
    typedef enum {
        UIBackgroundFetchResultNewData, //Download success with new data
        UIBackgroundFetchResultNoData,  //No data to download
        UIBackgroundFetchResultFailed   //Downlod Failed
    } UIBackgroundFetchResult;
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    // [self scheduleNotificationWithItem];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
}

@end
