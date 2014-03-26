//
//  MainViewController.m
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

#import "MainViewController.h"
#import "BuilderViewController.h"
#import "AppDelegate.h"
#import "DashboardViewController.h"
#import "ShowJourneyViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

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
    
    // Set the title, for the navigation bar
    self.title = NSLocalizedString(@"Journeys", @"Navigation bar title on the main view.");

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    // Create a button to add new journeys
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewJourney)];
    
    // Specify what sort of cell we'll be using
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier:@"Cell"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addNewJourney
{
    BuilderViewController *builderViewController = [[BuilderViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:builderViewController animated:YES];
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    unsigned long row = indexPath.row;
    if (row==0) [cell.textLabel setText:@"Uni4 -> CBG -> HIT (offline)"];
    if (row==1) [cell.textLabel setText:@"Uni4 -> CBG -> KGX"];
    if (row==2) [cell.textLabel setText:@"FXN -> CBG -> PBO"];
    return cell;
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
    // Nicely deselect the cell
    
    // Handle the offline demo
    if (indexPath.row == 0) {
    
        // Generate a journey spec
        JourneySegment *walk1 = [[JourneySegment alloc] init];
        walk1.journeyMode = JourneyModeWalk;
        walk1.durationMin = 2.0;
        JourneySegment *bus = [[JourneySegment alloc] init];
        bus.journeyMode = JourneyModeBus;
        bus.service = @"UNI4:";
        bus.startPoint = @"0500CCITY424";
        bus.endPoint = @"0500CCITY471";
        JourneySegment *walk2 = [[JourneySegment alloc] init];
        walk2.journeyMode = JourneyModeWalk;
        walk2.durationMin = 8.0;
        JourneySegment *train = [[JourneySegment alloc] init];
        train.journeyMode = JourneyModeTrain;
        train.startPoint = @"CBG";
        train.endPoint = @"HIT";
        JourneySegment *walk3 = [[JourneySegment alloc] init];
        walk3.journeyMode = JourneyModeWalk;
        walk3.durationMin = 12.0;
        NSMutableArray *journeySpec = [[NSMutableArray alloc] initWithObjects:walk1,bus,walk2,train,walk3,nil];
        
        // Generate journey info
        SegmentInfo *walk1Info = [[SegmentInfo alloc] init];
        SegmentInfo *busInfo = [[SegmentInfo alloc] init];
        busInfo.scheduledStart = [[NSMutableArray alloc] initWithObjects:@"07:07",@"07:27",@"07:47",@"08:07",@"08:27",@"08:47",@"09:07",@"09:30",@"09:50",@"10:10",@"10:30",@"10:50",@"11:10",@"11:30",@"11:50",@"12:10",@"12:30",@"12:50",@"13:10",@"13:30",@"13:50",@"14:10",@"14:30",@"14:50",@"15:10",@"15:30",@"15:50",@"16:10",@"16:30",@"16:50",@"17:10",@"17:30",@"17:50",@"18:10",@"18:30",@"18:50",@"19:10",@"19:30",nil];
        busInfo.scheduledEnd = [[NSMutableArray alloc] initWithObjects:@"07:26",@"07:46",@"08:06",@"08:26",@"08:46",@"09:06",@"09:26",@"09:46",@"10:06",@"10:26",@"10:46",@"11:06",@"11:26",@"11:46",@"12:06",@"12:26",@"12:46",@"13:06",@"13:26",@"13:46",@"14:06",@"14:26",@"14:46",@"15:06",@"15:26",@"15:46",@"16:06",@"16:26",@"16:46",@"17:06",@"17:26",@"17:46",@"18:06",@"18:26",@"18:46",@"19:06",@"19:26",@"19:46", nil];
        busInfo.expectedStart = [[NSMutableArray alloc] initWithObjects:@"07:07",@"07:27",@"07:47",@"08:07",@"08:27",@"08:47",@"09:07",@"09:30",@"09:50",@"10:10",@"10:30",@"10:50",@"11:10",@"11:30",@"11:50",@"12:10",@"12:30",@"12:50",@"13:10",@"13:30",@"13:50",@"14:10",@"14:30",@"14:50",@"15:10",@"15:30",@"15:50",@"16:10",@"16:30",@"16:50",@"17:10",@"17:30",@"17:50",@"18:10",@"18:30",@"18:50",@"19:10",@"19:30",nil];
        busInfo.expectedEnd = [[NSMutableArray alloc] initWithObjects:@"07:26",@"07:46",@"08:06",@"08:26",@"08:46",@"09:06",@"09:26",@"09:46",@"10:06",@"10:26",@"10:46",@"11:06",@"11:26",@"11:46",@"12:06",@"12:26",@"12:46",@"13:06",@"13:26",@"13:46",@"14:06",@"14:26",@"14:46",@"15:06",@"15:26",@"15:46",@"16:06",@"16:26",@"16:46",@"17:06",@"17:26",@"17:46",@"18:06",@"18:26",@"18:46",@"19:06",@"19:26",@"19:46", nil];
        SegmentInfo *walk2Info = [[SegmentInfo alloc] init];
        SegmentInfo *trainInfo = [[SegmentInfo alloc] init];
        trainInfo.scheduledStart = [[NSMutableArray alloc] initWithObjects:@"05:35",@"06:15",@"06:27",@"06:57",@"07:27",@"07:55",@"08:25",@"08:55",@"09:30",@"09:55",@"10:30",@"10:55",@"11:30",@"11:55",@"12:30",@"12:55",@"13:30",@"13:55",@"14:30",@"14:55",@"15:30",@"15:55",@"16:25",@"16:55",@"17:25",@"17:55",@"18:25",@"18:55",@"19:25",@"19:55",@"20:30",@"20:55",@"21:30",@"21:55",@"22:30",@"23:15",nil];
        trainInfo.scheduledEnd = [[NSMutableArray alloc] initWithObjects:@"06:23",@"06:43",@"07:09",@"07:36",@"08:05",@"08:33",@"09:04",@"09:34",@"09:59",@"10:34",@"11:00",@"11:34",@"12:00",@"12:34",@"13:00",@"13:34",@"14:00",@"14:34",@"15:00",@"15:34",@"16:00",@"16:34",@"17:01",@"17:34",@"18:01",@"18:34",@"19:04",@"19:34",@"20:04",@"20:34",@"21:00",@"21:34",@"22:00",@"22:34",@"23:00",@"23:53",nil];
        trainInfo.expectedStart = [[NSMutableArray alloc] initWithObjects:@"05:35",@"06:15",@"06:27",@"06:57",@"07:27",@"07:55",@"08:25",@"08:55",@"09:30",@"09:55",@"10:30",@"10:55",@"11:30",@"11:55",@"12:30",@"12:55",@"13:30",@"13:55",@"14:30",@"14:55",@"15:30",@"15:55",@"16:25",@"16:55",@"17:25",@"17:55",@"18:25",@"18:55",@"19:25",@"19:55",@"20:30",@"20:55",@"21:30",@"21:55",@"22:30",@"23:15",nil];
        trainInfo.expectedEnd = [[NSMutableArray alloc] initWithObjects:@"06:23",@"06:43",@"07:09",@"07:36",@"08:05",@"08:33",@"09:04",@"09:34",@"09:59",@"10:34",@"11:00",@"11:34",@"12:00",@"12:34",@"13:00",@"13:34",@"14:00",@"14:34",@"15:00",@"15:34",@"16:00",@"16:34",@"17:01",@"17:34",@"18:01",@"18:34",@"19:04",@"19:34",@"20:04",@"20:34",@"21:00",@"21:34",@"22:00",@"22:34",@"23:00",@"23:53",nil];
        SegmentInfo *walk3Info = [[SegmentInfo alloc] init];
        NSArray *journeyInfo = [[NSArray alloc] initWithObjects:walk1Info,busInfo,walk2Info,trainInfo,walk3Info,nil];

        // Push the graphical view
        DashboardViewController *dashboardViewController = [[DashboardViewController alloc] initWithJourneySpec:journeySpec
                                                                                                    journeyInfo:journeyInfo
                                                                                                      mcEnabled:YES];
        [self.navigationController pushViewController:dashboardViewController animated:YES];
    } else {
        
        // Set up the journey spec
        JourneySegment *seg1 = [[JourneySegment alloc] init];
        JourneySegment *seg2 = [[JourneySegment alloc] init];
        if (indexPath.row == 1) {
            [seg1 setJourneyMode:JourneyModeBus];
            [seg1 setStartPoint:@"0500CCITY424"];
            [seg1 setEndPoint:@"0500CCITY471"];
            [seg1 setService:@"UNI4:"];
            [seg2 setJourneyMode:JourneyModeTrain];
            [seg2 setStartPoint:@"CBG"];
            [seg2 setEndPoint:@"KGX"];
        }
        if (indexPath.row == 2) {
            [seg1 setJourneyMode:JourneyModeTrain];
            [seg1 setStartPoint:@"FXN"];
            [seg1 setEndPoint:@"CBG"];
            [seg2 setJourneyMode:JourneyModeTrain];
            [seg2 setStartPoint:@"CBG"];
            [seg2 setEndPoint:@"PBO"];
        }
        NSMutableArray *journeySpec = [[NSMutableArray alloc] initWithObjects:seg1, seg2, nil];
        ShowJourneyViewController *showJourneyViewController = [[ShowJourneyViewController alloc] init];
        [showJourneyViewController setJourneySpec:journeySpec];
        [self.navigationController pushViewController:showJourneyViewController animated:YES];
        
    }
    
}

@end
