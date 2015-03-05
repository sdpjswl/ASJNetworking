//
//  Networking.m
//  Networking
//
//  Created by sudeep on 04/02/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "Networking.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "AFNetworkActivityLogger.h"

NSString *const baseServerURL = @"http://xx.xx.xx.xx:xxxx";
NSInteger const logMessages = 0;

@interface Networking ()

+ (AFHTTPRequestOperationManager *)getRequestOperationManager;
+ (void)startRequestLogging:(BOOL)yesOrNo;
+ (void)shouldShowSpinner:(BOOL)yesOrNo onSender:(id)sender;
+ (void)showSpinnerOnView:(UIView *)view;
+ (void)hideSpinnerOnView:(UIView *)view;

@end

@implementation Networking


#pragma mark - Public

+ (void)fireGETRequestForMethodNamed:(NSString *)name parameters:(NSDictionary *)params sender:(id)sender completionBlock:(void (^)(id obj, NSError *error))completionBlock {
	
	[Networking shouldShowSpinner:YES onSender:sender];
	[Networking startRequestLogging:YES];
	
	AFHTTPRequestOperationManager *manager = [Networking getRequestOperationManager];
	[manager GET:name parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
		
		[Networking shouldShowSpinner:NO onSender:sender];
		[Networking startRequestLogging:NO];
		completionBlock(responseObject, nil);
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
		[Networking shouldShowSpinner:NO onSender:sender];
		[Networking startRequestLogging:NO];
		completionBlock(nil, error);
		
	}];
}

+ (void)firePOSTRequestForMethodNamed:(NSString *)name parameters:(NSDictionary *)params images:(NSArray *)images sender:(id)sender completionBlock:(void (^)(id obj, NSError *error))completionBlock {
	
	[Networking shouldShowSpinner:YES onSender:sender];
	[Networking startRequestLogging:YES];
	
	AFHTTPRequestOperationManager *manager = [Networking getRequestOperationManager];
	[manager POST:name parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
		
		if (images) {
			[images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				UIImage *img = (UIImage *)obj;
				NSData *imgData = UIImageJPEGRepresentation(img, 1.0);
				NSString *fileName = [NSString stringWithFormat:@"image%lu", idx];
				[formData appendPartWithFileData:imgData
											name:@"image"
										fileName:fileName
										mimeType:@"image/jpeg"];
			}];
		}
		
	} success:^(AFHTTPRequestOperation *operation, id responseObject) {
		
		[Networking shouldShowSpinner:NO onSender:sender];
		[Networking startRequestLogging:NO];
		completionBlock(responseObject, nil);
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
		[Networking shouldShowSpinner:NO onSender:sender];
		[Networking startRequestLogging:NO];
		completionBlock(nil, error);
	}];
}


#pragma mark - Private

+ (AFHTTPRequestOperationManager *)getRequestOperationManager {
	AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseServerURL]];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
	return manager;
}

+ (void)startRequestLogging:(BOOL)yesOrNo {
	
	if (!logMessages) {
		return;
	}
	
	[AFNetworkActivityLogger sharedLogger].level = AFLoggerLevelDebug;
	if (yesOrNo) {
		[[AFNetworkActivityLogger sharedLogger] startLogging];
	}
	else {
		[[AFNetworkActivityLogger sharedLogger] stopLogging];
	}
}

+ (void)shouldShowSpinner:(BOOL)yesOrNo onSender:(id)sender {
	UIViewController *vc = (UIViewController *)sender;
	if (yesOrNo) {
		[Networking showSpinnerOnView:vc.view];
	}
	else {
		[Networking hideSpinnerOnView:vc.view];
	}
}

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
