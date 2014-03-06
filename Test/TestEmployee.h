//
//  TestEmployee.h
//  Test
//
//  Created by Admin on 05.03.14.
//  Copyright (c) 2014 Alex Korenev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestEmployee : NSObject

@property (nonatomic, strong) NSString *employeeID;
@property (nonatomic, strong) NSString *first_name;
@property (nonatomic, strong) NSString *last_name;
@property (nonatomic, strong) NSString *position;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *all_hours;
@property (nonatomic, strong) NSString *photoURL;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) NSDictionary *hours;

-(id)initWithDictionary:(NSDictionary *)dict;

@end
