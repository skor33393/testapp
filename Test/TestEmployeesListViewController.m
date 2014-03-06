//
//  TestEmployeesListViewController.m
//  Test
//
//  Created by Admin on 05.03.14.
//  Copyright (c) 2014 Alex Korenev. All rights reserved.
//

#import "TestEmployeesListViewController.h"
#import "TestEmployeeStorage.h"
#import "TestEmployee.h"
#import "TestEmployeesListCell.h"
#import "TestEmployeeInfoViewController.h"
#import "TestIconDownloader.h"
#import "TestImageStore.h"

@interface TestEmployeesListViewController ()

@property (nonatomic, strong) NSArray *employees;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic) int currentSort;

enum SortType {
    SortTypeByName = 0,
    SortTypeByHours = 1
};

@end

@implementation TestEmployeesListViewController

- (void)loadData {
    // creating activity view
    UIView *activityView = [[UIView alloc] initWithFrame:self.view.frame];
    [activityView setBackgroundColor:[UIColor whiteColor]];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = activityView.center;
    
    [activityView addSubview:activityIndicator];
    
    [self.view addSubview:activityView];
    [activityIndicator startAnimating];
    
    // fetch data and reload table view
    [[TestEmployeeStorage sharedStorage] fetchEmployeesWithCompletionHandler:^(NSArray *employees, NSError *error) {
        self.employees = employees;
        
        [activityView removeFromSuperview];
        
        // sort employees
        if (self.currentSort == SortTypeByName) {
            [self sortByName];
        }
        else {
            [self sortByHours];
        }
        [self.employeesList reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_employees count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestEmployeesListCell *cell = (TestEmployeesListCell *)[tableView dequeueReusableCellWithIdentifier:@"Employee"];
    TestEmployee *empl = [_employees objectAtIndex:indexPath.row];
    
    if ([self.employees count] > 0) {

        if (!empl.photo) {
            empl.photo = [UIImage imageNamed:@"Placeholder"];
            [self startIconDownload:empl forIndexPath:indexPath];
            cell.photo.image = empl.photo;
        }
        else {
            cell.photo.image = empl.photo;
        }
        
        cell.fullName.text = [NSString stringWithFormat:@"%@ %@", [empl first_name], [empl last_name]];
        if ([empl number]) {
            cell.phoneNumber.text = [NSString stringWithFormat:@"тел. %@", [empl number]];
        }
        cell.hours.text = [empl all_hours];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

/* Configure table view header */

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 320, 44)];
    [headerView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    // setting up segmented control
    NSArray *itemArray = [NSArray arrayWithObjects: @"По имени", @"По часам", nil];
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:itemArray];
    [control setFrame:CGRectMake(60.0, 0, 200.0, 30.0)];
    control.center = headerView.center;
    [control setSelectedSegmentIndex:self.currentSort];
    [control setEnabled:YES];
    
    [control addTarget:self action:@selector(sortValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [headerView addSubview:control];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}

#pragma mark - Control Sorting

- (void)sortByName {
    // sort array by alphabetic order
    NSArray *toSort = self.employees;
    self.employees = [toSort sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(TestEmployee *)a first_name];
        NSString *second = [(TestEmployee *)b first_name];
        if ([first isEqualToString:second]) {
            NSString *fsurname = [(TestEmployee *)a last_name];
            NSString *ssurname = [(TestEmployee *)b last_name];
            return [fsurname compare:ssurname];
        }
        return [first compare:second];
    }];
}

- (void)sortByHours {
    // sort array by hours
    NSArray *toSort = self.employees;
    self.employees = [toSort sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSInteger first = [[(TestEmployee *)a all_hours] intValue];
        NSInteger second = [[(TestEmployee *)b all_hours] intValue];
        return first < second;
    }];
}

- (void)sortValueChanged:(id)sender {
    // handle changed sort type
    UISegmentedControl *sc = (UISegmentedControl *)sender;
    NSInteger selectedIndex = [sc selectedSegmentIndex];

    if (selectedIndex != self.currentSort) {
        if (selectedIndex == SortTypeByName) {
            [self sortByName];
            self.currentSort = SortTypeByName;
            [self.employeesList reloadData];
        }
        else {
            [self sortByHours];
            self.currentSort = SortTypeByHours;
            [self.employeesList reloadData];
        }
    }
}

#pragma mark - Lazy loading

- (void)startIconDownload:(TestEmployee *)empl forIndexPath:(NSIndexPath *)indexPath
{
    TestIconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[TestIconDownloader alloc] init];
        iconDownloader.employee = empl;
        [iconDownloader setCompletionHandler:^{
            
            TestEmployeesListCell *cell = (TestEmployeesListCell *)[self.employeesList cellForRowAtIndexPath:indexPath];
            
            if (empl.photo) {
                // Display the newly loaded image
                cell.photo.image = empl.photo;
                
                // Remove the IconDownloader from the in progress list.
                // This will result in it being deallocated.
                [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            }
            
        }];
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Employee info"]) {
        
        // Get destination controller
        TestEmployeeInfoViewController *vc = (TestEmployeeInfoViewController *)[segue destinationViewController];
        
        NSIndexPath *path = [self.employeesList indexPathForSelectedRow];
        
        TestEmployee *empl = [_employees objectAtIndex:path.row];
        
        // set needed data to destination view controller
        vc.employeeID = [empl employeeID];
    }
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.employeesList.dataSource = self;
    self.employeesList.delegate = self;
    
    self.currentSort = SortTypeByName;
    
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
