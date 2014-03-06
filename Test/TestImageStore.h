//
//  TestImageStore.h
//  Test
//
//  Created by Admin on 05.03.14.
//  Copyright (c) 2014 Alex Korenev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestEmployee.h"

@interface TestImageStore : NSObject

+ (TestImageStore *)sharedStore;
- (void)getEmployeePhoto:(TestEmployee *)empl withCompletionHandler:(void (^)(UIImage *image, NSError *error))block;

@end
