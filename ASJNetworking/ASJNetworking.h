//
//  ASJNetworking.h
//  ASJNetworkingExample
//
//  Created by sudeep on 04/07/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

@import Foundation;
@import UIKit;

typedef void (^ASJCompletionBlock)(id response, NSString *responseString, NSError *error);
typedef void (^ASJProgressBlock)(CGFloat progressPercentage);

typedef NS_ENUM(NSUInteger, ASJNetworkingRequestType) {
  ASJNetworkingRequestTypeGet,
  ASJNetworkingRequestTypePost,
  ASJNetworkingRequestTypeMultipartPost
};

@interface ASJNetworking : NSObject

- (instancetype)initWithBaseUrl:(NSString *)baseUrl
                  requestMethod:(NSString *)requestMethod
                    requestType:(ASJNetworkingRequestType)requestType;

- (instancetype)initWithBaseUrl:(NSString *)baseUrl
                 requestMethod:(NSString *)requestMethod
                   requestType:(ASJNetworkingRequestType)requestType
                     arguments:(NSDictionary *)arguments;

- (instancetype)initWithBaseUrl:(NSString *)baseUrl
                  requestMethod:(NSString *)requestMethod
                    requestType:(ASJNetworkingRequestType)requestType
                     parameters:(NSDictionary *)parameters;

- (instancetype)initWithBaseUrl:(NSString *)baseUrl
                 requestMethod:(NSString *)requestMethod
                   requestType:(ASJNetworkingRequestType)requestType
                     arguments:(NSDictionary *)arguments
                    parameters:(NSDictionary *)parameters;

- (instancetype)initWithBaseUrl:(NSString *)baseUrl
                  requestMethod:(NSString *)requestMethod
                    requestType:(ASJNetworkingRequestType)requestType
                     parameters:(NSDictionary *)parameters
                         images:(NSArray *)images;

- (instancetype)initWithBaseUrl:(NSString *)baseUrl
                 requestMethod:(NSString *)requestMethod
                   requestType:(ASJNetworkingRequestType)requestType
                     arguments:(NSDictionary *)arguments
                    parameters:(NSDictionary *)parameters
                        images:(NSArray *)images;

@property (assign, nonatomic) CGFloat timeoutInterval;

- (void)fireWithCompletion:(ASJCompletionBlock)completion;
- (void)fireWithProgress:(ASJProgressBlock)progress completion:(ASJCompletionBlock)completion;

@end

@interface ASJMultipartImageItem : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *filename;
@property (nonatomic) UIImage *image;

@end
