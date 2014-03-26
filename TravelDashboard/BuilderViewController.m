//
//  BuilderViewController.m
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

#import "BuilderViewController.h"
#import "JourneySegment.h"
#import "ShowJourneyViewController.h"
#import "RailStationTableViewController.h"
#import "BusRouteViewController.h"
#import "BusStopViewController.h"

@interface BuilderViewController (){
    float _topPos;
    float _bottomPos;
}
@property (nonatomic, strong) NSMutableArray* journeySpec;
@property (nonatomic, strong) UIView *verticalLine;
@end

@implementation BuilderViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Show"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(showJourney)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    // Set the title, for the navigation bar
    self.title = NSLocalizedString(@"Build Journey", @"Navigation bar title on the journey builder.");
    
    // Specify what sort of cells we'll be using
    [self.tableView registerClass: [BuilderCell class] forCellReuseIdentifier:@"BuilderCell"];
    [self.tableView registerClass: [TextCell class] forCellReuseIdentifier:@"TextCell"];
    
    // Initialise the journey specification
    self.journeySpec = [NSMutableArray array];
    
    // Configure the table appearence
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.verticalLine = [[UIView alloc] initWithFrame:CGRectMake(158, 0, 4, 0)];
    self.verticalLine.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [self.view addSubview:self.verticalLine];
    [self.view sendSubviewToBack:self.verticalLine];
}

- (void) viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showJourney
{
    ShowJourneyViewController *showJourneyViewController = [[ShowJourneyViewController alloc] init];
    [showJourneyViewController setJourneySpec:self.journeySpec];
    [self.navigationController pushViewController:showJourneyViewController animated:YES];
}

#pragma mark - Builder cell delegate

