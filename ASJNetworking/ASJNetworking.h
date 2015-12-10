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

typedef void (^CompletionBlock)(id response, NSString *responseString, NSError *error);
typedef void (^ProgressBlock)(CGFloat progressPc);
typedef void (^LoadingIndicatorBlock)();

@interface ASJNetworking : NSObject

@property (assign, nonatomic) CGFloat timeoutInterval;
@property (copy) LoadingIndicatorBlock startLoadingIndicatorBlock;
@property (copy) LoadingIndicatorBlock stopLoadingIndicatorBlock;

- (instancetype)initWithBaseUrl:(NSString *)baseUrl;

- (void)GET:(NSString *)methodName parameters:(NSDictionary *)parameters completion:(CompletionBlock)completion;

- (void)HEAD:(NSString *)methodName parameters:(NSDictionary *)parameters completion:(CompletionBlock)completion;

- (void)POST:(NSString *)methodName parameters:(NSDictionary *)parameters completion:(CompletionBlock)completion;

- (void)POST:(NSString *)methodName parameters:(NSDictionary *)parameters imageItems:(NSArray *)imageItems completion:(CompletionBlock)completion;

- (void)POST:(NSString *)methodName parameters:(NSDictionary *)parameters imageItems:(NSArray *)imageItems progress:(ProgressBlock)progress completion:(CompletionBlock)completion;

- (void)PUT:(NSString *)methodName parameters:(NSDictionary *)parameters completion:(CompletionBlock)completion;

- (void)PATCH:(NSString *)methodName parameters:(NSDictionary *)parameters completion:(CompletionBlock)completion;

- (void)DELETE:(NSString *)methodName parameters:(NSDictionary *)parameters completion:(CompletionBlock)completion;

@end

@interface ASJImageItem : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *filename;
@property (weak, nonatomic) UIImage *image;

@end
