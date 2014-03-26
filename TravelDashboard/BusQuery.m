//
//  BusQuery.m
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

#import "BusQuery.h"
#import "BusTimeQuery.h"
#import "AppDelegate.h"
#import "TNDS.h"

@implementation BusQuery {
    int _index;
    int _numQueriesPending;
}

-(void) makeQueryWithIndex:(int)index {
    _index = index;
    
    // Set up output data structure
    self.busTimeResponses = [[NSMutableArray alloc] init];
    for (int i=0; i<4; i++) {
        [self.busTimeResponses addObject:[NSNull null]];
    }
  
    // Do live queries
    _numQueriesPending = 2;
    BusLiveQuery *startQuery = [[BusLiveQuery alloc] init];
    [self.busTimeQueries addObject:startQuery];
    [startQuery setDelegate:self];
    [startQuery setBusStop:self.journeySegment.startPoint];
    [startQuery setService:self.journeySegment.service];
    [startQuery makeQueryWithIndex:0];
    BusLiveQuery *endQuery = [[BusLiveQuery alloc] init];
    [self.busTimeQueries addObject:endQuery];
    [endQuery setDelegate:self];
    [endQuery setBusStop:self.journeySegment.endPoint];
    [endQuery setService:self.journeySegment.service];
    [endQuery makeQueryWithIndex:1];
    
}

-(void) busLiveQueryWithIndex:(int)index returnedTimetableTimes:(NSArray *)timetableTimes liveTimes:(NSArray *)liveTimes {
    [self.busTimeResponses replaceObjectAtIndex:index withObject:timetableTimes];
    [self.busTimeResponses replaceObjectAtIndex:index+2 withObject:liveTimes];
    _numQueriesPending--;
    NSLog(@"Got bus %i time back, first is at %@.", index, [timetableTimes objectAtIndex:0]);
    
    if (_numQueriesPending == 0) {
        [self processResults];
    }
}

-(void) busLiveQueryFailedWithIndex:(int)index {
    [self.delegate segmentQueryFailedWithIndex:_index];
}

-(void) processResults {
    
    NSMutableArray *startTimetable = [self.busTimeResponses objectAtIndex:0];
    NSMutableArray *endTimetable = [self.busTimeResponses objectAtIndex:1];
    NSMutableArray *startLive = [self.busTimeResponses objectAtIndex:2];
    NSMutableArray *endLive = [self.busTimeResponses objectAtIndex:3];
    unsigned long numStart = startTimetable.count;
    unsigned long numEnd = endTimetable.count;
    
    // Get scheduled services
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    TNDS *tnds = appDelegate.tnds;
    NSMutableArray *startTnds = [[NSMutableArray alloc] init];
    NSMutableArray *endTnds = [[NSMutableArray alloc] init];
    [tnds querySegment:self.journeySegment toGetStart:startTnds end:endTnds];
    
    NSMutableArray *startTndsLive = [[NSMutableArray alloc] init];
    NSMutableArray *endTndsLive = [[NSMutableArray alloc] init];
    NSMutableArray *isCanceled = [[NSMutableArray alloc] init];
    for (int i=0; i<startTnds.count; i++) {
        NSString *a = [startTnds objectAtIndex:i];
        BOOL hasStartLive = NO;
        int startIdx;
        for (int j=0; j<numStart; j++) {
            if ([a compare:[startTimetable objectAtIndex:j]] == (NSComparisonResult) NSOrderedSame){
                hasStartLive = YES;
                startIdx = j;
            }
        }
        int endIdx;
        BOOL hasEndLive = NO;
        for (int j=0; j<numEnd; j++) {
            if ([a compare:[endTimetable objectAtIndex:j]] == (NSComparisonResult) NSOrderedSame){
                hasEndLive = YES;
                endIdx = j;
            }
        }
        
        
        if (hasStartLive & hasEndLive) {
            [startTndsLive addObject:[startLive objectAtIndex:startIdx]];
            [endTndsLive addObject:[endLive objectAtIndex:endIdx]];
            [isCanceled addObject:[NSNumber numberWithBool:NO]];
        } else if (hasStartLive) {
            [startTndsLive addObject:[startLive objectAtIndex:startIdx]];
            int endTime =
                [self getIntFromTimeString:[startLive objectAtIndex:startIdx]] -
                [self getIntFromTimeString:[startTnds objectAtIndex:i]] +
                [self getIntFromTimeString:[endTnds objectAtIndex:i]];
            [endTndsLive addObject:[NSString stringWithFormat:@"%02i:%02i", endTime/60, endTime%60]];
            [isCanceled addObject:[NSNumber numberWithBool:NO]];
        } else if (hasEndLive) {
            int startTime =
                [self getIntFromTimeString:[endLive objectAtIndex:endIdx]] +
                [self getIntFromTimeString:[startTnds objectAtIndex:i]] -
                [self getIntFromTimeString:[endTnds objectAtIndex:i]];
            [startTndsLive addObject:[NSString stringWithFormat:@"%02i:%02i", startTime/60, startTime%60]];
            [endTndsLive addObject:[endLive objectAtIndex:endIdx]];
            [isCanceled addObject:[NSNumber numberWithBool:NO]];
        } else {
            [startTndsLive addObject:[startTnds objectAtIndex:i]];
            [endTndsLive addObject:[endTnds objectAtIndex:i]];
            if (([self getIntFromTimeString:[startTimetable firstObject]] < [self getIntFromTimeString:[startTnds objectAtIndex:i]]) &
                ([self getIntFromTimeString:[startTnds objectAtIndex:i]] < [self getIntFromTimeString:[startLive lastObject]])) {
                [isCanceled addObject:[NSNumber numberWithBool:YES]];
            } else {
                [isCanceled addObject:[NSNumber numberWithBool:NO]];
            }
        }
        
    }
    
    // Delete canceled services
    for (int i=startTnds.count-1; i>=0; i--) {
        if ([[isCanceled objectAtIndex:i] boolValue] == YES) {
            [startTnds removeObjectAtIndex:i];
            [endTnds removeObjectAtIndex:i];
            [startTndsLive removeObjectAtIndex:i];
            [endTndsLive removeObjectAtIndex:i];
        }
    }
    
    // Pass results up to the delegate
    SegmentInfo *segmentInfo = [[SegmentInfo alloc] init];
    [segmentInfo setScheduledStart:startTnds];
    [segmentInfo setScheduledEnd:endTnds];
    [segmentInfo setExpectedStart:startTndsLive];
    [segmentInfo setExpectedEnd:endTndsLive];
    [self.delegate segmentQueryWithIndex:_index returnedInfo:segmentInfo];
    
}

- (int) getIntFromTimeString:(NSString*)string {
    NSString *hoursString = [string substringToIndex:2];
    NSString *minsString = [string substringFromIndex:3];
    int hours = (int) [hoursString integerValue];
    int mins = (int) [minsString integerValue];
    return (hours*60 + mins);
}

@end
