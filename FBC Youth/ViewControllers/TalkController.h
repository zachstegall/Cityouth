//
//  TalkController.h
//  FBC Youth
//
//  Created by Zach Stegall on 4/7/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//

#import "NavigationController.h"
#import "ProfileViewController.h"

#import <Foundation/Foundation.h>

@interface TalkController : NSObject

+ (void)loadAllData:(void(^)(NSDictionary *response))completion;
+ (void)editedDataForTable: (NavigationController *)navController editItems:(NSArray *)items;
+ (void)answeredRide: (NavigationController *)navController location:(NSString *)location item:(NSString *)answer;
+ (void)sendPushNotification: (NavigationController *)navController text:(NSString *)message completion:(void(^)(BOOL success))completion;

+ (void)downloadImage: (ProfileViewController *)profController imagepath:(NSString *)path name:(NSString *)imageFileName completion:(void(^)(NSData *data))completion;
+ (void)uploadImage: (ProfileViewController *)profController items:(NSDictionary *)items completion:(void(^)(BOOL success))completion;

@end
