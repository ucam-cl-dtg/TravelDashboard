//
//  ShowJourneyViewController.m
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

#import "ShowJourneyViewController.h"
#import "JourneySegment.h"
#import "DashboardViewController.h"
#import "AppDelegate.h"

@interface ShowJourneyViewController ()

@end

@implementation ShowJourneyViewController

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
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 70, 300, 100)];
    [self.infoLabel setText:@"Fetching results, please wait."];
    [self.infoLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:self.infoLabel];
    
    // Add in automatic walk section if required.
    if (self.journeySpec.count >= 2) {
        JourneySegment *firstSpec = [self.journeySpec objectAtIndex:0];
        JourneySegment *secondSpec = [self.journeySpec objectAtIndex:1];
        if (([firstSpec.endPoint compare:@"0500CCITY471"] == NSOrderedSame ) &
            ([secondSpec.startPoint compare:@"CBG"] == NSOrderedSame )){
            JourneySegment *walkToStation = [[JourneySegment alloc] init];
            walkToStation.durationMin = 8;
            walkToStation.journeyMode = JourneyModeWalk;
            [self.journeySpec insertObject:walkToStation atIndex:1];
        }
    }
    
	// Show the spec we're working with
    NSLog(@"Journey spec has %lu segments.", (unsigned long)self.journeySpec.count);
    for (int i=0; i<self.journeySpec.count; i++) {
        JourneySegment* segment = [self.journeySpec objectAtIndex:i];
        NSLog(@"Segment %i:", i);
        NSLog(@"Mode: %i", (int) segment.journeyMode);
        NSLog(@"From: %@", segment.startPoint);
        NSLog(@"To: %@", segment.endPoint);
        if (segment.journeyMode == JourneyModeBus) {
            NSLog(@"Service %@", segment.service);
        }
    }
    
    //  Get info for the spec
    self.journeyQuery = [[JourneyQuery alloc] init];
    [self.journeyQuery setDelegate:self];
    [self.journeyQuery setJourneySpec:self.journeySpec];
    [self.journeyQuery makeQuery];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) journeyQueryReturnedInfo:(NSArray *)journeyInfo {
    self.journeyInfo = journeyInfo;
    
    /*NSLog(@"Got journey info with %i segments:", journeyInfo.count);
    NSLog(@" ");
    for (int i=0; i<journeyInfo.count; i++) {
        JourneySegment *seg = [self.journeySpec objectAtIndex:i];
        NSLog(@"Segment %i, from %@ to %@.", i, [seg startPoint], [seg endPoint]);
        SegmentInfo *segInfo = [journeyInfo objectAtIndex:i];
        for (int j=0; j<[segInfo.scheduledStart count]; j++) {
            NSLog(@"%@ -> %@", [segInfo.scheduledStart objectAtIndex:j], [segInfo.scheduledEnd objectAtIndex:j]);
        }
    }*/
    
    DashboardViewController *dashboardViewController = [[DashboardViewController alloc] initWithJourneySpec:self.journeySpec
                                                                                                journeyInfo:self.journeyInfo];
    [self.navigationController pushViewController:dashboardViewController animated:YES];
    
}

-(void) journeyQueryFailed {
    [self.infoLabel setText:@"Query failed."];
}

@end
