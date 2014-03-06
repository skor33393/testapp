//
//  TestEmployeeStorage.h
//  Test
//
//  Created by Admin on 05.03.14.
//  Copyright (c) 2014 Alex Korenev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestEmployee.h"

@interface TestEmployeeStorage : NSObject

+ (TestEmployeeStorage *)sharedStorage;
// asynchronous request
- (void)fetchEmployeesWithCompletionHandler:(void (^)(NSArray *employees, NSError *error))block;
- (void)getUserInfoWithID:(NSString *)employeeID andCompletion:(void (^)(TestEmployee *employee, NSError *error))block;

@end
