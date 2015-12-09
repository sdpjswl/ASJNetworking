//
//  ASJNetworking.m
//  ASJNetworkingExample
//
//  Created by sudeep on 04/07/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import "ASJNetworking.h"

@interface ASJNetworking () <NSURLSessionDataDelegate>

@property (copy, nonatomic) NSString *baseUrl;
@property (copy, nonatomic) NSString *requestMethod;
@property (assign, nonatomic) ASJNetworkingRequestType requestType;
@property (copy, nonatomic) NSDictionary *arguments;
@property (copy, nonatomic) NSDictionary *parameters;
@property (copy, nonatomic) NSArray *images;
@property (copy) ASJCompletionBlock callback;
@property (copy) ASJProgressBlock progress;

@property (readonly, nonatomic) NSURLSession *urlSession;
@property (readonly, nonatomic) NSURL *requestUrl;
@property (readonly, nonatomic) NSURL *requestUrlWithRequestMethodAndArguments;
@property (readonly, copy, nonatomic) NSString *requestUrlStringWithArguments;
@property (readonly, copy, nonatomic) NSData *httpBody;
@property (readonly, copy, nonatomic) NSData *multipartHttpBody;
@property (readonly, copy, nonatomic) NSString *boundary;

@property (strong, nonatomic) NSMutableData *responseData;
@property (weak, nonatomic) NSError *responseError;

- (void)fireGetRequest;
- (void)firePostRequest;
- (void)fireMultipartPostRequest;
- (void)parseUrlResponse;

@end

@implementation ASJNetworking

#pragma mark - Initialisers

- (instancetype)initWithBaseUrl:(NSString *)baseUrl
                  requestMethod:(NSString *)requestMethod
                    requestType:(ASJNetworkingRequestType)requestType
{
  return [self initWithBaseUrl:baseUrl requestMethod:requestMethod requestType:requestType arguments:nil];
}

- (instancetype)initWithBaseUrl:(NSString *)baseUrl
                  requestMethod:(NSString *)requestMethod
                    requestType:(ASJNetworkingRequestType)requestType
                      arguments:(NSDictionary *)arguments
{
  return [self initWithBaseUrl:baseUrl requestMethod:requestMethod requestType:requestType arguments:arguments parameters:nil];
}

- (instancetype)initWithBaseUrl:(NSString *)baseUrl
                  requestMethod:(NSString *)requestMethod
                    requestType:(ASJNetworkingRequestType)requestType
                     parameters:(NSDictionary *)parameters
{
  return [self initWithBaseUrl:baseUrl requestMethod:requestMethod requestType:requestType arguments:nil parameters:parameters];
}

- (instancetype)initWithBaseUrl:(NSString *)baseUrl
                  requestMethod:(NSString *)requestMethod
                    requestType:(ASJNetworkingRequestType)requestType
                      arguments:(NSDictionary *)arguments
                     parameters:(NSDictionary *)parameters
{
  return [self initWithBaseUrl:baseUrl requestMethod:requestMethod requestType:requestType arguments:arguments parameters:parameters images:nil];
}

- (instancetype)initWithBaseUrl:(NSString *)baseUrl
                  requestMethod:(NSString *)requestMethod
                    requestType:(ASJNetworkingRequestType)requestType
                     parameters:(NSDictionary *)parameters
                         images:(NSArray *)images
{
  return [self initWithBaseUrl:baseUrl requestMethod:requestMethod requestType:requestType arguments:nil parameters:parameters images:images];
}

- (instancetype)initWithBaseUrl:(NSString *)baseUrl
                  requestMethod:(NSString *)requestMethod
                    requestType:(ASJNetworkingRequestType)requestType
                      arguments:(NSDictionary *)arguments
                     parameters:(NSDictionary *)parameters
                         images:(NSArray *)images
{
  self = [super init];
  if (self) {
    _baseUrl = baseUrl;
    _requestMethod = requestMethod;
    _requestType = requestType;
    _arguments = arguments;
    _parameters = parameters;
    _images = images;
    _timeoutInterval = 30.0;
    _responseData = [[NSMutableData alloc] init];
  }
  return self;
}

