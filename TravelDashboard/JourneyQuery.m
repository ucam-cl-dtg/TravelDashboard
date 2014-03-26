//
//  JourneyQuery.m
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

#import "JourneyQuery.h"
#import "JourneySegment.h"
#import "SegmentInfo.h"
#import "TrainQuery.h"
#import "BusQuery.h"
#import "CarQuery.h"

@implementation JourneyQuery{
    int _numQueriesPending;
}
- (void) makeQuery{
    
    // Initialise output data structure.
    int numSegments = (int) self.journeySpec.count;
    self.journeyInfo = [[NSMutableArray alloc] init];
    for (int i=0; i<numSegments; i++) {
        [self.journeyInfo addObject:[NSNull null]];
    }
    _numQueriesPending = 0;
    
    // Make query for each segment
    self.segmentQueries = [[NSMutableArray alloc] init];
    for (int i=0; i<numSegments; i++){
        JourneySegment *journeySegment = [self.journeySpec objectAtIndex:i];
        
        if (journeySegment.journeyMode == JourneyModeTrain) {
            _numQueriesPending++;
            TrainQuery *trainQuery = [[TrainQuery alloc] init];
            [self.segmentQueries addObject:trainQuery];
            [trainQuery setDelegate:self];
            [trainQuery setJourneySegment:journeySegment];
            [trainQuery makeQueryWithIndex:i];
            NSLog(@"Train query.");
        }
        
        if (journeySegment.journeyMode == JourneyModeBus) {
            _numQueriesPending++;
            BusQuery *busQuery = [[BusQuery alloc] init];
            [self.segmentQueries addObject:busQuery];
            [busQuery setDelegate:self];
            [busQuery setJourneySegment:journeySegment];
            [busQuery makeQueryWithIndex:i];
        }
        
        if (journeySegment.journeyMode == JourneyModeCar) {
            _numQueriesPending++;
            CarQuery *carQuery = [[CarQuery alloc] init];
            [self.segmentQueries addObject:carQuery];
            [carQuery setDelegate:self];
            [carQuery setJourneySegment:journeySegment];
            [carQuery makeQueryWithIndex:i];
        }

    }
    
}

- (void) segmentQueryWithIndex:(int)index returnedInfo:(SegmentInfo*)segmentInfo {
    [self.journeyInfo replaceObjectAtIndex:index withObject:segmentInfo];
    _numQueriesPending -= 1;
    NSLog(@"Got segment info");
    if (_numQueriesPending == 0) {
        NSLog(@"Everything done.");
        [self.delegate journeyQueryReturnedInfo:self.journeyInfo];
    }
}

-(void) segmentQueryFailedWithIndex:(int)index {
    [self.delegate journeyQueryFailed];
}

@end
