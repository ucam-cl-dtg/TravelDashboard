//
//  Axis.h
//  RenderTest
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

@interface Axis : NSObject
@property (assign, nonatomic) float minBound;
@property (assign, nonatomic) float maxBound;
@property (assign, nonatomic) float minRangeBound;
@property (assign, nonatomic) float minValue;
@property (assign, nonatomic) float maxValue;
@property (assign, nonatomic) BOOL axisLocked;
- (void) firstTouchBeganAtPos:(float)pos timestamp:(NSTimeInterval)timestamp;
- (void) secondTouchBeganAtPos:(float)pos timestamp:(NSTimeInterval)timestamp;
- (void) firstTouchMovedToPos:(float)pos timestamp:(NSTimeInterval)timestamp;
- (void) secondTouchMovedToPos:(float)pos timestamp:(NSTimeInterval)timestamp;
- (void) firstTouchEndedTimestamp:(NSTimeInterval)timestamp;
- (void) secondTouchEndedTimestamp:(NSTimeInterval)timestamp;
- (void) allTouchesEnded;
- (void) updateWithTimestep:(float)dt;
@end
