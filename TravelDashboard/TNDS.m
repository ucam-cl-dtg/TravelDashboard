//
//  TNDS.m
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

typedef struct
{
    UInt16 numStops;
    UInt16 numRoutes;
    UInt16 numPatterns;
    UInt16 numDayPatterns;
    UInt16 numJourneys;
    UInt16 padding;
} FileInfo;

typedef struct
{
    char ref[16];
    char name[32];
} BusStop;

typedef struct
{
    UInt16 numStops;
    UInt16 stopIdxs[126];
} Route;

typedef struct
{
    char string[72];
} RouteDescription;

typedef struct
{
    UInt16 routeIdx;
    UInt8 timeOffsets[126];
} Pattern;

typedef struct
{
    char isOperating[188];
} Days;

typedef struct
{
    UInt16 startTime;
    UInt16 daysIdx;
    UInt16 routeIdx;
    UInt16 patternIdx;
} Journey;

#import "TNDS.h"
@interface TNDS (){
    FileInfo *_pFileInfo;
    BusStop *_busStops;
    Route *_routes;
    RouteDescription *_routeDescriptions;
    Pattern *_patterns;
    Days *_days;
    Journey *_journeys;
    int _todayDayIdx;
}
@property (nonatomic, strong) NSData *data;
@end


@implementation TNDS

-(id) init {
    if (self = [super init]){
        NSString *filename = [[NSBundle mainBundle] pathForResource:@"tnds" ofType:@"bin"];
        self.data = [NSData dataWithContentsOfFile:filename];
        const char* fileBytes = (const char*)[self.data bytes];
        _pFileInfo = (FileInfo*)fileBytes;
        _busStops = (BusStop*) (fileBytes + sizeof(FileInfo));
        _routes = (Route*) (((char*) _busStops) + _pFileInfo->numStops*sizeof(BusStop));
        _routeDescriptions = (RouteDescription*) (((char*) _routes) + _pFileInfo->numRoutes*sizeof(Route));
        _patterns = (Pattern*) (((char*) _routeDescriptions) + _pFileInfo->numRoutes*sizeof(RouteDescription));
        _days = (Days*) (((char*) _patterns) + _pFileInfo->numPatterns*sizeof(Pattern));
        _journeys = (Journey*) (((char*) _days) + _pFileInfo->numDayPatterns*sizeof(Days));
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setDay:18];
        [components setMonth:2];
        [components setYear:2014];
        NSDate *startDate = [calendar dateFromComponents:components];
        NSDate *today = [NSDate date];
        NSTimeInterval timeInterval = [today timeIntervalSinceDate:startDate];
        _todayDayIdx = (int) floor(timeInterval/(60*60*24));
        
    }
    return self;
}

-(void) querySegment:(JourneySegment *)journeySegment
          toGetStart:(NSMutableArray *)startTnds
                 end:(NSMutableArray *)endTnds{
    
    // Check which opperating patterns are valid
    BOOL daysOk[_pFileInfo->numDayPatterns];
    for (int i=0; i<_pFileInfo->numDayPatterns; i++)
    {
        daysOk[i] = _days[i].isOperating[_todayDayIdx];
    }
    
    // Get the stop indexes of the start and end points
    int startStopIdx = [self lookupStopIdxForStopRef:journeySegment.startPoint];
    int endStopIdx = [self lookupStopIdxForStopRef:journeySegment.endPoint];
    
    // Check which routes are valid
    BOOL routeOk[_pFileInfo->numRoutes];
    int startStopIdxForRoute[_pFileInfo->numRoutes];
    int endStopIdxForRoute[_pFileInfo->numRoutes];
    for (int i=0; i<_pFileInfo->numRoutes; i++){
        BOOL startMatched = NO;
        BOOL endMatched = NO;
        for (int j=0; j<_routes[i].numStops; j++){
            if (_routes[i].stopIdxs[j] == startStopIdx){
                startMatched = YES;
                startStopIdxForRoute[i] = j;
            }
            if (_routes[i].stopIdxs[j] == endStopIdx){
                endMatched = YES;
                endStopIdxForRoute[i] = j;
            }
        }
        routeOk[i] = startMatched & endMatched & (startStopIdxForRoute[i] < endStopIdxForRoute[i]);
    }
    
    // Check which journeys are valid and store the results, orderd by departure time.
    for (int i=0; i<_pFileInfo->numJourneys; i++) {
        int daysIdxForJourney = _journeys[i].daysIdx;
        int routeIdxForJourney = _journeys[i].routeIdx;
        if (daysOk[daysIdxForJourney] & routeOk[routeIdxForJourney]) {
            int tStartMin = _journeys[i].startTime + _patterns[_journeys[i].patternIdx].timeOffsets[startStopIdxForRoute[routeIdxForJourney]];
            int tEndMin = _journeys[i].startTime + _patterns[_journeys[i].patternIdx].timeOffsets[endStopIdxForRoute[routeIdxForJourney]];
            NSString *startString = [NSString stringWithFormat:@"%02i:%02i", tStartMin/60, tStartMin%60];
            NSString *endString = [NSString stringWithFormat:@"%02i:%02i", tEndMin/60, tEndMin%60];
            
            NSUInteger newIndex = [startTnds indexOfObject:startString
                                             inSortedRange:(NSRange){0, [startTnds count]}
                                                   options:NSBinarySearchingInsertionIndex
                                           usingComparator:^(id a, id b) {
                                               return [a compare:b];
                                           }];
            
            [startTnds insertObject:startString atIndex:newIndex];
            [endTnds insertObject:endString atIndex:newIndex];
        }
    }

}

-(int) lookupStopIdxForStopRef:(NSString*)stopRef{
    const char *stopRefString = [stopRef UTF8String];
    for (int i=0; i<_pFileInfo->numStops; i++) {
        if (strcmp(stopRefString, _busStops[i].ref)==0) {
            return i;
        }
    }
    return -1;
}
    
@end