- (void) journeyMode:(JourneyMode) journeyMode selectedInCell:(BuilderCell *)cell {

    // Work out which cell has been updated
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    unsigned long section = indexPath.section;
    unsigned long numSegments = self.journeySpec.count;
    
    // Change the background color and add lines
    CGFloat height = cell.bounds.size.height;
    CGFloat width = cell.bounds.size.height;
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, height-1, width, 1)];
    bottomLine.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    [cell.contentView addSubview:bottomLine];
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 1)];
    bottomLine.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    [cell.contentView addSubview:topLine];
    [UIView animateWithDuration:0.3 animations:^{
        cell.backgroundColor = [UIColor whiteColor];
        topLine.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        bottomLine.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }];
    
    // Handle the first segment
    if (numSegments==0) {
        
        JourneySegment* newSegment = [[JourneySegment alloc] init];
        newSegment.journeyMode = journeyMode;
        [self.tableView beginUpdates];
        [self.journeySpec addObject:newSegment];
        NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
        [indexSet addIndex:0];
        [indexSet addIndex:2];
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        NSMutableArray *newCellPaths = [NSMutableArray arrayWithObjects: [NSIndexPath indexPathForItem:0 inSection:0],
                                                                         [NSIndexPath indexPathForItem:1 inSection:1],
                                                                         [NSIndexPath indexPathForItem:0 inSection:2], nil];
        if (journeyMode != JourneyModeWalk) [newCellPaths insertObject:[NSIndexPath indexPathForItem:2 inSection:1] atIndex:2];
        if (journeyMode == JourneyModeBus) [newCellPaths insertObject:[NSIndexPath indexPathForItem:3 inSection:1] atIndex:3];
        [self.tableView insertRowsAtIndexPaths:newCellPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];

    }
    
    // Handle inset at the start
    else if (section == 0) {
        
        JourneySegment* newSegment = [[JourneySegment alloc] init];
        newSegment.journeyMode = journeyMode;
        [self.tableView beginUpdates];
        [self.journeySpec insertObject:newSegment atIndex:0];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        NSMutableArray *newCellPath = [NSMutableArray arrayWithObjects: [NSIndexPath indexPathForItem:0 inSection:0],
                                                                        [NSIndexPath indexPathForItem:1 inSection:1], nil];
        if (journeyMode != JourneyModeWalk) [newCellPath insertObject:[NSIndexPath indexPathForItem:2 inSection:1] atIndex:2];
        if (journeyMode == JourneyModeBus) [newCellPath insertObject:[NSIndexPath indexPathForItem:3 inSection:1] atIndex:3];
        [self.tableView insertRowsAtIndexPaths:newCellPath withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
    
    // Handle inset at the end
    else if (section == numSegments+1){
        
        JourneySegment* newSegment = [[JourneySegment alloc] init];
        newSegment.journeyMode = journeyMode;
        [self.tableView beginUpdates];
        [self.journeySpec insertObject:newSegment atIndex:self.journeySpec.count];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:numSegments+2];
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        NSMutableArray *newCellPath = [NSMutableArray arrayWithObjects: [NSIndexPath indexPathForItem:1 inSection:numSegments+1],
                                                          [NSIndexPath indexPathForItem:0 inSection:numSegments+2], nil];
        if (journeyMode != JourneyModeWalk) [newCellPath insertObject:[NSIndexPath indexPathForItem:2 inSection:numSegments+1] atIndex:1];
        if (journeyMode == JourneyModeBus) [newCellPath insertObject:[NSIndexPath indexPathForItem:3 inSection:numSegments+1] atIndex:2];
        [self.tableView insertRowsAtIndexPaths:newCellPath withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
    }
    
    // Handle mode change on an existing segment
    else {
        [self.tableView beginUpdates];
        
        // Update data structure
        JourneySegment *journeySegment = [self.journeySpec objectAtIndex:section-1];
        JourneyMode oldMode = journeySegment.journeyMode;
        [journeySegment setJourneyMode:journeyMode];
        [journeySegment setStartPoint:@""];
        [journeySegment setEndPoint:@""];
        [journeySegment setService:@""];
        [journeySegment setDurationMin:0.0];
        
        // Remove the existing cells
        NSMutableArray *oldCellPaths = [NSMutableArray arrayWithObjects: [NSIndexPath indexPathForItem:1 inSection:section], nil];
        if (oldMode != JourneyModeWalk){
            [oldCellPaths insertObject:[NSIndexPath indexPathForItem:2 inSection:section] atIndex:1];
        }
        if (oldMode == JourneyModeBus){
            [oldCellPaths insertObject:[NSIndexPath indexPathForItem:3 inSection:section] atIndex:2];
        }
        [self.tableView deleteRowsAtIndexPaths:oldCellPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        
        // Add the new cells
        NSMutableArray *newCellPath = [NSMutableArray arrayWithObjects: [NSIndexPath indexPathForItem:1 inSection:section], nil];
        if (journeyMode != JourneyModeWalk){
            [newCellPath insertObject:[NSIndexPath indexPathForItem:2 inSection:section] atIndex:1];
        }
        if (journeyMode == JourneyModeBus){
            [newCellPath insertObject:[NSIndexPath indexPathForItem:3 inSection:section] atIndex:2];
        }
        [self.tableView insertRowsAtIndexPaths:newCellPath withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.tableView endUpdates];
        
        // Update vertical bar
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.journeySpec.count+1];
        CGRect rectOfCellInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
        _bottomPos = rectOfCellInTableView.origin.y + rectOfCellInTableView.size.height/2.0;
        [UIView animateWithDuration:0.3 animations:^{
            self.verticalLine.frame = CGRectMake(158, _topPos, 4, _bottomPos - _topPos);
        }];
    }
}

#pragma mark - Text cell delegate

-(void) text:(NSString *)text setInCell:(TextCell *)cell {
    
    // Work out which cell has been updated
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    unsigned long section = indexPath.section;
    JourneySegment* segment = [self.journeySpec objectAtIndex: section - 1];
    if (indexPath.row  == 1) {
        if (segment.journeyMode == JourneyModeWalk) {
            segment.durationMin = [text floatValue];
        } else {
            [segment setStartPoint:text];
        }
    }
    if (indexPath.row  == 2) [segment setEndPoint:text];
    if (indexPath.row  == 3) [segment setService:text];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of rows in the section.
    unsigned long numSections;
    unsigned long numSegments = self.journeySpec.count;
    if (numSegments == 0) {
        numSections = 1;
    } else {
        numSections = numSegments + 2;
    }
    return numSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int numRows;
    unsigned long numSegments = self.journeySpec.count;
    if ((numSegments == 0) | (section == 0) | (section == (numSegments+1))) {
        numRows = 1;
    } else {
        JourneySegment* segment = [self.journeySpec objectAtIndex:section-1];
        if (segment.journeyMode == JourneyModeBus) {
            numRows = 4;
        } else if (segment.journeyMode == JourneyModeWalk) {
            numRows = 2;
        } else {
            numRows = 3;
        }
    }
    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Update the vertical line
    if (indexPath.section == 0) {
        CGRect rectOfCellInTableView = [tableView rectForRowAtIndexPath:indexPath];
        _topPos = rectOfCellInTableView.origin.y + rectOfCellInTableView.size.height/2.0;
        if (self.journeySpec.count==0) _bottomPos = _topPos;
        [UIView animateWithDuration:0.3 animations:^{
            self.verticalLine.frame = CGRectMake(158, _topPos, 4, _bottomPos - _topPos);
        }];
    }
    if (indexPath.section == (self.journeySpec.count+1)) {
        CGRect rectOfCellInTableView = [tableView rectForRowAtIndexPath:indexPath];
        _bottomPos = rectOfCellInTableView.origin.y + rectOfCellInTableView.size.height/2.0;
        [UIView animateWithDuration:0.3 animations:^{
            self.verticalLine.frame = CGRectMake(158, _topPos, 4, _bottomPos - _topPos);
        }];
    }
    
    JourneySegment* journeySegment;
    JourneyMode journeyMode;
    if (indexPath.row == 0) {
        BuilderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuilderCell" forIndexPath:indexPath];
        [cell setDelegate:self];
        unsigned long numSegments = self.journeySpec.count;
        if ((0 < indexPath.section) & (indexPath.section < (numSegments + 1))) {
            [cell.addButton setHidden:YES];
            [cell.modeSelector setHidden:NO];
            journeySegment = [self.journeySpec objectAtIndex:indexPath.section-1];
            journeyMode = journeySegment.journeyMode;
            [cell.modeSelector setSelectedSegmentIndex:(int)journeyMode];
        }
        return cell;
    } else {
        TextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell" forIndexPath:indexPath];
        [cell setDelegate:self];
        unsigned long section = indexPath.section;
        JourneySegment* journeySegment = [self.journeySpec objectAtIndex:section-1];
        journeyMode = journeySegment.journeyMode;
        
        // Do the field hints
        if (journeyMode == JourneyModeWalk) {
            [cell.hintLabel setText:@"Minutes"];
        } else if (journeyMode == JourneyModeBus) {
            NSArray *fieldHints = [NSArray arrayWithObjects:@"Service", @"From", @"To", nil];
            [cell.hintLabel setText:[fieldHints objectAtIndex:(indexPath.row - 1)]];
        } else {
            NSArray *fieldHints = [NSArray arrayWithObjects:@"From", @"To", nil];
            [cell.hintLabel setText:[fieldHints objectAtIndex:(indexPath.row - 1)]];
        }
        
        // Do cell content
        if (journeyMode == JourneyModeCar) {
            if (indexPath.row==1) [cell.textField setText:journeySegment.startPoint];
            if (indexPath.row==2) [cell.textField setText:journeySegment.endPoint];
        } else if (journeyMode == JourneyModeWalk) {
            if (journeySegment.durationMin > 0.0) {
                [cell.textField setText:[NSString stringWithFormat:@"%i", (int)roundf(journeySegment.durationMin)]];
            } else {
                [cell.textField setText:@""];
            }
        } else if (journeyMode == JourneyModeBus) {
            if (indexPath.row==1) [cell.textField setText:journeySegment.service];
            if (indexPath.row==2) [cell.textField setText:journeySegment.startPointDisplay];
            if (indexPath.row==3) [cell.textField setText:journeySegment.endPointDisplay];
        } else {
            if (indexPath.row==1) [cell.textField setText:journeySegment.startPointDisplay];
            if (indexPath.row==2) [cell.textField setText:journeySegment.endPointDisplay];
        }
        
        // Set up cell state
        if (cell.textField.text.length > 0) [cell.hintLabel setHidden:YES];
        if ((journeyMode != JourneyModeCar) & (journeyMode != JourneyModeWalk)) {
            cell.textField.userInteractionEnabled = false;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        } else {
            cell.textField.userInteractionEnabled = true;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        // Handle bus cells before the service is set
        if ((journeyMode == JourneyModeBus) & (journeySegment.service.length==0) & (indexPath.row > 0)){
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textField.userInteractionEnabled = false;
        }
        
        return cell;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((0<indexPath.section) & (indexPath.section <= self.journeySpec.count)){
     
        JourneySegment *journeySegment = [self.journeySpec objectAtIndex:indexPath.section-1];
        if (journeySegment.journeyMode == JourneyModeTrain) {
            RailStationTableViewController *railStationTableViewController = [[ RailStationTableViewController alloc] initWithStyle:UITableViewStylePlain];
            railStationTableViewController.journeySegment = journeySegment;
            railStationTableViewController.row = (int) indexPath.row;
            [self.navigationController pushViewController:railStationTableViewController animated:YES];
        } else {
            if (indexPath.row == 1) {
                BusRouteViewController *busRouteViewController = [[BusRouteViewController alloc] initWithStyle:UITableViewStylePlain];
                busRouteViewController.journeySegment = [self.journeySpec objectAtIndex:indexPath.section-1];
                [self.navigationController pushViewController:busRouteViewController animated:YES];
            } else {
                if (journeySegment.service.length > 0) {
                    BusStopViewController *busStopViewController = [[BusStopViewController alloc] initWithStyle:UITableViewStylePlain
                                                                                                 journeySegment:[self.journeySpec objectAtIndex:indexPath.section-1]];
                    busStopViewController.row = (int) indexPath.row;
                    [self.navigationController pushViewController:busStopViewController animated:YES];
                }
            }
        }
    }
}

@end
