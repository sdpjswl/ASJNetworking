//
//  Networking.h
//  Networking
//
//  Created by sudeep on 04/02/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Networking : NSObject

/**
 *  Executes a GET request. Consider an example URL, "http://www.myAwesomeWebsite.com/login"
 *  which sends the "username" and "password" along with it.
 *
 *  @param name            The name of the request to be made. According to the example, it will be "login"
 *  @param params          Key-value pairs of parameters to attach with the request.
 *                         According to the example, it will be:
 *                         @{@"username": @"something",
 *                           @"password": @"somethingElse"}
 *  @param sender          A reference to the ViewController from which the request is being made.
 *                         This is used to display a spinner until the request completes. You should
 *                         be mainly required to send "self" here
 *  @param completionBlock The control will reach to this block once the request is completed.
 *                         If it failed, the "error" object will hold the reason why. If it was successful,
 *                         the "obj" object will hold the server response. You will need to typecast it
 *                         according to your needs
 */
+ (void)fireGETRequestForMethodNamed:(NSString *)name
                          parameters:(NSDictionary *)params
                              sender:(id)sender
                     completionBlock:(void (^)(id obj, NSError *error))completionBlock;

/**
 *  Executes a POST request. Consider an example URL, "http://www.myAwesomeWebsite.com/signUpWithProfilePhoto"
 *  which sends the "username", "password", "confirmPassword" and an image along with it.
 *
 *  @param name            The name of the request to be made. According to the example, it will be "signUpWithProfilePhoto"
 *  @param params          Key-value pairs of parameters to attach with the request. Note that if you are making a request
 *                         that requires image(s) tobe uploaded, those will not be sent in this argument.
 *                         According to the example, it will be:
 *                         @{@"username":        @"something",
 *                           @"password":        @"somethingElse",
 *                           @"confirmPassword": @"somethingElse"}
 *  @param images          An array of UIImages to be sent if it is a multi-part POST request. Any images will be sent tagged
 *                         with the field name "image" and file names of "image0", "image1" and so on. You are required to
 *                         make sure the server code for receiving the image and your client code is in sync. Change the field
 *                         name accordingly if need be. All UIImages are converted to JPEG data with max quality. This argument is
 *                         optional and can se set to 'nil'
 *  @param sender          A reference to the ViewController from which the request is being made.
 *                         This is used to display a spinner until the request completes. You should
 *                         be mainly required to send "self" here
 *  @param completionBlock The control will reach to this block once the request is completed.
 *                         If it failed, the "error" object will hold the reason why. If it was successful,
 *                         the "obj" object will hold the server response. You will need to typecast it
 *                         according to your needs
 */
+ (void)firePOSTRequestForMethodNamed:(NSString *)name
                           parameters:(NSDictionary *)params
                               images:(NSArray *)images
                               sender:(id)sender
                      completionBlock:(void (^)(id obj, NSError *error))completionBlock;

/**
 *  The URL to which requests are made. This must be set beforehand. Make this change in "Networking.m".
 *  e.g.: "http://www.myAwesomeWebsite.com". You must NOT add a slash ('/') at the end.
 */
extern NSString *const baseServerURL;

@end
