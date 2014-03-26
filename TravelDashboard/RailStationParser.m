//
//  RailStationParser.m
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

#import "RailStationParser.h"
#import "RailStation.h"

@implementation RailStationParser

-(NSMutableArray *)loadAndParseWithFilePath:(NSString *)filePath
{
    NSLog(@"Parsing file...");
    NSArray *pathFragments = [filePath componentsSeparatedByString:@"."];
    NSString *path = pathFragments[0];
    NSString *type = pathFragments[1];
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:path ofType:type];
    
    NSError *error;
    NSString *csvData = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:&error];
    NSArray *stationRawData = [csvData componentsSeparatedByString:@"\n"];
    
    NSArray *singleStation = [NSArray array];
    NSMutableArray *allStations = [NSMutableArray array];
    
    for (int i = 1; i < stationRawData.count-1; i++)
    {
        NSString *nextStationString = [NSString stringWithFormat:@"%@", stationRawData[i]];
        singleStation = [nextStationString componentsSeparatedByString:@","];
        
        NSString *name = [singleStation[3] substringFromIndex:1];
        name = [name substringToIndex:[name length] - 1];
        NSString *crs = [singleStation[2] substringFromIndex:1];
        crs = [crs substringToIndex:[crs length] - 1];
        
        RailStation *station = [[RailStation alloc] initWithName:name crs:crs];
        [allStations addObject:station];
    }
    return allStations;
}

@end
