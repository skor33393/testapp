//
//  TestCompanyViewController.m
//  Test
//
//  Created by Admin on 06.03.14.
//  Copyright (c) 2014 Alex Korenev. All rights reserved.
//

#import "TestCompanyViewController.h"
#import "TestEmployeeStorage.h"
#import "TestEmployee.h"

@interface TestCompanyViewController ()
@property (nonatomic, strong) NSArray *employees;
@end

@implementation TestCompanyViewController

#pragma mark - View Controller Lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // creating activity view
    UIView *activityView = [[UIView alloc] initWithFrame:self.view.frame];
    [activityView setBackgroundColor:[UIColor whiteColor]];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = activityView.center;
    
    [activityView addSubview:activityIndicator];
    
    [self.view addSubview:activityView];
    [activityIndicator startAnimating];
    
    [[TestEmployeeStorage sharedStorage] fetchEmployeesWithCompletionHandler:^(NSArray *employees, NSError *error) {
        self.employees = employees;
        self.employeesCount.detailTextLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.employees count]];
        NSInteger hours = 0;
        for (TestEmployee *empl in self.employees) {
            hours += [[empl all_hours] intValue];
        }
        self.allHours.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)hours];
        self.averageHours.detailTextLabel.text = [NSString stringWithFormat:@"%u", hours / [self.employees count]];
        
        [activityView removeFromSuperview];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
