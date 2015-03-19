 //
//  Networking.h
//  Networking
//
//  Created by sudeep on 04/02/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Networking : NSObject

+ (void)fireGETRequestForMethodNamed:(NSString *)name parameters:(NSDictionary *)params sender:(id)sender completionBlock:(void (^)(id obj, NSError *error))completionBlock;

+ (void)firePOSTRequestForMethodNamed:(NSString *)name parameters:(NSDictionary *)params images:(NSArray *)images sender:(id)sender completionBlock:(void (^)(id obj, NSError *error))completionBlock;

// base URL
extern NSString *const baseServerURL;

@end
