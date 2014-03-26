//
//  BusStopViewController.m
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

#import "BusStopViewController.h"
#import "BusRouteParser.h"
#import "BusRoute.h"

@interface BusStopViewController ()

@end

@implementation BusStopViewController

- (id)initWithStyle:(UITableViewStyle)style
     journeySegment:(JourneySegment*)journeySegment
{
    self = [super initWithStyle:style];
    if (self) {
        self.journeySegment = journeySegment;
        NSLog(@"Trying to find route");
        BusRouteParser *busRouteParser = [[BusRouteParser alloc] init];
        NSArray *allRoutes = [busRouteParser loadAndParseWithFilePath:@"EA.csv"];
        for (BusRoute *busRoute in allRoutes) {
            NSString *lineName = [busRoute lineName];
            NSString *routeName = [busRoute routeName];
            NSString *text = [[lineName stringByAppendingString:@": "] stringByAppendingString:routeName];
            if ([text isEqualToString:self.journeySegment.service]) {
                _allStops = busRoute.busStops;
                NSLog(@"Found route");
            }
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    return _allStops.count;
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
    NSString *text = [[_allStops objectAtIndex:[indexPath row]] name];
    [[cell textLabel] setText:text];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_row == 2) {
        [self.journeySegment setStartPoint:[[_allStops objectAtIndex:indexPath.row] ref]];
        [self.journeySegment setStartPointDisplay:[[_allStops objectAtIndex:indexPath.row] name]];
    } else {
        [self.journeySegment setEndPoint:[[_allStops objectAtIndex:indexPath.row] ref]];
        [self.journeySegment setEndPointDisplay:[[_allStops objectAtIndex:indexPath.row] name]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
