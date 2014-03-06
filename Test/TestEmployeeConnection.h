//
//  TestEmployeeStorageConnection.h
//  Test
//
//  Created by Admin on 05.03.14.
//  Copyright (c) 2014 Alex Korenev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestEmployeeConnection : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSURLConnection *internalConnection;
    NSMutableData *container;
}

@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, copy) void (^completionBlock)(id obj, NSError *error);

- (id)initWithReuest:(NSURLRequest *)request;
- (void)start;

@end
