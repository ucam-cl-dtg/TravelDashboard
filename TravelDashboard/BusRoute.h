//
//  BusRoute.h
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

#import <Foundation/Foundation.h>
#import "BusStop.h"

@interface BusRoute : NSObject
@property(nonatomic, strong) NSString* lineName;
@property(nonatomic, strong) NSString* routeName;
@property(nonatomic, strong) NSArray* busStops;
-(id)initWithLineName:(NSString *)lineName
            routeName:(NSString *)routeName
             busStops:(NSArray *)busStops;
@end
