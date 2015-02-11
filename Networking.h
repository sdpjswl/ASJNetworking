//
//  Networking.h
//  Networking
//
//  Created by Sudeep Jaiswal on 04/02/15.
//  Copyright (c) 2015 Sudeep Jaiswal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Networking : NSObject

// GET
+ (void)fireGETRequestForMethodNamed:(NSString *)name usingParameters:(NSDictionary *)params sender:(id)sender completionBlock:(void (^)(NSDictionary *dict))completionBlock failBlock:(void (^)(NSError *error))failBlock;

// POST
+ (void)firePOSTRequestForMethodNamed:(NSString *)name usingParameters:(NSDictionary *)params sender:(id)sender completionBlock:(void (^)(NSDictionary *dict))completionBlock failBlock:(void (^)(NSError *error))failBlock;

// base URL
extern NSString *const baseServerURL;

@end
