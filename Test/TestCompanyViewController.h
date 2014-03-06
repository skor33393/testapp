//
//  TestCompanyViewController.h
//  Test
//
//  Created by Admin on 06.03.14.
//  Copyright (c) 2014 Alex Korenev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestCompanyViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITableViewCell *employeesCount;
@property (weak, nonatomic) IBOutlet UITableViewCell *allHours;
@property (weak, nonatomic) IBOutlet UITableViewCell *averageHours;

@end
