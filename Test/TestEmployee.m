//
//  TestEmployee.m
//  Test
//
//  Created by Admin on 05.03.14.
//  Copyright (c) 2014 Alex Korenev. All rights reserved.
//

#import "TestEmployee.h"

static NSString *host = @"http://sizer.highglossy.com";

@implementation TestEmployee

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.employeeID = [dict objectForKey:@"id"];
        self.first_name = [dict objectForKey:@"first_name"];
        self.last_name = [dict objectForKey:@"last_name"];
        self.position = [dict objectForKey:@"position"];
        self.number = [dict objectForKey:@"number"];
        self.all_hours = [dict objectForKey:@"all_hours"];
        self.photoURL = [dict objectForKey:@"photo"];
        self.photo = nil;
        self.hours = [dict objectForKey:@"hours"];

    }
    return self;
}


@end
