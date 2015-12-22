//  ASJNetworking.m
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

#import "ASJNetworking.h"

@interface ASJNetworking () <NSURLSessionDataDelegate>

@property (copy, nonatomic) NSString *baseUrl;
@property (copy, nonatomic) NSString *methodName;
@property (copy, nonatomic) NSDictionary *parameters;
@property (copy, nonatomic) NSArray *imageItems;
@property (copy, nonatomic) CompletionBlock callback;
@property (copy) ProgressBlock progress;

@property (readonly, copy, nonatomic) NSData *httpBody;
@property (readonly, copy, nonatomic) NSData *multipartHttpBody;
@property (readonly, copy, nonatomic) NSString *boundary;

@property (readonly, nonatomic) NSURL *getRequestUrl;
@property (readonly, nonatomic) NSURL *requestUrl;
@property (readonly, nonatomic) NSURLSession *urlSession;

@property (copy, nonatomic) NSMutableData *responseData;
@property (copy, nonatomic) NSString *responseString;
@property (strong, nonatomic) NSError *responseError;
@property (assign, nonatomic) BOOL showNetworkActivityIndicator;

- (void)runRequestWithHTTPMethod:(NSString *)httpMethod;
- (void)runMultipartRequestWithHTTPMethod:(NSString *)httpMethod;
- (void)parseUrlResponseForTask:(NSURLSessionTask *)task;
- (NSData *)headerDataForHEADRequestTask:(NSURLSessionTask *)task;

@end

@implementation ASJNetworking

#pragma mark - Init

- (instancetype)initWithBaseUrl:(NSString *)baseUrl
{
  self = [super init];
  if (self) {
    _baseUrl = baseUrl;
    _timeoutInterval = 30.0;
    _responseData = [[NSMutableData alloc] init];
  }
  return self;
}

#pragma mark - GET

- (void)GET:(NSString *)methodName parameters:(NSDictionary *)parameters completion:(CompletionBlock)completion
{
  _methodName = methodName;
  _parameters = parameters;
  _callback = completion;
  
  NSURLSessionDataTask *task = [self.urlSession dataTaskWithURL:self.getRequestUrl];
  self.showNetworkActivityIndicator = YES;
  [task resume];
}

#pragma mark - HEAD

- (void)HEAD:(NSString *)methodName parameters:(NSDictionary *)parameters completion:(CompletionBlock)completion
{
  _methodName = methodName;
  _parameters = parameters;
  _callback = completion;
  
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.getRequestUrl];
  request.HTTPMethod = @"HEAD";
  
  NSURLSessionDataTask *task = [self.urlSession dataTaskWithRequest:request];
  self.showNetworkActivityIndicator = YES;
  [task resume];
}

#pragma mark - POST

- (void)POST:(NSString *)methodName parameters:(NSDictionary *)parameters completion:(CompletionBlock)completion
{
  _methodName = methodName;
  _parameters = parameters;
  _callback = completion;
  [self runRequestWithHTTPMethod:@"POST"];
}

- (void)POST:(NSString *)methodName parameters:(NSDictionary *)parameters imageItems:(NSArray *)imageItems completion:(CompletionBlock)completion
{
  [self POST:methodName parameters:parameters imageItems:imageItems progress:nil completion:completion];
}

- (void)POST:(NSString *)methodName parameters:(NSDictionary *)parameters imageItems:(NSArray *)imageItems progress:(ProgressBlock)progress completion:(CompletionBlock)completion
{
  _methodName = methodName;
  _parameters = parameters;
  _imageItems = imageItems;
  _progress = progress;
  _callback = completion;
  [self runMultipartRequestWithHTTPMethod:@"POST"];
}

#pragma mark - PUT

- (void)PUT:(NSString *)methodName parameters:(NSDictionary *)parameters completion:(CompletionBlock)completion
{
  _methodName = methodName;
  _parameters = parameters;
  _callback = completion;
  [self runRequestWithHTTPMethod:@"PUT"];
}

