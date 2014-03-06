//
//  TestEmployeeInfoViewController.m
//  Test
//
//  Created by Admin on 05.03.14.
//  Copyright (c) 2014 Alex Korenev. All rights reserved.
//

#import "TestEmployeeInfoViewController.h"
#import "TestEmployeeStorage.h"
#import "TestIconDownloader.h"
#import "TestWorkHoursViewController.h"

@interface TestEmployeeInfoViewController ()

@end

@implementation TestEmployeeInfoViewController

- (void)loadData {
    
    // creating activity view
    UIView *activityView = [[UIView alloc] initWithFrame:self.view.frame];
    [activityView setBackgroundColor:[UIColor whiteColor]];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = activityView.center;
    
    [activityView addSubview:activityIndicator];
    
    [self.view addSubview:activityView];
    [activityIndicator startAnimating];
    
    // fetch user info
    [[TestEmployeeStorage sharedStorage] getUserInfoWithID:self.employeeID andCompletion:^(TestEmployee *employee, NSError *error) {
        [activityView removeFromSuperview];
        self.employee = employee;
        self.name.text = [NSString stringWithFormat:@"%@ %@", [self.employee first_name], [self.employee last_name]];
        self.position.text = [NSString stringWithFormat:@"должность: %@", [self.employee position]];
        self.number.text = [NSString stringWithFormat:@"тел. %@", [self.employee number]];
        
        NSInteger avgHours = 0;
        if ([self.employee.hours count]) {
            for (id key in self.employee.hours) {
                avgHours += [[self.employee.hours objectForKey:key] intValue];
            }
            avgHours /= [self.employee.hours count];
            self.averageHours.text = [NSString stringWithFormat:@"среднее время работы: %ld", (long)avgHours];
        }
        else {
            self.averageHours.text = @"среднее время работы: неизвестно";
        }
        
        if (!self.employee.photo) {
            [self getImage];
        }
        else {
            self.photo.image = self.employee.photo;
        }
    }];
}

- (void)getImage {
    TestIconDownloader *iconDownloader = [[TestIconDownloader alloc] init];
    iconDownloader.employee = self.employee;
    
    [iconDownloader setCompletionHandler:^{
            
        if (self.employee.photo) {
            // Display the newly loaded image
            self.photo.image = self.employee.photo;
        }
        else {
            self.photo.image = [UIImage imageNamed:@"Placeholder"];
        }
    }];
    
    [iconDownloader startDownload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Work hours"]) {
        TestWorkHoursViewController *vc = (TestWorkHoursViewController *)[segue destinationViewController];
        
        vc.hours = self.employee.hours;
    }
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end