#pragma mark - Fire request

- (void)fireWithCompletion:(ASJCompletionBlock)completion
{
  [self fireWithProgress:nil completion:completion];
}

- (void)fireWithProgress:(ASJProgressBlock)progress completion:(ASJCompletionBlock)completion
{
  _progress = progress;
  _callback = completion;
  if (_requestType == ASJNetworkingRequestTypeGet)
  {
    [self fireGetRequest];
  }
  else if (_requestType == ASJNetworkingRequestTypePost)
  {
    [self firePostRequest];
  }
  else if (_requestType == ASJNetworkingRequestTypeMultipartPost)
  {
    [self fireMultipartPostRequest];
  }
}

#pragma mark - Get

- (void)fireGetRequest
{
  NSURLSessionDataTask *task = [self.urlSession dataTaskWithURL:self.requestUrl];
  [task resume];
}

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

#pragma mark - Post

- (void)firePostRequest
{
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.requestUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:_timeoutInterval];
  request.HTTPMethod = @"POST";
  request.HTTPBody = self.httpBody;
  [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
  [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  
  NSURLSessionDataTask *postDataTask = [self.urlSession dataTaskWithRequest:request];
  [postDataTask resume];
}

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

#pragma mark - Multipart post

- (void)fireMultipartPostRequest
{
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.requestUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:_timeoutInterval];
  request.HTTPMethod = @"POST";
  request.HTTPBody = self.multipartHttpBody;
  [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
  [request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", self.boundary] forHTTPHeaderField:@"Content-Type"];
  
  NSURLSessionDataTask *uploadTask = [self.urlSession dataTaskWithRequest:request];
  [uploadTask resume];
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
  for (id imageItem in _images)
  {
    BOOL success = [imageItem isMemberOfClass:[ASJMultipartImageItem class]];
    if (!success) {
      NSAssert(success, @"Items must be of kind ASJMultipartImageItem");
    }
  }
  
  // attach images
  for (ASJMultipartImageItem * imageItem in _images)
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

- (NSURL *)requestUrl
{
  return self.requestUrlWithRequestMethodAndArguments;
}

- (NSURL *)requestUrlWithRequestMethodAndArguments
{
  // append slash at the end if not present
  NSString *lastCharacter = [_baseUrl substringFromIndex:_baseUrl.length - 1];
  BOOL isTerminatedBySlash = [lastCharacter isEqualToString:@"/"] ? YES : NO;
  if (!isTerminatedBySlash)
  {
    _baseUrl = [_baseUrl stringByAppendingString:@"/"];
  }
  
  NSURL *baseUrl = [NSURL URLWithString:_baseUrl];
  if (!_requestMethod) {
    return baseUrl;
  }
  baseUrl = [NSURL URLWithString:_requestMethod relativeToURL:baseUrl];
  NSString *withArguments = [baseUrl.absoluteString stringByAppendingString:self.requestUrlStringWithArguments];
  return [NSURL URLWithString:withArguments];
}

- (NSString *)requestUrlStringWithArguments
{
  __block NSMutableString *tempString = [[NSMutableString alloc] initWithString:@"?"];
  [_arguments enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
    [tempString appendFormat:@"%@=%@&", key, obj];
  }];
  return [tempString substringWithRange:NSMakeRange(0, tempString.length - 1)];
}

#pragma mark - Parse response

- (void)parseUrlResponse
{
  if (!_callback) {
    return;
  }
  
  // fix duplication of data
  NSData *data = [NSData dataWithData:_responseData];
  _responseData = [[NSMutableData alloc] init];
  
  NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  if (!data) {
    _callback(data, responseString, _responseError);
    return;
  }
  
  NSError *parseError = nil;
  id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
  if (_callback) {
    _callback(json, responseString, _responseError);
  }
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
  [self parseUrlResponse];
}

#pragma mark - NSURLSessionDelegate

/**
 *  using a self signed SSL certificate casues requests to fail. upon detecting
 *  such a certificate, it is unable to validate it. control comes to
 *  this delegate method and when handled, requests will pass through.
 */
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
  
  completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}

@end

@implementation ASJMultipartImageItem

@end
