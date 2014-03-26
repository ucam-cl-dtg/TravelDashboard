//
//  BusStopViewController.h
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

#import <UIKit/UIKit.h>
#import "JourneySegment.h"

@interface BusStopViewController : UITableViewController {
    NSArray *_allStops;
}
@property (nonatomic, strong) JourneySegment *journeySegment;
- (id)initWithStyle:(UITableViewStyle)style
     journeySegment:(JourneySegment*)journeySegment;
@property (nonatomic, assign) int row;
@end