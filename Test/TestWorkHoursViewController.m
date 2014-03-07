//
//  TestWorkHoursViewController.m
//  Test
//
//  Created by Admin on 05.03.14.
//  Copyright (c) 2014 Alex Korenev. All rights reserved.
//

#import "TestWorkHoursViewController.h"

@interface TestWorkHoursViewController ()
@property (nonatomic, strong) NSArray *sortedKeys;
@end

@implementation TestWorkHoursViewController

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.hours count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"work hours cell"];

    NSString *key = [self.sortedKeys objectAtIndex:indexPath.row];
    cell.textLabel.text = key;
    cell.detailTextLabel.text = [self.hours objectForKey:key];
    
    return cell;
}

#pragma mark - View Controller Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.workHoursTableView.dataSource = self;
    
    NSArray *toSort = [self.hours allKeys];
    self.sortedKeys = [toSort sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = (NSString *)a;
        NSString *second = (NSString *)b;
        
        return [first compare:second];
    }];
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
