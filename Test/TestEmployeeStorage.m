//
//  TestEmployeeStorage.m
//  Test
//
//  Created by Admin on 05.03.14.
//  Copyright (c) 2014 Alex Korenev. All rights reserved.
//

#import "TestEmployeeStorage.h"
#import "TestEmployeeConnection.h"

@interface TestEmployeeStorage ()
@property (nonatomic, strong) NSArray *employees;
@end

@implementation TestEmployeeStorage

+ (TestEmployeeStorage *)sharedStorage {
    static TestEmployeeStorage *sharedStorage = nil;
    if (!sharedStorage) {
        sharedStorage = [[TestEmployeeStorage alloc] init];
    }
    
    return sharedStorage;
}

- (void)fetchEmployeesWithCompletionHandler:(void (^)(NSArray *, NSError *))block {
    // if there is cached version of employees list - return it
    if (_employees) {
        NSLog(@"cached employees list");
        block(_employees, nil);
        return;
    }
    
    // make a request
    NSString *requestString = [NSString stringWithFormat:@"http://sizer.highglossy.com/employees"];
    
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    TestEmployeeConnection *connection = [[TestEmployeeConnection alloc] initWithReuest:request];
    
    [connection setCompletionBlock:^(NSData *obj, NSError *error) {
        if (!error) {
            // parsing data into employees array
            NSData *toParse = obj;
            NSError *parsingError = nil;
            NSArray *tempEmployees = [[NSArray alloc] init];
            NSMutableArray *afterParse = [[NSMutableArray alloc] init];
            id jsonObject = [NSJSONSerialization JSONObjectWithData:toParse options:NSJSONReadingAllowFragments error:&parsingError];
            if ([jsonObject isKindOfClass:[NSDictionary class]]) {
                if ([[jsonObject objectForKey:@"employees"] isKindOfClass:[NSArray class]]) {
                    tempEmployees = [jsonObject objectForKey:@"employees"];
                    for (NSDictionary *dict in tempEmployees) {
                        TestEmployee *employee = [[TestEmployee alloc] initWithDictionary:dict];
                        [afterParse addObject:employee];
                    }
                    _employees = afterParse;
                }
            }
            block(_employees, error);
        }
        else {
            block(nil, error);
        }
    }];
    
    [connection start];
}

- (void)getUserInfoWithID:(NSString *)employeeID andCompletion:(void (^)(TestEmployee *, NSError *))block {
    NSString *requestString = [NSString stringWithFormat:@"http://sizer.highglossy.com/employees/%@", employeeID];
    
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    TestEmployeeConnection *connection = [[TestEmployeeConnection alloc] initWithReuest:request];
    
    [connection setCompletionBlock:^(NSData *data, NSError *error) {
        if (!error) {
            NSData *toParse = data;
            TestEmployee *employee;
            NSError *parsingError = nil;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:toParse options:NSJSONReadingAllowFragments error:&parsingError];
            if ([jsonObject isKindOfClass:[NSDictionary class]]) {
                employee = [[TestEmployee alloc] initWithDictionary:jsonObject];
            }
            
            block(employee, nil);
        }
        else {
            block(nil, error);
        }
    }];

    [connection start];
}

@end
