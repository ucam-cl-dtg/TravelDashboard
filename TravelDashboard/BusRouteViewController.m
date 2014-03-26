//
//  BusRouteViewController.m
//  TravelDashboard
//
//  Copyright 2014 Ian Sheret
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "BusRouteViewController.h"
#import "BusRouteParser.h"
#import "BusRoute.h"

@interface BusRouteViewController ()

@end

@implementation BusRouteViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        BusRouteParser *busRouteParser = [[BusRouteParser alloc] init];
        _allRoutes = [busRouteParser loadAndParseWithFilePath:@"EA.csv"];
        
        NSLog(@"_allRoutes.count = %lu", (unsigned long)_allRoutes.count);
        _searchData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    self.tableView.tableHeaderView = _searchBar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _searchData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    // Configure the cell...
    NSString *lineName = [[_searchData objectAtIndex:[indexPath row]] lineName];
    NSString *routeName = [[_searchData objectAtIndex:[indexPath row]] routeName];
    NSString *text = [[lineName stringByAppendingString:@": "] stringByAppendingString:routeName];
    [[cell textLabel] setText:text];
    return cell;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [_searchData removeAllObjects];
    BusRoute *busRoute;
    for (busRoute in _allRoutes)
    {
        if ([busRoute.lineName caseInsensitiveCompare:searchString] == NSOrderedSame){
            [_searchData addObject:busRoute]; //add the element to group
        }
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *lineName = [[_searchData objectAtIndex:[indexPath row]] lineName];
    NSString *routeName = [[_searchData objectAtIndex:[indexPath row]] routeName];
    NSString *text = [[lineName stringByAppendingString:@": "] stringByAppendingString:routeName];
    [self.journeySegment setService:text];
    NSLog(@"Stored %@.", text);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