- (void)PUT:(NSString *)methodName parameters:(NSDictionary *)parameters imageItems:(NSArray *)imageItems completion:(CompletionBlock)completion
{
  [self PUT:methodName parameters:parameters imageItems:imageItems progress:nil completion:completion];
}

- (void)PUT:(NSString *)methodName parameters:(NSDictionary *)parameters imageItems:(NSArray *)imageItems progress:(ProgressBlock)progress completion:(CompletionBlock)completion
{
  _methodName = methodName;
  _parameters = parameters;
  _imageItems = imageItems;
  _progress = progress;
  _callback = completion;
  [self runMultipartRequestWithHTTPMethod:@"PUT"];
}

#pragma mark - PATCH

- (void)PATCH:(NSString *)methodName parameters:(NSDictionary *)parameters completion:(CompletionBlock)completion
{
  _methodName = methodName;
  _parameters = parameters;
  _callback = completion;
  [self runRequestWithHTTPMethod:@"PATCH"];
}

#pragma mark - DELETE

- (void)DELETE:(NSString *)methodName parameters:(NSDictionary *)parameters completion:(CompletionBlock)completion
{
  _methodName = methodName;
  _parameters = parameters;
  _callback = completion;
  [self runRequestWithHTTPMethod:@"DELETE"];
}

#pragma mark - Run request

