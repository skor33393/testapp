//
//  TestWorkHoursViewController.h
//  Test
//
//  Created by Admin on 05.03.14.
//  Copyright (c) 2014 Alex Korenev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestWorkHoursViewController : UIViewController <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *workHoursTableView;
@property (strong, nonatomic) NSDictionary *hours;
@end
