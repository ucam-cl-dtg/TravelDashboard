//
//  Scenario.m
//  TransportDemo
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

#import "Scenario.h"
#include <stdlib.h>
#import "SegmentInfo.h"

@implementation Scenario

- (id) initWithJourneyInfo:(NSArray*) journeyInfo {
    if (self = [super init]) {
        
        // Define the timetable and variability information
        float nominalBusDep[] = {26700, 27900, 29100, 30300, 31500, 32700, 33900, 35100, 36300, 37500, 38700, 39900, 41100, 42300, 43500, 44700, 45900, 47100, 48300, 49500, 50700, 51900, 53100, 54300, 55800, 57000, 58200, 59400, 60600, 61800, 63000, 64200, 65100, 66300, 67500, 68700, 69900, 71100};
        float nominalBusDur[] = {900,900,900,900,900,900,900,900,900,900,900,900,900,900,900,900,900,900,900,900,900,900,900,900,900,900,900,900,900,900,900,900,900,900,900,900,900,900};
        float busDepRange[] = {240,240,300,360,360,300,300,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,300,360,360,360,360,360,420,420,480,480,420,360,300,240,240};
        float busDurRange[]   = {60,60,120,180,180,120,120,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,120,180,180,180,180,180,240,240,300,300,240,180,120,60,60};
        int nb = 38;
        float nominalTrainDep[] = {20100,20700,22500,23220,24300,25020,26100,26820,28500,29700,30300,32100,33600,34140,35700,37800,39300,41400,42900,45000,46500,48600,50100,52200,53700,55800,57300,59100,60900,62700,64500,66300,68100,69900,71700,73800,75300,75300,77400,78900,81000,83700};
        float nominalTrainDur[] = {2880,2280,1680,2460,2340,2340,2160,2340,2220,2160,2340,2340,2040,1800,2400,1740,2280,1740,2280,1740,2280,1740,2280,1740,2280,1740,2280,2100,2280,2100,2280,2280,2280,2100,2280,1740,2280,2280,1740,2280,1740,2280};
        int nt = 42;
        
        // Overwrite canned info with live info
        if (journeyInfo) {
            SegmentInfo *seg0 = [journeyInfo objectAtIndex:0];
            SegmentInfo *seg1;
            if (journeyInfo.count >= 2) {
                seg1 = [journeyInfo objectAtIndex:1];
            } else {
                seg1 = [journeyInfo objectAtIndex:0];
            }
            nb = (int) seg0.scheduledStart.count;
            nt = (int) seg1.scheduledStart.count;
            for (int i=0; i<nb; i++) {
                int t0 = [self getIntFromTimeString:[seg0.scheduledStart objectAtIndex:i]];
                int t1 = [self getIntFromTimeString:[seg0.scheduledEnd objectAtIndex:i]];
                nominalBusDep[i] = (float) t0;
                nominalBusDur[i] = (float) (t1 - t0);
            }
            for (int i=0; i<nt; i++) {
                int t0 = [self getIntFromTimeString:[seg1.scheduledStart objectAtIndex:i]];
                int t1 = [self getIntFromTimeString:[seg1.scheduledEnd objectAtIndex:i]];
                nominalTrainDep[i] = (float) t0;
                nominalTrainDur[i] = (float) (t1 - t0);
            }
        }
        
        // Populate the walk information
        _initialWalkTime = 0;
        _midWalkTime = 0;
        _finalWalkTime = 0;
        
        // Populate the bus information
        _numBusses = nb;
        for (int i=0; i<_numBusses; i++) {
            _busDep[i] = nominalBusDep[i] + (rand() % (int) busDepRange[i]);
            float busDur = nominalBusDur[i] + (rand() % (int) busDurRange[i]);
            _busArr[i] = _busDep[i] + busDur;
            _nomBusDep[i] = nominalBusDep[i];
            _nomBusArr[i] = nominalBusDep[i] + nominalBusDur[i];
        }
        
        // Populate the train information
        _numTrains = nt;
        for (int i=0; i<_numTrains; i++) {
            _trainDep[i] = nominalTrainDep[i] + (rand() % (4*60));
            float trainDur = nominalTrainDur[i] + (rand() % (2*60));
            _trainArr[i] = _trainDep[i] + trainDur;
            _nomTrainDep[i] = nominalTrainDep[i];
            _nomTrainArr[i] = nominalTrainDep[i] + nominalTrainDur[i];
        }
        
    }
    return self;
}

- (float*) busDep{ return _busDep; }
- (float*) busArr{ return _busArr; }
- (float*) trainDep{ return _trainDep; }
- (float*) trainArr{ return _trainArr; }
- (int) numBusses{ return _numBusses; }
- (int) numTrains{ return _numTrains; }
- (float) initialWalkTime{ return _initialWalkTime; }
- (float) midWalkTime{ return _midWalkTime; }
- (float) finalWalkTime{ return _finalWalkTime; }
- (float*) nomBusDep{ return _nomBusDep; }
- (float*) nomBusArr{ return _nomBusArr; }
- (float*) nomTrainDep{ return _nomTrainDep; }
- (float*) nomTrainArr{ return _nomTrainArr; }

- (int) getIntFromTimeString:(NSString*)string {
    NSString *hoursString = [string substringToIndex:2];
    NSString *minsString = [string substringFromIndex:3];
    int hours = (int) [hoursString integerValue];
    int mins = (int) [minsString integerValue];
    return (hours*3600 + mins*60);
}

@end
