//
//  TestImageStore.m
//  Test
//
//  Created by Admin on 05.03.14.
//  Copyright (c) 2014 Alex Korenev. All rights reserved.
//

#import "TestImageStore.h"
#import "TestEmployeeConnection.h"


@interface TestImageStore ()
@property (nonatomic, strong) NSMutableDictionary *images;
@end

@implementation TestImageStore

+ (TestImageStore *)sharedStore {
    static TestImageStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[TestImageStore alloc] init];
    }
    
    return sharedStore;
}

- (void)getEmployeePhoto:(TestEmployee *)empl withCompletionHandler:(void (^)(UIImage *, NSError *))block {
    
    // if employee photoURL is not valid assign Placeholfer for it
    
    if ([self.images objectForKey:empl.employeeID]) {
        block([self.images objectForKey:empl.employeeID], nil);
        return;
    }
    
    NSString *requestString = [NSString stringWithFormat:@"%@", empl.photoURL];
    
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
        
    TestEmployeeConnection *connection = [[TestEmployeeConnection alloc] initWithReuest:request];
    
    [connection setCompletionBlock:^(NSData *data, NSError *error) {
        //NSLog(@"%@", data);
        UIImage *image = [UIImage imageWithData:data];
        [self.images setObject:image forKey:empl.employeeID];
        
        block(image, nil);
    }];
    
    [connection start];

}

@end
