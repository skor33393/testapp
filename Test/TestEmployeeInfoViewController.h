//
//  TestEmployeeInfoViewController.h
//  Test
//
//  Created by Admin on 05.03.14.
//  Copyright (c) 2014 Alex Korenev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestEmployee.h"

@interface TestEmployeeInfoViewController : UIViewController

@property (nonatomic, strong) NSString *employeeID;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) TestEmployee *employee;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UILabel *averageHours;
@property (weak, nonatomic) IBOutlet UILabel *number;

@end
