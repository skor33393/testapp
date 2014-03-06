//
//  TestIconDownloader.h
//  Test
//
//  Created by Admin on 05.03.14.
//  Copyright (c) 2014 Alex Korenev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TestEmployee;

@interface TestIconDownloader : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (nonatomic, strong) TestEmployee *employee;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;
- (void)cancelDownload;

@end