- (void)runRequestWithHTTPMethod:(NSString *)httpMethod
{
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.requestUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:_timeoutInterval];
  request.HTTPMethod = httpMethod;
  request.HTTPBody = self.httpBody;
  [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
  [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  
  NSURLSessionDataTask *postDataTask = [self.urlSession dataTaskWithRequest:request];
  self.showNetworkActivityIndicator = YES;
  [postDataTask resume];
}

- (void)runMultipartRequestWithHTTPMethod:(NSString *)httpMethod
{
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.requestUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:_timeoutInterval];
  request.HTTPMethod = httpMethod;
  request.HTTPBody = self.multipartHttpBody;
  [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
  [request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", self.boundary] forHTTPHeaderField:@"Content-Type"];
  
  NSURLSessionDataTask *uploadTask = [self.urlSession dataTaskWithRequest:request];
  self.showNetworkActivityIndicator = YES;
  [uploadTask resume];
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
  [_responseData appendData:data];
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
  NSNumber *sent = [NSNumber numberWithLongLong:totalBytesSent];
  NSNumber *total = [NSNumber numberWithLongLong:totalBytesExpectedToSend];
  CGFloat percentage = (sent.longLongValue * 100) / total.doubleValue;
  if (_progress) {
    _progress(percentage);
  }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
  _responseError = error;
  [self parseUrlResponseForTask:task];
}

#pragma mark - Parsing

- (void)parseUrlResponseForTask:(NSURLSessionTask *)task
{
  if (!_callback) {
    self.showNetworkActivityIndicator = NO;
    return;
  }
  
  // fix duplication of data
  NSData *data = [NSData dataWithData:_responseData];
  _responseData = [[NSMutableData alloc] init];
  
  // might be HEAD
  if (!data.length)
  {
    BOOL isHEADRequest = [task.originalRequest.HTTPMethod isEqualToString:@"HEAD"];
    if (isHEADRequest)
    {
      data = [self headerDataForHEADRequestTask:task];
    }
  }
  
  NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  if (!data) {
    _callback(data, responseString, _responseError);
    self.showNetworkActivityIndicator = NO;
    return;
  }
  
  NSError *parseError = nil;
  id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
  if (_callback) {
    _callback(json, responseString, _responseError);
    self.showNetworkActivityIndicator = NO;
  }
}

- (NSData *)headerDataForHEADRequestTask:(NSURLSessionTask *)task
{
  NSDictionary *headers = [(NSHTTPURLResponse *)task.response allHeaderFields];
  return [NSJSONSerialization dataWithJSONObject:headers options:NSJSONWritingPrettyPrinted error:nil];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
  // using a self signed SSL certificate casues requests to fail
  completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}

#pragma mark - HTTP body

- (NSData *)httpBody
{
  if (!_parameters) {
    return nil;
  }
  NSError *error;
  NSData *body = [NSJSONSerialization dataWithJSONObject:_parameters options:0 error:&error];
  if (error) {
    NSLog(@"error creating post data: %@", error.localizedDescription);
    return nil;
  }
  return body;
}

- (NSData *)multipartHttpBody
{
  NSMutableData *body = [[NSMutableData alloc] init];
  
  // attach parameters
  [_parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop)
   {
     [body appendData:[[NSString stringWithFormat:@"--%@\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[[NSString stringWithFormat:@"%@\r\n", obj] dataUsingEncoding:NSUTF8StringEncoding]];
   }];
  
  // attach images
  for (id imageItem in _imageItems)
  {
    BOOL success = [imageItem isMemberOfClass:[ASJImageItem class]];
    if (!success) {
      NSAssert(success, @"Items must be of kind ASJImageItem");
    }
    
    ASJImageItem *imageItemObject = (ASJImageItem *)imageItem;
    BOOL nilCheck = (imageItemObject.name && imageItemObject.filename && imageItemObject.image);
    if (!nilCheck) {
      NSAssert(nilCheck, @"ASJImageItem properties name, filename and image must not be nil");
    }
  }
  
  // attach images
  for (ASJImageItem *imageItem in _imageItems)
  {
    NSData *imageData = UIImageJPEGRepresentation(imageItem.image, 0.6);
    if (imageData) {
      [body appendData:[[NSString stringWithFormat:@"--%@\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
      [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", imageItem.name, imageItem.filename] dataUsingEncoding:NSUTF8StringEncoding]];
      [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
      [body appendData:imageData];
      [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
  }
  [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  return [NSData dataWithData:body];
}

- (NSString *)boundary
{
  return @"--------5A4n88-i269s-h15a--------";
}

#pragma mark - Request url

- (NSURL *)getRequestUrl
{
  NSURL *requestUrl = self.requestUrl;
  if (!_parameters) {
    return requestUrl;
  }
  
  __block NSMutableString *tempString = [[NSMutableString alloc] initWithString:requestUrl.absoluteString];
  [tempString appendString:@"?"];
  
  [_parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
    [tempString appendFormat:@"%@=%@&", key, obj];
  }];
  NSString *withParameters = [tempString substringWithRange:NSMakeRange(0, tempString.length - 1)];
  return [NSURL URLWithString:withParameters];
}

- (NSURL *)requestUrl
{
  // append slash at the end if not present
  NSString *lastCharacter = [_baseUrl substringFromIndex:_baseUrl.length - 1];
  BOOL isTerminatedBySlash = [lastCharacter isEqualToString:@"/"] ? YES : NO;
  if (!isTerminatedBySlash)
  {
    _baseUrl = [_baseUrl stringByAppendingString:@"/"];
  }
  
  NSURL *baseUrl = [NSURL URLWithString:_baseUrl];
  if (!_methodName) {
    return baseUrl;
  }
  return [NSURL URLWithString:_methodName relativeToURL:baseUrl];
}

#pragma mark - Url session

- (NSURLSession *)urlSession {
  static NSURLSession *session = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    session = [NSURLSession sessionWithConfiguration:configuration
                                            delegate:self
                                       delegateQueue:[NSOperationQueue mainQueue]];
  });
  return session;
}

#pragma mark - Network activity indicator

- (void)setShowNetworkActivityIndicator:(BOOL)showNetworkActivityIndicator
{
  BOOL isVisible = [UIApplication sharedApplication].isNetworkActivityIndicatorVisible;
  if (showNetworkActivityIndicator)
  {
    if (isVisible) {
      return;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  }
  else
  {
    if (!isVisible) {
      return;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  }
}

@end

#pragma mark - ASJImageItem

@implementation ASJImageItem

+ (ASJImageItem *)imageItemWithName:(NSString *)name fileName:(NSString *)filename image:(UIImage *)image
{
  ASJImageItem *item = [[ASJImageItem alloc] init];
  item.name = name;
  item.filename = filename;
  item.image = image;
  return item;
}

@end
