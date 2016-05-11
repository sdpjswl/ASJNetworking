//  ASJNetworking.h
//
// Copyright (c) 2015 Sudeep Jaiswal
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

@import Foundation;
@import UIKit;

@class ASJImageItem;

NS_ASSUME_NONNULL_BEGIN

typedef void (^CompletionBlock)(id response, NSString *responseString, NSError *error);
typedef void (^ProgressBlock)(CGFloat progressPc);
typedef void (^RequestBlock)();

@interface ASJNetworking : NSObject

/**
 *  The time interval in seconds after which the request times out
 */
@property (assign, nonatomic) CGFloat timeoutInterval;

/**
 *  The designated initializer for this class
 *
 *  @param baseUrl Pass the base url for the request you wish to make
 *
 *  @return Returns an instance of the class
 */
- (instancetype)initWithBaseUrl:(NSString *)baseUrl NS_DESIGNATED_INITIALIZER;

/**
 *  Don't allow init because a baseUrl is must.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 *  Executes a GET request. Used to fetch data from the server.
 *
 *  @param methodName Method name for the request, after the '/'
 *  @param parameters Attach any parameters for the request
 *  @param completion A block that is executed when the request is completed, successfully or otherwise
 */
- (void)GET:(nullable NSString *)methodName parameters:(nullable NSDictionary *)parameters completion:(nullable CompletionBlock)completion;

/**
 *  Executes a HEAD request. This is almost like a GET request, except that it does not return the response body, only the headers.
 *
 *  @param methodName Method name for the request, after the '/'
 *  @param parameters Attach any parameters for the request
 *  @param completion A block that is executed when the request is completed, successfully or otherwise. This request has been modified to return the response headers in the response object.
 */
- (void)HEAD:(nullable NSString *)methodName parameters:(nullable NSDictionary *)parameters completion:(nullable CompletionBlock)completion;

/**
 *  Executes a POST request. Used to send new data to the server.
 *
 *  @param methodName Method name for the request, after the '/'
 *  @param parameters Attach any parameters for the request
 *  @param completion A block that is executed when the request is completed, successfully or otherwise
 */
- (void)POST:(nullable NSString *)methodName parameters:(nullable NSDictionary *)parameters completion:(nullable CompletionBlock)completion;

/**
 *  Executes a multipart POST request. Used to send new data to the server.
 *
 *  @param methodName Method name for the request, after the '/'
 *  @param parameters Attach any parameters for the request
 *  @param imageItems Attach image items of type 'ASJImageItem'
 *  @param completion A block that is executed when the request is completed, successfully or otherwise
 */
- (void)POST:(nullable NSString *)methodName parameters:(nullable NSDictionary *)parameters imageItems:(nullable NSArray<ASJImageItem *> *)imageItems completion:(nullable CompletionBlock)completion;

/**
 *  Executes a multipart POST request. Used to send new data to the server.
 *
 *  @param methodName Method name for the request, after the '/'
 *  @param parameters Attach any parameters for the request
 *  @param imageItems Attach image items of type 'ASJImageItem'
 *  @param progress   A progress block that is continuously invoked. It provides the percentage of the request completed.
 *  @param completion A block that is executed when the request is completed, successfully or otherwise
 */
- (void)POST:(nullable NSString *)methodName parameters:(nullable NSDictionary *)parameters imageItems:(nullable NSArray<ASJImageItem *> *)imageItems progress:(nullable ProgressBlock)progress completion:(nullable CompletionBlock)completion;

/**
 *  Executes a PUT request. Used to send update existing data on the server.
 *
 *  @param methodName Method name for the request, after the '/'
 *  @param parameters Attach any parameters for the request
 *  @param completion A block that is executed when the request is completed, successfully or otherwise
 */
- (void)PUT:(nullable NSString *)methodName parameters:(nullable NSDictionary *)parameters completion:(nullable CompletionBlock)completion;

/**
 *  Executes a multipart PUT request. Used to update existing data on the server.
 *
 *  @param methodName Method name for the request, after the '/'
 *  @param parameters Attach any parameters for the request
 *  @param imageItems Attach image items of type 'ASJImageItem'
 *  @param completion A block that is executed when the request is completed, successfully or otherwise
 */
- (void)PUT:(nullable NSString *)methodName parameters:(nullable NSDictionary *)parameters imageItems:(nullable NSArray<ASJImageItem *> *)imageItems completion:(nullable CompletionBlock)completion;

/**
 *  Executes a multipart PUT request. Used to update existing data on the server.
 *
 *  @param methodName Method name for the request, after the '/'
 *  @param parameters Attach any parameters for the request
 *  @param imageItems Attach image items of type 'ASJImageItem'
 *  @param progress   A progress block that is continuously invoked. It provides the percentage of the request completed.
 *  @param completion A block that is executed when the request is completed, successfully or otherwise
 */
- (void)PUT:(nullable NSString *)methodName parameters:(nullable NSDictionary *)parameters imageItems:(nullable NSArray<ASJImageItem *> *)imageItems progress:(nullable ProgressBlock)progress completion:(nullable CompletionBlock)completion;

/**
 *  Executes a PATCH request. Used to partially update existing data on the server.
 *
 *  @param methodName Method name for the request, after the '/'
 *  @param parameters Attach any parameters for the request
 *  @param completion A block that is executed when the request is completed, successfully or otherwise
 */
- (void)PATCH:(nullable NSString *)methodName parameters:(nullable NSDictionary *)parameters completion:(nullable CompletionBlock)completion;

/**
 *  Executes a DELETE request. Used to delete resources existing on the server.
 *
 *  @param methodName Method name for the request, after the '/'
 *  @param parameters Attach any parameters for the request
 *  @param completion A block that is executed when the request is completed, successfully or otherwise
 */
- (void)DELETE:(nullable NSString *)methodName parameters:(nullable NSDictionary *)parameters completion:(nullable CompletionBlock)completion;

/**
 *  Stops the currently active request
 */
- (void)cancelActiveRequest;

@end

@interface ASJImageItem : NSObject

/**
 *  Field name of the image in the body
 */
@property (copy, nonatomic) NSString *name;

/**
 *  Filename to be given to the image
 */
@property (copy, nonatomic) NSString *filename;

/**
 *  The image to be sent itself
 */
@property (strong, nonatomic) UIImage *image;

/**
 *  A handy constructor to quickly create ASJImageItems
 *
 *  @return An instance of the class
 */
+ (ASJImageItem *)imageItemWithName:(NSString *)name fileName:(NSString *)filename image:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
