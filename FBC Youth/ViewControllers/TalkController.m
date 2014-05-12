//
//  TalkController.m
//  FBC Youth
//
//  Created by Zach Stegall on 4/7/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//

#import "TalkController.h"

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <SAMCache/SAMCache.h>

#define ServerApiURL @"http://198.58.106.245/youth/testindex.php"
#define ServerNotificationApiURL @"http://198.58.106.245/youth/testzachnotification.php"

@implementation TalkController

+ (void)loadAllData:(void (^)(NSDictionary *))completion
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"selectall": @""};
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [manager POST:ServerApiURL parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        [[SAMCache sharedCache] setObject:responseObject forKey:@"data"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        completion(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        completion(nil);
        
    }];
}

+ (void)editedDataForTable:(NavigationController *)navController editItems:(NSArray *)items
{
    if ([[items objectAtIndex:0] isEqualToString:@"insert"]) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params = @{@"msg": [items objectAtIndex:1],
                                 @"type": [items objectAtIndex:2],
                                 @"date": [NSDate date]};
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [manager POST:ServerApiURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [navController editedForTableComplete:YES items:items];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [navController editedForTableComplete:NO items:items];
        }];
        
    } else if ([[items objectAtIndex:0] isEqualToString:@"delete"]) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params = @{@"msg": [items objectAtIndex:1],
                                 @"type": [items objectAtIndex:2],
                                 @"action": [items objectAtIndex:3]};
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [manager POST:ServerApiURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [navController editedForTableComplete:YES items:items];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [navController editedForTableComplete:NO items:items];
        }];
        
    } else if ([[items objectAtIndex:0] isEqualToString:@"update"]) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params = @{@"first": [items objectAtIndex:1],
                                 @"last": [items objectAtIndex:2],
                                 @"excited": [items objectAtIndex:3],
                                 @"obj": [items objectAtIndex:4],
                                 @"verseq": [items objectAtIndex:5],
                                 @"token": [items objectAtIndex:6],
                                 @"imagepath": [items objectAtIndex:7]};
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [manager POST:ServerApiURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [navController editedForTableComplete:YES items:items];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [navController editedForTableComplete:NO items:items];
        }];
        
    }
}

+ (void)answeredRide:(NavigationController *)navController location:(NSString *)location item:(NSString *)answer
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"loc": location,
                             @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"]};
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [manager POST:ServerApiURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [navController answeredRideComplete:YES answer:answer];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [navController answeredRideComplete:NO answer:answer];
    }];
}

+ (void)sendPushNotification:(NavigationController *)navController text:(NSString *)message completion:(void (^)(BOOL))completion
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"message": message};
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [manager POST:ServerNotificationApiURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(NO);
    }];
}

+ (void)downloadImage:(ProfileViewController *)profController imagepath:(NSString *)path name:(NSString *)imageFileName completion:(void (^)(NSData *))completion
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [[NSURL alloc] initWithString:path];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        [[SAMCache sharedCache] setObject:data forKey:imageFileName];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(data);
        });
        //[profController downloadImageComplete:data filename:imageFileName];
    }];
    [task resume];
}

+ (void)uploadImage:(ProfileViewController *)profController items:(NSDictionary *)items completion:(void (^)(BOOL))completion
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:[items objectForKey:@"urlString"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:[items objectForKey:@"imageData"] name:@"image" fileName:[items objectForKey:@"imageFileName"] mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(NO);
    }];
}

@end
