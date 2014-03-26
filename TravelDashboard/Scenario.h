//
//  Scenario.h
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

#import <Foundation/Foundation.h>

#define MAX_PER_DAY 50

@interface Scenario : NSObject{
    float _busDep[MAX_PER_DAY];
    float _busArr[MAX_PER_DAY];
    float _trainDep[MAX_PER_DAY];
    float _trainArr[MAX_PER_DAY];
    float _nomBusDep[MAX_PER_DAY];
    float _nomBusArr[MAX_PER_DAY];
    float _nomTrainDep[MAX_PER_DAY];
    float _nomTrainArr[MAX_PER_DAY];
    int _numBusses;
    int _numTrains;
    float _initialWalkTime;
    float _midWalkTime;
    float _finalWalkTime;
}

- (id) initWithJourneyInfo:(NSArray*) journeyInfo;
- (float*) busDep;
- (float*) busArr;
- (float*) trainDep;
- (float*) trainArr;
- (int) numBusses;
- (int) numTrains;
- (float) initialWalkTime;
- (float) midWalkTime;
- (float) finalWalkTime;
- (float*) nomBusDep;
- (float*) nomBusArr;
- (float*) nomTrainDep;
- (float*) nomTrainArr;

@end
