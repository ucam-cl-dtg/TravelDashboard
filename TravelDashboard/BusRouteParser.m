//
//  BusRouteParser.m
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

#import "BusRouteParser.h"
#import "BusRoute.h"

@implementation BusRouteParser
-(NSMutableArray *)loadAndParseWithFilePath:(NSString *)filePath
{
    NSLog(@"Parsing bus file...");
    NSArray *pathFragments = [filePath componentsSeparatedByString:@"."];
    NSString *path = pathFragments[0];
    NSString *type = pathFragments[1];
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:path ofType:type];
    
    NSError *error;
    NSString *csvData = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:&error];
    NSArray *routeRawData = [csvData componentsSeparatedByString:@"\n"];
    
    NSArray *singleRoute = [NSArray array];
    NSMutableArray *allRoutes = [NSMutableArray array];
    NSMutableArray *busStops;
    for (int i=0; i<routeRawData.count-1; i++)
    {
        NSString *nextRouteString = [NSString stringWithFormat:@"%@", routeRawData[i]];
        singleRoute = [nextRouteString componentsSeparatedByString:@","];
        
        NSString *lineName = singleRoute[0];
        NSString *routeName = singleRoute[1];
        int numStops = ((int)singleRoute.count - 2)/ 2;
        busStops = [NSMutableArray array];
        for (int j=0; j<numStops; j++) {
            BusStop *busStop = [[BusStop alloc] initWithName:singleRoute[2*j + 3] ref:singleRoute[2*j + 2]];
            [busStops addObject:busStop];
        }
        
        BusRoute *busRoute = [[BusRoute alloc] initWithLineName:lineName
                                                      routeName:routeName
                                                      busStops:busStops];
        [allRoutes addObject:busRoute];
    }
    return allRoutes;
}


@end
