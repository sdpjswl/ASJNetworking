//
//  Networking.m
//  AscentDemo
//
//  Created by ABS_MAC02 on 04/02/15.
//  Copyright (c) 2015 esense. All rights reserved.
//

#import "Networking.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "AFNetworkActivityLogger.h"

// '1' or '0' to show network responses in the console
#define LOG_MESSAGES 0

NSString *const baseServerURL = @"http://xx.xx.xx.xx:xxxx";

@implementation Networking


#pragma mark - GET

+ (void)fireGETRequestForMethodNamed:(NSString *)name usingParameters:(NSDictionary *)params sender:(id)sender completionBlock:(void (^)(NSDictionary *dict))completionBlock failBlock:(void (^)(NSError *error))failBlock {
    
    // set the request up
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseServerURL]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    // show spinner on sender VC
    UIViewController *vc = (UIViewController *)sender;
    [Networking showSpinnerOnView:vc.view];
    
    // start log messages
    if (LOG_MESSAGES) {
        [AFNetworkActivityLogger sharedLogger].level = AFLoggerLevelDebug;
        [[AFNetworkActivityLogger sharedLogger] startLogging];
    }
    
    // hit it!
    [manager GET:name.lowercaseString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // hide the spinner
        [Networking hideSpinnerOnView:vc.view];
        
        // stop log messages
        if (LOG_MESSAGES) {
            [[AFNetworkActivityLogger sharedLogger] stopLogging];
        }
        
        // typecast the response for use
        NSDictionary *dict = (NSDictionary *)responseObject;
        completionBlock(dict); // calling the block with a parameter
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // hide the spinner
        [Networking hideSpinnerOnView:vc.view];
        
        // stop log messages
        if (LOG_MESSAGES) {
            [[AFNetworkActivityLogger sharedLogger] stopLogging];
        }
        
        // calling the block with a parameter
        failBlock(error);
    }];
}


#pragma mark - POST

+ (void)firePOSTRequestForMethodNamed:(NSString *)name usingParameters:(NSDictionary *)params sender:(id)sender completionBlock:(void (^)(NSDictionary *dict))completionBlock failBlock:(void (^)(NSError *error))failBlock  {
    
    // set the request up
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseServerURL]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    // show spinner on sender VC
    UIViewController *vc = (UIViewController *)sender;
    [Networking showSpinnerOnView:vc.view];
    
    // start log messages
    if (LOG_MESSAGES) {
        [AFNetworkActivityLogger sharedLogger].level = AFLoggerLevelDebug;
        [[AFNetworkActivityLogger sharedLogger] startLogging];
    }
    
    // hit it!
    [manager POST:name parameters:params constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // hide the spinner
        [Networking hideSpinnerOnView:vc.view];
        
        // stop log messages
        if (LOG_MESSAGES) {
            [[AFNetworkActivityLogger sharedLogger] stopLogging];
        }
        
        // typecast the response for use
        NSDictionary *dict = (NSDictionary *)responseObject;
        completionBlock(dict); // calling the block with a parameter
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // hide the spinner
        [Networking hideSpinnerOnView:vc.view];
        
        // stop log messages
        if (LOG_MESSAGES) {
            [[AFNetworkActivityLogger sharedLogger] stopLogging];
        }
        
        failBlock(error); // calling the block with a parameter
    }];
}


#pragma mark - Spinner

+ (void)showSpinnerOnView:(UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    });
}

+ (void)hideSpinnerOnView:(UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:view animated:YES];
    });
}

@end
